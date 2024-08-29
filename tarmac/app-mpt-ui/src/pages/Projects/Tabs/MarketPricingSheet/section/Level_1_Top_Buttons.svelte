<script>
  // @ts-nocheck
  import { useQuery } from "@sveltestack/svelte-query";
  import { createEventDispatcher, onMount } from "svelte";
  import { get } from "svelte/store";
  import { SettingFilterState } from "./settingsAndFilterStore.js";
  import ExternalDataDetail from "./ExternalData/ExternalData.svelte";
  import AddSurveyData from "./AddSurveyData/AddSurveyData.svelte";
  import Loading from "components/shared/loading.svelte";
  import Modal from "components/shared/modal.svelte";
  import {
    getAllMarketPricingSheetPdf,
    getCurrentMarketPricingSheetPdf,
    downloadMarketPricingSheetPdfFile,
    getJobMatchInfo,
    getPositionDetailInfo,
    getGridItemsForMarketPricingSheetInfo,
    getMarketSegmentCombinedAverage,
  } from "api/apiCalls";
  import * as ExcelJS from "exceljs/dist/exceljs.min.js";
  import { marketPricingSheetStore, marketPricingModalStore } from "store/marketPricingSheet.js";
  import { MarketPricingExportColumns } from "utils/constants.js";
  import { lowerCamelCaseInObjectKeys, YEARFRAC } from "utils/functions.js";
  import { getPricingFilterGlobalSettingsFromSession, getDefaultBenchmarks } from "../marketPricingCommon.js";
  import { BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT, BENCHMARK_IDS_WITH_DECIMAL_POSITIONS } from "utils/constants";

  export let benchmarks = [];
  export let projectVersionId;
  export let marketPricingSheetID;
  export let organizationId;
  export let globalSettings;

  let fullScreenName = "Full Screen";
  let isLeftMenuVisible = true;
  let fileS3Url = "";
  let fileS3Name = "";
  let props = {};
  let notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");

  const queryDownloadPDF = useQuery(
    ["downloadPricingSheetPdfFile", fileS3Url],
    async () => {
      const data = await downloadMarketPricingSheetPdfFile(fileS3Url);
      return data.data;
    },
    { enabled: false, cacheTime: 0 },
  );

  $: if ($queryDownloadPDF.data) {
    downloadURI($queryDownloadPDF.data, fileS3Name);
  }

  const queryAllPDF = useQuery(
    ["allMarketPricingSheetPdf", projectVersionId],
    async () => {
      const data = await getAllMarketPricingSheetPdf(projectVersionId);
      return data.data;
    },
    { enabled: false, cacheTime: 0 },
  );

  $: if ($queryAllPDF.data) {
    refetchDownloadPDF($queryAllPDF.data);
  }

  const queryCurrentPDF = useQuery(
    ["currentMarketPricingSheetPdf", projectVersionId, marketPricingSheetID],
    async () => {
      const data = await getCurrentMarketPricingSheetPdf(projectVersionId, marketPricingSheetID);
      refetchDownloadPDF(data.data);
      return data.data;
    },
    { enabled: false, cacheTime: 0 },
  );

  $: if ($queryDownloadPDF.error || $queryAllPDF.error || $queryCurrentPDF.error) {
    notificationWidget.show("Error while exporting pricing sheet to PDF", "error");
  }

  const refetchDownloadPDF = data => {
    fileS3Url = data.fileS3Url;
    fileS3Name = data.fileS3Name;
    $queryDownloadPDF.refetch();
  };

  const downloadURI = (uri, name) => {
    const link = document.createElement("a");
    link.download = name;
    link.href = uri;
    link.target = "_blank";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    $queryDownloadPDF.remove();
  };

  export function SetFullScreenButtonText(text) {
    fullScreenName = text;
  }

  export function SetLeftMenuVisible(isVisible) {
    isLeftMenuVisible = isVisible;
  }

  export function SettingsChanged(settings) {
    benchmarks = settings.Benchmarks;
  }

  export function getIsLeftMenuVisible() {
    return isLeftMenuVisible;
  }

  //let mandatoryColumns = ["Cut_Name"];
  function LoadSettingsFromStore() {
    let settings = get(SettingFilterState);
    isLeftMenuVisible = settings.LeftMenu;
  }

  onMount(() => {
    LoadSettingsFromStore();
  });
  const dispatch = createEventDispatcher();

  const toggleFullScreen = () => {
    dispatch("toggleFullScreen");
  };

  function ShowLeftMenu() {
    isLeftMenuVisible = !isLeftMenuVisible;
    dispatch("ShowLeftMenu", {
      isLeftMenuVisible,
    });
  }

  let filters = null;
  export function FilterChanged(filter) {
    filters = filter;
  }

  function uploadPricingSheet(marketPricingSheetID) {
    props = {
      marketPricingSheetID,
      projectVersionId,
      organizationId,
      benchmarks,
    };

    marketPricingModalStore.update(store => ({
      ...store,
      addSurveyData: true,
    }));
  }

  function uploadPDFPricingSheet(marketPricingSheetID) {
    if (marketPricingSheetID == -1) {
      $queryAllPDF.refetch();
    } else {
      $queryCurrentPDF.refetch();
    }
  }

  const setExportHeader = (worksheet, headerInfo, selectedBenchmarks) => {
    globalSettings = getPricingFilterGlobalSettingsFromSession();
    const { OrgName: orgName } = globalSettings;
    if (orgName) {
      worksheet.insertRow(1, [headerInfo.Org_Name]);
    }
    worksheet.insertRow(2, []);
    const headerNames = [
      {
        name: "Client Position Detail",
        startCol: 3,
        endCol: 14,
      },
      {
        name: "Job Match Detail",
        startCol: 15,
        endCol: 17,
      },
      {
        name: "Survey Cut Details",
        startCol: 18,
        endCol: 32,
      },
    ];
    // iterate over selectedBenchmarks and add to headerNames
    // 33 is start column for Benchmars
    let ROW = 2;
    // let startColumn = 33;

    let benchmarkHeaderNames = [];
    selectedBenchmarks.reduce((acc, benchmark) => {
      benchmarkHeaderNames.push({
        name: benchmark.title,
        startCol: acc,
        endCol: acc + benchmark.percentiles?.length - 1,
      });
      return acc + benchmark.percentiles?.length;
    }, 33);

    [...headerNames, ...benchmarkHeaderNames].forEach(header => {
      worksheet.mergeCells(ROW, header.startCol, ROW, header.endCol);
      const cell = worksheet.getRow(2).getCell(header.startCol);
      cell.value = header.name;
      cell.alignment = { horizontal: "center" };
      cell.border = {
        top: { style: "thin" },
        left: { style: "thin" },
        bottom: { style: "thin" },
        right: { style: "thin" },
      };
    });
  };

  const getAgedMarketValue = (gridItem, selectedBenchmarks) => {
    let benchmarkRow = {};
    const adjustment = gridItem.adjustment || 0;
    const { AgeToDate: ageToDate } = globalSettings;

    gridItem.benchmarks.forEach(benchmark => {
      // if benchmark.id is not in selectedBenchmarks, skip
      if (!selectedBenchmarks.some(selectedBenchmark => selectedBenchmark.id == benchmark.id)) {
        return;
      }
      let agingFactor = benchmark.agingFactor;
      let x = 1 + agingFactor;
      let a = gridItem.surveyDataEffectiveDate < ageToDate ? 1 : -1;
      let b = YEARFRAC(gridItem.surveyDataEffectiveDate, ageToDate);

      // @ts-ignore
      let y = a * b;
      let agedValue = Math.pow(x, y);
      let prefix = "";
      let suffix = "";

      if (BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT.includes(benchmark.id)) {
        prefix = "";
        suffix = "%";
      } else {
        prefix = "$";
        suffix = "";
      }
      const selectedBenchmark = selectedBenchmarks.find(selectedBenchmark => selectedBenchmark.id == benchmark.id);
      if (benchmark.percentiles) {
        benchmark.percentiles?.forEach(percentile => {
          // do not calculate for percentiles that are not selected
          if (!selectedBenchmark.percentiles?.some(selectedPercentile => selectedPercentile == percentile.percentile)) {
            return;
          }
          let agedMarketValue = agedValue * percentile.marketValue;
          const decimalPosition = BENCHMARK_IDS_WITH_DECIMAL_POSITIONS.includes(selectedBenchmark.id) ? 2 : 0;
          benchmarkRow[`${selectedBenchmark.id}-${percentile.percentile}`] =
            prefix +
              Number((1 + adjustment) * agedMarketValue)
                .toFixed(decimalPosition)
                .toString()
                .replace(/\B(?=(\d{3})+(?!\d))/g, ",") +
              suffix || "---";
        });
      } else {
        selectedBenchmark.percentiles?.forEach(percentile => {
          benchmarkRow[`${selectedBenchmark.id}-${percentile}`] = "---";
        });
      }
    });

    return benchmarkRow;
  };

  const calculateAverages = async (worksheet, data, marketSegmentName) => {
    const groupedData = {};

    // Iterate through the input array
    data.forEach(record => {
      const { marketSegmentCutName, ...rest } = record;

      // If the marketSegmentCutName is not already a key in groupedData, initialize it as an array
      if (!groupedData[marketSegmentCutName]) {
        groupedData[marketSegmentCutName] = [];
      }

      // Push the remaining properties to the array
      groupedData[marketSegmentCutName].push(rest);
    });

    // Calculate averages for each group
    const result = Object.entries(groupedData).map(([groupName, groupRecords]) => {
      const averages = {};

      // Calculate the sum of each property in the group
      groupRecords.reduce((acc, record) => {
        Object.keys(record).forEach(prop => {
          if (!averages[prop]) {
            averages[prop] = 0;
          }
          if (record[prop] !== "---") averages[prop] += record[prop];
        });
        return acc;
      }, {});

      // Calculate the average for each property but excluding the records with "---" values
      Object.keys(averages).forEach(prop => {
        let averageTotal = averages[prop] / groupRecords.filter(record => record[prop] !== "---").length;
        averages[prop] = isNaN(averageTotal) ? "---" : averageTotal;
      });

      // Create a new object for the result
      return {
        providerCount: groupName ? `${groupName} Average:` : "Average:",
        ...averages,
      };
    });

    worksheet.addRows(result);
    // calculate ERI Average if market segment have a eriAdjustmentFactor value other than 0
    const marketSegment = $marketPricingSheetStore.marketSegments.find(marketSegment => marketSegment.name == marketSegmentName);
    const eriAdjustmentFactor = marketSegment.eriAdjustmentFactor;
    const eriCutName = marketSegment.eriCutName;

    const nationalAverage = result.find(row => row.providerCount === "National Average:");
    if (nationalAverage && eriAdjustmentFactor != 0) {
      let nationalERIAdjusted = {};
      Object.keys(nationalAverage).forEach(key => {
        if (key != "providerCount") {
          if (nationalAverage[key] === "---") {
            nationalERIAdjusted[key] = "---";
            return;
          }
          nationalERIAdjusted[key] =
            eriAdjustmentFactor < 0
              ? nationalAverage[key] - nationalAverage[key] * eriAdjustmentFactor
              : nationalAverage[key] + nationalAverage[key] * eriAdjustmentFactor;
        }
      });
      worksheet.addRow({
        providerCount: `${eriCutName || "ERI Adjustment"} (${eriAdjustmentFactor}):`,
        ...nationalERIAdjusted,
      });
    }

    // calculate Combined Average
    if (marketSegment.id > 0) {
      const combinedAverage = await getMarketSegmentCombinedAverage(marketSegment.id);

      if (!combinedAverage.data || combinedAverage.data.length == 0) {
        return;
      }

      combinedAverage.data.forEach(combinedAverage => {
        if (combinedAverage && combinedAverage.marketSegmentId) {
          let averageItem = [];
          let combinedAvgItem = [];
          if (combinedAverage.cuts) {
            combinedAverage.cuts.forEach(cut => {
              // result are the array of averages
              result.forEach(avg => {
                if (avg.providerCount == `${cut.name} Average:`) {
                  combinedAvgItem.push(avg);
                }
              });
            });
            const fields = Object.keys(result[0]).filter(key => key !== "providerCount");

            fields.forEach(key => {
              let sum = 0;
              let count = 0;

              combinedAvgItem.forEach(item => {
                sum += item[key];
                count++;
              });

              if (sum == 0 || isNaN(sum) || count == 0) {
                averageItem[key] = "---";
              } else {
                averageItem[key] = sum / count;
              }
            });
          }
          worksheet.addRow({
            providerCount: `${combinedAverage.name} Average:`,
            ...averageItem,
          });
        }
      });
    }
  };

  const getAllMarketPricingSheetsData = async () => {
    const jobCodeTitles = $marketPricingSheetStore.jobCodeTitles;

    const promises = jobCodeTitles.map(async item => {
      const marketPricingSheetID = item.marketPricingSheetId;
      const marketSegmentName = item.marketSegmentName;

      // replace for client-position job-match-detail and grid data
      const clientPositionDetail = await getPositionDetailInfo(projectVersionId, filters.MarketPricingSheetID);
      const jobMatchDetail = await getJobMatchInfo(projectVersionId, marketPricingSheetID);
      const gridData = await getGridItemsForMarketPricingSheetInfo(projectVersionId, marketPricingSheetID);

      // Do something with the results, for example, push them to a new object
      return {
        marketPricingSheetID,
        marketSegmentName,
        clientPositionDetail: clientPositionDetail.data,
        jobMatchDetail: jobMatchDetail.data,
        gridData: gridData.data,
      };
    });

    // Wait for all promises to resolve
    const results = await Promise.all(promises);

    return results;
  };

  const addRowsAndAverages = async (
    gridData,
    marketPricingSheetID,
    marketSegmentName,
    clientPositionDetail,
    jobMatchDetail,
    selectedBenchmarks,
    worksheet,
  ) => {
    const gridForAverages = [];
    gridData
      .filter(gridItem => gridItem.excludeInCalc === false)
      .forEach(gridItem => {
        let benchmarkRow = getAgedMarketValue(gridItem, selectedBenchmarks);
        gridForAverages.push({ marketSegmentCutName: gridItem.marketSegmentCutName, ...benchmarkRow });
        worksheet.addRow({
          marketPricingSheetID,
          marketSegmentName,
          ...gridItem,
          ...clientPositionDetail[0],
          jobMatchTitle: jobMatchDetail.jobTitle,
          jobMatchNotes: jobMatchDetail.jobMatchNotes,
          description: jobMatchDetail.description,
          ...benchmarkRow,
        });
      });

    await calculateAverages(worksheet, gridForAverages, marketSegmentName);
  };

  async function exportExcelPricingSheet(exportCurrentPage) {
    const headerInfo = $marketPricingSheetStore.headerInfo;
    const globalSettings = getPricingFilterGlobalSettingsFromSession();
    let selectedBenchmarks = globalSettings.Benchmarks || [];

    if (selectedBenchmarks && selectedBenchmarks.length == 0) {
      const defaultBenchmarks = getDefaultBenchmarks(benchmarks);
      selectedBenchmarks = defaultBenchmarks.map(benchmark => ({
        id: benchmark.Value.toString(),
        title: benchmark.Text.toString(),
        agingFactor: 0,
        percentiles: benchmark.Percentile.map(percentile => percentile.toString()),
      }));
    }

    let fileName;
    const workbook = new ExcelJS.Workbook();
    let worksheet = workbook.addWorksheet("Sheet 1");
    // add columns to MarketPricingExportColumns for the given Benchmarks
    let benchmarkColumns = [];
    selectedBenchmarks.forEach(benchmark => {
      if (benchmark.percentiles) {
        benchmark.percentiles.forEach(percentile => {
          const percentileSuffix = !isNaN(percentile) ? "th" : "";
          benchmarkColumns.push({
            header: `${percentile}${percentileSuffix}`,
            key: `${benchmark.id}-${percentile}`,
            style: {
              numFmt: '"$"#,##0.00',
              alignment: {
                horizontal: "right",
              },
            },
          });
        });
      }
    });

    worksheet.columns = [...MarketPricingExportColumns, ...benchmarkColumns];

    if (exportCurrentPage == -1) {
      fileName = `mpt_MarketPricingReport_${headerInfo.Org_Name}_${projectVersionId}_${new Date().toLocaleDateString()}.xlsx`;
      const results = await getAllMarketPricingSheetsData();
      // iterate over results and add to worksheet
      results.forEach(async result => {
        const { marketPricingSheetID, marketSegmentName, clientPositionDetail, jobMatchDetail, gridData } = result;
        await addRowsAndAverages(
          gridData,
          marketPricingSheetID,
          marketSegmentName,
          clientPositionDetail,
          jobMatchDetail,
          selectedBenchmarks,
          worksheet,
        );
      });
    } else {
      const marketPricingSheetID = $marketPricingSheetStore.marketPricingSheetID;
      const clientPositionDetail = $marketPricingSheetStore.clientPositionDetail;
      const gridData = $marketPricingSheetStore.gridData;
      const jobMatchDetail = lowerCamelCaseInObjectKeys($marketPricingSheetStore.jobMatchDetail);

      const marketSegmentName = get(SettingFilterState).SheetName;
      fileName = `mpt_MarketPricingSheet_${headerInfo.Org_Name}_${projectVersionId}_${new Date().toLocaleDateString()}_${marketPricingSheetID}.xlsx`;
      await addRowsAndAverages(
        gridData,
        marketPricingSheetID,
        marketSegmentName,
        clientPositionDetail,
        jobMatchDetail,
        selectedBenchmarks,
        worksheet,
      );
    }

    setExportHeader(worksheet, headerInfo, selectedBenchmarks);

    const workbookOutput = await workbook.xlsx.writeBuffer();
    const blob = new Blob([workbookOutput], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });
    const downloadUrl = URL.createObjectURL(blob);
    downloadURI(downloadUrl, fileName);
  }

  const onAddExternalDataModalClose = event => {
    marketPricingModalStore.update(store => ({
      ...store,
      addExternalData: false,
    }));

    if (event && event.detail.reload) {
      dispatch("externalDataModalClose");
    }
  };

  addEventListener("UpdateLastSave", () => {
    let lastSaved = document.querySelector(".lastSaved");
    if (document.getElementById("spnMPSSaveTimeStamp")) document.getElementById("spnMPSSaveTimeStamp").innerHTML = new Date().toLocaleString();
    if (lastSaved) lastSaved.style.display = "inline-block";
  });

  const onAddSurveyDataModalClose = () => {
    marketPricingModalStore.update(store => ({
      ...store,
      addSurveyData: false,
    }));
  };
</script>

<span id="notification" />
<div class="row flex-section w-100" data-cy="marketSegmentSection">
  <div class="card-body d-flex justify-content-end" style="margin:0px;padding-top:0px !important;">
    <div style="float:left" class="d-flex justify-content-start col-12">
      <div class="col-12">
        <div class="row">
          <div class="d-flex justify-content-start bd-highlight col-xxl-6 col-lg-12 col-md-12">
            <button style="height:33px" class="btn btn-primary me-2" on:click={ShowLeftMenu}>
              <i class="fa {isLeftMenuVisible ? 'fa-angle-double-left' : 'fa-angle-double-right'}  fa-md" />
              {isLeftMenuVisible ? "Hide Pane" : "Show Pane"}
            </button>
          </div>
          <div
            class="d-flex justify-content-end bd-highlight col-xxl-6 col-lg-12 col-md-12 p-0"
            style:opacity={filters == null || filters.MarketPricingSheetID == -1 ? "0" : "1"}
          >
            <div class="">
              <div class="lastSaved mt-2 me-2">
                <i class="fa fa-floppy-o" id="lastSavedFloppy" aria-hidden="true" /> Last saved on <span id="spnMPSSaveTimeStamp">1/1/2020</span>
              </div>
            </div>
            <div class="">
              <div class="dropdown dropdown-div mx-1">
                <button
                  class="btn btn-primary dropdown-toggle"
                  data-cy="addSurveyData"
                  id="popupSurveyData"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  Add Survey Data
                </button>
                <ul class="dropdown-menu" aria-labelledby="ddlExternalData">
                  <li>
                    <a class="dropdown-item" href={"#"} data-cy="addexternaldata-all" on:click={() => uploadPricingSheet(-1)}
                      >Add Data to All Pricing Sheets</a
                    >
                  </li>
                  <li>
                    <a class="dropdown-item" href={"#"} data-cy="addexternaldata-current" on:click={() => uploadPricingSheet(marketPricingSheetID)}
                      >Add Data to Current Pricing Sheet</a
                    >
                  </li>
                </ul>
              </div>
            </div>
            <div class="">
              <div class="dropdown dropdown-div mx-1">
                <button
                  class="btn btn-primary dropdown-toggle"
                  data-cy="mps-export"
                  id="ddlMSPexport"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  Export
                </button>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href={"#"} on:click={() => uploadPDFPricingSheet(-1)}>All pricing sheets to PDF</a>
                  </li>
                  <li>
                    <a class="dropdown-item" href={"#"} on:click={() => uploadPDFPricingSheet(marketPricingSheetID)}>Current pricing sheet to PDF</a>
                  </li>
                  <li>
                    <a class="dropdown-item" data-cy="export-excel-all" href={"#"} on:click={() => exportExcelPricingSheet(-1)}
                      >All pricing sheets to Excel</a
                    >
                  </li>
                  <li>
                    <a class="dropdown-item" data-cy="export-excel-current" href={"#"} on:click={() => exportExcelPricingSheet(marketPricingSheetID)}
                      >Current pricing sheet to Excel</a
                    >
                  </li>
                </ul>
              </div>
            </div>
            <div class="">
              <button class="btn btn-primary" data-cy="export" id="exportMSPSheet" on:click={toggleFullScreen}>
                <i class="fa fa-arrows-alt" />
                {fullScreenName}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

{#if $marketPricingModalStore.addExternalData}
  <Modal show={ExternalDataDetail} {props} on:closed={onAddExternalDataModalClose} />
{/if}

{#if $queryAllPDF.isLoading || $queryCurrentPDF.isLoading || $queryDownloadPDF.isLoading}
  <div class="overlay">
    <Loading isLoading={true} />
  </div>
{/if}

{#if $marketPricingModalStore.addSurveyData}
  <Modal show={AddSurveyData} on:closed={onAddSurveyDataModalClose} />
{/if}

<style>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 999;
  }
  .dropdown-item {
    cursor: pointer;
  }

  .lastSaved {
    color: var(--bs-secondary-color);
    display: none;
  }
</style>
