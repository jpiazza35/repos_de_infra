// @ts-nocheck
import PopoverCell from "components/grid/PopoverCell.svelte";
import { headerCustomStyles } from "components/shared/functions";
import { writable } from "svelte/store";

export const gridConfig = {
  dataSource: [],
  navigatable: true,
  filterable: {
    extra: false,
    operators: {
      string: {
        contains: "Contains",
      },
    },
  },
  sortable: true,
  resizable: true,
  dataBound: function (e) {
    this.lockedHeader.find("th:first")[0].innerHTML = ``;
    mounPopoverComponent(e);
  },
  columns: [
    {
      selectable: true,
      title: "Select",
      width: 40,
      attributes: { class: "k-text-center" },
      hidden: false,
      visible: true,
      isAlwaysVisible: true,
      locked: true,
      headerAttributes: { style: headerCustomStyles },
    },
    {
      field: "organizationName",
      headerAttributes: { "data-cy": "organizationName", style: headerCustomStyles },
      title: "Organization",
      width: 200,
      hidden: false,
      visible: true,
      isAlwaysVisible: true,
      locked: true,
    },
    {
      field: "jobCode",
      headerAttributes: { "data-cy": "clientJobCode", style: headerCustomStyles },
      title: "Client Job Code",
      width: 130,
      visible: true,
      hidden: false,
      isAlwaysVisible: true,
      locked: true,
    },
    {
      field: "positionCode",
      headerAttributes: { "data-cy": "clientPositionCode", style: headerCustomStyles },
      title: "Client Position Code",
      width: 130,
      visible: true,
      hidden: false,
    },
    {
      field: "jobTitle",
      headerAttributes: { "data-cy": "clientJobTitle", style: headerCustomStyles },
      title: "Client Job Title",
      width: 200,
      visible: true,
      hidden: false,
    },
    {
      field: "jobGroup",
      headerAttributes: { "data-cy": "clientJobGroup", style: headerCustomStyles },
      title: "Client Job Group",
      width: 200,
      visible: true,
      hidden: false,
    },
    {
      field: "marketSegmentName",
      headerAttributes: { "data-cy": "marketSegmentName", style: headerCustomStyles },
      title: "Market Segment",
      width: 150,
      visible: true,
      hidden: false,
    },
    {
      field: "standardJobCode",
      headerAttributes: { "data-cy": "standardJobCode", style: headerCustomStyles },
      title: "Standard Job Code",
      width: 150,
      visible: true,
      hidden: false,
    },
    {
      field: "standardJobTitle",
      headerAttributes: { "data-cy": "standardJobTitle", style: headerCustomStyles },
      title: "Standard Job Title",
      width: 200,
      visible: true,
      hidden: false,
    },
    {
      field: "standardJobDescription",
      headerAttributes: { "data-cy": "standardJobDescription", style: headerCustomStyles },
      template: "<div class='svelte-popover-container'></div>",
      title: "Standard Job description",
      width: 200,
      visible: true,
      hidden: false,
    },
    {
      field: "jobMatchStatusName",
      headerAttributes: { "data-cy": "matchStatus", style: headerCustomStyles },
      title: "Status",
      width: 150,
      visible: true,
      hidden: false,
    },
    {
      field: "jobMatchNote",
      headerAttributes: { "data-cy": "jobMatchNote", style: headerCustomStyles },
      title: "Job Match Notes",
      width: 200,
      visible: true,
      hidden: false,
    },
  ],
};

const mounPopoverComponent = e => {
  e.sender.tbody.find(".svelte-popover-container").each(function (index) {
    const cell = jQuery(this);
    const dataItem = e.sender.dataItem(cell.closest("tr"));
    const { standardJobDescription } = dataItem;
    new PopoverCell({
      target: this,
      props: {
        id: `popover-job-description-${index}`,
        text: standardJobDescription,
      },
    });
  });
};

export const columnsStore = writable(
  gridConfig.columns
    .map(column => {
      return {
        title: column.title,
        field: column.field,
        show: true,
      };
    })
    .filter(column => {
      return column.field && column.field !== "organizationName" && column.field !== "jobCode";
    }),
);

export const JobMatchStatus = {
  NotStarted: 7,
  AnalystReviewed: 8,
  PeerReviewed: 9,
  Complete: 10,
  7: "Not Started",
  8: "Analyst Reviewed",
  9: "Peer Reviewed",
  10: "Complete",
};
