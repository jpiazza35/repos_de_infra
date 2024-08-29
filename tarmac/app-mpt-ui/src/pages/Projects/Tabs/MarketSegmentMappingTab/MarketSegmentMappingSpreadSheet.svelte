<script>
  import { onMount } from "svelte";
  import { useQuery, useMutation } from "@sveltestack/svelte-query";
  import { getMarketMappingJobs, saveMarketMappingJobs, getMarketMappingMarketSegments, getProjectVersionStatus } from "api/apiCalls";
  import { ProjectStatus } from "models/project/projectDetails";
  import { promiseWrap, removeBlankColumns, sheetRowsToDataSourceData, filterNullProperties } from "utils/functions";
  import isEqual from "lodash.isequal";
  import zip from "lodash.zip";
  import { tabFullScreen } from "../../../../store/tabs";
  import { getAuth0User } from "../../../../auth/auth0";
  import DOMPurify from "dompurify";

  export let orgId;
  export let projId;
  export let projVersionId;
  export let isProjectValid;

  let spreadsheet;
  let sheet;
  let notificationWidget;
  let marketSegments = [];
  let marketSegmentsNames = [];
  let projectStatus;
  let aggregationMethodKey, fileOrgKey;
  let filteredDataset = [];
  let dataRows = 0;
  let dataCols;
  let spreadsheetDataLoaded = false;
  let dataBound;

  const MAX_ROWS = 1001;
  const MAX_COLS = 32;
  const HEADING_BACKGROUND_COLOR = "#EDEDED";
  let localStorageKey = "";

  // query to load market segments
  const queryMappingMarketSegments = useQuery(
    ["mappingMarkegSegment", projVersionId],
    async () => {
      const data = await getMarketMappingMarketSegments(projVersionId);
      return data.data;
    },
    { enabled: false },
  );

  //mutation to save grid data
  const mutationSaveMappingJobs = useMutation(
    async payload => {
      const data = await saveMarketMappingJobs(projVersionId, payload);
      return data.data;
    },
    {
      onSuccess: async () => {
        notificationWidget.show("The records were saved", "success");
      },
      onError: marketMappingError => {
        // @ts-ignore
        notificationWidget.show(marketMappingError.response.data.title, "error");
      },
    },
  );

  const setMarketSegments = () => {
    if ($queryMappingMarketSegments.isSuccess) {
      marketSegments = $queryMappingMarketSegments.data;
      marketSegmentsNames = marketSegments.map(m => DOMPurify.sanitize(m.name));
      if (marketSegments.length > 0) {
        sheet.range(`E2:E${MAX_ROWS}`).validation({
          dataType: "list",
          showButton: true,
          comparerType: "list",
          from: `"${marketSegmentsNames.join(",")}"`,
          allowNulls: true,
          type: "reject",
        });
      }
    }
    if ($queryMappingMarketSegments.isError) {
      notificationWidget.show("There was an error fetching market segments", "error");
    }
  };

  // load project version status
  const queryProjectVersionStatus = useQuery(
    ["projectVersionStatus", projVersionId],
    async () => {
      const data = await getProjectVersionStatus(projVersionId);
      return data.data;
    },
    { enabled: false },
  );

  const setRangeValidation = () => {
    if ($queryProjectVersionStatus.isSuccess) {
      projectStatus = $queryProjectVersionStatus.data;
      sheet.range(`A1:AF${MAX_ROWS}`).enable(false);
      if (projectStatus === ProjectStatus.DRAFT) {
        sheet.range(`E1:F${dataRows}`).enable(true);
        sheet.range("E1").background(HEADING_BACKGROUND_COLOR);
        sheet.range("F1").background(HEADING_BACKGROUND_COLOR);
      }
    }
    if ($queryProjectVersionStatus.isError) {
      notificationWidget.show("There was an error fetching project version status", "error");
    }
  };

  const resizeSheet = () => {
    if (filteredDataset?.length === 0 || sheet === undefined) {
      return;
    }
    sheet.resize(dataRows, dataCols);
    sheet.range(`A1:AF${dataRows}`).filter(true);

    // we need to update #kendo-wrapper height to match the new sheet height
    // each row is 20px tall + 80px for header, collumn letters and formula bar
    let kendoWrapper = jQuery("#kendo-wrapper");
    const ROW_HEIGHT = 20;
    const TOOLBAR_HEIGHT = 120;
    if (dataRows < 20) {
      let height = dataRows * ROW_HEIGHT + TOOLBAR_HEIGHT;
      kendoWrapper.css("height", `${height}px`);
    }
    if (dataRows >= 20) {
      kendoWrapper.css("height", `100vh`);
    }
  };

  onMount(async () => {
    const user = await getAuth0User();
    localStorageKey = `msm-hidden-columns-${user.email}`;

    $queryMappingMarketSegments.refetch();
    $queryProjectVersionStatus.refetch();
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    let kendoWrapper = jQuery("#kendo-wrapper");
    let kendoSpreadsheet = jQuery("<div id='kendo-spreadsheet' style='width: 100%'></div>");
    kendoWrapper.append(kendoSpreadsheet);

    jQuery("#kendo-spreadsheet").kendoSpreadsheet(sampleConfig);
    spreadsheet = jQuery("#kendo-spreadsheet").data("kendoSpreadsheet");
    sheet = spreadsheet.activeSheet();
    jQuery("#kendo-spreadsheet").show();
  });

  // @ts-ignore
  let dataSource = new kendo.data.DataSource({
    transport: {
      read: onRead,
    },
    requestEnd: function () {
      spreadsheetDataLoaded = true;
    },
    batch: true,
    schema: {
      model: {
        id: "MarketSegmentMapping",
      },
    },
  });

  $: if (isProjectValid && sheet) {
    sheet.setDataSource(dataSource);
  }

  $: if (spreadsheetDataLoaded && $queryMappingMarketSegments.isFetched) {
    setMarketSegments();
  }

  $: if (spreadsheetDataLoaded && $queryProjectVersionStatus.isFetched) {
    setRangeValidation();
  }

  $: if ($tabFullScreen) {
    setTimeout(() => {
      jQuery("#kendo-spreadsheet").data("kendoSpreadsheet").refresh();
    }, 1);
  }

  async function onRead(options) {
    const [marketMappingResponse] = await promiseWrap(getMarketMappingJobs(projVersionId));
    aggregationMethodKey = marketMappingResponse[0].aggregationMethodKey;
    fileOrgKey = marketMappingResponse[0].fileOrgKey;

    const firstColumns = marketMappingResponse.map(m => {
      return {
        Organization: `${m.organizationName.escape()} - ${m.fileOrgKey}`,
        "Client Job Code": m.jobCode.escape(),
        "Position Code": m.positionCode.escape(),
        "Client Job Title": m.jobTitle.escape(),
        "Market Segment": m.marketSegmentName.escape(),
        "Client Job Group": m.jobGroup.escape(),
      };
    });

    const remainingColumns = marketMappingResponse.map(m => {
      return {
        "n Incumbents": m.incumbentCount,
        "n FTEs": m.fteCount,
        "Location Description": m.locationDescription,
        "Job Family": m.jobFamily,
        "Pay Grade": m.payGrade,
        "Pay Type": m.payType,
        "Position Code Description": m.positionCodeDescription,
        "Job Level": m.jobLevel,
        "Base Pay Hourly Rate": m.formattedBenchmarkDataTypes["Base Pay Hourly Rate"],
        "Annualized Base Salary": m.formattedBenchmarkDataTypes["Annualized Base Salary"],
        "Pay Range Minimum": m.formattedBenchmarkDataTypes["Pay Range Minimum"],
        "Pay Range Midpoint": m.formattedBenchmarkDataTypes["Pay Range Midpoint"],
        "Pay Range Maximum": m.formattedBenchmarkDataTypes["Pay Range Maximum"],
        "Annualized Pay Range Minimum": m.formattedBenchmarkDataTypes["Annualized Pay Range Minimum"],
        "Annualized Pay Range Midpoint": m.formattedBenchmarkDataTypes["Annualized Pay Range Midpoint"],
        "Annualized Pay Range Maximum": m.formattedBenchmarkDataTypes["Annualized Pay Range Maximum"],
        "Actual Annual Incentive": m.formattedBenchmarkDataTypes["Actual Annual Incentive"],
        "Annual Incentive Receiving": m.formattedBenchmarkDataTypes["Annual Incentive Receiving"],
        "Target Annual Incentive": m.formattedBenchmarkDataTypes["Target Annual Incentive"],
        "Target Incentive Percent": m.formattedBenchmarkDataTypes["Target Incentive Percent"],
        "Annual Incentive Threshold Opportunity": m.formattedBenchmarkDataTypes["Annual Incentive Threshold Opportunity"],
        "Threshold Incentive Percent": m.formattedBenchmarkDataTypes["Threshold Incentive Percent"],
        "Annual Incentive Maximum Opportunity": m.formattedBenchmarkDataTypes["Annual Incentive Maximum Opportunity"],
        "Maximum Incentive Percentage": m.formattedBenchmarkDataTypes["Maximum Incentive Percentage"],
        "TCC Hourly": m.formattedBenchmarkDataTypes["TCC Hourly"],
        TCC: m.formattedBenchmarkDataTypes["TCC"],
      };
    });

    const filteredRemainingColumns = removeBlankColumns(remainingColumns);
    filteredDataset = firstColumns.map((obj, i) => ({ ...obj, ...filteredRemainingColumns[i] }));
    dataRows = filteredDataset.length + 1;
    dataCols = Object.keys(filteredDataset[0]).length;
    options.success(filteredDataset);
  }

  export async function SaveChanges() {
    const rows = spreadsheet.toJSON().sheets[0].rows.sort((a, b) => a.index - b.index);

    let records = JSON.parse(JSON.stringify(sheetRowsToDataSourceData(rows)));
    let initialData = filterNullProperties(dataBound);

    const invalidMarketSegmentsNames = records
      .map(r => r["Market Segment"])
      .filter(name => name !== "" && name !== null && name !== undefined && !marketSegmentsNames.includes(name));

    if (invalidMarketSegmentsNames.length > 0) {
      notificationWidget.show(`The following are invalid market segments: ${DOMPurify.sanitize(invalidMarketSegmentsNames.join(", "))}`, "error");
      return;
    }

    const differingRows = zip(initialData, records)
      .filter(([row1, row2]) => !isEqual(row1, row2))
      .map(([, row2]) => row2);

    const payload = differingRows.map(r => {
      return {
        aggregationMethodKey: aggregationMethodKey,
        fileOrgKey: fileOrgKey,
        positionCode: r["Position Code"].escape(),
        jobCode: r["Client Job Code"].escape(),
        jobGroup: r["Client Job Group"].escape(),
        marketSegmentId: marketSegments.find(m => m.name == r["Market Segment"])?.id,
      };
    });

    $mutationSaveMappingJobs.mutate(payload);
  }

  export function ExcelExport() {
    jQuery("#kendo-spreadsheet").data("kendoSpreadsheet").saveAsExcel();
  }

  function onHideColumn(arg) {
    let hiddenColumns = localStorage.getItem(localStorageKey) ? JSON.parse(localStorage.getItem(localStorageKey)) : [];

    const entry = hiddenColumns.find(item => item.orgId == orgId && item.projId == projId && item.projVersionId == projVersionId);
    if (!entry) {
      hiddenColumns = [
        ...hiddenColumns,
        {
          orgId: orgId,
          projId: projId,
          projVersionId: projVersionId,
          hiddenColumns: [arg.index],
        },
      ];
      localStorage.setItem(localStorageKey, JSON.stringify(hiddenColumns));
    } else if (entry && !entry.hiddenColumns.includes(arg.index)) {
      entry.hiddenColumns = [...entry.hiddenColumns, arg.index];
      localStorage.setItem(localStorageKey, JSON.stringify(hiddenColumns));
    }
  }

  function onSpreadsheetEdit(e) {
    const editedRowIndex = e.range.topLeft().row;
    const marketSegmentCell = e.range.topLeft().col === 4; // Column index is 4 for "Market Segment" column
    const clientJobGroupCell = e.range.topLeft().col === 5; // Column index is 5 for "Client Job" column

    if (editedRowIndex > 0) {
      const newValue = Array.isArray(e.data) ? e.data[0] && e.data[0][0]?.value : e.data;
      const escapedValue = newValue?.escape();
      const sheet = spreadsheet.sheetByName("Sheet 1");
      let cell;

      if (marketSegmentCell) {
        cell = sheet.range(editedRowIndex, 4);
      } else if (clientJobGroupCell) {
        cell = sheet.range(editedRowIndex, 5);
      }
      cell && cell.value(escapedValue);
    }
  }

  let sampleConfig = {
    toolbar: {
      data: false,
      insert: false,
    },
    sheetsbar: false,
    dataBound: function (e) {
      resizeSheet();
      dataBound = JSON.parse(JSON.stringify(e.sheet.dataSource.data()));

      // hide columns that were hidden before
      const hiddenColumns = localStorage.getItem(localStorageKey);
      if (hiddenColumns) {
        const columns = JSON.parse(hiddenColumns);
        const entry = columns.find(item => item.orgId == orgId && item.projId == projId && item.projVersionId == projVersionId);
        if (entry && entry.hiddenColumns.length > 0) {
          entry.hiddenColumns.forEach(column => {
            sheet.hideColumn(column);
          });
        }
      }
    },
    excel: {
      fileName: "Market-Mapping-Jobs.xlsx",
    },
    rows: MAX_ROWS,
    columns: MAX_COLS,
    columnWidth: 100,
    sheets: [
      {
        name: "Sheet 1",
        columns: [{ width: 150 }, { width: 90 }, { width: 100 }, { width: 145 }, { width: 120 }, { width: 120 }],
        frozenColumns: 6,
        frozenRows: 1,
      },
    ],
    hideColumn: onHideColumn,
    changing: onSpreadsheetEdit,
  };

  // update empty label with "(Blanks)" when filter button is clicked on the spreadsheet
  jQuery(document).on("click", "span.k-spreadsheet-filter", function () {
    jQuery(".k-spreadsheet-value-treeview-wrapper .k-group.k-treeview-group .k-group.k-treeview-group > li").each(function () {
      let text = jQuery(this).find(".k-treeview-leaf-text").text();
      if (text === "") {
        jQuery(this).find(".k-treeview-leaf-text").text("(Blanks)");
      }
    });
  });
</script>

<div id="notification" />
<div style="height: 100vh" id="kendo-wrapper" />
