<script>
  // @ts-nocheck
  import { onMount, onDestroy, createEventDispatcher } from "svelte";
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";
  import { useMutation } from "@sveltestack/svelte-query";

  import Modal from "components/shared/modal.svelte";
  import { isDirty } from "utils/functions";
  import { MarketSegmentStatusOptions } from "utils/constants";
  import ArraysUtils from "utils/array";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import { saveMarketSegment, updateMarketSegment } from "api/apiCalls";
  import { marketSegmentStore, unsavedMarketSegmentStore } from "./marketSegmentStore";
  import { MSSectionTypes, closeAllSections, navigateTo } from "./MSNavigationManager";
  import SurveyLevelDetails from "../modal/SurveyLevelDetails.svelte";
  import Loading from "components/shared/loading.svelte";
  import ActionCell from "components/grid/ActionCell.svelte";
  import CheckboxCell from "components/grid/CheckboxCell.svelte";
  import LinkCell from "components/grid/LinkCell.svelte";
  import InputCell from "components/grid/InputCell.svelte";
  import { getMarketSegmentStoreCuts } from "utils/project";

  export let projectVersionId = null;
  export let isProjectStatusFinal = false;
  export let marketSegments = [];

  let msName = null,
    notificationWidget = null,
    deleteCutConfirmationWidget = null,
    selectionCutList = [],
    projStatus = "",
    showSurveyDetailsModal = false,
    surveyDetailsModalComponent = null,
    surveyDetailsModalData = null,
    marketSegmentId = null,
    dirty,
    deleteDirty = false,
    saveAndNext = false;
  $: isLoading = $mutationUpdate.isLoading || $mutationSave.isLoading;

  const dispatch = createEventDispatcher();

  // mutation to create market segment
  const mutationSave = useMutation(
    async data => {
      const response = await saveMarketSegment(data);
      return response.data;
    },
    {
      onSuccess: marketSegmentSaveResponse => {
        onMarketSegmentSave(marketSegmentSaveResponse);
      },
      onError: () => {
        notificationWidget?.show("The marketsegment has some error or this combination already exists", "error");
        deleteDirty = false;
      },
    },
  );

  // mutation to update market segment
  const mutationUpdate = useMutation(
    async data => {
      const response = await updateMarketSegment(data);
      return response.data;
    },
    {
      onSuccess: marketSegmentSaveResponse => {
        onMarketSegmentSave(marketSegmentSaveResponse);
      },
      onError: () => {
        notificationWidget?.show("The marketsegment has some error or this combination already exists", "error");
        deleteDirty = false;
      },
    },
  );

  const onMarketSegmentSave = marketSegmentSaveResponse => {
    notificationWidget?.show("The market segment has been saved", "success");
    dirty = false;
    deleteDirty = false;
    let marketSegment = marketSegmentSaveResponse;
    marketSegment = { ...marketSegment, cuts: marketSegment.cuts };
    marketSegmentStore.update(store => ({
      ...store,
      id: marketSegmentSaveResponse.id,
      marketSegment: marketSegment,
      selectionCuts: [],
    }));

    marketSegmentId = marketSegmentSaveResponse.id;
    dispatch("saveSegment", marketSegment);
    if (saveAndNext) navigateNext();
  };

  const loadGrid = () => {
    jQuery("#new-grid").kendoGrid({
      dataSource: {
        data: $form.selectionCuts,
        schema: {
          model: {
            fields: {
              blendFlag: { type: "boolean" },
              marketSegmentCutKey: { type: "number" },
              marketSegmentId: { type: "number" },
              industrySectorName: { type: "string" },
              organizationTypeKey: { type: "number" },
              organizationTypeName: { type: "string" },
              cutGroupKey: { type: "number" },
              cutGroupName: { type: "string" },
              cutSubGroupKey: { type: "number" },
              cutSubGroupName: { type: "string" },
              cutName: { type: "string" },
              displayOnReport: { type: "boolean" },
              reportOrder: { type: "number" },
            },
          },
        },
      },
      resizable: true,
      sortable: {
        mode: "single",
        allowUnsort: false,
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
          title: "Industry/Sector",
          field: "industrySectorName",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: function (dataItem) {
            return dataItem.blendFlag ? "Blend" : dataItem.industrySectorName || "";
          },
        },
        {
          title: "Org Type",
          field: "organizationTypeName",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: function (dataItem) {
            return dataItem.blendFlag ? "Blend" : dataItem.organizationTypeName || "";
          },
        },
        {
          title: "Cut Group",
          field: "cutGroupName",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          attributes: {
            "data-cy": "cutGroupNameCell",
          },
          template: function (dataItem) {
            return dataItem.blendFlag ? "Blend" : dataItem.cutGroupName || "";
          },
        },
        {
          title: "Cut Sub-Group",
          field: "cutSubGroupName",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: "<div class='svelte-link-container'></div>",
        },
        {
          title: "Market Pricing Cut",
          field: "cutName",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: "<div class='svelte-input-container'></div>",
        },
        {
          title: "Display on Report",
          field: "displayOnReport",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: "<div class='svelte-checkbox-container'></div>",
        },
        {
          title: "Report Order",
          field: "reportOrder",
          headerAttributes: {
            style: "background: rgb(128, 128, 128); color: rgb(255, 255, 255); border-right: 1px solid #fff",
          },
          template: function (dataItem) {
            return dataItem.reportOrder || $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === dataItem.marketSegmentCutKey) + 1;
          },
        },
      ],
      dataBound: function (e) {
        const grid = this;
        mountActionCellComponent(e);
        mountLinkCellComponent(e);
        mountCheckCellComponent(e);
        mountInputCellComponent(e);
        mountDragAndDrop(grid);
      },
    });
  };

  // TABLE DRAG AND DROP
  let draggedRow;
  let targetRow;
  let enableDragAndDrop = false;

  const handleDragStart = event => {
    // Get the draggable row
    draggedRow = event.target.closest("tr");
  };

  const handleDragEnd = () => {
    // Change the order of the cuts in the form
    if (draggedRow && targetRow && enableDragAndDrop) {
      const draggedRowData = jQuery("#new-grid").data("kendoGrid").dataItem(draggedRow);
      const targeRowData = jQuery("#new-grid").data("kendoGrid").dataItem(targetRow);

      const fromIndex = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === draggedRowData.marketSegmentCutKey);
      const toIndex = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === targeRowData.marketSegmentCutKey);
      $form.selectionCuts = [...ArraysUtils.arrayMove($form.selectionCuts, fromIndex, toIndex)];
      enableDragAndDrop = false;
    }
    // Remove the class from the previous target row
    if (targetRow) targetRow.style.background = "initial";
  };

  const handleDrop = event => {
    event.preventDefault();
    // Get the target row
    targetRow = event.target.closest("tr");

    if (targetRow !== draggedRow) {
      enableDragAndDrop = true;
      unsavedMarketSegmentStore.set(true);
    }
  };

  const handleDragOver = event => {
    event.preventDefault();
    // Get the target row
    targetRow = event.target.closest("tr");
    // Add a class to the target row
    if (targetRow && targetRow !== draggedRow) {
      targetRow.style.background = "#8b8b8b";
    }
  };

  const handleDragLeave = event => {
    event.preventDefault();
    // Remove the class from the previous target row
    if (targetRow) targetRow.style.background = "initial";
  };
  const mountDragAndDrop = grid => {
    if (isProjectStatusFinal) return;

    const rows = grid.element.find("tbody tr");
    rows.each(function (_, row) {
      jQuery(row).attr("draggable", true);
    });

    let tbody = grid.element.find("tbody")[0];
    tbody?.addEventListener("dragstart", handleDragStart);
    tbody?.addEventListener("dragend", handleDragEnd);
    tbody?.addEventListener("drop", handleDrop);
    tbody?.addEventListener("dragover", handleDragOver);
    tbody?.addEventListener("dragleave", handleDragLeave);
  };

  const mountActionCellComponent = e => {
    e.sender.tbody.find(".svelte-action-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      const { marketSegmentCutKey } = dataItem;
      const componentInstance = new ActionCell({
        target: this,
        props: {
          disabled: isProjectStatusFinal,
          value: { marketSegmentCutKey },
        },
      });

      componentInstance.$on("onDelete", function () {
        showDeleteDialog($form.selectionCuts.find(cut => cut.marketSegmentCutKey === marketSegmentCutKey));
      });
      componentInstance.$on("onMoveTop", function (event) {
        const index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === event.detail.marketSegmentCutKey);
        $form.selectionCuts = [...ArraysUtils.arrayMove($form.selectionCuts, index, 0)];
        unsavedMarketSegmentStore.set(true);
      });
      componentInstance.$on("onMoveBottom", function (event) {
        const index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === event.detail.marketSegmentCutKey);
        $form.selectionCuts = [...ArraysUtils.arrayMove($form.selectionCuts, index, $form.selectionCuts.length - 1)];
        unsavedMarketSegmentStore.set(true);
      });
      componentInstance.$on("onMoveUp", function (event) {
        const index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === event.detail.marketSegmentCutKey);
        if (index === 0) return;
        $form.selectionCuts = [...ArraysUtils.arrayMove($form.selectionCuts, index, index - 1)];
        unsavedMarketSegmentStore.set(true);
      });
      componentInstance.$on("onMoveDown", function (event) {
        const index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === event.detail.marketSegmentCutKey);
        if (index === $form.selectionCuts.length - 1) return;
        $form.selectionCuts = [...ArraysUtils.arrayMove($form.selectionCuts, index, index + 1)];
        unsavedMarketSegmentStore.set(true);
      });
    });
  };

  const mountLinkCellComponent = e => {
    e.sender.tbody.find(".svelte-link-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      const { marketSegmentCutKey, blendFlag, cutSubGroupName } = dataItem;
      const componentInstance = new LinkCell({
        target: this,
        props: {
          className: "link-primary",
          dataCy: `BlendCutGroupLink`,
          value: { marketSegmentCutKey, blendFlag, name: blendFlag ? "Blend" : cutSubGroupName || "" },
        },
      });
      componentInstance.$on("onClick", function (event) {
        if (event.detail.blendFlag) {
          openSurveyDetailsModalBlend(event.detail.marketSegmentCutKey);
        } else {
          openSurveyDetailsModal(event.detail.marketSegmentCutKey);
        }
      });
    });
  };

  const mountCheckCellComponent = e => {
    e.sender.tbody.find(".svelte-checkbox-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      if (dataItem?.blendFlag) return;
      const componentInstance = new CheckboxCell({
        target: this,
        props: {
          disabled: isProjectStatusFinal,
          value: dataItem?.displayOnReport,
          datacy: `${dataItem.marketSegmentCutKey}-checkboxSelectCut`,
        },
      });
      componentInstance.$on("onClick", function (event) {
        let value = event.detail.target.checked;
        let index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === dataItem?.marketSegmentCutKey);
        handleToggleCheckbox(value, index);
        unsavedMarketSegmentStore.set(true);
      });
    });
  };

  const mountInputCellComponent = e => {
    e.sender.tbody.find(".svelte-input-container").each(function () {
      const cell = jQuery(this);
      const dataItem = e.sender.dataItem(cell.closest("tr"));
      if (!dataItem) return;
      const { marketSegmentCutKey, blendFlag, cutName, cutGroupName } = dataItem;
      const index = $form.selectionCuts.findIndex(cut => cut.marketSegmentCutKey === marketSegmentCutKey);
      if (blendFlag) {
        const componentInstance = new LinkCell({
          target: this,
          props: {
            className: "link-primary",
            dataCy: `BlendPricingInputCell-${cutName}`,
            value: { marketSegmentCutKey, blendFlag, name: cutName },
          },
        });
        componentInstance.$on("onClick", function (event) {
          navigateToBlend(event.detail.marketSegmentCutKey);
        });
      } else {
        let newCutName = cutName ? cutName : cutGroupName;

        const componentInstance = new InputCell({
          target: this,
          props: {
            disabled: isProjectStatusFinal,
            value: newCutName,
            id: `cutName`,
            name: `selectionCuts[${index}].cutName`,
            datacy: `marketPricingInputCell-${index}`,
          },
        });
        updateField(`selectionCuts[${index}].cutName`, newCutName);
        componentInstance.$on("onChange", function (event) {
          handleChange(event.detail);
        });
      }
    });
  };

  $: if ($form.selectionCuts) {
    if (jQuery("#new-grid").data("kendoGrid")) jQuery("#new-grid").data("kendoGrid").setDataSource($form.selectionCuts);
  }

  const { form, touched, updateField, handleChange, updateInitialValues, handleReset } = createForm({
    initialValues: getInitialValues(),
    validationSchema: yup.object().shape({
      selectionCuts: yup.array().of(
        yup.object().shape({
          cutName: yup.string().max(100).required(),
          displayOnReport: yup.bool().default(true),
        }),
      ),
      status: yup.string().required().default(MarketSegmentStatusOptions[4].value),
    }),
    onSubmit: () => {},
  });

  $: dirty = isDirty($touched);
  $: dirty, setUnsavedChanges();

  const setUnsavedChanges = () => {
    if (dirty) {
      unsavedMarketSegmentStore.set(true);
    } else {
      unsavedMarketSegmentStore.set(false);
    }
  };

  onMount(() => {
    registerKendoControls();
    loadGrid();
  });

  marketSegmentStore?.subscribe(store => {
    {
      const { marketSegment, status } = store;
      projStatus = status && status.id ? status : MarketSegmentStatusOptions[4];
      marketSegmentId = store?.id || marketSegment?.id;
      msName = store?.marketSegmentName || marketSegment?.name;
      selectionCutList = getMarketSegmentStoreCuts(store).sort((a, b) => a.reportOrder - b.reportOrder);

      // initialize form values for new market segment
      if (store?.id === 0) {
        updateInitialValues({
          marketSegmentName: msName || marketSegment?.name,
          selectionCuts: selectionCutList.map((sCut, i) => {
            return {
              ...sCut,
              cutName: sCut?.cutName || "",
              displayOnReport: sCut?.displayOnReport ?? true,
              reportOrder: sCut?.reportOrder ?? i + 1,
              marketSegmentCutKey: i + 1,
            };
          }),
          status: MarketSegmentStatusOptions[4].id,
        });
      } else {
        // initialize form values for existing market segment
        updateInitialValues({
          marketSegmentName: msName,
          selectionCuts: selectionCutList.map((sCut, i) => {
            return {
              ...sCut,
              cutName: sCut.cutName || "",
              displayOnReport: sCut.displayOnReport ?? true,
              reportOrder: sCut.reportOrder ?? i + 1,
            };
          }),
          status: projStatus?.value ?? MarketSegmentStatusOptions[4].value,
        });
      }
    }
  });

  function getInitialValues() {
    selectionCutList.push({ displayOnReport: true });
    return {
      marketSegmentName: msName || "",
      selectionCuts: selectionCutList,
      status: projStatus?.value || MarketSegmentStatusOptions[4].value,
    };
  }

  function registerKendoControls() {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    deleteCutConfirmationWidget = jQuery("#dialog-selected-cuts");
  }

  function deleteSelectedCutOrBlend(row) {
    let { selectionCuts } = $form;
    let index = selectionCuts.findIndex(c => c === row);
    if (index !== -1) {
      selectionCuts.splice(index, 1);
      selectionCuts.forEach((c, i) => {
        c.reportOrder = i + 1;
      });
      updateField("selectionCuts", selectionCuts);
    }
  }

  const showDeleteDialog = selectedRow => {
    deleteCutConfirmationWidget = jQuery("#dialog-selected-cuts")
      .kendoDialog({
        title: "Confirmation Required",
        visible: false,
        width: 300,
        content: "Are you sure you want to delete this Cut?",
        actions: [
          {
            text: "Yes",
            primary: false,
            action: function () {
              deleteSelectedCutOrBlend(selectedRow);
              deleteCutConfirmationWidget.close();
              deleteDirty = true;
              return true;
            },
          },
          {
            text: "No",
            primary: true,
          },
        ],
      })
      .data("kendoDialog");
    deleteCutConfirmationWidget.open().center();
  };

  onDestroy(() => {
    let tbody = document.querySelector("#new-grid tbody");
    tbody?.removeEventListener("dragstart", handleDragStart);
    tbody?.removeEventListener("dragend", handleDragEnd);
    tbody?.removeEventListener("drop", handleDrop);
    tbody?.removeEventListener("dragover", handleDragOver);
    tbody?.removeEventListener("dragleave", handleDragLeave);
  });

  const createPayload = () => {
    let payload = {
      name: $marketSegmentStore.marketSegmentName,
      description: $marketSegmentStore?.marketSegmentDescription,
      projectVersionId,
      status: projStatus?.id ?? 4,
      cuts: $form.selectionCuts
        ?.map((cut, index) => {
          let {
            blendFlag,
            displayOnReport,
            cutName,
            industrySectorKeys,
            industrySectorKey,
            organizationTypeKeys,
            organizationTypeKey,
            cutGroupKeys,
            cutGroupKey,
            cutGroupName,
            cutSubGroupKeys,
            cutSubGroupKey,
            cutSubGroupName,
            industrySectorName,
            marketSegmentCutKey,
            organizationTypeName,
          } = cut;
          let detail = Object.prototype.hasOwnProperty.call(cut, "cutDetails") ? "cutDetails" : "surveyDetails";

          cut[detail] = cut[detail]?.map(detail => {
            return {
              ...detail,
              publisherKey: detail.surveyPublisherKey,
            };
          });

          return {
            cutName,
            cutGroupName,
            cutSubGroupName,
            industrySectorName,
            marketSegmentCutKey,
            organizationTypeName,
            industrySectorKey: industrySectorKeys ? industrySectorKeys[0] : industrySectorKey,
            organizationTypeKey: organizationTypeKeys ? organizationTypeKeys[0] : organizationTypeKey,
            cutGroupKey: cutGroupKeys ? cutGroupKeys[0] : cutGroupKey,
            cutSubGroupKey: cutSubGroupKeys ? cutSubGroupKeys[0] : cutSubGroupKey,
            displayOnReport,
            reportOrder: index + 1,
            blendFlag,
            cutDetails: cut[detail],
          };
        })
        .filter(cut => !cut.blendFlag),
      blends: $form.selectionCuts
        ?.map((cut, index) => {
          let blend = $marketSegmentStore.marketSegment?.blends?.find(blend => blend.marketSegmentCutKey === cut.marketSegmentCutKey);
          if (blend) {
            return {
              ...blend,
              displayOnReport: cut.displayOnReport,
              reportOrder: index + 1,
            };
          }
        })
        .filter(blend => blend),
    };

    return payload;
  };

  const checkForm = () => {
    if (selectionCutList.length < 1) {
      notificationWidget?.show("Please select at least one cut", "error");
      return false;
    }
    return true;
  };

  const save = () => {
    if (!checkForm()) {
      return;
    }

    msName = $marketSegmentStore.marketSegmentName;
    if (!msName?.length) {
      notificationWidget.show("Please enter a market segment name", "error");
      return;
    }

    if ($marketSegmentStore?.marketSegmentDescription?.length > 100) {
      notificationWidget.show("Description cannot be more than 100 characters.", "error");
      return;
    }

    if (marketSegments.find(ms => ms.name === msName && ms.id !== marketSegmentId)) {
      notificationWidget?.show("The market segment name must be unique", "error");
      return;
    }
    let payload = createPayload();
    if (marketSegmentId) {
      $mutationUpdate.mutate({ ...payload, id: marketSegmentId });
    } else {
      $mutationSave.mutate(payload);
    }
  };

  const saveNext = () => {
    saveAndNext = true;
    save();
  };

  const handleToggleCheckbox = (value, index) => {
    updateField(
      // @ts-ignore
      `selectionCuts[${index}].displayOnReport`,
      value,
    );
  };

  function navigateNext() {
    if (dirty || deleteDirty) {
      jQuery(document).ready(function () {
        jQuery("#dialog-selected-cuts").kendoDialog({
          title: "Confirmation Required",
          visible: false,
          content: "You have unsaved changes. Are you sure you want to leave without saving?",
          actions: [
            {
              text: "Yes",
              primary: true,
              action: () => {
                handleReset();
                deleteDirty = false;
                navigateTo(MSSectionTypes.CUTS, MSSectionTypes.ERI);
              },
            },
            { text: "No", primary: false },
          ],
        });

        let dialog = jQuery("#dialog-selected-cuts").data("kendoDialog");
        dialog.open();
        updateKendoDialogStyles(dialog.element);
      });
    } else {
      navigateTo(MSSectionTypes.CUTS, MSSectionTypes.ERI);
    }
    saveAndNext = false;
  }

  function navigatePrevious() {
    if (dirty || deleteDirty) {
      jQuery(document).ready(function () {
        jQuery("#dialog-selected-cuts").kendoDialog({
          title: "Confirmation Required",
          visible: false,
          content: "You have unsaved changes. Are you sure you want to leave without saving?",
          actions: [
            {
              text: "Yes",
              primary: true,
              action: () => {
                handleReset();
                deleteDirty = false;
                navigateTo(MSSectionTypes.CUTS, MSSectionTypes.FILTERS);
              },
            },
            { text: "No", primary: false },
          ],
        });

        let dialog = jQuery("#dialog-selected-cuts").data("kendoDialog");
        dialog.open();
        updateKendoDialogStyles(dialog.element);
      });
    } else {
      navigateTo(MSSectionTypes.CUTS, MSSectionTypes.FILTERS);
    }
  }
  function openSurveyDetailsModalBlend(marketSegmentCutKey) {
    const blendCutGroupName = $marketSegmentStore.marketSegment.blends
      .find(b => b.marketSegmentCutKey === marketSegmentCutKey)
      .cuts.at(0).cutGroupName;

    const selectedCutGroupCuts = $form.selectionCuts.filter(c => c.cutGroupName === blendCutGroupName);
    const surveyDetailsnew = selectedCutGroupCuts.map(cut => cut.surveyDetails || cut.cutDetails);
    showSurveyDetailsModal = true;
    surveyDetailsModalComponent = SurveyLevelDetails;
    surveyDetailsModalData = {
      canUpdateSurveyDetails: false,
      surveyData: surveyDetailsnew,
      marketSegmentId: marketSegmentId,
    };
  }

  function openSurveyDetailsModal(marketSegmentCutKey = -1) {
    let selectedCut = $form.selectionCuts.find(cut => cut.marketSegmentCutKey === marketSegmentCutKey);

    let surveyDetails = selectedCut
      ? selectedCut.surveyDetails || selectedCut.cutDetails
      : $form.selectionCuts.map(cut => cut.surveyDetails || cut.cutDetails);

    showSurveyDetailsModal = true;
    surveyDetailsModalComponent = SurveyLevelDetails;
    surveyDetailsModalData = {
      isProjectStatusFinal,
      canUpdateSurveyDetails: true,
      surveyData: surveyDetails,
      marketSegmentId: marketSegmentId,
      allSurveyData: $form.selectionCuts.map(cut => cut.surveyDetails || cut.cutDetails)?.flat(),
    };
  }

  function navigateToBlend(selectedBlendKey) {
    marketSegmentStore.update(store => ({
      ...store,
      selectedBlendKey,
      isSelectedFromCuts: true,
    }));

    navigateTo(MSSectionTypes.CUTS, MSSectionTypes.BLEND);
  }
</script>

<div id="dialog-selected-cuts" data-cy="deleteDialogMSSelectedCuts" />
<div id="notification" />
<div class="accordion-item">
  <h2 class="accordion-header" id="headingCuts">
    <button
      class="accordion-button collapsed"
      data-cy="accordionSelectedCutsBtn"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#collapseCuts"
      aria-expanded="false"
      aria-controls="collapseCuts"
      id="selectedCutsAccordion"
      on:click={closeAllSections}
    >
      <i class="fa fa-scissors" />&nbsp; Selected Cuts
    </button>
  </h2>
  <div
    id="collapseCuts"
    class="accordion-collapse collapse"
    aria-labelledby="headingCuts"
    data-bs-parent="#accordionExample"
    data-cy="selectedCutsSection"
  >
    <div class="accordion-body">
      {#if isLoading}
        <div class="overlay">
          <Loading {isLoading} />
        </div>
      {/if}
      <div class="row my-2">
        <div class="col-sm-12 col-lg-6 mb-2 d-flex justify-content-start">
          <div class="form-group row">
            <label class="col-5 col-form-label text-end" data-cy="marketSegment-status" for="Status"> Status </label>
            <div class="col-7">
              <input
                type="text"
                class="form-control"
                data-cy="marketSegment-status"
                maxlength="100"
                autocomplete="off"
                value={projStatus?.value ?? MarketSegmentStatusOptions[4].value}
                disabled
              />
            </div>
          </div>
        </div>
      </div>

      <!-- table -->
      <div class="row my-2 p-3">
        <div class="col-12 p-0">
          <div id="new-grid" data-cy="selectCutsGrid" style="max-height: 400px;" />
        </div>
      </div>

      <!-- panel-footer -->
      <div class="row d-flex flex-wrap justify-content-end p-3 py-2">
        <div class="col-6 p-0">
          <button class="btn btn-primary pull-left" data-cy="msSelectionCutSection-viewDetailsBtn" on:click={() => openSurveyDetailsModal()}
            >{marketSegmentId && !isProjectStatusFinal ? "Edit Details" : "View Details"}</button
          >
        </div>
        <div class="col-6 p-0 text-end">
          <button class="btn btn-primary" data-cy="msSelectionCutSection-previousBtn" on:click={navigatePrevious}>Previous</button>
          <button
            class="btn btn-primary"
            data-cy="msSelectionCutSection-saveBtn"
            disabled={isProjectStatusFinal ? isProjectStatusFinal : !selectionCutList?.length}
            on:click={save}>Save</button
          >
          <button
            class="btn btn-primary"
            data-cy="msSelectionCutSection-saveNextBtn"
            disabled={isProjectStatusFinal ? isProjectStatusFinal : !selectionCutList?.length}
            on:click={saveNext}>Save & Next</button
          >
          <button class="btn btn-primary" data-cy="msSelectionCutSection-nextBtn" disabled={!selectionCutList?.length} on:click={navigateNext}
            >Next</button
          >
        </div>
      </div>
    </div>
  </div>
</div>

{#if showSurveyDetailsModal}
  <Modal
    show={surveyDetailsModalComponent}
    props={surveyDetailsModalData}
    on:closed={() => {
      showSurveyDetailsModal = false;
      surveyDetailsModalComponent = null;
    }}
    closeOnEsc={true}
  />
{/if}

<style>
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
