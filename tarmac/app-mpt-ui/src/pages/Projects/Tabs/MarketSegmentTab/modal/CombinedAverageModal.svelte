<script>
  import { onMount, createEventDispatcher } from "svelte";
  import { useMutation } from "@sveltestack/svelte-query";
  import CheckboxCell from "components/grid/CheckboxCell.svelte";
  import { createMarketSegmentCombinedAverage, updateMarketSegmentCombinedAverage } from "api/apiCalls";
  import { marketSegmentStore, cutNamesStore } from "../Sections/marketSegmentStore";
  import ArraysUtils from "utils/array";
  import { escapeString } from "utils/functions";

  const dispatch = createEventDispatcher();

  export let combinedAverageLength;
  export let combinedAverage;
  export let handleSave;
  export let handleUpdate;

  let name = combinedAverage ? combinedAverage.name : "";
  let selectedCutsNames = combinedAverage ? combinedAverage.cuts.map(cut => escapeString(cut.name)) : [];
  let notificationWidget = null;
  let cutNames = [];
  $: mutationIsLoading = $mutationCreate.isLoading || $mutationUpdate.isLoading;
  $: buttonSpinner = mutationIsLoading ? `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true" />` : "";
  $: disabledSave = name === "" || selectedCutsNames.length < 2;
  $: unsavedChanges = !combinedAverage && (name !== "" || selectedCutsNames.length > 0);
  $: disabledReset =
    combinedAverage &&
    name === combinedAverage.name &&
    ArraysUtils.equals(
      selectedCutsNames,
      combinedAverage.cuts.map(cut => cut.name),
    );

  //mutation to create combined average
  const mutationCreate = useMutation(data => createMarketSegmentCombinedAverage($marketSegmentStore.id, data), {
    onSuccess: async () => {
      notificationWidget.show("Combined Average Saved successfully", "success");
      handleSave();
      dispatch("dataUpdate", { hasUnSavedChanges: false });
      dispatch("close");
    },
    onError: () => {
      notificationWidget.show("Error saving Combined Average", "error");
    },
  });

  // mutation to update combined average
  const mutationUpdate = useMutation(data => updateMarketSegmentCombinedAverage($marketSegmentStore.id, combinedAverage?.id, data), {
    onSuccess: async () => {
      notificationWidget.show("Combined Average updated successfully", "success");
      handleUpdate();
      dispatch("dataUpdate", { hasUnSavedChanges: false });
      dispatch("close");
    },
    onError: () => {
      notificationWidget.show("Error updating Combined Average", "error");
    },
  });

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    dispatch("dataUpdate", { hasUnSavedChanges: false });
    addEriValueToCutNames();
    loadGrid();
  });

  // add ERI value to cut names if is present
  const addEriValueToCutNames = () => {
    cutNames = $cutNamesStore;
    const { marketSegment } = $marketSegmentStore;
    if (marketSegment && marketSegment.eriCutName) {
      cutNames = [...cutNames, marketSegment.eriCutName];
    }
  };

  const loadGrid = () => {
    jQuery("#combined-average-modal-grid").kendoGrid({
      dataSource: {
        data: cutNames,
      },
      columns: [
        {
          title: "Select",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255);",
          },
          template: "<div class='svelte-checkbox-container'></div>",
        },
        {
          title: "Cut Name",
          field: "cuts",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255);",
          },
          template: function (dataItem) {
            return escapeString(dataItem);
          },
        },
      ],
      dataBound: function (e) {
        mountCheckCellComponent(e);
      },
    });
  };

  const mountCheckCellComponent = e => {
    e.sender.tbody.find(".svelte-checkbox-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      const cutName = dataItem;
      const componentInstance = new CheckboxCell({
        target: this,
        props: {
          value: selectedCutsNames.some(cut => cut === cutName),
          datacy: `inputCheckbox${cutName}`,
        },
      });
      // Add component handle events
      componentInstance.$on("onClick", function () {
        if (selectedCutsNames.some(cut => cut === cutName)) {
          selectedCutsNames = selectedCutsNames.filter(cut => cut !== cutName);
        } else {
          selectedCutsNames = [...selectedCutsNames, cutName];
        }
      });
    });
  };

  // update grid if selectedCuts change
  $: if (selectedCutsNames) {
    if (jQuery("#combined-average-modal-grid").data("kendoGrid")) jQuery("#combined-average-modal-grid").data("kendoGrid").refresh();
  }

  // notify modal component if there are unsaved changes
  $: if (!disabledReset || unsavedChanges) {
    dispatch("dataUpdate", { hasUnSavedChanges: true });
  } else {
    dispatch("dataUpdate", { hasUnSavedChanges: false });
  }

  const save = () => {
    if (combinedAverage) {
      // combined average update
      // @ts-ignore
      $mutationUpdate.mutate({
        id: combinedAverage.id,
        marketSegmentId: $marketSegmentStore.id,
        name: name,
        order: combinedAverage.order,
        cuts: selectedCutsNames.map(cutName => ({
          id: combinedAverage.cuts.find(cut => cut.name === cutName)?.id || 0,
          combinedAveragesId: combinedAverage.id,
          name: cutName,
        })),
      });
    } else {
      // combined average create
      // @ts-ignore
      $mutationCreate.mutate({
        id: 0,
        marketSegmentId: $marketSegmentStore.id,
        name: name,
        order: combinedAverageLength + 1,
        cuts: selectedCutsNames.map(cut => ({ id: 0, combinedAveragesId: 0, name: cut })),
      });
    }
  };

  const close = () => {
    // reset the data to the original state
    if (combinedAverage) {
      name = combinedAverage.name;
      selectedCutsNames = combinedAverage.cuts.map(cut => cut.name);
    } else {
      dispatch("close");
    }
  };
</script>

<div class="card" data-cy="combined-average-level-details">
  <div class="card-header card-header-sticky">
    <h5 class="my-2" data-cy="modalTitle">{combinedAverage ? "Update Combined Average" : "Create Combined Average"}</h5>
  </div>
  <div class="card-body">
    <form>
      <div class="form-group row justify-content-md-center">
        <label for="combinedAverageName" data-cy="combinedAverageNameLabel" class="col-2 col-form-label">Combined Average Name</label>
        <div class="col-6">
          <input type="text" class="form-control" id="combinedAverageName" data-cy="combinedAverageNameInput" bind:value={name} maxlength="100" />
        </div>
      </div>
    </form>
    <div class="row my-2 p-3 justify-content-md-center">
      <div class="col-8 p-0">
        <div id="combined-average-modal-grid" data-cy="combined-average-modal-grid" />
      </div>
    </div>
  </div>
  <div class="card-footer d-flex justify-content-end">
    <button class="btn btn-primary mx-2" data-cy="saveBtnCombinedModal" on:click={save} disabled={disabledSave || mutationIsLoading}>
      {@html buttonSpinner}
      Save and Close</button
    >
    <button class="btn btn-primary mx-2" data-cy="closeBtn" on:click={close} disabled={disabledReset || mutationIsLoading}>
      {combinedAverage ? "Reset" : "Close"}</button
    >
  </div>
</div>
<div id="dialog-unsaved-modal" data-cy="unsavedDialogMSCombinedAverageModal" />
