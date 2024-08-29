<script>
  import { onMount, onDestroy } from "svelte";
  import { useQuery } from "@sveltestack/svelte-query";
  import { getProjectDetails } from "api/apiCalls";
  import { ProjectStatus } from "models/project/projectDetails";
  import { tabFullScreen } from "store/tabs";
  import { projectVersionStore } from "store/project";
  import { getAggregationMethodologyName } from "utils/project";
  import EditableFieldsMessage from "./EditableFieldsMessage/EditableFieldsMessage.svelte";
  import MarketSegmentMappingSpreadSheet from "./MarketSegmentMappingSpreadSheet.svelte";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;

  let MSMappingRef;
  let projectDetails;
  let fullScreenName = "Full Screen";
  let aggregationMethodologyKey = 1;
  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;
  $: isProjectValid = Boolean(projectDetails?.fileStatusName) && projectDetails?.fileStatusName.includes("Valid");

  // load project details
  const queryResult = useQuery(
    ["projectDetails", inputFilterProjectId, inputFilterProjectVersionId],
    async () => {
      const data = await getProjectDetails(inputFilterProjectId, inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  const loadDetails = () => {
    $queryResult.refetch();
  };

  $: if (isFiltersSelected) loadDetails();
  $: if ($queryResult.data) projectDetails = $queryResult.data;
  $: if ($queryResult.error) {
    let notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    notificationWidget?.show("There was an error fetching project details", "error");
  }

  onMount(() => {
    projectVersionStore?.subscribe(store => {
      if (store) {
        aggregationMethodologyKey = store.aggregationMethodologyKey;
      }
    });
  });

  const unsubscribeToTabFullScreen = tabFullScreen.subscribe(value => {
    fullScreenName = value ? "Exit Full Screen" : "Full Screen";
  });

  const toggleFullScreen = () => {
    tabFullScreen.update(() => !$tabFullScreen);
  };

  onDestroy(() => {
    $queryResult.remove();
    unsubscribeToTabFullScreen();
  });
</script>

<span id="notification" />

{#if !isFiltersSelected}
  <div class="alert alert-primary" role="alert">
    To visualize Market Segment Mapping, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{:else}
  <div class="row mb-3">
    <div class="col-5">
      <div class="col-12 d-flex">
        <!-- svelte-ignore a11y-label-has-associated-control -->
        <label class="col-form-label me-2" data-cy="LabelAggregationMethodology">Aggregation Methodology</label>
        <div>
          <input
            type="text"
            id="input-aggregation"
            list="dlOganizationData"
            class="form-control"
            disabled
            value={getAggregationMethodologyName(aggregationMethodologyKey)}
            data-cy="aggregationMethodology"
          />
        </div>
      </div>
    </div>
    <div class="col-5">
      <div class="row">
        <div class="col-12 d-flex justify-content-between">
          <div class="d-flex flex-wrap">
            <button
              class="btn btn-primary me-1"
              data-cy="save"
              on:click={() => MSMappingRef.SaveChanges()}
              disabled={projectDetails?.projectStatus !== ProjectStatus.DRAFT}>Save</button
            >
            <button class="btn btn-primary me-1" data-cy="export" on:click={() => MSMappingRef.ExcelExport()} disabled={!isProjectValid}
              >Export</button
            >
          </div>
        </div>
      </div>
    </div>
    <div class="col-2 text-end">
      <button class="btn btn-primary" data-cy="fullscreen" on:click={toggleFullScreen}>
        <i class="fa fa-arrows-alt" />
        {fullScreenName}
      </button>
    </div>
  </div>
  <EditableFieldsMessage {projectDetails} />
  <MarketSegmentMappingSpreadSheet
    orgId={inputFilterOrgId}
    projId={inputFilterProjectId}
    projVersionId={inputFilterProjectVersionId}
    {isProjectValid}
    bind:this={MSMappingRef}
  />
{/if}

<style>
  .btn-primary {
    min-width: 100px !important;
    margin-right: 5px;
    margin: 2px 5px 2px 0;
  }
</style>
