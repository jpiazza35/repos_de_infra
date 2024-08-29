const headerCustomStyles = "background: #808080; color: #fff; border-color: #fff";

export const marketSegmentGridConfig = {
  navigatable: true,
  filterable: false,
  sortable: true,
  resizable: true,
  pageable: {
    alwaysVisible: true,
    pageSizes: [15, 25, 50],
    pageSize: 15,
  },
  autoBind: false,
};

export const marketSegmentGridColumns = [
  {
    field: "marketSegmentName",
    headerAttributes: { "data-cy": "marketSegmentName", style: headerCustomStyles },
    title: "Market Segment Name",
    width: 300,
    hidden: false,
    visible: true,
    isAlwaysVisible: true,
    editable: () => false,
  },
  {
    field: "marketSegmentDescription",
    headerAttributes: { "data-cy": "marketSegmentDescription", style: headerCustomStyles },
    title: "Description",
    width: 400,
    visible: true,
    hidden: false,
    isAlwaysVisible: true,
    editable: () => false,
  },
  {
    field: "mappedJobs",
    headerAttributes: { "data-cy": "mappedJobs", style: headerCustomStyles },
    title: "# of Jobs Mapped",
    visible: true,
    hidden: false,
    editable: () => false,
  },
  {
    field: "createdUtcDateTime",
    headerAttributes: { "data-cy": "createdUtcDateTime", style: headerCustomStyles },
    title: "Created Date",
    visible: true,
    hidden: false,
    editable: () => false,
    template: date => {
      return date.createdUtcDateTime ? new Date(date.createdUtcDateTime).toLocaleDateString("en-US") : "";
    },
  },
  {
    field: "statusName",
    headerAttributes: { "data-cy": "status", style: headerCustomStyles },
    title: "status",
    visible: true,
    hidden: false,
    editable: () => true,
  },
];
