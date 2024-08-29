<script>
  import { createEventDispatcher, onMount } from "svelte";
  import { externalDataSpreadsheetConfig } from "./ExternalDataSpreadsheetConfig";
  import { getExternalDataForPricingSheet, saveExternalDataForPricingSheet } from "../../apiMarketPricingCalls";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import { useMutation, useQuery } from "@sveltestack/svelte-query";
  import { getMainSettingsInfo } from "api/apiCalls";
  import { marketPricingModalStore } from "store/marketPricingSheet";
  import { benchMarkStore } from "../settingsAndFilterStore";
  import { getDefaultBenchmarks } from "../../marketPricingCommon";

  export let marketPricingSheetID;
  export let projectVersionId;
  export let organizationId;

  const dispatch = createEventDispatcher();

  let notificationWidget;
  let spreadsheetConfig = JSON.parse(JSON.stringify(externalDataSpreadsheetConfig));
  let spreadsheet = null;
  let externalDataBody = null;
  let errorMessages = [];
  let showValidationErrors = false;
  let hasUnSavedChanged = false;
  let benchmarks = [];

  const querySettings = useQuery(
    ["settings", projectVersionId],
    async () => {
      const data = await getMainSettingsInfo(projectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($querySettings?.data) {
    benchmarks = $querySettings.data?.benchmarks?.length > 0 ? $querySettings.data.benchmarks : getDefaultBenchmarks($benchMarkStore);
  }

  function AdjustHeightWidth() {
    jQuery(externalDataBody).css("height", window.innerHeight - 100 + "px");
  }

  onMount(async () => {
    await $querySettings.refetch();

    AdjustHeightWidth();
    registerSpreeadsheet();

    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  });

  function registerSpreeadsheet() {
    addDynamicBenchmarkColumns();
    spreadsheetConfig.change = () => {
      const rows = spreadsheet.activeSheet().toJSON().rows;
      rows.shift();
      hasUnSavedChanged = rows.some(row => row.cells.some(cell => cell.value?.toString().trim()));
      dispatch("dataUpdate", {
        hasUnSavedChanges: hasUnSavedChanged,
        message: "Are you sure you want to close the window?  All information will be lost.",
      });
    };

    jQuery("#kendo-spreadsheet").kendoSpreadsheet(spreadsheetConfig);
    spreadsheet = jQuery("#kendo-spreadsheet").data("kendoSpreadsheet");

    validateTheSpreadsheet();
  }

  function addDynamicBenchmarkColumns() {
    benchmarks.forEach(item => {
      const percentiles = item.percentile || item.Percentile || item.percentiles || [];
      percentiles.sort();
      percentiles.forEach(percentile => {
        if (percentile) {
          const name = (item.title || item.Text) + " " + percentile + "th";
          spreadsheetConfig.sheets[0].rows[0].cells.push({
            value: name,
            background: "#808080",
            textAlign: "center",
            color: "#ffffff",
            bold: true,
            enable: false,
            key: item.id,
            percentile: percentile,
            isBenchmark: true,
          });
        }
      });
    });

    spreadsheetConfig.sheets.forEach(sheet => {
      sheet.rows[0].cells.forEach(() => {
        sheet.columns.push({
          width: 150,
        });
      });
    });

    spreadsheetConfig.columns = spreadsheetConfig.sheets[0].rows[0].cells.length;
  }

  function ExternalUpload() {
    const rows = spreadsheet.activeSheet().toJSON().rows;
    rows.shift();
    if (rows.some(row => row.cells.some(cell => cell.value))) {
      confirmProjectStatusChange();
    } else {
      document.getElementById("fileid").click();
    }
  }

  const downloadTemplate = async () => {
    let divElement = document.createElement("div");
    divElement.id = "kendo-download-spreadsheet";
    divElement.style.display = "none";
    document.body.appendChild(divElement);

    jQuery("#kendo-download-spreadsheet").kendoSpreadsheet(spreadsheetConfig);
    let downloadSpreadsheet = jQuery("#kendo-download-spreadsheet").data("kendoSpreadsheet");
    const externalDataResponse = await getExternalDataForPricingSheet(projectVersionId, marketPricingSheetID);
    if (externalDataResponse.status !== 200) {
      notificationWidget.show("Error while downloading external data!", "error");
      return;
    }

    const formattedData = getFormattedRowData(externalDataResponse.data, "field");
    downloadSpreadsheet.activeSheet().fromJSON({ rows: formattedData });
    downloadSpreadsheet.saveAsExcel();
  };

  function confirmProjectStatusChange() {
    jQuery("#confirm-excel-load")?.remove();
    let divElement = document.createElement("div");
    divElement.id = "confirm-excel-load";
    document.body.appendChild(divElement);

    jQuery("#confirm-excel-load").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      content: "All data in the grid will be replaced. If there are any unmatched column names, they will be ignored.",
      actions: [
        {
          text: "Yes",
          action: function () {
            document.getElementById("fileid").click();
            return true;
          },
          primary: true,
        },
        {
          text: "No",
          action: function () {
            return true;
          },
          primary: true,
        },
      ],
    });

    var dialog = jQuery("#confirm-excel-load").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
    dialog.bind("close", () => {
      jQuery("#confirm-excel-load")?.remove();
    });
  }

  function FileUploaded(e) {
    e.preventDefault();
    let re = /(\.xlsx)$/i;
    if (!re.exec(this.files[0].name)) {
      notificationWidget.show("File type must be in .xlsx format!", "error");
      return;
    }

    // spreadsheet.fromFile(this.files[0]);
    fnConvertExcelToJSON(this.files[0]);
    showValidationErrors = false;
    errorMessages = [];
    e.target.value = "";
  }

  // @ts-ignore
  const fnConvertExcelToJSON = file => {
    //method to convert excel to json
    var reader = new FileReader();
    reader.onload = function (event) {
      var data = event.target.result;
      // @ts-ignore
      // eslint-disable-next-line no-undef
      var workbook = XLSX.read(data, {
        type: "binary",
      });
      var json_object;
      workbook.SheetNames.forEach(function (sheetName) {
        // @ts-ignore
        // eslint-disable-next-line no-undef
        var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
        json_object = JSON.stringify(XL_row_object);
      });
      reset();
      const jsonData = JSON.parse(json_object);
      spreadsheet.activeSheet().fromJSON({ rows: getFormattedRowData(jsonData, "value") });
      validateTheSpreadsheet();
    };
    reader.onerror = function (event) {
      console.error("File could not be read! Code " + event.target.error.code);
    };
    reader.readAsBinaryString(file);
  };

  const getFormattedRowData = (dataList, parameter) => {
    let rows = [];
    dataList.forEach((item, index) => {
      let rowItem = {
        cells: [],
        index: index + 1,
      };

      spreadsheetConfig.sheets[0].rows[0].cells.forEach(cell => {
        let columnMatched = false;
        Object.keys(item).forEach(key => {
          if (
            key.toLowerCase().trim() === cell[parameter]?.toLowerCase().trim() ||
            key.toLowerCase().trim() === cell[parameter]?.slice(0, -1)?.toLowerCase().trim()
          ) {
            if (key.toLocaleLowerCase().trim() === "Survey Effective Date".toLocaleLowerCase().trim()) {
              rowItem.cells.push({ value: item[key], format: "MM/DD/YYYY" });
            } else {
              rowItem.cells.push({ value: item[key] });
            }

            columnMatched = true;
          }
        });

        if (!columnMatched) {
          rowItem.cells.push({ value: "" });
        }
      });
      rows.push(rowItem);
    });

    return rows;
  };

  const saveExternalData = async () => {
    validateTheSpreadsheet();
    errorMessages = [];
    showValidationErrors = true;
    const rows = spreadsheet.activeSheet().toJSON().rows;
    rows.shift();
    const externalData = [];
    const externalDataItemCopy = [];
    let inCompleteRows = [];
    let inCorrectDataPositions = "";
    let missingBenchMarkDataRows = [];
    const columns = spreadsheetConfig.sheets[0].rows[0].cells;

    rows.forEach(row => {
      const externalDataItem = {};
      const hasDataInAnyCell = row.cells.some(cell => cell.value);
      if (hasDataInAnyCell) {
        let staticCells = row.cells.slice(0, 17);
        let benchMarkCells = row.cells.slice(17);

        let requiredColumns = staticCells.slice(0, 15);
        const hasDataInRequiredColumns = requiredColumns.every(column => column.value);
        if (!hasDataInRequiredColumns) {
          inCompleteRows.push(row.index + 1);
        }

        const hasDataInAnyBenchmarkColumn = benchMarkCells.some(column => column.value);
        if (!hasDataInAnyBenchmarkColumn) {
          inCompleteRows.push(row.index + 1);
          missingBenchMarkDataRows.push(row.index + 1);
        }

        staticCells.forEach((cell, index) => {
          if (cell.value?.toString().trim()) {
            if (cell.validation?.dataType === "number" && typeof cell.value !== "number") {
              let character = "A".charCodeAt(0);
              inCorrectDataPositions += " [" + (row.index + 1) + "," + String.fromCharCode(character + index) + "]";
            }
          }
        });

        if (hasDataInRequiredColumns && hasDataInAnyBenchmarkColumn && !inCorrectDataPositions) {
          staticCells.forEach((cell, index) => {
            let value = cell.validation.dataType === "text" ? cell.value?.toString() : cell.value;
            if (columns[index].type === "date") {
              value = new Date(Date.UTC(0, 0, cell.value));
            }

            externalDataItem[columns[index].saveField] = value;
          });

          externalDataItem["incumbentCount"] = externalDataItem["incumbentCount"] || 0;
          externalDataItemCopy.push(externalDataItem);

          benchMarkCells.forEach((cell, index) => {
            if (cell.value) {
              let record = JSON.parse(JSON.stringify(externalDataItem));
              if (columns[index + 17] && columns[index + 17].percentile) {
                record["benchmarkDataTypeKey"] = columns[index + 17].key;
                record["benchmarkDataTypeValue"] = cell.value;
                record["percentileNumber"] = columns[index + 17].percentile;

                if (marketPricingSheetID > 0) {
                  record["marketPricingSheetID"] = marketPricingSheetID;
                }

                externalData.push(record);
              }
            }
          });
        }
      }
    });

    inCompleteRows = [...new Set(inCompleteRows)];

    if (inCompleteRows.length > 0) {
      errorMessages.push("Please fill all the required columns in the rows " + inCompleteRows.join(", "));
    }

    const duplicateIndex = checkForDuplicateRecords(externalDataItemCopy);
    if (duplicateIndex.length > 0) {
      errorMessages.push("Duplicate records found in the rows " + duplicateIndex.join(", ") + ".");
    }

    if (missingBenchMarkDataRows.length > 0) {
      errorMessages.push("Please fill the data in at least one benchmark columns in the rows " + missingBenchMarkDataRows.join(", ") + ".");
    }

    if (inCorrectDataPositions?.length > 0) errorMessages.push("Please enter valid data in the cells " + inCorrectDataPositions + ".");

    if (marketPricingSheetID > 0 && externalData.some(d => d.projectOrganizationId !== organizationId || d.organizationId !== organizationId)) {
      errorMessages.push("Please enter the correct organization Id.");
    }

    if (errorMessages.length > 0) {
      return;
    }

    // @ts-ignore
    $mutationSaveExternalDataForPricingSheet.mutate(externalData);
  };

  const mutationSaveExternalDataForPricingSheet = useMutation(
    async payload => {
      const data = await saveExternalDataForPricingSheet(projectVersionId, payload);
      return data.data;
    },
    {
      onSuccess: async () => {
        notificationWidget.show("External data was successfully saved", "success");
        dispatch("dataUpdate", { hasUnSavedChanges: false, reload: true });
        dispatch("close");
      },
      onError: () => {
        notificationWidget.show("Error while saving external data!", "error");
      },
    },
  );

  const checkForDuplicateRecords = records => {
    const duplicateRecords = [];
    records = records.map(r => JSON.stringify(r));
    records.forEach((record, index) => {
      const isDuplicate = records.some((r, i) => r === record && i !== index);
      if (isDuplicate) {
        duplicateRecords.push(index + 2);
      }
    });

    return duplicateRecords;
  };

  const validateTheSpreadsheet = () => {
    const dynamicColumnsCount = spreadsheet.activeSheet().toJSON().columns.length - 17;
    spreadsheet.activeSheet().range(1, 17, 200, dynamicColumnsCount).validation({
      comparerType: "between",
      from: "0",
      to: "999999999.99",
      allowNulls: true,
      dataType: "number",
      messageTemplate: "Number should match the validation.",
    });

    spreadsheet.activeSheet().range("J2:J").format("mm/dd/yyyy");

    spreadsheet.activeSheet().range("J2:J").validation({
      dataType: "date",
      showButton: true,
      comparerType: "between",
      from: 'DATEVALUE("01/01/1900")',
      to: 'DATEVALUE("12/31/9999")',
      allowNulls: true,
      titleTemplate: "Birth Date validaiton error",
      messageTemplate: "Birth Date should be between 1899 and 1998 year.",
    });

    const numberRanges = [spreadsheet.activeSheet().range("A2:B"), spreadsheet.activeSheet().range("Q2:Q")];
    numberRanges.forEach(range =>
      range.validation({
        comparerType: "custom",
        from: "AND(ISNUMBER(A2))",
        allowNulls: true,
        dataType: "number",
        messageTemplate: "Please enter a valid number.",
      }),
    );

    const ranges = [spreadsheet.activeSheet().range("C2:I"), spreadsheet.activeSheet().range("K2:Q")];
    ranges.forEach(range =>
      range.validation({
        comparerType: "custom",
        from: "AND(LEN(C2) < 100)",
        allowNulls: true,
        dataType: "text",
        messageTemplate: "Allowed maximum 10 characters.",
      }),
    );
  };

  const reset = () => {
    spreadsheet.activeSheet().range("A2:AZ").clear();
    validateTheSpreadsheet();
    showValidationErrors = false;
    errorMessages = [];
  };

  window.onresize = () => {
    spreadsheet.resize();
  };

  const confirmClose = () => {
    jQuery("#dialog").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 500,
      content: "You have unsaved changes which might be lost. Do you wish to continue?",
      actions: [
        {
          text: "Yes",
          primary: true,
          action: function () {
            marketPricingModalStore.update(store => ({
              ...store,
              addSurveyData: true,
              addExternalData: false,
            }));
          },
        },
        { text: "No", primary: true },
      ],
    });

    var dialog = jQuery("#dialog").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
  };

  const handleOnClickBackButton = () => {
    if (hasUnSavedChanged) {
      confirmClose();
    } else {
      marketPricingModalStore.update(store => ({
        ...store,
        addSurveyData: true,
        addExternalData: false,
      }));
    }
  };
</script>

<span id="notification" />

<div data-cy="addExternalDataPopup">
  <div class="row">
    <div class="col-12">
      <div class="card-header card-header-sticky">
        <h5 class="my-2" data-cy="modelTitle">Add External Data</h5>
      </div>
      <div class="card-body pb-0" bind:this={externalDataBody}>
        <div class="d-flex justify-content-between mb-3">
          <div class="col-lg-6 col-sm-12 col-md-12">
            <button class="btn btn-primary" id="mpsExternalDataBackButton" on:click={handleOnClickBackButton}>Back</button>
            {#if showValidationErrors && errorMessages.length > 0}
              <div class="alert alert-danger d-flex flex-column mx-1 justify-content-between" role="alert">
                <div class="d-flex justify-content-between mb-1">
                  <span>Errors!</span>
                  <button type="button" class="btn-close" aria-label="Close" on:click={() => (showValidationErrors = false)} />
                </div>
                {#each errorMessages as error}
                  <span>
                    {error}
                  </span>
                {/each}
              </div>
            {/if}
          </div>
          <div class="d-flex justify-content-between">
            <div>
              <input id="fileid" type="file" on:change={FileUploaded} hidden />
              <input id="buttonUpload" type="button" value="Load from Excel" class="btn btn-primary" on:click={ExternalUpload} />
              <button class="btn btn-primary" id="mpsExternalDataDownload" on:click={downloadTemplate}>Download Template</button>
            </div>
          </div>
        </div>

        <!-- <div bind:this={container} style="width: 100%;" /> -->
        <div id="kendo-spreadsheet" style="width: 100%; max-height: 75vh;" />
      </div>
      <div class="card-footer d-flex justify-content-between">
        <div />
        <div>
          <button class="btn btn-secondary" data-cy="Reset" on:click={reset}>Reset</button>
          <button class="btn btn-primary" data-cy="close" on:click={saveExternalData} disabled={!hasUnSavedChanged}>Save and Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

<svelte:window on:resize={AdjustHeightWidth} />

<style>
  .card-footer {
    z-index: 1;
    background: white !important;
  }
</style>
