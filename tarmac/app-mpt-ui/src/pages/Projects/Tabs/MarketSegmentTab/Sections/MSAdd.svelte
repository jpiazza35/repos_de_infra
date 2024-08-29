<script>
  import { onMount } from "svelte";
  import { promiseWrap } from "utils/functions";
  import { saveMarketSegment } from "api/apiCalls";
  import { marketSegmentListStore } from "./marketSegmentStore";

  export let isProjectStatusFinal;
  export let inputFilterProjectVersionId;

  let showAddNewUI = false;
  let marketSegmentName = "";
  let marketSegmentDescription = "";
  let showValidations = false;
  let notificationWidget;
  let existingMarketSegments = [];

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    marketSegmentListStore.subscribe(data => (existingMarketSegments = data));
  });

  const addMarketSegment = async () => {
    showValidations = true;
    marketSegmentName = marketSegmentName?.trim();
    marketSegmentDescription = marketSegmentDescription?.trim();

    if (!marketSegmentName?.length) {
      notificationWidget.show("Please enter a market segment name", "error");
      return;
    }

    if (marketSegmentDescription?.length > 100) {
      notificationWidget.show("Description cannot be more than 100 characters.", "error");
      return;
    }

    if (existingMarketSegments.find(ms => ms.marketSegmentName?.trim().toLowerCase() === marketSegmentName.toLocaleLowerCase())) {
      notificationWidget.show("The market segment name must be unique", "error");
      return;
    }

    const payload = { name: marketSegmentName, description: marketSegmentDescription, projectVersionId: inputFilterProjectVersionId, status: 11 };
    const [response, error] = await promiseWrap(saveMarketSegment(payload));
    if (error) {
      notificationWidget.show("Error in adding market segment", "error");
    }

    if (response) {
      notificationWidget.show("The market segment has been saved", "success");
      closeMarketSegmentAdd();
      dispatchEvent(new Event("newMarketSegmentAdded"));
    }
  };

  const closeMarketSegmentAdd = () => {
    marketSegmentName = marketSegmentDescription = "";
    showAddNewUI = showValidations = false;
  };
</script>

<span id="notification" />

<div class="d-flex ">
  <button
    disabled={isProjectStatusFinal}
    class="btn btn-secondary mb-4 whitespace-nowrap"
    data-cy="addMarketSegmentBtn"
    on:click={() => (showAddNewUI = true)}
    >Add New
  </button>

  {#if showAddNewUI}
    <div class="mx-4 w-100">
      <div class="d-flex col-lg-6 col-md-10 col-sm-12 border p-2  border-dark">
        <input
          class="form-control"
          id="marketSegmentName"
          name="marketSegmentName"
          data-cy="marketSegmentName"
          placeholder="Enter Market Segment Name"
          maxlength="100"
          bind:value={marketSegmentName}
          class:is-invalid={!marketSegmentName?.trim()?.length && showValidations}
        />
        <input
          class="form-control"
          id="marketSegmentDescription"
          name="marketSegmentDescription"
          data-cy="marketSegmentDescription"
          placeholder="Enter Market Segment Description"
          bind:value={marketSegmentDescription}
          class:is-invalid={!(marketSegmentDescription?.trim()?.length <= 100) && showValidations}
        />

        <div class="d-flex">
          <button class="btn btn-primary mx-4" data-cy="saveMSBtn" on:click={addMarketSegment}>Save</button>
          <button class="btn btn-primary mx-2" data-cy="saveMSBtn" on:click={closeMarketSegmentAdd}>Close</button>
        </div>
      </div>
      <div />
    </div>
  {/if}
</div>

<style>
  .whitespace-nowrap {
    white-space: nowrap;
  }
</style>
