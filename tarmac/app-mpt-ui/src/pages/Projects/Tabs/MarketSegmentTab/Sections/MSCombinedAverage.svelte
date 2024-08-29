<script>
  import { onMount } from "svelte";
  import { useQuery, useMutation } from "@sveltestack/svelte-query";
  import { getMarketSegmentCombinedAverage, saveMarketSegmentCombinedAverage } from "api/apiCalls";
  import Modal from "components/shared/modal.svelte";
  import CombinedAverageModal from "../modal/CombinedAverageModal.svelte";
  import ActionCell from "components/grid/ActionCell.svelte";
  import LinkCell from "components/grid/LinkCell.svelte";
  import { closeAllSections, MSSectionTypes, navigateTo } from "./MSNavigationManager";
  import { marketSegmentStore, unsavedMarketSegmentStore } from "./marketSegmentStore";
  import ArraysUtils from "utils/array";
  import { escapeString } from "utils/functions";

  export let isProjectStatusFinal = false;

  let disabled = false;
  let combinedAverageData = [];
  let iniCombinedAverageData = [];
  let dialogDelete = null;
  let dialogCreate = null;
  let dialogUnsaved = null;
  let notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  let saveAndNext = false;
  let selectedCombinedAverage = null;
  let updatedCombinedAverage = [];
  let combinedAverageModalComponent = null;
  $: $marketSegmentStore, (disabled = isProjectStatusFinal || $marketSegmentStore.id === 0);
  $: updatedCombinedAverage, setUnsavedChanges();

  const setUnsavedChanges = () => {
    if (updatedCombinedAverage.length > 0) {
      unsavedMarketSegmentStore.set(true);
    } else {
      unsavedMarketSegmentStore.set(false);
    }
  };

  // load combined average list
  const queryCombinedSegments = useQuery(
    ["combinedAverages", $marketSegmentStore.id],
    async () => {
      const data = await getMarketSegmentCombinedAverage($marketSegmentStore.id);
      return data.data;
    },
    { enabled: false },
  );

  // mutation to update combined average list
  const mutationUpdateList = useMutation(data => saveMarketSegmentCombinedAverage($marketSegmentStore.id, data), {
    onSuccess: () => {
      refetchQuery(true);
      updatedCombinedAverage = [];
      notificationWidget.show("Combined average list updated successfully", "success");
      if (saveAndNext) {
        saveAndNext = false;
        navigateTo(MSSectionTypes.COMBINED_AVERAGE, MSSectionTypes.CUTS);
      }
    },
    onError: () => {
      notificationWidget.show("Error updating combined average list", "error");
    },
  });

  const refetchQuery = (clearCache = false) => {
    if (clearCache) $queryCombinedSegments.remove();
    if ($marketSegmentStore.id > 0) $queryCombinedSegments.refetch();
    else {
      combinedAverageData = [];
      iniCombinedAverageData = [];
    }
  };

  // load and set the data loaded from the api
  $: $marketSegmentStore, refetchQuery();
  $: if ($queryCombinedSegments.data) {
    combinedAverageData = updateCombinedAverageOrder($queryCombinedSegments.data.sort((a, b) => a.order - b.order));
    iniCombinedAverageData = updateCombinedAverageOrder($queryCombinedSegments.data.sort((a, b) => a.order - b.order));
  }

  onMount(() => {
    loadGrid();
    mountDeleteDialog();
    mountUnsavedDialog();
    mountCreateDialog();
  });

  const updateCombinedAverageOrder = combinedAverage => {
    return combinedAverage.map((combinedAverage, index) => {
      return {
        ...combinedAverage,
        order: index + 1,
      };
    });
  };

  const mountDeleteDialog = () => {
    dialogDelete = jQuery("#dialog-delete").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 400,
      content: `Are you sure you want to delete the Combined Average?`,
      actions: [
        {
          text: "Yes",
          primary: false,
          action: function () {
            deleteCombinedAverage();
          },
        },
        {
          text: "No",
          primary: true,
        },
      ],
    });
  };

  const mountCreateDialog = () => {
    dialogCreate = jQuery("#dialog-unsaved").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 400,
      content: `There are unsaved changes. Do you want to save?`,
      actions: [
        {
          text: "Save",
          primary: true,
          action: function () {
            // Update list with the new data
            updatedCombinedAverage = [];
            $mutationUpdateList.mutate(updateCombinedAverageOrder(combinedAverageData));
            showCombinedAverageModal();
          },
        },
        {
          text: "No",
          primary: false,
          action: function () {
            // Reset list with the initial data
            updatedCombinedAverage = [];
            combinedAverageData = [...iniCombinedAverageData];
            showCombinedAverageModal();
          },
        },
      ],
    });
  };

  const mountUnsavedDialog = () => {
    dialogUnsaved = jQuery("#dialog-unsaved").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 400,
      content: `You have unsaved changes. Are you sure you want to leave without saving?`,
      actions: [
        {
          text: "Yes",
          primary: true,
          action: function () {
            updatedCombinedAverage = [];
            combinedAverageData = [...iniCombinedAverageData];
            navigateTo(MSSectionTypes.COMBINED_AVERAGE, MSSectionTypes.BLEND);
          },
        },
        {
          text: "No",
          primary: false,
        },
      ],
    });
  };

  const loadGrid = () => {
    jQuery("#combined-average-grid").kendoGrid({
      dataSource: {
        data: combinedAverageData,
        schema: {
          model: {
            fields: {
              id: { type: "number" },
              marketSegmentId: { type: "number" },
              name: { type: "string" },
              cuts: { type: "array" },
              order: { type: "number" },
            },
          },
        },
      },
      columns: [
        {
          title: "Action",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },

          template: "<div class='svelte-action-container'></div>",
        },
        {
          title: "Combined Average Name",
          field: "name",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: "<div class='svelte-link-container'></div>",
        },
        {
          title: "Selected Cut Names",
          field: "cuts",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
            dataCy: "selectedCutNames",
          },
          template: function (dataItem) {
            return dataItem.cuts.map(cut => escapeString(cut.name)).join(", ");
          },
        },
        {
          title: "Combined Average Report Order",
          field: "order",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255);",
            dataCy: "combinedAverageOrder",
          },
        },
      ],
      dataBound: function (e) {
        mountActionCellComponent(e);
        mountLinkCellComponent(e);
      },
    });
  };

  // update grid if combinedAverageData change
  $: if (combinedAverageData) {
    if (jQuery("#combined-average-grid").data("kendoGrid")) jQuery("#combined-average-grid").data("kendoGrid").setDataSource(combinedAverageData);
    marketSegmentStore.update(store => ({
      ...store,
      combinedAverageData: combinedAverageData,
    }));
  }

  const mountActionCellComponent = e => {
    e.sender.tbody.find(".svelte-action-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      const { id, marketSegmentId, name, cuts, order } = dataItem;
      const componentInstance = new ActionCell({
        target: this,
        props: {
          disabled: disabled,
          showDragAndDrop: false,
          value: { id, marketSegmentId, name, cuts, order },
        },
      });
      // Add component handle events
      componentInstance.$on("onDelete", function (event) {
        selectedCombinedAverage = event.detail;
        dialogDelete
          .data("kendoDialog")
          .content(`Are you sure you want to delete the Combined Average <b>${escapeString(selectedCombinedAverage.name)}</b>?`);
        dialogDelete.data("kendoDialog").open();
      });
      componentInstance.$on("onMoveTop", function (event) {
        const index = combinedAverageData.findIndex(data => data.id === event.detail.id);
        combinedAverageData = [...ArraysUtils.arrayMove(combinedAverageData, index, 0)];
      });
      componentInstance.$on("onMoveBottom", function (event) {
        const index = combinedAverageData.findIndex(data => data.id === event.detail.id);
        combinedAverageData = [...ArraysUtils.arrayMove(combinedAverageData, index, combinedAverageData.length - 1)];
      });
      componentInstance.$on("onMoveUp", function (event) {
        const index = combinedAverageData.findIndex(data => data.id === event.detail.id);
        if (index === 0) return;
        combinedAverageData = [...ArraysUtils.arrayMove(combinedAverageData, index, index - 1)];
      });
      componentInstance.$on("onMoveDown", function (event) {
        const index = combinedAverageData.findIndex(data => data.id === event.detail.id);
        if (index === combinedAverageData.length - 1) return;
        combinedAverageData = [...ArraysUtils.arrayMove(combinedAverageData, index, index + 1)];
      });
    });
  };

  const mountLinkCellComponent = e => {
    e.sender.tbody.find(".svelte-link-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      const { id, marketSegmentId, name, cuts, order } = dataItem;
      const componentInstance = new LinkCell({
        target: this,
        props: {
          disabled: disabled,
          value: { id, marketSegmentId, name, cuts, order },
          dataCy: "combinedAverageName",
        },
      });
      // Add component handle events
      componentInstance.$on("onClick", function (event) {
        selectedCombinedAverage = event.detail;
        combinedAverageModalComponent = CombinedAverageModal;
      });
    });
  };

  const deleteCombinedAverage = () => {
    updatedCombinedAverage = [...updatedCombinedAverage, selectedCombinedAverage];
    combinedAverageData = combinedAverageData.filter(data => {
      return !(data.id == selectedCombinedAverage.id && data.name == selectedCombinedAverage.name);
    });
    selectedCombinedAverage = null;
  };

  const showCombinedAverageModal = () => {
    if (updatedCombinedAverage.length > 0) {
      dialogCreate.data("kendoDialog").open();
    } else {
      selectedCombinedAverage = null;
      combinedAverageModalComponent = CombinedAverageModal;
    }
  };

  const saveCombinedAverage = () => {
    refetchQuery();
  };

  const updateCombinedAverage = () => {
    refetchQuery();
  };

  const navigatePrevious = () => {
    if (updatedCombinedAverage.length > 0) {
      dialogUnsaved.data("kendoDialog").open();
    } else {
      navigateTo(MSSectionTypes.COMBINED_AVERAGE, MSSectionTypes.BLEND);
    }
  };

  const navigateNext = () => {
    navigateTo(MSSectionTypes.COMBINED_AVERAGE, MSSectionTypes.CUTS);
  };

  const save = () => {
    // @ts-ignore
    $mutationUpdateList.mutate(updateCombinedAverageOrder(combinedAverageData));
  };

  const saveNext = () => {
    saveAndNext = true;
    // @ts-ignore
    $mutationUpdateList.mutate(updateCombinedAverageOrder(combinedAverageData));
  };
</script>

<div class="accordion-item">
  <h2 class="accordion-header" id="headingCombinedAverage">
    <button
      class="accordion-button collapsed"
      data-cy="accordionCombinedAveragedBtn"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#collapseCombinedAverage"
      aria-expanded="false"
      aria-controls="collapseCombinedAverage"
      id="combinedAverageAccordion"
      on:click={closeAllSections}
    >
      &mu;&nbsp; Combined Average
    </button>
  </h2>
  <div
    id="collapseCombinedAverage"
    class="accordion-collapse collapse"
    aria-labelledby="headingCombinedAverage"
    data-bs-parent="#accordion"
    data-cy="combinedAverageSection"
  >
    <div class="accordion-body">
      <!-- table -->
      <div class="row my-2 p-3">
        <div class="col-12 p-0">
          <div id="combined-average-grid" data-cy="combined-average-grid-cy" />
        </div>
      </div>
      <!-- footer -->
      <div class="row d-flex flex-wrap justify-content-end p-3 py-2">
        <div class="col-6 p-0">
          <button
            class="btn btn-primary pull-left"
            data-cy="addCombinedAverageBtn"
            disabled={disabled || $mutationUpdateList.isLoading}
            on:click={showCombinedAverageModal}>Add Combined Average</button
          >
        </div>
        <div class="col-6 p-0 text-end">
          <button
            class="btn btn-primary"
            data-cy="msCombinedAverageSection-previousBtn"
            disabled={isProjectStatusFinal || $mutationUpdateList.isLoading}
            on:click={navigatePrevious}>Previous</button
          >
          <button
            class="btn btn-primary"
            data-cy="msCombinedAverageSection-saveBtn"
            disabled={disabled || combinedAverageData.length === 0 || $mutationUpdateList.isLoading}
            on:click={save}>Save</button
          >
          <button
            class="btn btn-primary"
            data-cy="msCombinedAverageSection-saveNextBtn"
            disabled={disabled || combinedAverageData.length === 0 || $mutationUpdateList.isLoading}
            on:click={saveNext}>Save & Next</button
          >
          <button
            class="btn btn-primary"
            data-cy="msCombinedAverageSection-nextBtn"
            disabled={isProjectStatusFinal || $mutationUpdateList.isLoading}
            on:click={navigateNext}>Next</button
          >
        </div>
      </div>
    </div>
  </div>
  <div id="dialog-delete" data-cy="deleteDialogMSCombinedAverage" />
  <div id="dialog-unsaved" data-cy="unsavedDialogMSCombinedAverage" />
  <div id="dialog-create" data-cy="createDialogMSCombinedAverage" />
  <div id="notification" />

  <Modal
    show={combinedAverageModalComponent}
    props={{
      combinedAverage: selectedCombinedAverage,
      combinedAverageLength: combinedAverageData.length,
      handleSave: saveCombinedAverage,
      handleUpdate: updateCombinedAverage,
    }}
    on:closed={() => {
      combinedAverageModalComponent = null;
    }}
    closeOnEsc={true}
  />
</div>
