<script>
  // @ts-nocheck

  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";
  import { useMutation } from "@sveltestack/svelte-query";
  import Input from "components/controls/input.svelte";
  import Typeahead from "components/controls/typeahead.svelte";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import { isDirty } from "utils/functions";
  import { saveBlends } from "api/apiCalls";
  import { MSSectionTypes, closeAllSections, navigateTo } from "./MSNavigationManager";
  import { marketSegmentStore, unsavedMarketSegmentStore } from "./marketSegmentStore";
  import Modal from "components/shared/modal.svelte";
  import SurveyLevelDetails from "../modal/SurveyLevelDetails.svelte";
  import Loading from "components/shared/loading.svelte";

  export let isProjectStatusFinal = false;
  let blendNamesArray = [];
  let newBlendName = "";
  let uniqueCutGroupsNames = [];
  let notificationWidget = null;
  let selectedBlendKey;
  let selectedCutGroupName;
  let selectedCutGroupCuts = [];
  let selectedCutDetails = [];
  let blendList = [];
  let marketSegId;
  let showSurveyDetailsModal = false;
  let surveyDetailsModalComponent = null;
  let surveyDetailsModalData = null;
  let isError = false;
  let checkedCuts;
  let selectedBlend;
  let totalWeightError = "";
  $: selectionBlendsCount = $form.selectionBlends?.filter(blend => blend.checked).length || 0;
  $: totalWeight = $form.selectionBlends?.filter(blend => blend.checked).reduce((acc, obj) => acc + parseFloat(obj.blendWeight), 0) || 0;

  // mutation to save the blend
  const mutationSave = useMutation(
    async payload => {
      const data = await saveBlends(marketSegId, payload);
      return data.data;
    },
    {
      onSuccess: saveBlendResponse => {
        selectedBlendKey = saveBlendResponse.find(b => b.blendName === blendName)?.marketSegmentCutKey;
        blendList = saveBlendResponse;
        let blendsToCuts = saveBlendResponse.map(blend => {
          return {
            blendFlag: true,
            cutName: blend.blendName,
            cutDetails: [],
            displayOnReport: blend.displayOnReport,
            marketSegmentCutKey: blend.marketSegmentCutKey,
            marketSegmentId: blend.marketSegmentId,
            reportOrder: blend.reportOrder,
            cuts: blend.cuts,
          };
        });
        marketSegmentStore.update(store => ({
          ...store,
          marketSegment: {
            ...store.marketSegment,
            blends: saveBlendResponse,
            cuts: store.marketSegment.cuts.filter(cut => !cut.blendFlag).concat(blendsToCuts),
          },
          isSelectedFromCuts: false,
        }));
        notificationWidget?.show("The Blend has been saved", "success");
        dirty = false;
      },
      onError: () => {
        notificationWidget?.show("There was an error saving the Blend", "error");
      },
    },
  );

  const { form, errors, touched, handleChange, updateField, updateInitialValues, handleReset } = createForm({
    initialValues: {
      selectionBlends: [],
    },
    validationSchema: yup.object().shape({
      selectionBlends: yup.array().of(
        yup.object().shape({
          checked: yup.boolean(),
          industrySectorName: yup.string(),
          organizationTypeName: yup.string(),
          cutGroupName: yup.string(),
          cutSubGroupName: yup.string(),
          blendWeight: yup.number().min(0.01).max(1).required(),
        }),
      ),
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

  let isAddBlendDisabled = false;
  let blendName = "";

  function isBlendNameValid(name) {
    if (name?.length > 100) {
      isAddBlendDisabled = name?.length > 100;
      isError = name?.length > 100;
      notificationWidget?.show("Blend name cannot have more than 100 characters.", "error");
      return false;
    }
    return true;
  }

  function calculateIncrementedMaxReportOrder(marketSegment, blendList) {
    let incrementedMaxReportOrder = 0;

    let maxCutsReportOrder = Math.max(...(marketSegment?.cuts?.map(cut => cut.reportOrder) || []));

    if (isNaN(maxCutsReportOrder)) maxCutsReportOrder = marketSegment?.cuts?.length || 0;

    let maxBlendsReportOrder = blendList?.length > 0 && Math.max(...(blendList?.map(blend => blend.reportOrder) || []));

    let maxReportOrder = Math.max(maxCutsReportOrder, maxBlendsReportOrder);
    incrementedMaxReportOrder = maxReportOrder + 1;

    return incrementedMaxReportOrder;
  }

  const checkForErrors = () => {
    blendName = jQuery(".typeahead")?.val();
    if (isAddBlendDisabled || isError) {
      return false;
    }
    totalWeightError = "";
    if ($form.selectionBlends?.filter(blend => blend.checked).reduce((acc, obj) => acc + parseFloat(obj.blendWeight), 0) !== 1) {
      totalWeightError = "The total weight of the blend must be 1";
      return false;
    }
    if (blendName === "") {
      notificationWidget?.show("Please enter a blend name", "error");
      return false;
    }
    if (blendName?.length > 100) {
      notificationWidget?.show("Blend name cannot have more than 100 characters.", "error");
      return false;
    }
    checkedCuts = $form.selectionBlends.filter(c => c.checked);
    if (checkedCuts.length === 0) {
      notificationWidget?.show("Please select at least one cut", "error");
      return false;
    }
    return true;
  };

  const save = async () => {
    let blendName = jQuery(".typeahead")?.val();
    if (isBlendNameValid(blendName)) {
      if (!marketSegId) {
        notificationWidget?.show("Please save market segment at Selection Cuts Section first", "error");
        return false;
      }

      if (checkForErrors()) {
        let payload = {
          BlendName: blendName,
          DisplayOnReport: true,
          ReportOrder: calculateIncrementedMaxReportOrder($marketSegmentStore?.marketSegment, blendList),
          MarketSegmentCutKey: selectedBlendKey || 0,
          Cuts: checkedCuts.map(c => ({
            marketSegmentBlendKey: c.marketSegmentBlendKey,
            ChildMarketSegmentCutKey: c.marketSegmentCutKey || c.childMarketSegmentCutKey,
            blendWeight: parseFloat(c.blendWeight),
          })),
        };
        $mutationSave.mutate(payload);
      }
    }
  };

  const saveNext = async () => {
    if (await save()) navigateNext();
  };

  function navigateNext() {
    if (dirty) {
      jQuery("#dialog-ERI").kendoDialog({
        title: "Confirmation Required",
        visible: false,
        content: "You have unsaved changes. Are you sure you want to leave without saving?",
        actions: [
          {
            text: "Yes",
            primary: true,
            action: () => {
              handleReset();
              navigateTo(MSSectionTypes.BLEND, MSSectionTypes.COMBINED_AVERAGE);
            },
          },
          { text: "No", primary: false },
        ],
      });

      var dialog = jQuery("#dialog-ERI").data("kendoDialog");
      dialog.open();
      updateKendoDialogStyles(dialog.element);
    } else {
      navigateTo(MSSectionTypes.BLEND, MSSectionTypes.COMBINED_AVERAGE);
    }
  }

  function navigatePrevious() {
    if (dirty) {
      jQuery("#dialog-ERI").kendoDialog({
        title: "Confirmation Required",
        visible: false,
        content: "You have unsaved changes. Are you sure you want to leave without saving?",
        actions: [
          {
            text: "Yes",
            primary: true,
            action: () => {
              handleReset();
              navigateTo(MSSectionTypes.BLEND, MSSectionTypes.ERI);
            },
          },
          { text: "No", primary: false },
        ],
      });

      var dialog = jQuery("#dialog-ERI").data("kendoDialog");
      dialog.open();
      updateKendoDialogStyles(dialog.element);
    } else {
      navigateTo(MSSectionTypes.BLEND, MSSectionTypes.ERI);
    }
  }

  const handleSelectBlend = async item => {
    jQuery(".typeahead").val(item.blendName);

    uniqueCutGroupsNames = [item.cuts[0]?.cutGroupName];
    selectedCutGroupName = uniqueCutGroupsNames[0];

    updateInitialValues({
      selectionBlends: item.cuts.map(cut => ({
        ...cut,
        checked: true,
      })),
    });

    checkForErrors();
  };

  const clearBlendSection = () => {
    blendNamesArray = [];
    selectedBlend = {};
    uniqueCutGroupsNames = [];
    selectedBlendKey = null;
    jQuery(".typeahead").val("");
    updateInitialValues({ selectionBlends: [] });
    handleReset();
  };

  marketSegmentStore?.subscribe(store => {
    const { marketSegment, id, isEditing } = store;
    marketSegId = id;
    selectedCutGroupCuts = [];

    if (marketSegment && marketSegment?.blends && marketSegment?.blends.length > 0) {
      blendNamesArray = marketSegment?.blends?.filter(blend => blend.cuts?.filter(c => c.cutGroupName !== "National"));

      let selectionBlends = marketSegment?.blends;
      if (selectionBlends && selectionBlends.length > 0) {
        if ($marketSegmentStore?.isSelectedFromCuts) {
          selectedBlend = selectionBlends.find(b => b.marketSegmentCutKey === $marketSegmentStore?.selectedBlendKey);
        } else {
          selectedBlend = selectionBlends.reduce((prevBlend, currentBlend) => {
            return currentBlend.reportOrder > prevBlend.reportOrder ? currentBlend : prevBlend;
          });
        }
        selectedBlendKey = selectedBlend?.marketSegmentCutKey;
        if (selectedBlendKey) updateFormInitialValues(selectionBlends);
      } else {
        marketSegmentStore.update(store => ({
          ...store,
          selectedBlendKey: null,
        }));
      }
    } else {
      !isEditing && clearBlendSection();
    }
  });

  const handleClickAddBlend = async () => {
    if (!marketSegId) {
      notificationWidget?.show("Please save market segment at Selection Cuts Section first", "error");
      return false;
    }

    selectedBlendKey = 0;
    newBlendName = jQuery(".typeahead").val();
    if (isBlendNameValid(newBlendName)) {
      uniqueCutGroupsNames = $marketSegmentStore?.marketSegment.cuts
        ?.filter(c => c.cutGroupName && c.cutGroupName !== "National")
        .map(obj => obj.cutGroupName)
        .filter((value, index, self) => self.indexOf(value) === index);
      selectedCutGroupCuts = $marketSegmentStore?.marketSegment?.cuts?.filter(c => c.cutGroupName === uniqueCutGroupsNames[0]);
      selectedCutGroupName = uniqueCutGroupsNames[0];
      if (selectedCutGroupCuts) {
        updateInitialValues({
          selectionBlends: selectedCutGroupCuts?.map(cut => ({
            ...cut,
            checked: false,
          })),
        });
      }
    }
  };

  const handleSelectCutGroup = async event => {
    selectedCutGroupName = event.target.value;
    selectedCutGroupCuts = $marketSegmentStore?.marketSegment?.cuts?.filter(c => c.cutGroupName === selectedCutGroupName);

    updateInitialValues({
      selectionBlends: selectedCutGroupCuts?.map(cut => ({
        ...cut,
        checked: false,
      })),
    });
  };

  const handleToggleCheckbox = (event, index) => {
    const selectionCuts = $marketSegmentStore?.marketSegment?.cuts || [];
    const selectionBlends = $marketSegmentStore?.marketSegment?.blends || [];
    const allObjects = [...selectionCuts, ...selectionBlends, ...selectedCutGroupCuts];

    const max = Math.max(...allObjects.map(obj => obj.reportOrder));

    updateField(`selectionBlends[${index}].checked`, event.target.checked);
    updateField(`selectionBlends[${index}].reportOrder`, max + 1);
  };

  const handleChangeWeight = e => {
    let value = parseFloat(e.target.value);
    if (!isNaN(value)) {
      value = Math.round(value * 100) / 100;
      value = Math.min(Math.max(value, 0), 1);
      e.target.value = value.toFixed(2);
    }
    totalWeightError = "";
    handleChange(e);
  };

  let surveyDetails;

  function openSurveyDetailsModal(selectedBlendKey) {
    selectedCutGroupCuts = $marketSegmentStore?.marketSegment?.cuts?.filter(c => c.cutGroupName === selectedCutGroupName);
    surveyDetails = selectedBlendKey ? selectedCutGroupCuts.map(cut => cut.surveyDetails || cut.cutDetails) : selectedCutDetails;
    selectedBlend =
      $marketSegmentStore?.marketSegment?.blends?.length > 0
        ? $marketSegmentStore?.marketSegment?.blends.filter(b => b.marketSegmentCutKey === selectedBlendKey)
        : [];

    showSurveyDetailsModal = true;
    surveyDetailsModalComponent = SurveyLevelDetails;
    surveyDetailsModalData = {
      canUpdateSurveyDetails: false,
      surveyData: surveyDetails,
    };
  }

  notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  let sortBy = { col: "Cut Group", ascending: true };

  function updateFormInitialValues(selectionBlends) {
    const blend = selectionBlends.find(b => b.marketSegmentCutKey === selectedBlendKey);
    if (blend) {
      newBlendName = blend.blendName;
      jQuery(".typeahead").val(newBlendName);
      selectedCutDetails = blend.cuts.map(c => c.cutDetails);
      uniqueCutGroupsNames = [blend.cuts[0]?.cutGroupName];
      selectedCutGroupName = uniqueCutGroupsNames[0];
      updateInitialValues({
        selectionBlends: blend.cuts.map(cut => ({
          ...cut,
          checked: true,
        })),
      });
    }
  }

  $: sort = column => {
    if (sortBy.col == column) {
      sortBy.ascending = !sortBy.ascending;
    } else {
      sortBy.col = column;
      sortBy.ascending = true;
    }

    // Modifier to sorting function for ascending or descending
    let sortModifier = sortBy.ascending ? 1 : -1;

    let sort = (a, b) => {
      a[column] = a[column] ?? "";
      b[column] = b[column] ?? "";

      return a[column] < b[column] ? -1 * sortModifier : a[column] > b[column] ? 1 * sortModifier : 0;
    };

    $form.selectionBlends = $form.selectionBlends?.sort(sort);
    // @ts-ignore
    $errors.selectionBlends = $errors.selectionBlends?.sort(sort);
  };
</script>

<div id="notification" data-cy="notificationBlend" />
<div id="kendo-dialog" />

<div class="accordion-item">
  <h2 class="accordion-header" id="headingBlend">
    <button
      class="accordion-button collapsed"
      data-cy="accordionBlendBtn"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#collapseBlend"
      aria-expanded="false"
      aria-controls="collapseBlend"
      id="blendAccordion"
      on:click={closeAllSections}
    >
      <i class="fa fa-compress" />&nbsp; Blend
    </button>
  </h2>
  <div id="collapseBlend" class="accordion-collapse collapse" aria-labelledby="headingBlend" data-bs-parent="#accordionBlend" data-cy="blendSection">
    <div class="accordion-body">
      {#if $mutationSave.isLoading}
        <div class="overlay">
          <Loading isLoading={$mutationSave.isLoading} />
        </div>
      {/if}
      <div>
        <div class="row my-2">
          <div class="col-sm-12 col-md-3 col-lg-3 mb-2">
            <div class="form-group row">
              <label class="col-5 col-form-label text-end" data-cy="blendNameLabel" for="blendNameLabel"> Blend Name </label>
              <div class="col-7">
                <Typeahead
                  items={blendNamesArray}
                  onSelectItem={handleSelectBlend}
                  nameProperty="blendName"
                  disabled={isProjectStatusFinal}
                  selectedItem={selectedBlend?.blendName}
                />
              </div>
            </div>
          </div>
          <div class="col-md-auto col-md-2 col-lg-2 mb-2">
            <button on:click={handleClickAddBlend} class="btn btn-primary" data-cy="addBlendBtn" disabled={isProjectStatusFinal}>Add Blend</button>
          </div>
          <div class="col-md-auto col-md-5 col-lg-5 mb-2">
            <div class="form-group row">
              <label class="col-4 col-form-label text-end" data-cy="cutGroupLabel" for="cutGroup"> Select Cut Group </label>
              <div class="col-6">
                {#if selectedBlendKey}
                  <select class="form-select" id="cutGroupDisabled" disabled value={selectedCutGroupName}
                    >{#each uniqueCutGroupsNames as cutGroupName}
                      <option value={cutGroupName}>{cutGroupName}</option>
                    {/each}</select
                  >
                {:else}
                  <select class="form-select" id="cutGroup" value={selectedCutGroupName} on:change={handleSelectCutGroup} data-cy="selectCutGroupCy">
                    <option value="" selected> Select Cut Group </option>
                    {#if uniqueCutGroupsNames}
                      {#each uniqueCutGroupsNames as cutGroupName}
                        <option value={cutGroupName}>{cutGroupName}</option>
                      {/each}
                    {:else}
                      <option value="">No cut groups available</option>
                    {/if}
                  </select>
                {/if}
              </div>
            </div>
          </div>
          <div class="col-sm-12 col-md-2 col-lg-2 mb-2 d-flex justify-content-end">
            <div class="form-group row justify-content-end">
              <label class="col-4 col-form-label text-end" data-cy="totalsLabel" for="name"> Totals </label>
              <div class="col-8 d-flex justify-content-end">
                <Input id="totalsControl" data-cy="totalsControlCy" disabled value={totalWeight.toFixed(2)} error={totalWeightError} showFeedback />
              </div>
            </div>
          </div>
        </div>
        <div>
          <table class="table table-bordered table-striped">
            <colgroup>
              <col span="1" style="width: 3%;" />
              <col span="1" style="width: 35%;" />
              <col span="1" style="width: 17%;" />
              <col span="1" style="width: 15%;" />
              <col span="1" style="width: 15%;" />
              <col span="1" style="width: 15%;" />
            </colgroup>
            <thead>
              <tr>
                <th data-cy="checkedBlendCollumn" on:click={() => sort("checked")}>Select</th>
                <th data-cy="industrySectorNameBlendCollumn" on:click={() => sort("industrySectorName")}>Industry/Sector</th>
                <th data-cy="organizationTypeNameBlendCollumn" on:click={() => sort("organizationTypeName")}>Org Type</th>
                <th data-cy="cutGroupNameBlendCollumn" on:click={() => sort("cutGroupName")}>Cut Group</th>
                <th data-cy="cutSubGroupNameBlendCollumn" on:click={() => sort("cutSubGroupName")}>Cut Sub-Group</th>
                <th data-cy="weightBlendCollumn" on:click={() => sort("blendWeight")}>Weight</th>
              </tr>
            </thead>
            <tbody>
              {#if !$form.selectionBlends || $form.selectionBlends?.length === 0}
                <tr>
                  <td colspan="6" class="text-center" data-cy="emptyBlendTableCy">No blends added</td>
                </tr>
              {:else}
                {#each $form.selectionBlends as blend, i}
                  <tr>
                    <td valign="middle">
                      <input
                        type="checkbox"
                        data-cy="blendDataCheckbox"
                        checked={blend.checked}
                        on:change={e => handleToggleCheckbox(e, i)}
                        disabled={isProjectStatusFinal}
                      />
                    </td>
                    <td valign="middle">
                      {blend?.industrySectorName?.length > 0 ? blend?.industrySectorName : "-"}
                    </td>
                    <td valign="middle">{blend.organizationTypeName}</td>
                    <td valign="middle">{blend.cutGroupName}</td>
                    <td valign="middle">
                      {blend?.cutSubGroupName?.length > 0 ? blend?.cutSubGroupName : "-"}
                    </td>
                    <td>
                      <Input
                        colSize="12"
                        id="blendWeight"
                        name={`selectionBlends[${i}].blendWeight`}
                        min="0"
                        max="1"
                        data-cy="blendWeightInput"
                        step="0.01"
                        type="number"
                        on:change={handleChangeWeight}
                        on:blur={handleChangeWeight}
                        value={$form.selectionBlends[i]?.blendWeight}
                        error={$errors.selectionBlends[i]["blendWeight"]}
                        disabled={isProjectStatusFinal}
                      />
                    </td>
                  </tr>
                {/each}
              {/if}
            </tbody>
          </table>
        </div>
      </div>

      <div class="d-flex flex-wrap justify-content-end my-4 row">
        <!-- panel-footer -->
        <div class="col-6">
          <button class="btn btn-primary pull-left" data-cy="msBlendSection-viewDetailBtn" on:click={openSurveyDetailsModal}>View Details</button>
        </div>
        <div class="col-6 text-end">
          <button class="btn btn-primary" data-cy="msBlendSection-previousBtn" on:click={navigatePrevious}>Previous</button>
          <button class="btn btn-primary" data-cy="msBlendSection-saveBtn" disabled={isProjectStatusFinal || selectionBlendsCount < 2} on:click={save}
            >Save</button
          >
          <button
            class="btn btn-primary"
            data-cy="msBlendSection-saveNextBtn"
            disabled={isProjectStatusFinal || selectionBlendsCount < 2}
            on:click={saveNext}>Save & Next</button
          >
          <button class="btn btn-primary" data-cy="msBlendSection-nextBtn" on:click={navigateNext}>Next</button>
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
  />
{/if}

<style>
  .col-form-label {
    white-space: nowrap;
  }

  .btn-primary {
    margin-right: 5px;
    margin: 2px 5px 2px 0;
    padding: 4px 20px;
  }

  .table thead {
    background-color: #808080;
    color: white;
  }

  .table thead th {
    font-weight: 400;
    cursor: pointer;
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
