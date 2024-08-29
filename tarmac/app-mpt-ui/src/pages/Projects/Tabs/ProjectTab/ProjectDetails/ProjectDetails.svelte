<script>
  // @ts-nocheck
  import { useMutation } from "@sveltestack/svelte-query";
  import { createEventDispatcher, onMount } from "svelte";
  import { serialize } from "object-to-formdata";
  import { BenchmarkDataTypeInfo, ProjectDetails } from "models/project/projectDetails";
  import { promiseWrap } from "utils/functions";
  import { getProjectDetails, saveProjectDetails, updateProjectDetails, getBenchmarkDataTypes, saveFileDetails } from "api/apiCalls";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import ProjectInfoSection from "./modal/ProjectInfoSection.svelte";
  import SourceDataInfoSection from "./modal/SourceDataInfoSection.svelte";
  import BenchmarkDataTypesSection from "./modal/BenchmarkDataTypesSection.svelte";
  import { projectVersionStore } from "store/project";

  export let projectId, projectVersionId;
  export let surveySourceGroups;
  $: disabled = projectDetails?.projectStatus === 2;

  const dispatch = createEventDispatcher();

  const mutationUpdate = useMutation(
    async payload => {
      const data = await updateProjectDetails(projectId, payload, projectVersionId);
      return data.data;
    },
    {
      onSuccess: response => {
        onSuccessSave(response);
      },
      onError: () => {
        notificationWidget.show("Error in saving the project", "error");
      },
    },
  );

  const mutationSave = useMutation(
    async payload => {
      const data = await saveProjectDetails(payload);
      return data.data;
    },
    {
      onSuccess: response => {
        onSuccessSave(response);
      },
      onError: () => {
        notificationWidget.show("Error in saving the project", "error");
      },
    },
  );

  const onSuccessSave = projectDetailsResponse => {
    notificationWidget.show("Data has been saved successfully", "success");
    projectDetails = new ProjectDetails(projectDetailsResponse);
    projectId = projectDetails.id;
    projectVersionId = projectDetails.version;
    isProjectUpdate = true;
    dispatch("dataUpdate", {
      isProjectSaved: true,
      hasUnSavedChanged: false,
      orgId: projectDetails.organizationID,
      orgName: projectDetails.organizationName,
      isProjectCreate,
    });
    updateFormInitialValues();
    if ($projectVersionStore.id === projectDetails.version) {
      projectVersionStore.update(store => ({
        ...store,
        aggregationMethodologyKey: projectDetails.aggregationMethodologyKey,
        versionLabel: projectDetails.versionLabel,
      }));
    }
  };

  const onClose = () => {
    if (isProjectModified) {
      jQuery("#confirmation-kendo-dialog").kendoDialog({
        title: "Confirmation Required",
        visible: false,
        content: "You have unsaved changes. Are you sure you want to leave without saving?",
        actions: [
          {
            text: "Yes",
            primary: true,
            action: () => {
              dispatch("close");
              jQuery("#confirmation-kendo-dialog")?.remove();
            },
          },
          { text: "No", primary: false },
        ],
      });

      const dialog = jQuery("#confirmation-kendo-dialog").data("kendoDialog");
      dialog.open();
      updateKendoDialogStyles(dialog.element);
    } else {
      dispatch("close");
    }
  };

  let projectDetails;
  let benchmarkDataTypes = [];
  let isProjectUpdate = false;
  let isProjectCreate = false;
  let notificationWidget;
  let file;
  let selectedDateAlreadyExistsFileKey;
  let confirmOverwrite;

  let projectInfoForm, projectInfoStatus;
  let sourceDataInfoForm, sourceDataInfoStatus, benchmarkDataTypesStatus;
  let projectInfoRef, sourceDataInfoRef, benchmarkDataTypesRef;
  let workforceProjectTypeSelected;
  let dialogReset = null;
  let isProjectInfoModified = false,
    isSourceDataModified = false,
    isBenchmarkTypesModified = false;
  $: isProjectModified = isProjectInfoModified || isSourceDataModified || isBenchmarkTypesModified;

  onMount(async () => {
    mountResetDialog();
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");

    await getBenchMarkDataTypes();
    if (projectId > 0) {
      isProjectUpdate = true;
      const [projectDetailsData, projectDetailsError] = await promiseWrap(getProjectDetails(projectId, projectVersionId));
      if (projectDetailsError) notificationWidget.show("Error getting project details", "error");
      if (projectDetailsData) {
        projectDetails = new ProjectDetails(projectDetailsData);
      }
    } else if ($projectVersionStore.organizationName && $projectVersionStore.organizationID) {
      isProjectCreate = true;
      projectDetails = new ProjectDetails({
        organizationName: $projectVersionStore.organizationName,
        organizationID: $projectVersionStore.organizationID,
      });
    } else {
      isProjectCreate = true;
      projectDetails = new ProjectDetails({});
    }
  });

  const mountResetDialog = () => {
    dialogReset = jQuery("#reset-kendo-dialog").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      content: "Are you sure you want to reset the changes?",
      actions: [
        {
          text: "Yes",
          action: function () {
            resetProjectDetails();
            return true;
          },
          primary: true,
        },
        { text: "No", primary: true },
      ],
    });
    updateKendoDialogStyles(dialogReset.data("kendoDialog").element);
  };

  const onClickSave = async e => {
    await projectInfoRef.submitForm(e);
    await sourceDataInfoRef.submitForm(e);
    await benchmarkDataTypesRef.submitForm(e);

    if (!projectInfoStatus || !sourceDataInfoStatus || !benchmarkDataTypesStatus) return;

    if (selectedDateAlreadyExistsFileKey && !confirmOverwrite) {
      confirmOverwriteDate();
    } else {
      checkIfProjectStatusIsFinal();
    }
  };

  function confirmOverwriteDate() {
    jQuery("#confirm-overwrite").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      content: "A file with this data effective date already exists. Do you want to proceed to replace the existing file?",
      actions: [
        {
          text: "Yes",
          action: function () {
            confirmOverwrite = true;
            checkIfProjectStatusIsFinal();
            return true;
          },
          primary: true,
        },
        {
          text: "No",
          action: function () {
            sourceDataInfoRef?.updateFieldValue("effectiveDate", null);
            sourceDataInfoRef?.submitForm();
            return true;
          },
          primary: true,
        },
      ],
    });

    var dialog = jQuery("#confirm-overwrite").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
  }

  function checkIfProjectStatusIsFinal() {
    projectInfoForm?.projectStatus == 2 ? confirmProjectStatusChange() : saveProject();
  }

  function confirmProjectStatusChange() {
    jQuery("#confirm-status-change")?.remove();
    let divElement = document.createElement("div");
    divElement.id = "confirm-status-change";
    document.body.appendChild(divElement);

    jQuery("#confirm-status-change").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      content: jQuery("#kendo-project-status-dialog")[0].innerHTML,
      actions: [
        {
          text: "Yes",
          action: function () {
            saveProject();
            return true;
          },
          primary: true,
        },
        {
          text: "No",
          action: function () {
            return true;
          },
          primary: true,
        },
      ],
    });

    var dialog = jQuery("#confirm-status-change").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
    dialog.bind("close", () => {
      jQuery("#confirm-status-change")?.remove();
    });
  }

  const saveProject = async () => {
    const payload = {
      ...projectInfoForm,
      sourceDataInfo: {
        ...sourceDataInfoForm,
        effectiveDate: new Date(sourceDataInfoForm?.effectiveDate) ?? null,
      },
      versionDate: new Date(projectInfoForm.versionDate),
      versionLabel: projectInfoForm.versionLabel.toString(),
      benchmarkDataTypes: benchmarkDataTypes
        .filter(dataType => dataType.checked)
        .map(dataType => {
          return { ...dataType, overrideAgingFactor: dataType.overrideAgingFactor !== "" ? dataType.overrideAgingFactor : null };
        }),
    };

    try {
      // When the user 'No Data' in Source Data Info
      if (payload.sourceDataInfo?.sourceDataType == 0) {
        payload.sourceDataInfo.fileLogKey = null;
      } else {
        if (file) {
          const fileDetails = {
            organizationId: projectInfoForm.organizationID,
            sourceDataName: sourceDataInfoForm.sourceData,
            effectiveDate: sourceDataInfoForm.effectiveDate,
            clientFileName: file.name,
            projectVersion: payload.version,
            File: file,
          };

          let fileFormData = serialize(fileDetails);
          const [fileResponse] = await promiseWrap(saveFileDetails(fileFormData));
          payload.sourceDataInfo.fileLogKey = fileResponse.fileLogKey;
          payload.existingFileLogKey = selectedDateAlreadyExistsFileKey;
        }
      }

      isProjectUpdate ? $mutationUpdate.mutate(payload) : $mutationSave.mutate(payload);
    } catch (error) {
      notificationWidget.show("Error in saving the project", "error");
    }
  };

  function resetProjectDetails() {
    projectInfoRef?.resetForm();
    sourceDataInfoRef?.resetForm();
    benchmarkDataTypesRef?.resetForm();
    isProjectModified = false;
  }

  function onClear() {
    dialogReset.data("kendoDialog").open();
  }

  function updateEffectiveDates() {
    sourceDataInfoRef.getEffectiveDates();
  }

  function updateFormInitialValues() {
    projectInfoRef?.updateFormInitialValues(projectDetails);
    sourceDataInfoRef?.getEffectiveDates();
    sourceDataInfoRef?.updateFormInitialValues(projectDetails.sourceDataInfo);
    benchmarkDataTypesRef?.updateFormInitialValues(projectDetails.benchmarkDataTypes, isProjectUpdate);
  }

  const getBenchMarkDataTypes = async () => {
    if (surveySourceGroups?.length) {
      workforceProjectTypeSelected = surveySourceGroups.find(o => o.name === "Employee")?.id;

      const [values, error] = await promiseWrap(getBenchmarkDataTypes(workforceProjectTypeSelected));
      if (error) {
        notificationWidget.show("Error in getting benchmark data types", "error");
        return;
      }

      benchmarkDataTypes = values?.map(v => new BenchmarkDataTypeInfo(v)) || [];
    }
  };
</script>

<span id="notification" />
<div id="reset-kendo-dialog" />
<div id="confirmation-kendo-dialog" />
<div id="confirm-overwrite" />

<div id="kendo-project-status-dialog" class="d-none">
  <div class="my-2">
    <h5 style="font-weight: 700;">
      {projectDetails?.id ? "Project ID - " + projectDetails?.id : ""}
    </h5>
    <p style="margin-left: 50px; margin-top: 15px; line-height: 1.5;">
      Once the Project Status is set to Final, the Project will be read-only. <br />
      Are you sure you want to set the Project Status to Final?
    </p>
  </div>
</div>

{#if projectDetails}
  <div class="row">
    <div class="col-12">
      <div class="card-header card-header-sticky">
        {#if projectDetails.id}
          <h5 class="my-2" data-cy="modelTitle">
            Project Details - #{projectDetails.id}
          </h5>
        {:else}
          <h5 class="my-2" data-cy="modelTitle">Project Details</h5>
        {/if}
      </div>
      <div class="card-body">
        <ProjectInfoSection
          bind:projectDetails
          bind:projectInfoForm
          bind:projectInfoStatus
          bind:this={projectInfoRef}
          bind:disabled
          bind:surveySourceGroups
          bind:isFormModified={isProjectInfoModified}
          on:updateEffectiveDates={updateEffectiveDates}
        />
        <SourceDataInfoSection
          bind:sourceDataInfo={projectDetails.sourceDataInfo}
          bind:sourceDataInfoForm
          bind:sourceDataInfoStatus
          bind:projectInfoForm
          bind:file
          bind:this={sourceDataInfoRef}
          bind:isUpdate={isProjectUpdate}
          bind:organizationID={projectDetails.organizationID}
          bind:disabled
          bind:isFormModified={isSourceDataModified}
          bind:selectedDateAlreadyExistsFileKey
        />
        {#if benchmarkDataTypes.length}
          <BenchmarkDataTypesSection
            bind:selectedBenchmarkDataTypes={projectDetails.benchmarkDataTypes}
            bind:benchmarkDataTypes
            bind:benchmarkDataTypesStatus
            bind:this={benchmarkDataTypesRef}
            bind:disabled
            bind:isUpdate={isProjectUpdate}
            bind:isFormModified={isBenchmarkTypesModified}
          />
        {/if}
      </div>
      <div class="card-footer d-flex justify-content-between">
        <div>
          {#if !disabled}
            <button type="submit" class="btn btn-primary" data-cy="save" on:click={e => onClickSave(e)} disabled={!isProjectModified}>Save</button>
            <button class="btn btn-primary" data-cy="cancel" on:click={onClear} disabled={!isProjectModified}>Reset</button>
          {/if}
        </div>
        <div>
          <button class="btn btn-primary" data-cy="close" on:click={onClose}>Close</button>
        </div>
      </div>
    </div>
  </div>
{/if}
