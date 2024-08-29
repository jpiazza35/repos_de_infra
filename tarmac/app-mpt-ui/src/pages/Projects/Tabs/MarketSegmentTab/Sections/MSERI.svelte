<script>
  // @ts-nocheck
  import { useMutation } from "@sveltestack/svelte-query";
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";
  import Input from "components/controls/input.svelte";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import Loading from "components/shared/loading.svelte";
  import { saveERI } from "api/apiCalls";
  import { isDirty } from "utils/functions";
  import { marketSegmentStore, unsavedMarketSegmentStore } from "./marketSegmentStore";
  import { MSSectionTypes, closeAllSections, navigateTo } from "./MSNavigationManager";

  export let isProjectStatusFinal = false;

  let marketSegment;
  let notificationWidget = null;
  let hasNationalCuts = false;
  let saveAndNext = false;

  //mutation to save ERI
  const mutationSave = useMutation(
    async request => {
      const data = await saveERI(marketSegment.id, request);
      return data.data;
    },
    {
      onSuccess: () => {
        notificationWidget?.show("The ERI records have been saved", "success");
        if (saveAndNext) {
          navigateNext();
        }
      },
      onError: () => {
        notificationWidget?.show("There was an error saving ERI records", "error");
      },
    },
  );

  const { form, errors, touched, handleChange, updateInitialValues, updateValidateField, handleReset } = createForm({
    initialValues: {
      eriItem: {
        marketSegmentCutKey: null,
        eriAdjustmentFactor: null,
        eriCutName: null,
        eriCity: null,
      },
    },
    validationSchema: yup.object().shape({
      eriItem: yup.object().shape({
        eriAdjustmentFactor: yup
          .number()
          .nullable()
          .transform((value, originalValue) => {
            if (originalValue !== null && originalValue !== "") {
              return parseFloat(parseFloat(originalValue).toFixed(2));
            }
            return value;
          })
          .min(-1.0, "ERI ADJ Factor should have -1.0 as the minimum value")
          .max(1.0, "ERI ADJ Factor should have 1.0 as the maximum value")
          .typeError("ERI ADJ Factor must be a number")
          .test("eriAdjFactorDecimals", "ERI ADJ Factor can have up to 2 decimal places", value => {
            if (value !== null && value !== "") {
              const decimalCount = value.toString().split(".")[1]?.length || 0;
              return decimalCount <= 2;
            }
            return true;
          }),
        eriCutName: yup
          .string()
          .nullable()
          .when("eriAdjustmentFactor", {
            is: value => value != null && value !== "" && value !== 0,
            then: yup
              .string()
              .required("ERI Cut name is mandatory when ERI Adj factor is entered")
              .max(100, "ERI Cut name should have at most 100 characters"),
            otherwise: yup.string().max(100, "ERI Cut name should have at most 100 characters"),
          }),
        eriCity: yup.string().max(100, "ERI Cut city should have at most 100 characters"),
      }),
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
  let eriCutNameUsed = false;
  let eriItem = {};
  form.subscribe(s => (eriItem = s.eriItem));

  marketSegmentStore?.subscribe(store => {
    marketSegment = store.marketSegment;

    if (marketSegment && marketSegment.cuts.length > 0) {
      eriCutNameUsed = store.combinedAverageData?.find(c => c.cuts?.find(b => b.name.includes(marketSegment.eriCutName)));
      hasNationalCuts = marketSegment.cuts.some(c => c.cutGroupName === "National");
      const { eriAdjustmentFactor, eriCutName, eriCity } = marketSegment;
      updateInitialValues({
        eriItem: {
          eriAdjustmentFactor: eriAdjustmentFactor ?? "",
          eriCutName: eriCutName ?? "",
          eriCity: eriCity ?? "",
        },
      });
    }
  });

  function handleChangeAdjFactor(event) {
    const input = event.target;
    let value = parseFloat(input.value);
    value = Math.round(value * 100) / 100;
    value = Math.min(Math.max(value, -1), 1);
    input.value = value.toFixed(2);
    handleChange(event, "eriItem.eriAdjustmentFactor");
    updateValidateField("eriItem.eriCutName", eriItem.eriCutName);
  }

  const checkForErrors = eriItem => {
    if (!$marketSegmentStore.id) {
      notificationWidget?.show("Please save market segment at Selection Cuts Section first", "error");
      return false;
    }
    if (isProjectStatusFinal) {
      return false;
    }
    if (eriItem?.eriAdjustmentFactor?.length > 0 && !eriItem.eriCutName) {
      notificationWidget?.show("There was an error saving ERI, check the fields and try again", "error");
      return false;
    }

    return true;
  };

  const save = () => {
    const { eriItem } = $form;
    if (checkForErrors(eriItem)) {
      if (hasNationalCuts) {
        marketSegment.eriAdjustmentFactor = eriItem.eriAdjustmentFactor === "" ? null : eriItem.eriAdjustmentFactor;
        marketSegment.eriCutName = eriItem.eriCutName === "" ? null : eriItem.eriCutName?.escape();
        marketSegment.eriCity = eriItem.eriCity === "" ? null : eriItem.eriCity;
        $mutationSave.mutate(marketSegment);
        dirty = false;
      }
    }
  };

  const saveNext = () => {
    saveAndNext = true;
    save();
  };

  const navigateNext = () => {
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
              navigateTo(MSSectionTypes.ERI, MSSectionTypes.BLEND);
            },
          },
          { text: "No", primary: false },
        ],
      });

      const dialog = jQuery("#dialog-ERI").data("kendoDialog");
      dialog.open();
      updateKendoDialogStyles(dialog.element);
    } else {
      navigateTo(MSSectionTypes.ERI, MSSectionTypes.BLEND);
    }
    saveAndNext = false;
  };

  const navigatePrevious = () => {
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
              navigateTo(MSSectionTypes.ERI, MSSectionTypes.CUTS);
            },
          },
          { text: "No", primary: false },
        ],
      });

      const dialog = jQuery("#dialog-ERI").data("kendoDialog");
      dialog.open();

      updateKendoDialogStyles(dialog.element);
    } else {
      navigateTo(MSSectionTypes.ERI, MSSectionTypes.CUTS);
    }
  };

  $: isSaveDisabled = isProjectStatusFinal
    ? isProjectStatusFinal
    : marketSegment && eriItem
    ? (!!eriItem.eriAdjustmentFactor && !eriItem.eriCutName) ||
      (!marketSegment.eriAdjustmentFactor &&
        !eriItem.eriAdjustmentFactor &&
        !marketSegment.eriCutName &&
        !eriItem.eriCutName &&
        !marketSegment.eriCity &&
        !eriItem.eriCity) ||
      (!!eriItem.eriCutName && eriItem.eriCutName.length > 100) ||
      (!!eriItem.eriCity && eriItem.eriCity.length > 100)
    : true;

  notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
</script>

<div id="dialog-ERI" />
<div id="notification" />
<div class="accordion-item">
  <h2 class="accordion-header" id="headingERI">
    <button
      class="accordion-button collapsed"
      data-cy="accordionERIBtn"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#collapseERI"
      aria-expanded="false"
      aria-controls="collapseERI"
      id="eriAccordion"
      on:click={closeAllSections}
    >
      <i class="fa fa-line-chart" />&nbsp; ERI
    </button>
  </h2>
  <div id="collapseERI" class="accordion-collapse collapse" aria-labelledby="headingERI" data-bs-parent="#accordionExample" data-cy="eriSection">
    <div class="accordion-body">
      {#if $mutationSave.isLoading}
        <div class="overlay">
          <Loading isLoading={true} />
        </div>
      {/if}
      <!-- here goes the table -->
      <table class="table table-bordered table-striped" data-cy="tableERISection">
        <colgroup>
          <col span="1" style="width: 10%;" />
          <col span="1" style="width: 15%;" />
          <col span="1" style="width: 15%;" />
        </colgroup>
        <thead>
          <tr>
            <th data-cy="eriAdjFactorTh">ERI Adj Factor</th>
            <th data-cy="eriCutNameTh">ERI Cut Name</th>
            <th data-cy="eriCutCityTh">ERI Cut City</th>
          </tr>
        </thead>
        {#if !hasNationalCuts}
          <tbody>
            <tr>
              <td colspan="7" class="text-center" data-cy="noNationals"> No national cuts selected </td>
            </tr>
          </tbody>
        {:else}
          <tbody>
            <tr>
              <td>
                <Input
                  colSize="12"
                  id="eriItem.eriAdjustmentFactor"
                  name=".eriItem.eriAdjustmentFactor"
                  data-cy="eriAdjustmentFactorInput"
                  step="0.10"
                  min="-1"
                  max="1"
                  type="number"
                  on:change={e => handleChangeAdjFactor(e)}
                  on:blur={e => handleChangeAdjFactor(e)}
                  value={$form.eriItem?.eriAdjustmentFactor}
                  required={false}
                  disabled={isProjectStatusFinal}
                />
              </td>
              <td>
                <Input
                  colSize="12"
                  id="eriItem.eriCutName"
                  name="eriItem.eriCutName"
                  data-cy="eriCutNameInput"
                  on:change={handleChange}
                  on:blur={handleChange}
                  value={$form.eriItem?.eriCutName?.unescape()}
                  error={$errors.eriItem?.eriCutName}
                  disabled={isProjectStatusFinal || eriCutNameUsed}
                />
              </td>
              <td>
                <Input
                  colSize="12"
                  id="eriItem.eriCity"
                  name="eriItem.eriCity"
                  data-cy="eriCityInput"
                  on:change={handleChange}
                  on:blur={handleChange}
                  value={$form.eriItem?.eriCity}
                  required={false}
                  error={$errors.eriItem?.eriCity}
                  disabled={isProjectStatusFinal}
                />
              </td>
            </tr>
          </tbody>
        {/if}
      </table>
      <div class="d-flex my-4 row">
        <div class="col-8 text-right" style="margin-top: -15px;">
          {#if eriCutNameUsed}
            <span class="combinedAverageWarning" data-cy="combinedAverageWarningSpan">
              The ERI Name participates in a combined average. Please delete the combined average first, before removing or changing the ERI Name.
            </span>
          {/if}
        </div>
        <div class="col-4 text-right">
          <button class="btn btn-primary btn-right" data-cy="msEriSection-nextBtn" on:click={navigateNext}>Next</button>
          <button class="btn btn-primary btn-right" data-cy="msEriSection-saveNextBtn" disabled={isSaveDisabled} on:click={saveNext}
            >Save & Next</button
          >
          <button class="btn btn-primary btn-right" data-cy="msEriSection-saveBtn" disabled={isSaveDisabled} on:click={save}>Save</button>
          <button type="submit" class="btn btn-primary btn-right" data-cy="msEriSection-previousBtn" on:click={navigatePrevious}>Previous</button>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .btn-right {
    float: right;
    margin: 2px 5px 2px 0;
  }

  .table thead {
    background-color: #808080;
    color: white;
  }

  .table thead th {
    font-weight: 400;
    cursor: pointer;
  }

  .combinedAverageWarning {
    font-size: 11px;
    color: #0076be;
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
