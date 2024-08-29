import { getFileToDownload, getFileDetails } from "../../../../api/apiCalls";
import { promiseWrap } from "../../../../utils/functions";
import { headerCustomStyles } from "components/shared/functions";

export const projConfig = {
  excel: {
    fileName: "ProjectGridExport.xlsx",
  },
  navigatable: true,
  filterable: false,
  sortable: true,
  resizable: true,
  editable: false,
  pageable: {
    alwaysVisible: true,
    pageSizes: [15, 25, 50],
    pageSize: 15,
  },
  autoBind: false,
};

const handleSourceDataClick = async e => {
  e.stopPropagation();
  e.preventDefault();

  const notificationWidget = jQuery("#notification").data("kendoNotification");
  const grid = jQuery("#grid").data("kendoGrid");

  const dataItem = grid.dataItem(e.target.closest("tr"));
  const { fileLogKey } = dataItem;

  if (fileLogKey) {
    let [fileResponse] = await promiseWrap(getFileToDownload(fileLogKey));
    let downloadLink = document.createElement("a");
    downloadLink.href = fileResponse;
    downloadLink.style.display = "none";
    downloadLink.click();
    notificationWidget.show("Your file has been downloaded", "success");
  } else {
    notificationWidget.show("No file key provided", "error");
  }
};

const handleFileStatusClick = async e => {
  e.stopPropagation();
  e.preventDefault();

  const notificationWidget = jQuery("#notification").data("kendoNotification");
  const grid = jQuery("#grid").data("kendoGrid");

  const dataItem = grid.dataItem(e.target.closest("tr"));
  const { fileLogKey, projectVersionLabel } = dataItem;

  if (fileLogKey) {
    let [fileDetailsResponse, error] = await promiseWrap(getFileDetails(fileLogKey));

    if (error) {
      notificationWidget.show("Error downloading file", "error");
    } else {
      const csvdata = createCsvData(fileDetailsResponse);
      downloadDataToCsv(fileDetailsResponse, projectVersionLabel, csvdata);
      notificationWidget.show("Your file has been downloaded", "success");
    }
  } else {
    notificationWidget.show("No file key provided", "error");
  }
};

const createCsvData = function (data) {
  if (!data) {
    return null;
  }

  let csvRows = [];

  for (let i = 0; i < data.details?.length; i++) {
    const values = Object.values(data.details[i]);
    const size = values.length;
    const time = values[size - 1];
    const text = values[size - 2];
    const row = time + ": " + text;
    csvRows.push(row);
  }

  return csvRows.join("\n");
};

const downloadDataToCsv = function (data, projectVersionLabel, csvData) {
  if (!data) {
    return;
  }

  const clientFileName = data.clientFileName?.split(".")[0] ?? "Filename";
  const projectVersion = projectVersionLabel ?? "ProjectVersion";
  const fileName = `${clientFileName}_${projectVersion}_Logs.csv`;
  const blob = new Blob([csvData], { type: "text/csv" });

  // Creating an object for downloading url
  const url = window.URL.createObjectURL(blob);

  const a = document.createElement("a");
  a.setAttribute("href", url);
  a.setAttribute("download", fileName);
  a.click();
};

export const renderProjectColumns = sourceGroupData => {
  let projColumns = [
    {
      field: "organization",
      headerAttributes: {
        style: "vertical-align: top;" + headerCustomStyles,
        "data-cy": "Organization",
      },
      template: data => {
        return `${data.organization} - ${data.organizationId}`;
      },
      title: "Organization",
      width: 223,
    },
    {
      field: "id",
      headerAttributes: {
        "data-cy": "id",
        style: headerCustomStyles,
      },
      title: "Project Id",
      width: 90,
    },
    {
      field: "name",
      headerAttributes: {
        "data-cy": "name",
        style: headerCustomStyles,
      },
      title: "Project Name",
      width: 115,
    },
    {
      field: "projectVersion",
      headerAttributes: {
        "data-cy": "projectVersion",
        style: headerCustomStyles,
      },
      title: "Project Version",
      width: 125,
    },
    {
      field: "projectVersionLabel",
      title: "Project Version Label",
      width: 165,
      headerAttributes: {
        "data-cy": "projectVersionLabel",
        style: headerCustomStyles,
      },
    },
    {
      field: "projectVersionDate",
      headerAttributes: {
        "data-cy": "projectVersionDate",
        style: headerCustomStyles,
      },
      template: "#= kendo.toString(kendo.parseDate(projectVersionDate, 'yyyy-MM-dd'), 'MM/dd/yyyy') #",
      title: "Version Date",
      width: 110,
    },
    {
      field: "status",
      headerAttributes: {
        "data-cy": "status",
        style: headerCustomStyles,
      },
      title: "Project Status",
      width: 120,
    },
    {
      field: "sourceData",
      title: "Source Data",
      headerAttributes: {
        "data-cy": "sourceData",
        style: headerCustomStyles,
      },
      command: {
        name: "sourceData",
        title: "Source Data",
        click: e => {
          handleSourceDataClick(e);
        },
        attributes: {
          class: "action-project-table sourceData",
        },
      },
      width: 110,
    },
    {
      field: "dataEffectiveDate",
      template:
        "# if (dataEffectiveDate != null) { #" +
        "#= kendo.toString(kendo.parseDate(dataEffectiveDate), 'MM/dd/yyyy') #" +
        "# } else { #" +
        "" +
        "# } #",
      headerAttributes: {
        "data-cy": "DateEffectiveDate",
        style: headerCustomStyles,
      },
      title: "Data Effective Date",
      width: 153,
    },
    {
      field: "fileStatusName",
      headerAttributes: {
        "data-cy": "fileStatusName",
        style: headerCustomStyles,
      },
      title: "File Status",
      width: 160,
      command: {
        name: "fileStatusName",
        title: "File Status",
        click: e => {
          handleFileStatusClick(e);
        },
        attributes: {
          class: "action-project-table fileStatusName",
        },
      },
    },
    {
      field: "aggregationMethodologyName",
      headerAttributes: {
        "data-cy": "AggregationMethodology",
        style: headerCustomStyles,
      },
      title: "Aggregation Methodology",
      width: 198,
    },
    {
      field: "workForceProjectType",
      template: data => {
        return sourceGroupData && sourceGroupData.find(surveySource => surveySource?.id === data.workForceProjectType)?.name;
      },
      headerAttributes: {
        "data-cy": "WorkforceProjectType",
        style: headerCustomStyles,
      },
      title: "Workforce Project Type",
      width: 180,
    },
  ];

  return projColumns;
};
