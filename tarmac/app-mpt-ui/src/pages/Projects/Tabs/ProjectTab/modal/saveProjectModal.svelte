<script>
  // @ts-nocheck

  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";
  import Organization from "../../../../../components/shared/organization.svelte";
  import { onMount } from "svelte";
  import Input from "../../../../../components/controls/input.svelte";
  import { getDateString, promiseWrap } from "../../../../../utils/functions";
  import { ProjectStatusOptionsArray } from "../../../../../utils/constants";
  import { getFileToDownload, getProjectListForOrganization } from "../../../../../api/apiCalls";

  let projectList = [],
    projectDetails = $$props,
    file,
    dataEffectiveDateCustom;

  const { organization, handleSaveAsProject, handleShowSaveAsModal } = $$props;

  const aggregationMethodologyOptions = [
    { id: 1, text: "Parent" },
    { id: 2, text: "Child" },
  ];

  onMount(async () => {
    let [fileResponse] = [];
    if (fileKey) [fileResponse] = await promiseWrap(getFileToDownload(fileKey));

    if (fileResponse) {
      file = fileResponse;
    }

    dataEffectiveDateCustom = getDateString(new Date(projectDetails && dataEffectiveDate));
  });

  const {
    id,
    organizationId,
    projectVersion,
    projectVersionDate,
    dataEffectiveDate,
    status,
    name,
    projectVersionLabel,
    workForceProjectType,
    aggregationMethodologyKey,
    benchmarkDataTypes,
    surveySourceGroupDataProps,
    fileLogKey,
    fileKey,
  } = projectDetails;

  let showSourceDataInfo = projectDetails && fileKey;

  function getInitialValues() {
    return {
      id,
      organizationID: organizationId || "",
      versionDate: getDateString(new Date(projectVersionDate)) || "",
      sourceDataType: (fileKey && 1) || 0,
      fileLogKey: fileLogKey || 0,
      sourceData: projectDetails.sourceData || [],
      projectStatus: ProjectStatusOptionsArray.find(s => s.value === status).id || "",
      name: name || "",
      versionLabel: projectVersionLabel || "",
      workforceProjectType: workForceProjectType || surveySourceGroupDataProps.find(o => o.name === "Employee")?.id,
      version: projectVersion || "",
      aggregationMethodologyKey: aggregationMethodologyKey,
      benchmarkDataTypes: benchmarkDataTypes || [],
    };
  }

  export const updateFormInitialValues = data => updateInitialValues(getInitialValues(data));

  $: orgValue = `${organization} - ${organizationId}` || "";

  const onClickSave = async () => {
    await handleSaveAsProject($form);
  };

  const close = async () => {
    await handleShowSaveAsModal();
  };

  const { form, errors, updateField, updateValidateField, handleChange, updateInitialValues } = createForm({
    initialValues: getInitialValues(),
    validationSchema: yup.object().shape({
      organizationID: yup.lazy(value => (value === "" ? yup.string().required() : yup.number().required())),
      versionDate: yup.string().required(),
      projectStatus: yup.number().oneOf(ProjectStatusOptionsArray).required(),
      name: yup.string().required(),
      versionLabel: yup.string().required(),
      version: yup.number().required(),
      aggregationMethodologyKey: yup.number().required(),
    }),
    onSubmit: () => {
      onClickSave();
    },
  });

  const onOrgInputChange = async event => {
    const orgID = event?.detail?.id ? event.detail.id : "";
    updateValidateField("organizationID", orgID);

    if (orgID) {
      const [projectListData] = await promiseWrap(getProjectListForOrganization(orgID));
      if (projectListData != null && projectListData?.length > 0) {
        projectList = projectListData;
      }
    }
    const orgValueInput = document.querySelector(".add-project-modal-input-organization");
    if (!orgValueInput.disabled) updateProjectVersion();
  };

  function updateProjectVersion() {
    const projectName = $form.name?.toLowerCase() || "";
    const newVersionCount = projectList.filter(project => project.name.toLowerCase() === projectName).length + 1;

    if ($form.version !== newVersionCount) {
      updateValidateField("version", newVersionCount);
      updateValidateField("versionLabel", newVersionCount);
      updateField("workforceProjectType", surveySourceGroupDataProps.find(o => o.name === "Employee")?.id);
      updateField("aggregationMethodologyKey", aggregationMethodologyOptions.find(a => a.text === "Child")?.id);
    } else {
      updateField("id", 0);
    }
  }

  async function downloadFile(e) {
    e.stopPropagation();
    e.preventDefault();
    window.open(file);
  }
</script>

<span id="notification" />
<div id="kendo-dialog" />
<div class="row" data-cy="saveAsProjectModal">
  <div class="col-12">
    <div class="card-header card-header-sticky">
      <h5 class="my-2" data-cy="modelTitle">Save As</h5>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-12">
          <div class="card border-bottom-0">
            <div class="card-header">
              <h6 class="my-2" data-cy="projectInfoTitle">Project ID - {id}</h6>
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
                        bind:selectedOrgValue={orgValue}
                        customClassName={"add-project-modal-input-organization"}
                        on:orgSelected={onOrgInputChange}
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
                        on:change={handleChange}
                        on:blur={handleChange}
                        on:keyup={updateProjectVersion}
                        bind:value={$form.name}
                        error={$errors.name}
                      />
                    </div>
                  </div>
                  <div class="form-group row mb-2">
                    <label class="col-6 col-form-label required text-end" data-cy="projectVersionLabel" for="versionLabel">
                      Project Version Label
                    </label>
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
                    <label class="col-6 col-form-label text-end required" data-cy="aggregationLabel" for="aggregationMethodology">
                      Aggregation Methodology
                    </label>
                    <div class="col-6">
                      <select
                        class="form-select"
                        data-cy="aggregationValue"
                        id="aggregationMethodology"
                        name="aggregationMethodology"
                        on:change={handleChange}
                        value={$form.aggregationMethodologyKey}
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
                        {#each $$props.surveySourceGroupDataProps as option}
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
      {#if showSourceDataInfo}
        <div class="row">
          <div class="col-12">
            <div class="card border-bottom-0">
              <div class="card-header">
                <h6 class="my-2" data-cy="projectInfoTitle">Source Data Info</h6>
              </div>
              <div class="card-body">
                <div class="row my-2">
                  <div class="row my-2">
                    <div class="col-lg-12 col-md-9 col-sm-12">
                      <div class="d-flex justify-content-start align-items-start">
                        <div class="form-check mx-2">
                          <input
                            class="form-check-input"
                            type="radio"
                            name="sourceData"
                            id="rbNoData"
                            data-cy="noDataValue"
                            value={0}
                            disabled={projectDetails && projectDetails.fileKey}
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
                            checked={projectDetails && projectDetails.fileKey}
                          />
                          <label class="form-check-label" for="rbExisting" data-cy="useExistingLabel">Use Existing</label>
                        </div>
                        <div class="form-check mx-2">
                          <input
                            class="form-check-input"
                            type="radio"
                            name="sourceData"
                            id="rbNoData"
                            data-cy="noDataValue"
                            value={0}
                            disabled={projectDetails && projectDetails.fileKey}
                          />
                          <label class="form-check-label" for="rbNoData" data-cy="noDataLabel">Upload New</label>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="row my-2">
                    <div class="col-lg-12 col-md-9 col-sm-12">
                      <div class="row" id="divUseExisting">
                        <div class="col-lg-4 col-sm-12 col-md-6 mb-2">
                          <div class="form-group row">
                            <label class="col-6 col-form-label text-end required" data-cy="sourceDataLabel" for="sourceDataValue">
                              Source Data
                            </label>
                            <div class="col-6">
                              <select
                                class="form-select"
                                data-cy="sourceDataValue"
                                id="sourceDataValue"
                                name="sourceData"
                                value={projectDetails && projectDetails.sourceData}
                                disabled
                              >
                                <option selected value="">Select Source Data</option>
                                <option value="Incumbent">Incumbent</option>
                                <option value="Job">Job</option>
                              </select>
                            </div>
                          </div>
                        </div>
                        <div class="col-lg-4 col-sm-12 col-md-6 mb-2">
                          <div class="form-group row">
                            <label class="col-6 col-form-label text-end required" data-cy="sourceDataLabel" for="sourceDataValue">
                              Data Effective Date
                            </label>
                            <div class="col-6">
                              <input
                                type="text"
                                class="form-control"
                                maxlength="100"
                                id="fileLogKey"
                                data-cy="fileLogKeySaveAs"
                                required
                                disabled
                                autocomplete="off"
                                value={projectDetails && dataEffectiveDateCustom}
                              />
                            </div>
                          </div>
                        </div>
                        <div class="col-lg-4 col-sm-12 col-md-6 mb-2">
                          <div class="form-group row">
                            <label class="col-6 col-form-label text-end required" data-cy="uploadDataLabel" for="uploadData">
                              Source Data file:
                            </label>
                            <div class="col-6">
                              {#if file}
                                <span class="csvFile" on:keydown={() => false} data-cy="uploadDataValueSaveAsModal" on:click={downloadFile}
                                  ><i class="fa fa-download download-icon" />{file.substring(
                                    file.lastIndexOf(".com") + 5,
                                    file.indexOf(".csv") + 4,
                                  )}</span
                                >
                              {:else}
                                <span class="form-label mt-2" data-cy="uploadDataValueSaveAsModal">No file for download</span>
                              {/if}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      {/if}
    </div>
  </div>
  <div class="row">
    <div class="col-12">
      <div class="card-footer d-flex justify-content-start">
        <div>
          <button type="submit" class="btn btn-primary" data-cy="save" on:click={onClickSave}>Save</button>
        </div>
        <div>
          <button class="btn btn-primary" data-cy="close" on:click={close}>Cancel</button>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .card-footer {
    position: sticky;
    bottom: 0;
    background-color: white;
  }

  .btn-primary {
    border: 1px solid #1c82c1;
    background: #1c82c1;
    color: white;
    border-radius: 5px;
    box-shadow: 1px 1px 3px rgb(0 0 0 / 26%);
    cursor: pointer;
    margin-left: 5px;
    height: fit-content;
  }
  .csvFile {
    color: #1c82c1;
    cursor: pointer;
  }
  .download-icon {
    margin-right: 5px;
  }
</style>
