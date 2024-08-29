<script>
  // @ts-nocheck

  import { onMount, createEventDispatcher } from "svelte";
  import { promiseWrap } from "utils/functions";
  import { getMarketSegmentSurveyData, updateMarketSegmentSurveyData } from "api/apiCalls";
  import { updateKendoGridStyles, headerCustomStyles } from "components/shared/functions";

  import { marketSegmentStore } from "../Sections/marketSegmentStore";
  import CryptoJS from "crypto-js";

  export let selectedFilters = null;
  export let canUpdateSurveyDetails = false;
  export let marketSegmentId = null;
  export let surveyData = [];
  export let allSurveyData = [];
  export let isProjectStatusFinal = false;

  const dispatch = createEventDispatcher();

  const close = () => {
    dispatch("close");
  };

  $: dispatch("dataUpdate", { hasUnSavedChanges });

  let notificationWidget = null;
  let container = null;
  let hasUnSavedChanges = false;

  onMount(async () => {
    if (canUpdateSurveyDetails) {
      const encrypted = localStorage.getItem("userRoles");
      const bytes = CryptoJS.AES.decrypt(encrypted, "MPT");
      const userRoles = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));
      canUpdateSurveyDetails = marketSegmentId && userRoles.includes("WRITE_MARSEG") && !isProjectStatusFinal;
    }
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    registerKendoGrid();
    await getSurveyData();
  });

  const registerKendoGrid = () => {
    jQuery(container).kendoGrid({
      dataSource: surveyData,
      dataBound: function () {
        this.thead.find("th:first")[0].innerHTML = `<span class="k-column-title">Select</span>`;
        var grid = this;
        grid.items().each(function () {
          var dataItem = grid.dataItem(this);
          if (dataItem.selected) {
            grid.select(this);
          }
        });
      },
      change: function () {
        const selectedRows = this.select();
        hasUnSavedChanges = selectedRows.length !== surveyData.filter(d => d.selected).length;
      },
      noRecords: {
        template: () => `<div class="w-100 mt-4 d-flex justify-content-center"><span>There is no data available to view.</span></div>`,
      },
      navigatable: true,
      filterable: false,
      sortable: true,
      resizable: true,
      columns: [
        {
          selectable: true,
          title: "Select",
          width: 40,
          attributes: { class: "k-text-center" },
          hidden: !canUpdateSurveyDetails,
          headerAttributes: { style: headerCustomStyles },
        },
        {
          field: "publisherName",
          headerAttributes: { "data-cy": "survey-publisher", style: headerCustomStyles },
          title: "Survey Publisher",
          width: 80,
        },
        {
          field: "year",
          headerAttributes: { "data-cy": "survey-year", style: headerCustomStyles },
          title: "Survey Year",
          width: 50,
        },
        {
          field: "surveyName",
          headerAttributes: { "data-cy": "survey-name", style: headerCustomStyles },
          title: "Survey Name",
          width: 100,
        },
        {
          field: "industrySectorName",
          headerAttributes: { "data-cy": "industry-sector", style: headerCustomStyles },
          title: "Industry/Sector",
          width: 80,
        },
        {
          field: "organizationTypeName",
          headerAttributes: { "data-cy": "org-type", style: headerCustomStyles },
          title: "Org Type",
          width: 80,
        },
        {
          field: "cutGroupName",
          headerAttributes: { "data-cy": "cut-group", style: headerCustomStyles },
          title: "Cut Group",
          width: 80,
        },
        {
          field: "cutSubGroupName",
          headerAttributes: { "data-cy": "cut-sub-group", style: headerCustomStyles },
          title: "Cut Sub-Group",
          width: 80,
        },
        {
          field: "cutName",
          headerAttributes: { "data-cy": "cut", style: headerCustomStyles },
          title: "Cut",
          width: 80,
        },
      ],
    });

    updateKendoGridStyles(".survey-grid");
  };

  const getSurveyData = async () => {
    kendo.ui.progress(jQuery(".grid-loading"), true);
    if (!surveyData.length && selectedFilters) {
      const [surveyDataResponse, surverDataError] = await promiseWrap(getMarketSegmentSurveyData(selectedFilters));
      if (surverDataError) {
        notificationWidget.show("Error while fetching survey data. Please try again later.", "error");
        return;
      }

      surveyData = [...surveyDataResponse];
    }

    surveyData = surveyData.flat();
    surveyData = surveyData.map(data => ({
      ...data,
      publisherName: data.surveyPublisherName || data.publisherName,
      year: data.surveyYear || data.year,
    }));

    jQuery(container).data("kendoGrid")?.dataSource.data(surveyData); // update grid data
    jQuery(".survey-grid .k-grid-content tbody td").css({ "background-color": "inherit" });
    kendo.ui.progress(jQuery(".grid-loading"), false);
  };

  const saveSurveyData = async () => {
    const grid = jQuery(container).data("kendoGrid");
    const selectedRows = grid.select();
    const selectedDataItems = [];
    for (let i = 0; i < selectedRows.length; i++) {
      const dataItem = grid.dataItem(selectedRows[i]);
      selectedDataItems.push(dataItem);
    }

    if (selectedDataItems.length !== surveyData.length) {
      let deletedItems =
        surveyData.filter(data => !selectedDataItems.some(item => item.marketSegmentCutDetailKey === data.marketSegmentCutDetailKey)) || [];
      allSurveyData.forEach(data => {
        if (surveyData.some(item => item.marketSegmentCutDetailKey === data.marketSegmentCutDetailKey)) {
          data.selected = !deletedItems.some(item => item.marketSegmentCutDetailKey === data.marketSegmentCutDetailKey);
        }
      });

      kendo.ui.progress(jQuery(".grid-loading"), true);
      const [response, error] = await promiseWrap(updateMarketSegmentSurveyData(marketSegmentId, allSurveyData));
      if (error) {
        notificationWidget.show("Error while saving survey data. Please try again later.", "error");
        return;
      }

      let marketSegment = response;
      marketSegment = { ...marketSegment, selectionCuts: marketSegment.cuts };
      marketSegmentStore.update(store => ({
        ...store,
        id: response.id,
        marketSegment: marketSegment,
      }));

      hasUnSavedChanges = false;
      notificationWidget.show("Survey level details saved successfully.", "success");
      kendo.ui.progress(jQuery(".grid-loading"), false);
    }
  };
</script>

<div id="dialogSurveyLevelDetails" data-cy="dialogSurveyLevelDetails" />

<span id="notification" />

<div data-cy="survey-level-details">
  <div class="card-header card-header-sticky">
    <h5 class="my-2" data-cy="modalTitle">Survey Level Details</h5>
  </div>

  <div class="m-4">
    <div class="survey-grid" bind:this={container} />
  </div>

  <div class="card-footer d-flex flex-wrap justify-content-end">
    <div class="d-flex justify-content-end">
      {#if canUpdateSurveyDetails}
        <button class="btn btn-primary mx-2" data-cy="saveBtn" on:click={saveSurveyData} disabled={!hasUnSavedChanges}>Save</button>
      {/if}

      <button class="btn btn-primary mx-2" data-cy="closeBtn" on:click={close}>Close</button>
    </div>
  </div>
</div>

<style>
  .card-header-sticky {
    position: sticky;
    top: 0;
    background-color: lightgray;
    z-index: 1055;
    color: black;
    font-weight: 600;
  }
</style>
