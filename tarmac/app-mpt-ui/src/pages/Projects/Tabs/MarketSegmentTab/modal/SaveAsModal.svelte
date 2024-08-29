<script>
  // @ts-nocheck
  import { createEventDispatcher, onMount } from "svelte";
  import { getProjectVersionList, saveMarketSegment, getMarketSegmentsList } from "api/apiCalls";
  import { useQuery, useMutation } from "@sveltestack/svelte-query";
  import { promiseWrap } from "utils/functions";
  import Loading from "components/shared/loading.svelte";

  export let marketSegments;
  export let sourceMarketSegment;
  export let sourceMarketSegmentName = "";
  export let sourceProjectVersion;
  export let sourceProjectId;

  let projectVersionList = [];
  let updatedMarketSegmentName = "";
  let updatedProjectVersion = "";
  let notificationWidget;

  const dispatch = createEventDispatcher();
  const close = () => dispatch("close", {});
  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    updatedMarketSegmentName = sourceMarketSegmentName;
    updatedProjectVersion = sourceProjectVersion;
    $queryProjectVersionList.refetch();
  });

  // load project versions from selected project
  const queryProjectVersionList = useQuery(
    ["projectVersionList", sourceProjectId],
    async () => {
      const data = await getProjectVersionList(sourceProjectId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryProjectVersionList.data) {
    projectVersionList = $queryProjectVersionList.data;
  }

  const saveAsMarketSegment = () => {
    if (!updatedProjectVersion || !updatedMarketSegmentName) {
      return;
    }

    const isMarketSegmentNameInValid =
      updatedMarketSegmentName?.length == 0 ||
      marketSegments.find(ms => ms.marketSegmentName === updatedMarketSegmentName) ||
      (updatedMarketSegmentName == sourceMarketSegmentName && updatedProjectVersion == sourceProjectVersion);

    if (isMarketSegmentNameInValid) {
      notificationWidget?.show("The market segment name must be unique for a project version", "error");
      return;
    }

    const payload = {
      id: sourceMarketSegment.id,
      projectVersionId: updatedProjectVersion,
      name: updatedMarketSegmentName,
      description: sourceMarketSegment.marketSegmentDescription
    };

    $mutationSave.mutate(payload);
  };

  $: if (updatedProjectVersion) {
    getMarketSegmentsOnVersionChange();
  }

  const getMarketSegmentsOnVersionChange = async () => {
    const [marketSegmentsResponse, marketSegmentsError] = await promiseWrap(getMarketSegmentsList(updatedProjectVersion));
    if (marketSegmentsError) {
      notificationWidget.show("Error while getting market segments for the selected project version", "error");
      return;
    }

    marketSegments = marketSegmentsResponse;
  };

  // mutation to create market segment
  const mutationSave = useMutation(
    async data => {
      const response = await saveMarketSegment(data);
      return response.data;
    },
    {
      onSuccess: () => {
        notificationWidget?.show("The market segment has been saved", "success");
        dispatch("dataUpdate", { isSaved: true });
        dispatch("close");
      },
      onError: () => {
        notificationWidget?.show("The marketsegment has some error or this combination already exists", "error");
      },
    },
  );
</script>

<span id="notification" />
<div id="kendo-dialog" />

<div class="row" data-cy="saveAsMarketSegmentModal">
  <div class="col-12">
    <div class="card-header card-header-sticky">
      <h5 class="my-2" data-cy="modelTitle">Save As</h5>
    </div>
    <div class="card-body">
      {#if $mutationSave.isLoading}
        <div class="overlay">
          <Loading isLoading={true} />
        </div>
      {/if}
      <div class="row">
        <div class="col-12 d-flex flex-wrap">
          <div class="form-group d-flex mb-2 col-6">
            <label class="col-form-label col-5" data-cy="sourceProjectVersionLabel" for="sourceProjectVersionLabel">Source Project Version</label>
            <select
              class="form-control"
              data-cy="sourceProjectVersionLabel"
              id="sourceProjectVersionLabel"
              bind:value={sourceProjectVersion}
              disabled
            >
              {#each projectVersionList as projectVersion}
                <option value={projectVersion.id}>
                  {projectVersion.versionLabel} - {projectVersion.id}
                </option>
              {/each}
            </select>
          </div>
          <div class="form-group d-flex mb-2 col-6">
            <label class="col-form-label col-4 text-right" data-cy="updatedProjectVersionLabel" for="updatedProjectVersion">To</label>

            <select class="form-control" data-cy="updatedProjectVersionControl" id="updatedProjectVersion" bind:value={updatedProjectVersion}>
              {#each projectVersionList as projectVersion}
                <option value={projectVersion.id}>
                  {projectVersion.versionLabel} - {projectVersion.id}
                </option>
              {/each}
            </select>
          </div>
          <div class="form-group d-flex mb-4 col-6">
            <label class="col-5" for="sourceMarketSegmentName" data-cy="sourceMarketSegmentNameLabel">Source Market Segment Name</label>
            <input
              type="email"
              class="form-control"
              id="sourceMarketSegmentName"
              data-cy="sourceMarketSegmentNameControl"
              bind:value={sourceMarketSegmentName}
              disabled
            />
          </div>
          <div class="form-group d-flex mb-4 col-6">
            <label class="col-4 text-right" for="updatedMarketSegmentName" data-cy="updatedMarketSegmentNameLabel">To</label>
            <input
              type="email"
              class="form-control"
              id="updatedMarketSegmentName"
              data-cy="updatedMarketSegmentNameControl"
              bind:value={updatedMarketSegmentName}
            />
          </div>
        </div>
      </div>
      <div class="card-footer d-flex justify-content-between">
        <div />
        <div>
          <button
            type="submit"
            class="btn btn-primary"
            data-cy="save"
            on:click={e => saveAsMarketSegment(e)}
            disabled={!updatedProjectVersion || !updatedMarketSegmentName}>Save</button
          >
          <button class="btn btn-primary" data-cy="cancel" on:click={close}>Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .text-right {
    text-align: center;
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
