import { projectVersionStore } from "store/project";

export const marketSummaryGridConfig = {
  dataSource: [],
  navigatable: true,
  sortable: true,
  encoded: true,
  resizable: true,
  dataBound: function () {
    // @ts-ignore
    jQuery(".benchmarkToolTip").kendoTooltip({
      content: "No Survey Data",
      position: "top",
      width: 130,
    });
  },

  noRecords: true,
  columns: [
    {
      field: "clientJobCode",
      headerAttributes: { "data-cy": "clientJobCodeSummary" },
      title: "Client Job Code",
      width: 140,
      hidden: false,
    },
    {
      field: "clientJobTitle",
      headerAttributes: { "data-cy": "clientJobTitleSummary" },
      title: "Client Job Title",
      width: 180,
    },
    {
      field: "fteCount",
      headerAttributes: { "data-cy": "nFTEsSummary" },
      title: "n FTEs =",
      width: 80,
    },
    {
      field: "clientPositionCode",
      headerAttributes: { "data-cy": "clientPositionCodeSummary" },
      title: "Client Position Code",
      width: 180,
      hidden: true,
      template: "#= clientPositionCode ? clientPositionCode : '' #",
    },
    {
      field: "clientPositionCodeDescription",
      headerAttributes: { "data-cy": "clientPositionCodeDescriptionSummary" },
      title: "Client Position Code Description",
      width: 180,
      hidden: true,
      template: "#= clientPositionCodeDescription ? clientPositionCodeDescription : '' #",
    },
    {
      field: "incumbentCount",
      headerAttributes: { "data-cy": "nFTEs2Summary" },
      title: "Incumbent Count",
      width: 180,
      hidden: true,
      template: "#= clientPositionCode ? incumbentCount : '' #",
    },
    {
      field: "marketPricingSheetId",
      headerAttributes: { "data-cy": "marketPricingSheetIdSummary" },
      title: "Market Pricing Sheet ID",
      width: 100,
    },
    {
      field: "benchmarkJobCode",
      headerAttributes: { "data-cy": "benchmarkJobCodeSummary" },
      title: "Benchmark Job Code",
      width: 100,
    },
    {
      field: "benchmarkJobTitle",
      headerAttributes: { "data-cy": "benchmarkJobTitleSummary" },
      title: "Benchmark Job Title",
      width: 130,
    },
    {
      field: "jobMatchAdjustmentNotes",
      headerAttributes: { "data-cy": "jobMatchAdjustmentNotesSummary" },
      title: "Job Match Adjustment Notes",
      width: 100,
      template:
        "#= jobMatchAdjustmentNotes ? '<span data-cy=\"jobMatchAdjustmentNotesCy\">' + jobMatchAdjustmentNotes.unescape() + '</span>' : '--' #",
    },
    {
      field: "marketSegment",
      headerAttributes: { "data-cy": "marketSegmentSummary" },
      title: "Market Segment",
      width: 150,
    },
    {
      field: "jobGroup",
      headerAttributes: { "data-cy": "jobGroupSummary" },
      title: "Job Group",
      width: 150,
    },
    {
      field: "dataScope",
      headerAttributes: { "data-cy": "dataScopeSummary" },
      title: "Data Scope",
      width: 150,
    },
  ],
  excelExport: function (e) {
    let sheet = e.workbook.sheets[0];
    let columns = sheet.columns;
    let rows = sheet.rows;
    let columnIndexFormat = [];
    columns.forEach(column => {
      delete column.width;
      column.autoWidth = true;
    });

    let headerRows = sheet.rows.filter(row => row.type === "header");
    if (headerRows[0].cells.length) {
      paintDynamicHeader(headerRows[0], columnIndexFormat);
    }
    if (headerRows[1].cells.length) {
      headerRows[1] = paintDynamicSubHeader(headerRows[1]);
    }
    let orgName, projectName, projectVersionLabel;

    projectVersionStore?.subscribe(store => {
      orgName = store.organizationName;
      projectName = store.projectName;
      projectVersionLabel = store.versionLabel;
    });

    formatColumnData(headerRows, rows);
    let fileName = `MarketSummaryExport_${orgName}_${projectName}_${projectVersionLabel}`;
    e.workbook.fileName = `${fileName}.xlsx`;
  },
};

export const employeeSummaryGridConfig = {
  columns: [
    {
      field: "incumbentId",
      headerAttributes: { "data-cy": "incumbentIdIDEmployeeSummary" },
      title: "Client Employee ID",
      width: 140,
    },
    {
      field: "incumbentName",
      headerAttributes: { "data-cy": "incumbentNameEmployeeSummary" },
      title: "Client Employee Name",
      width: 180,
    },
    {
      field: "clientJobCode",
      headerAttributes: { "data-cy": "clientJobCodeEmployeeSummary" },
      title: "Client Job Code",
      width: 140,
    },
    {
      field: "clientJobTitle",
      headerAttributes: { "data-cy": "clientJobTitleEmployeeSummary" },
      title: "Client Job Title",
      width: 180,
    },
    {
      field: "marketPricingSheetId",
      headerAttributes: { "data-cy": "marketPricingSheetIdEmployeeSummary" },
      title: "Market Pricing Sheet ID",
      width: 100,
    },
    {
      field: "benchmarkJobCode",
      headerAttributes: { "data-cy": "benchmarkJobCodeEmployeeSummary" },
      title: "Benchmark Job Code",
      width: 100,
    },
    {
      field: "benchmarkJobTitle",
      headerAttributes: { "data-cy": "benchmarkJobTitleEmployeeSummary" },
      title: "Benchmark Job Title",
      width: 130,
    },
    {
      field: "jobMatchAdjustmentNotes",
      headerAttributes: { "data-cy": "jobMatchAdjustmentNotesEmployeeSummary" },
      title: "Job Match Adjustment Notes",
      width: 100,
      template: "#= jobMatchAdjustmentNotes ? jobMatchAdjustmentNotes : '--' #",
    },
    {
      field: "marketSegment",
      headerAttributes: { "data-cy": "marketSegmentEmployeeSummary" },
      title: "Market Segment",
      width: 150,
    },
    {
      field: "jobGroup",
      headerAttributes: { "data-cy": "jobGroupEmployeeSummary" },
      title: "Job Group",
      width: 150,
    },
    {
      field: "dataScope",
      headerAttributes: { "data-cy": "dataScopeEmployeeSummary" },
      title: "Data Scope",
      width: 150,
    },
  ],
};

const borderStyle = { color: "#FFFFFF", size: 1 };
const benchmarkColumnBackground = "#48484C";
const comparisonColumnBackground = "#747477";

const paintDynamicHeader = (headerRow, columnIndexFormat) => {
  let dataScopeColumnIndex = -1;
  headerRow.cells.forEach((cell, columnIndex) => {
    const { background, value } = cell;
    const lastStaticColumn = background === "#7a7a7a" && value === "Data Scope";
    if (lastStaticColumn) {
      dataScopeColumnIndex = columnIndex;
    }
    if (dataScopeColumnIndex !== -1 && columnIndex > dataScopeColumnIndex) {
      columnIndexFormat.push({ index: columnIndex, value: value });
      cell.borderBottom = cell.borderLeft = cell.borderRight = cell.borderTop = borderStyle;
      cell.background = columnIndex % 2 === 0 ? benchmarkColumnBackground : comparisonColumnBackground;
    }
  });
};

const paintDynamicSubHeader = headerRow => {
  const comparisonRatio = "Ratio to <br/> Market";
  const benchmarkPercentile = "Market <br/>";
  const average = "Average";
  headerRow.cells.forEach(cell => {
    const { value } = cell;
    if (value.includes(benchmarkPercentile)) {
      cell.value = value.includes("<br/>") ? value.replace("<br/>", "\n") : value;
      cell.background = benchmarkColumnBackground;
      cell.textAlign = "center";
      cell.borderLeft = cell.borderRight = borderStyle;
      cell.type = "benchmark";
    } else if (value.includes(comparisonRatio) || value.includes(average)) {
      cell.value = value.replace(/<br\/>/g, "\n");
      cell.textAlign = "center";
      value.includes(average) ? (cell.type = "average") : (cell.type = "comparison");
      cell.background = comparisonColumnBackground;
    }
  });
  return headerRow;
};

const formatColumnData = (headerRows, rows) => {
  let staticArrayRange = [...Array(10)];
  const headerIndices = staticArrayRange
    .concat(headerRows[1].cells)
    .map(cell => (cell?.type === "benchmark" || cell?.type === "average" ? true : false));

  const dataRows = rows.filter(r => r.type !== "header");

  dataRows.map(row => {
    for (let i = 0; i < row.cells.length; i++) {
      const cell = row.cells[i];
      const isHeader = headerIndices[i];
      if (isHeader && cell.value !== "" && !isNaN(cell.value)) {
        cell.value = cell.value ? `$${cell.value.toFixed(2)}` : `---`;
      }
    }
  });
};
