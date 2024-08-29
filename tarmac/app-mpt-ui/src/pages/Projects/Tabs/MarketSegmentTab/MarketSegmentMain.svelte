<script>
  // @ts-nocheck
  import { onMount, onDestroy } from "svelte";
  import { useQuery } from "@sveltestack/svelte-query";
  import MSFilters from "./Sections/MSFilters.svelte";
  import MSBlend from "./Sections/MSBlend.svelte";
  import MSERI from "./Sections/MSERI.svelte";
  import MSSelectedCuts from "./Sections/MSSelectedCuts.svelte";
  import MSCombinedAverage from "./Sections/MSCombinedAverage.svelte";
  import MSAdd from "./Sections/MSAdd.svelte";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import { promiseWrap } from "utils/functions";
  import { MarketSegmentStatusOptions } from "utils/constants";
  import { getProjectStatus, getMarketSegments, getMarketSegmentCuts } from "api/apiCalls";
  import { tabFullScreen } from "store/tabs";
  import { MSSectionTypes, navigateTo } from "./Sections/MSNavigationManager";
  import { ProjectStatus } from "models/project/projectDetails";
  import { cutNamesStore, marketSegmentStore, filterStore, unsavedMarketSegmentStore } from "./Sections/marketSegmentStore";
  import MarketSegmentGrid from "./grid/MarketSegmentGrid.svelte";
  import Loading from "components/shared/loading.svelte";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;

  $: inputFilterProjectVersionId && getMarketSegmentsOnVersionChange();

  // When one of the top level filters change check if the market segment section must be shown
  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;

  let notificationWidget = null;
  let marketSegments = [];
  let selectedMarketSegment;
  let showMarketSegmentSections = false;
  let isProjectStatusFinal = false;
  let fullScreenName = "Full Screen";
  let isLoading = false;

  // load market segment cuts
  const queryCuts = useQuery(
    ["cutsNames", $marketSegmentStore.id],
    async () => {
      const data = await getMarketSegmentCuts($marketSegmentStore.id);
      return data.data;
    },
    { enabled: false },
  );

  $: $marketSegmentStore, refetchQuery();
  $: if ($queryCuts.data) cutNamesStore.set($queryCuts.data.filter(cut => cut !== ""));

  const refetchQuery = () => {
    if ($marketSegmentStore.id > 0) $queryCuts.refetch();
  };

  onMount(() => {
    // registerKendoControls();
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  });

  $: $marketSegmentStore, setUnsavedChanges();

  addEventListener("newMarketSegmentAdded", async e => {
    e.preventDefault();
    await getMarketSegmentsOnVersionChange();
  });

  // Mount tooltip for each header of each Grid in the page
  jQuery(document)
    .kendoTooltip({
      filter: "th", // Select the th elements of the Grid.
      position: "top",
      width: 250,
      content: function (e) {
        return e.target.text();
      },
    })
    .data("kendoTooltip");

  const setUnsavedChanges = () => {
    // show unsaved prompt if the user is creating a new market segment
    if (!$marketSegmentStore.isEditing && $marketSegmentStore.id === 0 && $marketSegmentStore.marketSegment) {
      unsavedMarketSegmentStore.set(true);
    } else {
      unsavedMarketSegmentStore.set(false);
    }
  };

  const getProjectStatusOnVersionChange = async () => {
    if (!inputFilterProjectId) return false;

    const [projectVersionStatusResponse, projectVersionStatusError] = await promiseWrap(getProjectStatus(inputFilterProjectId));
    if (projectVersionStatusError) {
      notificationWidget.show("Error while getting project status", "error");
      return false;
    }
    return projectVersionStatusResponse === ProjectStatus.FINAL;
  };

  const getMarketSegmentsOnVersionChange = async () => {
    showMarketSegmentSections = false;
    isLoading = true;
    isProjectStatusFinal = await getProjectStatusOnVersionChange();
    const [marketSegmentsResponse, marketSegmentsError] = await promiseWrap(getMarketSegments(inputFilterProjectVersionId));
    if (marketSegmentsError) {
      notificationWidget.show("Error while getting market segments for the selected project version", "error");
      return;
    }

    marketSegments = marketSegmentsResponse;
    isLoading = false;
  };

  const handleOnSaveSegment = async event => {
    refetchQuery();
    selectedMarketSegment = event.detail;
    const [marketSegmentsResponse, marketSegmentsError] = await promiseWrap(getMarketSegments(inputFilterProjectVersionId));
    if (marketSegmentsError) {
      notificationWidget.show("Error while getting market segments for the selected project version", "error");
      return;
    }
    marketSegments = marketSegmentsResponse;
  };

  function editMarketSegment(data) {
    filterStore.reset();
    notificationWidget.hide();
    selectedMarketSegment = marketSegments.find(marketSegment => marketSegment.id === data.detail.marketSegmentId);
    if (selectedMarketSegment) {
      marketSegmentStore.update(store => ({
        ...store,
        isEditing: true,
        marketSegment: selectedMarketSegment,
        marketSegmentName: selectedMarketSegment?.name || data.detail.marketSegmentName,
        marketSegmentDescription: selectedMarketSegment?.description || data.detail.marketSegmentDescription,
        id: selectedMarketSegment?.id || data.detail.marketSegmentId,
        projectVersionId: selectedMarketSegment?.projectVersionId,
        status: isProjectStatusFinal ? MarketSegmentStatusOptions[5] : MarketSegmentStatusOptions[4],
      }));
      setShowFinalDialog($marketSegmentStore.isEditing);

      showMarketSegmentSections = true;
      setTimeout(() => navigateTo("", selectedMarketSegment.cuts?.length ? MSSectionTypes.CUTS : MSSectionTypes.FILTERS), 10);
    }
  }

  const unsubscribeToTabFullScreen = tabFullScreen.subscribe(value => {
    fullScreenName = value ? "Exit Full Screen" : "Full Screen";
  });

  const toggleFullScreen = () => {
    tabFullScreen.update(() => !$tabFullScreen);
  };

  onDestroy(() => {
    unsubscribeToTabFullScreen();
    marketSegmentStore.reset();
  });

  $: showFinalDialog = isProjectStatusFinal && isFiltersSelected;
  const setShowFinalDialog = editing => {
    if (editing) {
      showFinalDialog = false;
      return showFinalDialog;
    }
    if (isProjectStatusFinal && isFiltersSelected) {
      showFinalDialog = isProjectStatusFinal && isFiltersSelected;
      return showFinalDialog;
    }
    showFinalDialog = !isProjectStatusFinal && isFiltersSelected;
    return false;
  };

  const backToGridView = () => {
    if ($unsavedMarketSegmentStore) {
      jQuery("#confirmation-kendo-dialog").kendoDialog({
        title: "Confirmation Required",
        visible: false,
        content: "Are you sure you want to leave? All changes will be lost.",
        actions: [
          {
            text: "Yes",
            primary: true,
            action: () => {
              showMarketSegmentSections = false;
            },
          },
          { text: "No", primary: false },
        ],
      });

      const dialog = jQuery("#confirmation-kendo-dialog").data("kendoDialog");
      dialog.open();
      updateKendoDialogStyles(dialog.element);
    } else {
      showMarketSegmentSections = false;
    }
  };
</script>

<div id="confirmation-kendo-dialog" />
{#if !isFiltersSelected}
  <div class="alert alert-primary" role="alert" data-cy="filterSelectCy">
    To visualize Market Segment, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{/if}

{#if isFiltersSelected && !showMarketSegmentSections}
  {#if isProjectStatusFinal}
    <div class="alert alert-primary mb-2" role="alert">
      This project is currently on <span class="alert-link">Final Status</span>. Select a <span class="alert-link">Market Segment Name</span> to view details.
    </div>
  {/if}
  {#if isLoading}
    <div class="overlay">
      <Loading {isLoading} />
    </div>
  {/if}

  {#if !isLoading}
    <MSAdd {inputFilterProjectVersionId} {isProjectStatusFinal} />
    <MarketSegmentGrid
      {inputFilterProjectId}
      {inputFilterProjectVersionId}
      {isProjectStatusFinal}
      on:Edit={editMarketSegment}
      on:SaveAs={getMarketSegmentsOnVersionChange}
    />
  {/if}
{/if}

{#if showMarketSegmentSections && isFiltersSelected}
  <div class="mx-4 w-100">
    <div class="d-flex justify-content-between col-lg-12 col-md-12 col-md-12 flex-wrap">
      <div class="col-10 d-flex align-items-center">
        <div class="d-flex align-items-center col-5">
          <!-- svelte-ignore a11y-label-has-associated-control -->
          <label class="whitespace-nowrap" data-cy="MSNameLabel">Market Segment Name</label>
          <input
            class="form-control mx-2"
            id="marketSegmentName"
            name="marketSegmentName"
            data-cy="marketSegmentNameControl"
            placeholder="Enter Market Segment Name"
            maxlength="100"
            on:change={() => unsavedMarketSegmentStore.set(true)}
            bind:value={$marketSegmentStore.marketSegmentName}
            class:is-invalid={!$marketSegmentStore.marketSegmentName?.trim()?.length}
          />
        </div>
        <div class="d-flex align-items-center col-5 mx-4">
          <!-- svelte-ignore a11y-label-has-associated-control -->
          <label class="whitespace-nowrap" data-cy="MSDescriptionLabel">Market Segment Description</label>
          <input
            class="form-control mx-2"
            id="marketSegmentDescription"
            name="marketSegmentDescription"
            data-cy="marketSegmentDescriptionControl"
            placeholder="Enter Market Segment Description"
            on:change={() => unsavedMarketSegmentStore.set(true)}
            bind:value={$marketSegmentStore.marketSegmentDescription}
            class:is-invalid={$marketSegmentStore.marketSegmentDescription?.trim()?.length > 100}
          />
        </div>
      </div>

      <div class="col-2">
        <button class="btn btn-primary mx-4" data-cy="" on:click={backToGridView}> Back </button>
        <button class="btn btn-primary" data-cy="export" style="margin: 0 0 0 auto;" on:click={toggleFullScreen}>
          <i class="fa fa-arrows-alt" />
          {fullScreenName}
        </button>
      </div>
    </div>
    <div />
  </div>
  <div class="row p-2">
    <div class="accordion accordion-flush accbox" id="accordionContainer" data-cy="accordionContainer">
      <MSFilters {isProjectStatusFinal} />
      <MSSelectedCuts {marketSegments} projectVersionId={inputFilterProjectVersionId} {isProjectStatusFinal} on:saveSegment={handleOnSaveSegment} />
      <MSERI {isProjectStatusFinal} />
      <MSBlend {isProjectStatusFinal} />
      <MSCombinedAverage {isProjectStatusFinal} />
    </div>
  </div>
{/if}

<span id="notification" />
<div id="deleteDialog" data-cy="deleteDialog" />

<style>
  .btn-primary {
    min-width: 90px !important;
    margin-right: 5px;
    margin: 2px 5px 2px 0;
  }

  #accordionContainer {
    border: 1px solid rgba(0, 0, 0, 0.125);
    padding: 0px;
  }

  .whitespace-nowrap {
    white-space: nowrap;
  }

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
</style>
