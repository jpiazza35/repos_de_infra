<script>
  // @ts-nocheck
  import { onMount } from "svelte";
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";

  import { getSourceDataEffectiveDate } from "api/apiCalls";
  import { formatDate, promiseWrap } from "utils/functions";
  import { FileStatus } from "models/project/projectDetails";

  export let projectInfoForm;
  export let sourceDataInfoForm;
  export let sourceDataInfoStatus;
  export let file;
  export let sourceDataInfo;
  export let isUpdate;
  export let organizationID;
  export let disabled;
  export let isFormModified = false;
  export let selectedDateAlreadyExistsFileKey;

  export const resetForm = () => {
    handleReset();
    isFormModified = false;
    showValidations = false;
  };
  export const submitForm = e => {
    handleSubmit(e);
    showValidations = true;
  };
  export const updateFormInitialValues = data => {
    updateInitialValues(getInitialValues(data));
    file = undefined;
    showValidations = false;
    isFormModified = false;
  };

  export const updateFieldValue = (field, value) => updateField(field, value);

  const ALLOWED_FILE_TYPES = ["text/csv"];

  let notificationWidget;
  let selectedOption;
  let effectiveDates = [];
  let showValidations = false;

  $: orgId = organizationID || projectInfoForm?.organizationID;
  $: sourceDataInfoForm = $form;
  $: sourceDataInfoStatus = $isValid && isFileValid;
  $: isFileValid = $form.sourceDataType === 2 ? !!file : true;
  $: isFormModified = false;

  onMount(() => {
    if (isUpdate && !disabled) {
      getEffectiveDates({});
    }

    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  });
  const { form, errors, isValid, updateField, updateValidateField, handleChange, handleReset, handleSubmit, updateInitialValues, validateField } =
    createForm({
      initialValues: getInitialValues(sourceDataInfo),
      validationSchema: yup.object().shape({
        sourceDataType: yup.number().oneOf([0, 1, 2]),
        sourceData: yup
          .string()
          .oneOf(["Incumbent", "Job"])
          .when("sourceDataType", {
            is: value => value !== 0,
            then: yup.string().oneOf(["Incumbent", "Job"]).required(),
            otherwise: yup.string().oneOf(["", "Incumbent", "Job"]),
          }),
        effectiveDate: yup.string().when("sourceDataType", {
          is: value => value === 2,
          then: yup.string().required(),
          otherwise: yup.string(),
        }),
        fileLogKey: yup.number().when("sourceDataType", {
          is: sourceDataType => sourceDataType === 1,
          then: yup.number().min(1),
          otherwise: yup.number(),
        }),
      }),
      onSubmit: () => {},
    });

  export async function getEffectiveDates(event) {
    selectedOption = event?.target?.value || $form.sourceData;

    if (orgId && selectedOption) {
      const [effectiveDateResponse, _effectiveDateError] = await promiseWrap(getSourceDataEffectiveDate(orgId, selectedOption));
      if (effectiveDateResponse.length > 0) {
        effectiveDates = effectiveDateResponse;
        if ($form.sourceDataType == 1) {
          updateValidateField("fileLogKey", $form.fileLogKey || effectiveDateResponse[0].fileLogKey);
        }
      }

      if (_effectiveDateError) notificationWidget.show("Error on Effective Date", "error");
    }
  }
  function getInitialValues(sourceDataInfo) {
    return {
      sourceDataType: sourceDataInfo?.sourceDataType,
      sourceData: sourceDataInfo?.sourceData,
      effectiveDate: sourceDataInfo?.effectiveDate,
      fileLogKey: sourceDataInfo?.fileLogKey || 0,
    };
  }

  function checkEffectiveDate(event) {
    isFormModified = true;
    if ($form.sourceDataType === 1) {
      updateValidateField("fileLogKey", parseInt(event.target.value));
      return;
    } else {
      let selectedDate = event.target.value;
      selectedDateAlreadyExistsFileKey = effectiveDates.find(item => item.effectiveDate.split("T")[0] === selectedDate)?.fileLogKey;

      updateValidateField("effectiveDate", selectedDate);
    }
  }

  function handleSelectFile(event) {
    const selectedFile = event.target.files[0];

    if (!isValidFile(selectedFile)) {
      event.target.value = null;
      return;
    }

    file = selectedFile;
  }

  function isValidFile(file) {
    if (!file) {
      return false;
    }

    if (!ALLOWED_FILE_TYPES.includes(file.type)) {
      notificationWidget.show("File type must be csv", "error");
      return false;
    }

    if (file.size < 617) {
      // Template size
      notificationWidget.show("File can't be empty", "error");
      return false;
    }

    return true;
  }

  function onSourceDataTypeChange(value) {
    updateField("sourceDataType", value);
    isFormModified = true;
    if (showValidations) {
      validateField("sourceData");
      validateField("effectiveDate");
      validateField("fileLogKey");
    }
  }
</script>

<div id="kendo-dialog-eff-dates" />
<div class="row">
  <div class="col-12">
    <div class="card border-bottom-0">
      <div class="card-header">
        <h6 class="my-2">Source Data Info</h6>
      </div>
      <div class="card-body">
        <div class="row my-2">
          <div class="col-lg-3 col-md-12 col-sm-12 mt-2 mb-4">
            <div class="d-flex justify-content-center align-items-center">
              <div class="form-check mx-2">
                <input
                  class="form-check-input"
                  type="radio"
                  name="sourceData"
                  id="rbNoData"
                  data-cy="noDataValue"
                  value={0}
                  on:change={() => onSourceDataTypeChange(0)}
                  checked={$form.sourceDataType === 0}
                  {disabled}
                />
                <label class="form-check-label" for="rbNoData" data-cy="noDataLabel">No Data</label>
              </div>
              <div class="form-check mx-2">
                <input
                  class="form-check-input"
                  type="radio"
                  name="sourceData"
                  id="rbExisting"
                  value={1}
                  data-cy="useExistingValue"
                  on:change={() => onSourceDataTypeChange(1)}
                  checked={$form.sourceDataType === 1}
                  {disabled}
                />
                <label class="form-check-label" for="rbExisting" data-cy="useExistingLabel">Use Existing</label>
              </div>
              <div class="form-check mx-2">
                <input
                  class="form-check-input"
                  type="radio"
                  name="sourceData"
                  id="rbNew"
                  value={2}
                  data-cy="uploadNewValue"
                  on:change={() => onSourceDataTypeChange(2)}
                  checked={$form.sourceDataType === 2}
                  {disabled}
                />
                <label class="form-check-label" for="rbNew" data-cy="uploadNewLabel">Upload New</label>
              </div>
            </div>
          </div>
          <div class="col-lg-9 col-md-9 col-sm-12">
            <div>
              {#if $form.sourceDataType === 1}
                <div class="row" id="divUseExisting">
                  <div class="col-lg-4 col-sm-12 mb-2">
                    <div class="form-group row">
                      <label class="col-lg-5 col-sm-6 col-form-label text-end required" data-cy="sourceDataLabel" for="sourceDataValue">
                        Source Data
                      </label>
                      <div class="col-lg-7 col-sm-6">
                        <select
                          class="form-select"
                          data-cy="sourceDataValue"
                          id="sourceDataValue"
                          name="sourceData"
                          on:change|preventDefault={e => {
                            getEffectiveDates(e);
                            handleChange(e);
                            isFormModified = true;
                          }}
                          value={$form.sourceData}
                          {disabled}
                          class:is-invalid={$errors.sourceData}
                        >
                          <option selected value="">Select Source Data</option>
                          <option value="Incumbent">Incumbent</option>
                          <option value="Job">Job</option>
                        </select>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-5 col-sm-12 mb-2">
                    <div class="form-group row">
                      <label class="col-lg-6 col-sm-6 col-form-label text-end required" data-cy="effectiveDateLabel" for="effectiveDateValue1">
                        Data Effective Date
                      </label>
                      <div class="col-lg-6 col-sm-6">
                        <select
                          id="fileLogKey"
                          class="form-select"
                          data-cy="fileLogKey"
                          on:change={checkEffectiveDate}
                          value={$form.fileLogKey}
                          {disabled}
                          class:is-invalid={$errors.fileLogKey}
                        >
                          <option selected value={0}>Select Data Effective Date</option>
                          {#each effectiveDates.filter(e => e.fileStatusKey === FileStatus.Valid || e.fileStatusKey === FileStatus.ValidWithWarnings) as effectiveDate}
                            <option value={effectiveDate.fileLogKey}>
                              {`${formatDate(effectiveDate.effectiveDate)} - ${effectiveDate.fileStatusName}`}
                            </option>
                          {/each}
                        </select>
                      </div>
                    </div>
                  </div>
                </div>
              {:else if $form.sourceDataType === 2}
                <div class="row" id="divNewUpload">
                  <div class="col-lg-3 col-sm-12 mb-2">
                    <div class="form-group row">
                      <label class="col-lg-5 col-sm-6 col-form-label text-end required" data-cy="sourceDataLabel" for="sourceDataValue">
                        Source Data
                      </label>
                      <div class="col-lg-7 col-sm-6">
                        <select
                          class="form-select"
                          data-cy="sourceDataValue"
                          id="sourceDataValue"
                          name="sourceData"
                          on:change|preventDefault={e => {
                            getEffectiveDates(e);
                            handleChange(e);
                          }}
                          value={$form.sourceData}
                          class:is-invalid={$errors.sourceData}
                        >
                          <option selected value="">Select Source Data</option>
                          <option value="Incumbent">Incumbent</option>
                          <option value="Job">Job</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <div class="col-lg-4 col-sm-12 mb-2">
                    <div class="form-group row">
                      <label class="col-lg-6 col-sm-6 col-form-label text-end required" data-cy="effectiveDateLabel" for="effectiveDateValue2">
                        Data Effective Date
                      </label>
                      <div class="col-lg-6 col-sm-6">
                        <input
                          id="effectiveDateValue2"
                          type="date"
                          class="form-control"
                          data-cy="effectiveDateValue2"
                          on:change={checkEffectiveDate}
                          value={$form.effectiveDate}
                          class:is-invalid={$errors.effectiveDate}
                        />
                      </div>
                    </div>
                  </div>

                  <div class="col-lg-5 col-sm-12 mb-2">
                    <div class="form-group row">
                      <label class="col-lg-4 col-sm-6 col-form-label text-end required" data-cy="uploadDataLabel" for="uploadData">
                        Upload your data here (CSV only)
                      </label>
                      <div class="col-lg-8 col-sm-6">
                        <input
                          id="uploadData"
                          type="file"
                          accept=".csv"
                          class="form-control"
                          data-cy="uploadDataValue"
                          on:change={handleSelectFile}
                          class:is-invalid={showValidations && !isFileValid}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
