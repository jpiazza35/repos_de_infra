<script>
  // @ts-nocheck
  import { onMount, createEventDispatcher } from "svelte";
  import { promiseWrap } from "utils/functions";
  import Modal from "components/shared/modal.svelte";
  import { marketSegmentGridConfig, marketSegmentGridColumns } from "./MarketSegmentGridOptions";
  import { getMarketSegmentsList, deleteMarketSegment, updateMarketSegmentStatus } from "api/apiCalls";
  import { marketSegmentListStore } from "../Sections/marketSegmentStore";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import SaveAsModal from "../modal/SaveAsModal.svelte";

  export let inputFilterProjectId;
  export let inputFilterProjectVersionId;
  export let isProjectStatusFinal;

  const dispatch = createEventDispatcher();
  const NOT_TABLE_HEIGHT = 200;

  let container = null;
  let marketSegmentList = [];
  let notificationWidget;
  let showSaveAsModal = false;
  let saveModalComponent = SaveAsModal;
  let props = {};

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    configureGrid();
  });

  $: if (inputFilterProjectVersionId) {
    getMarketSegmentList();
  }

  addEventListener("newMarketSegmentAdded", async e => {
    e.preventDefault();
    await getMarketSegmentList();
  });

  const getMarketSegmentList = async () => {
    const [marketSegmentResponse, marketSegmentStatusError] = await promiseWrap(getMarketSegmentsList(inputFilterProjectVersionId));
    if (marketSegmentStatusError) {
      notificationWidget.show("Error while getting market segments", "error");
      return false;
    }

    marketSegmentList = marketSegmentResponse;
    marketSegmentListStore.set(marketSegmentList);
    if (jQuery(container).data("kendoGrid")) {
      jQuery(container)
        .data("kendoGrid")
        .dataSource.data([...marketSegmentList]);
    }
  };

  const configureGrid = () => {
    let statusColumn = marketSegmentGridColumns.find(col => col.field === "statusName");
    statusColumn.editor = statusDropDownEditor;

    jQuery(container).kendoGrid({
      ...marketSegmentGridConfig,
      columns: [
        {
          field: "Action",
          headerAttributes: {
            style: "background: #808080; color: #fff; border-color: #fff",
            "data-cy": "Action",
          },
          title: "Action",
          command: [
            {
              text: "Details",
              className: "action-ms-table",
              click: e => handleEditMarketSegment(e),
            },
            {
              text: "Save As",
              className: "action-ms-table",
              click: e => handleSaveAsMarketSegment(e),
            },
            {
              text: "Delete",
              className: "action-ms-table",
              click: e => handleDeleteMarketSegment(e),
            },
          ],
          width: 180,
          exportable: false,
        },
        ...marketSegmentGridColumns,
      ],
      dataSource: marketSegmentList,
      editable: !isProjectStatusFinal,
      dataBound() {
        const hyperLinkCss = "background: none; border: none; color: #3498db; text-decoration: underline; cursor: pointer;";
        this.tbody.find("tr").each((index, row) => {
          const jQueryRow = jQuery(row);
          const commandButtons = jQueryRow.find(".action-ms-table");
          commandButtons.each((_, element) => {
            if (element.textContent === "Delete" && isProjectStatusFinal) {
              element.disabled = true;
            }

            if (element.textContent === "Save As" && isProjectStatusFinal) {
              element.disabled = true;
            }

            element.style = hyperLinkCss;
          });
        });
      },
    });

    jQuery(".k-grid-header span.k-icon").css({ color: "#fff" });
    jQuery(".k-grid-content").css({ "max-height": document.documentElement.clientHeight - NOT_TABLE_HEIGHT });
  };

  function statusDropDownEditor(container, options) {
    const statusDropdownItems = [
      { id: 11, text: "Active" },
      { id: 12, text: "Inactive" },
    ];
    const marketSegmentId = options.model?.marketSegmentId;

    jQuery('<input name="' + options.field + '"/>')
      .appendTo(container)
      .kendoDropDownList({
        autoBind: false,
        dataTextField: "text",
        dataValueField: "text",
        dataSource: statusDropdownItems,
        change: function () {
          callUpdateMarketSegmentStatus(marketSegmentId, this.value() === "Active" ? 11 : 12);
        },
      });
  }

  const callUpdateMarketSegmentStatus = async (marketSegmentId, status) => {
    const [, error] = await promiseWrap(updateMarketSegmentStatus(marketSegmentId, status));
    if (error) {
      notificationWidget.show("Error in updating the status", "error");
    }

    notificationWidget.show("Status updated successfully", "success");
  };

  const handleEditMarketSegment = e => {
    const grid = jQuery(container).data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));
    if (dataItem) {
      dispatch("Edit", dataItem);
    }
  };

  const handleSaveAsMarketSegment = e => {
    const grid = jQuery(container).data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));
    if (dataItem) {
      props = {
        marketSegments: marketSegmentList,
        sourceMarketSegment: dataItem,
        sourceProjectVersion: inputFilterProjectVersionId,
        sourceProjectId: inputFilterProjectId,
        sourceMarketSegmentName: dataItem?.marketSegmentName,
      };

      showSaveAsModal = true;
    }
  };

  const handleDeleteMarketSegment = e => {
    const grid = jQuery(container).data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));
    if (dataItem) {
      showDeleteMarketSegmentPopup(dataItem);
    }
  };

  const showDeleteMarketSegmentPopup = dataItem => {
    jQuery("#marketsegment-delete-dialog")?.remove();
    let divElement = document.createElement("span");
    divElement.id = "marketsegment-delete-dialog";
    document.body.appendChild(divElement);

    jQuery("#marketsegment-delete-dialog").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 500,
      content: "Are you sure you want to delete? This action cannot be undone.",
      actions: [
        {
          text: "Yes",
          action: function () {
            callDeleteMarketSegment(dataItem);
            return true;
          },
          primary: true,
        },
        { text: "No", primary: true },
      ],
    });

    let dialog = jQuery("#marketsegment-delete-dialog").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
    dialog.bind("close", () => {
      jQuery("#confirm-status-change")?.remove();
    });
  };

  const callDeleteMarketSegment = async dataItem => {
    const [, error] = await promiseWrap(deleteMarketSegment(dataItem.marketSegmentId));
    if (error) {
      notificationWidget.show(error?.response?.data[0] || "Error while deleting market segments", "error");
      return;
    }

    notificationWidget.show("Market Segment deleted successfully", "success");
    getMarketSegmentList();
  };

  const onSaveAsModalClose = event => {
    showSaveAsModal = false;
    if (event?.detail?.isSaved) {
      getMarketSegmentList();
      dispatch("SaveAs");
    }
  };
</script>

<div id="grid" bind:this={container} />
<span id="notification" />

{#if showSaveAsModal}
  <Modal show={saveModalComponent} {props} on:closed={onSaveAsModalClose} styleWindow={{ width: "60%" }} />
{/if}
