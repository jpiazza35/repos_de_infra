<script>
  // @ts-nocheck
  import { useQuery } from "@sveltestack/svelte-query";
  import { createEventDispatcher, onMount } from "svelte";
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";

  import Input from "components/controls/input.svelte";
  import Organization from "components/shared/organization.svelte";
  import { getDateString } from "utils/functions";
  import { ProjectStatusOptionsArray } from "utils/constants";
  import { getProjectListForOrganization } from "api/apiCalls";

  export let projectInfoForm;
  export let projectInfoStatus;
  export let projectDetails;
  export let disabled;
  export let isFormModified = false;
  export let surveySourceGroups = [];

  export const submitForm = e => handleSubmit(e);
  export const updateFieldValue = (field, value) => updateValidateField(field, value);
  export const updateFormInitialValues = data => updateInitialValues(getInitialValues(data));

  const dispatch = createEventDispatcher();

  $: orgName = projectDetails?.organizationName || "";
  $: isUpdate = projectDetails?.id > 0;
  $: projectInfoForm = $form;
  $: projectInfoStatus = $isValid;
  $: isFormModified = $isModified;

  let orgInputRef;
  let projectList = [];
  let notificationWidget;

  const aggregationMethodologyOptions = [
    { id: 1, text: "Parent" },
    { id: 2, text: "Child" },
  ];

  // load project list for organization
  const queryProjectList = useQuery(
    ["projectList", $form?.organizationID],
    async () => {
      const data = await getProjectListForOrganization($form.organizationID);
      return data.data;
    },
    { enabled: false, cacheTime: 0 },
  );

  const refetchProjectList = () => {
    $queryProjectList.refetch();
  };

  if (projectDetails?.organizationID) {
    refetchProjectList();
  }

  $: if ($queryProjectList.data) {
    projectList = $queryProjectList.data;
    if (!isUpdate) {
      updateValidateField("version", projectList?.length + 1);
    }
  }

  $: if ($isModified) {
    isFormModified = true;
  }

  const { form, errors, isValid, isModified, updateField, updateValidateField, handleChange, handleReset, handleSubmit, updateInitialValues } =
    createForm({
      initialValues: getInitialValues(projectDetails),
      validationSchema: yup.object().shape({
        organizationID: yup.lazy(value => (value === "" ? yup.string().required() : yup.number().required())),
        versionDate: yup.string().required(),
        projectStatus: yup
          .number()
          .oneOf(ProjectStatusOptionsArray.map(opt => opt.id))
          .required(),
        name: yup
          .string()
          .required()
          .test("duplicate-name", "Duplicate project name", function (value) {
            if (isUpdate) {
              return true;
            }
            const projectName = value?.toLowerCase()?.trim() || "";

            if (projectName?.length && $form.organizationID) {
              const isDuplicate = projectList?.find(p => p.name?.toLowerCase()?.trim() === projectName);
              if (isDuplicate && notificationWidget) {
                notificationWidget.hide();
                notificationWidget.show(`This project name is already exists`, "error");
              }

              return isDuplicate ? false : true;
            }
          }),
        versionLabel: yup.string().required(),
        version: yup.number().required(),
        aggregationMethodologyKey: yup
          .number()
          .oneOf(aggregationMethodologyOptions.map(opt => opt.id))
          .required(),
      }),
      onSubmit: () => {},
    });

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  });

  function getInitialValues(projectDetails) {
    return {
      organizationID: projectDetails?.organizationID || "",
      versionDate: getDateString(projectDetails?.versionDate),
      projectStatus: projectDetails?.projectStatus,
      name: projectDetails?.name || "",
      versionLabel: projectDetails?.versionLabel,
      workforceProjectType: projectDetails?.workforceProjectType || surveySourceGroups.find(o => o.name === "Employee")?.id,
      version: projectDetails?.version,
      aggregationMethodologyKey: projectDetails?.aggregationMethodologyKey || aggregationMethodologyOptions.find(a => a.text === "Parent")?.id,
    };
  }

  const onOrgInputChange = event => {
    const orgID = event.detail ? event.detail.id : "";
    updateValidateField("organizationID", orgID);

    if (orgID) {
      $queryProjectList.refetch();
      dispatch("updateEffectiveDates", orgID);
    }
    if ($form.name) {
      updateValidateField("name", $form.name);
    }
  };

  export const resetForm = () => {
    handleReset();
    if (!isUpdate) orgInputRef.reset();
  };
</script>

<span id="notification" />
{#if projectDetails && $form}
  <div class="row">
    <div class="col-12">
      <div class="card border-bottom-0">
        <div class="card-header">
          <h6 class="my-2" data-cy="projectInfoTitle">Project Info</h6>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-4">
              <div class="form-group row mb-2">
                <label for="organizationID" class="col-6 col-form-label text-end required" data-cy="orgLabel">Organization (Name or ID)</label>
                <div class="col-6">
                  <Organization
                    removeLabel
                    isValid={!$errors.organizationID}
                    bind:disabled={isUpdate}
                    bind:selectedOrgValue={orgName}
                    customClassName={"add-project-modal-input-organization"}
                    on:orgSelected={onOrgInputChange}
                    bind:this={orgInputRef}
                  />
                </div>
              </div>
              <div class="form-group row mb-2">
                <label class="col-6 col-form-label text-end required" data-cy="nameLabel" for="name"> Project Name </label>
                <div class="col-6">
                  <Input
                    id="name"
                    name="name"
                    maxlength="100"
                    placeholder="Enter Project Name"
                    on:keyup={handleChange}
                    bind:value={$form.name}
                    error={$errors.name}
                    disabled={isUpdate || disabled}
                  />
                </div>
              </div>
              <div class="form-group row mb-2">
                <label class="col-6 col-form-label required text-end" data-cy="projectVersionLabel" for="versionLabel"> Project Version Label </label>
                <div class="col-6">
                  <Input
                    id="versionLabel"
                    name="versionLabel"
                    placeholder="Enter Project Version Label"
                    maxlength="100"
                    on:change={handleChange}
                    on:blur={handleChange}
                    bind:value={$form.versionLabel}
                    error={$errors.versionLabel}
                    {disabled}
                  />
                </div>
              </div>
            </div>
            <div class="col-4">
              <div class="form-group row mb-2">
                <label for="versionDate" class="col-6 col-form-label text-end required" data-cy="versionDateLabel"> Project Version Date</label>
                <div class="col-6">
                  <input
                    type="text"
                    class="form-control"
                    maxlength="100"
                    id="versionDate"
                    data-cy="versionDateValue"
                    required
                    disabled
                    autocomplete="off"
                    value={$form.versionDate}
                  />
                </div>
              </div>
              <div class="form-group row mb-2">
                <label class="col-6 col-form-label text-end required" data-cy="statusLabel" for="projectStatus"> Project Status </label>
                <div class="col-6">
                  <select
                    id="projectStatus"
                    class="form-select"
                    data-cy="statusValue"
                    on:change={e => updateField("projectStatus", parseInt(e.target.value))}
                    value={$form.projectStatus}
                    required
                    disabled={isUpdate && disabled}
                  >
                    {#each ProjectStatusOptionsArray as option}
                      <option value={option.id}>
                        {option.value}
                      </option>
                    {/each}
                  </select>
                </div>
              </div>
              <div class="form-group row mb-2">
                <label class="col-6 col-form-label text-end required" data-cy="aggregationLabel" for="aggregationMethodologyKey">
                  Aggregation Methodology
                </label>
                <div class="col-6">
                  <select
                    class="form-select"
                    data-cy="aggregationValue"
                    id="aggregationMethodologyKey"
                    name="aggregationMethodologyKey"
                    on:change={e => updateField("aggregationMethodologyKey", parseInt(e.target.value))}
                    value={$form.aggregationMethodologyKey}
                    {disabled}
                  >
                    {#each aggregationMethodologyOptions as option}
                      <option value={option.id}>
                        {option.text}
                      </option>
                    {/each}
                  </select>
                </div>
              </div>
            </div>
            <div class="col-4">
              <div class="form-group row mb-2">
                <label class="col-6 col-form-label text-end required" data-cy="workforceLabel" for="workforceProjectType">
                  Workforce Project Type
                </label>
                <div class="col-6">
                  <select
                    disabled
                    class="form-select"
                    data-cy="workforceValue"
                    id="workforceProjectType"
                    on:change={e => updateField("workforceProjectType", parseInt(e.target.value))}
                    value={$form.workforceProjectType}
                  >
                    {#each surveySourceGroups as option}
                      <option value={option.id}>
                        {option.name}
                      </option>
                    {/each}
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}
