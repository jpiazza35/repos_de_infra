<script>
  import { onMount, createEventDispatcher } from "svelte";
  import { useMutation } from "@sveltestack/svelte-query";
  import { updateKendoDialogStyles } from "components/shared/functions";
  import Standards from "./Sections/Standards.svelte";
  import Audit from "./Sections/Audit.svelte";
  import { JobMatchStatus } from "./JobMatchingGridConfig";
  import {
    getMatchedStandardJobs,
    saveJobMatchDetails,
    getJobMatchPublishers,
    getSurveyJobDetails,
    getJobMatchAuditCalculations,
    checkJobMatchAssignemnt,
  } from "api/apiCalls";

  export let selectedJobMatchs;
  export let projectVersionId;
  export let isProjectStatusFinal;

  let notificationWidget = null;
  let selectedStandardsCopy = [];
  let selectedStandards = [];
  let isStandardValid = false;
  let jobMatch = {};
  let jobMatchCopy = {};
  let isModified = false;
  let selectedJobs = [];
  let isJobDetailValid = true;
  let selectedStandardJobCodes = [];
  let surveyPublishers = [];
  let isSaved = false;
  let auditValues = {};
  let isJobMatchsSame = true;
  let searchStandards = [];
  let searchStandardInput = "";

  const dispatch = createEventDispatcher();

  const setJobMatchStatus = jobMatchStatusKey => {
    if (!jobMatchStatusKey) return JobMatchStatus.AnalystReviewed;
    // "7 - Not Started" should default to "8 - Analyst Reviewed"
    if (jobMatchStatusKey === 7) return JobMatchStatus.AnalystReviewed;

    return jobMatchStatusKey;
  };

  // load standard jobs
  const mutationMatchedStandarJobs = useMutation(
    async selectedJobs => {
      const data = await getMatchedStandardJobs(projectVersionId, selectedJobs);
      return data.data;
    },
    {
      onSuccess: response => {
        jobMatch = response;
        jobMatch.publisherKey = response.publisherKey || 0;
        jobMatch.jobMatchStatusKey = setJobMatchStatus(response.jobMatchStatusKey);
        jobMatch.jobMatchNote = jobMatch.jobMatchNote?.unescape();
        selectedStandards =
          response.standardJobs?.length > 0 ? response.standardJobs.map(job => ({ ...job, blendNote: job.blendNote ? job.blendNote : "" })) : [];
        selectedStandardJobCodes = selectedStandards?.map(standard => standard.standardJobCode);
        getSurveyPublishers(selectedStandardJobCodes);
        selectedStandardsCopy = structuredClone(selectedStandards);
        jobMatchCopy = structuredClone(jobMatch);
      },
      onError: () => {
        notificationWidget.show("Error while fetching selected standards", "error");
      },
    },
  );

  // check match assignment
  const mutationMatchAssigment = useMutation(
    async selectedJobs => {
      const data = await checkJobMatchAssignemnt(projectVersionId, selectedJobs);
      return data.data;
    },
    {
      onSuccess: response => {
        isJobMatchsSame = response.valid;
      },
      onError: () => {
        notificationWidget.show("Error while comparing selected job matchs", "error");
      },
    },
  );

  // load survey publishers
  const mutationSurveyPublishers = useMutation(
    async request => {
      await new Promise(resolve => setTimeout(resolve, 5000));
      const data = await getJobMatchPublishers(request);
      return data.data;
    },
    {
      onSuccess: response => {
        surveyPublishers = response;
      },
      onError: () => {
        notificationWidget.show("Error while fetching survey publishers", "error");
      },
    },
  );

  // load audit values
  const mutationAudit = useMutation(
    async request => {
      const data = await getJobMatchAuditCalculations(projectVersionId, request);
      return data.data;
    },
    {
      onSuccess: response => {
        auditValues = response;
      },
      onError: () => {
        notificationWidget.show("Error while fetching audit values", "error");
      },
    },
  );

  // save job match details
  const mutationSave = useMutation(
    async request => {
      const data = await saveJobMatchDetails(projectVersionId, request);
      return data.data;
    },
    {
      onSuccess: () => {
        notificationWidget.show("Job Match saved successfully.", "success");
        selectedStandardsCopy = structuredClone(selectedStandards);
        jobMatchCopy = structuredClone(jobMatch);
        canSave = false;
        isSaved = true;
        dispatch("dataUpdate", {
          isSaved,
          hasUnSavedChanged: false,
        });
        dispatch("close");
      },
      onError: () => {
        notificationWidget.show("Error while saving job match details", "error");
      },
    },
  );

  // fetch survey job details
  const mutationSuveryJobDetails = useMutation(
    async request => {
      const data = await getSurveyJobDetails(request);
      return data.data;
    },
    {
      onSuccess: response => {
        jobMatch.jobCode = response.map(s => s.surveyJobCode).join(" | ");
        jobMatch.jobTitle = response.map(s => s.surveyJobTitle).join(" | ");
        jobMatch.jobDescription = response.map(s => s.surveyJobDescription).join(" | ");
        if (jobMatch.jobTitle.includes(" | ")) {
          jobMatch.jobTitle = "BLEND " + jobMatch.jobTitle;
        }
        if (jobMatch.jobDescription.includes(" | ")) {
          jobMatch.jobDescription = "BLEND " + jobMatch.jobDescription;
        }
      },
      onError: () => {
        notificationWidget.show("Error while fetching survey job details", "error");
      },
    },
  );

  $: canSave = isStandardValid && isModified && isJobDetailValid;
  $: isJobDetailValid = jobMatch.jobCode?.length > 0 && jobMatch.jobTitle?.length > 0 && jobMatch.jobDescription?.length > 0;
  $: isModified =
    JSON.stringify(selectedStandards) !== JSON.stringify(selectedStandardsCopy) || JSON.stringify(jobMatch) !== JSON.stringify(jobMatchCopy);

  $: dispatch("dataUpdate", {
    isSaved,
    hasUnSavedChanges: isModified,
    message: "Are you sure you want to close this window? All the information in this session will be lost.",
  });

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    selectedJobMatchs?.forEach(job => {
      selectedJobs.push({
        aggregationMethodKey: job.aggregationMethodKey,
        fileOrgKey: job.fileOrgKey,
        positionCode: job.positionCode,
        jobCode: job.jobCode,
      });
    });

    jQuery("#cardBody").click(function (e) {
      if (!e.target.classList.contains("header") && e.target.id !== "searchStandardsInput") {
        searchStandardInput = "";
        searchStandards = [];
      }
    });

    // @ts-ignore
    $mutationMatchAssigment.mutate({ selectedJobs });
    // @ts-ignore
    $mutationMatchedStandarJobs.mutate(selectedJobs);
  });

  const saveJobMatch = async () => {
    if (!canSave) {
      notificationWidget.show("Please complete all the required fields", "error");
      return;
    }

    // @ts-ignore
    $mutationSave.mutate({
      marketPricingJobCode: jobMatch.jobCode,
      marketPricingJobTitle: jobMatch.jobTitle,
      marketPricingJobDescription: jobMatch.jobDescription,
      publisherName: jobMatch.publisherName,
      jobMatchNote: jobMatch.jobMatchNote,
      jobMatchStatusKey: jobMatch.jobMatchStatusKey,
      publisherKey: jobMatch.publisherKey,
      selectedJobs,
      standardJobs: selectedStandards,
    });
  };

  const onReset = () => {
    jQuery("#jobMatching-reset-dialog")?.remove();
    let divElement = document.createElement("span");
    divElement.id = "jobMatching-reset-dialog";
    document.body.appendChild(divElement);

    jQuery("#jobMatching-reset-dialog").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 500,
      content: "Are you sure you want to reset? Any changes will be lost and information will reset to the last save.",
      actions: [
        {
          text: "Yes",
          action: function () {
            selectedStandards = JSON.parse(JSON.stringify(selectedStandardsCopy));
            jobMatch = JSON.parse(JSON.stringify(jobMatchCopy));
            auditValues = {};
            return true;
          },
          primary: true,
        },
        { text: "No", primary: true },
      ],
    });

    var dialog = jQuery("#jobMatching-reset-dialog").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
    dialog.bind("close", () => {
      jQuery("#confirm-status-change")?.remove();
    });
  };

  const updateJobMatchDetails = standards => {
    if (standards?.length > 0) {
      jobMatch.PublisherKey = 0;
      jobMatch.jobCode = standards.map(standard => standard.standardJobCode).join(" | ");
      jobMatch.jobTitle = standards.map(standard => standard.standardJobTitle).join(" | ");
      jobMatch.jobDescription = standards
        .map(standard => standard.standardJobDescription)
        .filter(s => s.length)
        .join(" | ");

      if (jobMatch.jobTitle.includes(" | ")) {
        jobMatch.jobTitle = "BLEND " + jobMatch.jobTitle;
      }

      if (jobMatch.jobDescription.includes(" | ")) {
        jobMatch.jobDescription = "BLEND " + jobMatch.jobDescription;
      }
    }
  };

  const standardSelectionChange = event => {
    selectedStandardJobCodes = event?.detail.selectedStandardJobCodes || [];
    getSurveyPublishers(selectedStandardJobCodes);
    onPublisherChange();
  };

  const getSurveyPublishers = standardJobCodes => {
    if (standardJobCodes?.length === 0) {
      jobMatch.publisherKey = 0;
      jobMatch.jobCode = jobMatch.jobTitle = jobMatch.jobDescription = "";
      surveyPublishers = [];
      auditValues = {};
      return;
    }
    // @ts-ignore
    $mutationSurveyPublishers.mutate({ standardJobCodes });
    // @ts-ignore
    $mutationAudit.mutate({ clientJobCodes: selectedJobs.map(job => job.jobCode), standardJobCodes: standardJobCodes });
  };

  const onPublisherChange = () => {
    if (jobMatch.publisherKey > 0) {
      // @ts-ignore
      $mutationSuveryJobDetails.mutate({
        publisherKey: jobMatch.publisherKey,
        standardJobCodes: selectedStandardJobCodes,
      });
    } else {
      updateJobMatchDetails(selectedStandards);
    }
  };
</script>

<span id="notification" />

<div class="ml-2" style="width: 80vw">
  <div class="card-header card-header-sticky">
    <h5 class="my-1" data-cy="modelTitle">Job Match</h5>
  </div>
  <div class="card-body border-right m-2 " id="cardBody">
    <div class="d-flex flex-wrap">
      <div class="d-flex align-items-center col-lg-6 col-sm-12 col-md-12">
        <span class="client-code-label">Client Code / Job Title</span>
        <div class="d-flex align-items-center flex-wrap ml-4">
          {#each selectedJobMatchs as jobMatch}
            <span class="m-1 px-2 py-1 border rounded client-code-pills">{jobMatch.jobCode} - {jobMatch.jobTitle}</span>
          {/each}
        </div>
      </div>
      {#if !isJobMatchsSame}
        <div class="col-lg-6 col-sm-12 col-md-12">
          <div class="alert alert-warning d-flex flex-column mx-1 justify-content-between" role="alert">
            <div class="d-flex justify-content-between mb-1">
              <span>Warning!</span>
              <button type="button" class="btn-close" aria-label="Close" on:click={() => (isJobMatchsSame = true)} />
            </div>
            <span>
              The selected client job codes are not matched to the same standard job code(s) or do not have the same publisher chosen. Any new edits
              here will override previous job matches for each client job code
            </span>
          </div>
        </div>
      {/if}
    </div>

    <Standards
      isLoading={$mutationMatchedStandarJobs.isLoading}
      bind:selectedStandards
      bind:disabled={isProjectStatusFinal}
      bind:isValid={isStandardValid}
      bind:searchStandardInput
      bind:searchStandards
      on:standardSelectionChange={standardSelectionChange}
    />

    <Audit bind:auditValues bind:selectedStandards />

    <div class="row my-4">
      <div class="col-12">
        <div class="card border">
          <div class="card-header">
            <h6 class="my-1" data-cy="jobdescription-notes-status">Job Description, Notes & Status</h6>
          </div>
          <div class="card-body">
            <div class="col-8">
              <div class="form-group col-6">
                <label for="publisherName" class="col-form-label required" data-cy="selectFromPublisher"> Select From Publisher</label>
                <div class="col-11">
                  <select
                    class="form-select"
                    data-cy="publisherName"
                    bind:value={jobMatch.publisherKey}
                    on:change={() => onPublisherChange()}
                    disabled={isProjectStatusFinal}
                  >
                    <option value={0} selected>Standard</option>
                    {#each surveyPublishers as publisher}
                      <option value={publisher.publisherKey}>{publisher.publisherName}</option>
                    {/each}
                  </select>
                </div>
              </div>
              <div class="d-flex flex-wrap">
                <div class="form-group col-6">
                  <label for="jobCode" class="col-form-label required" data-cy="jobCodeLabel">Job Code</label>
                  <div class="col-11">
                    <input
                      type="text"
                      class="form-control required"
                      maxlength="100"
                      id="jobCode"
                      data-cy="jobCodeControl"
                      autocomplete="off"
                      placeholder="Job Code(Default)"
                      bind:value={jobMatch.jobCode}
                      disabled={isProjectStatusFinal}
                    />
                  </div>
                </div>
                <div class="form-group col-6">
                  <label for="jobTitle" class="col-form-label required" data-cy="jobTitleLabel">Job Title</label>
                  <div class="col-11">
                    <input
                      type="text"
                      class="form-control"
                      maxlength="100"
                      id="jobTitle"
                      data-cy="jobTitleControl"
                      autocomplete="off"
                      placeholder="Job Title(Default)"
                      bind:value={jobMatch.jobTitle}
                      disabled={isProjectStatusFinal}
                    />
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label for="jobDescription" class="col-form-label required" data-cy="jobDescriptionLabel">Job Description</label>
                <div class="col-12">
                  <textarea
                    class="form-control"
                    id="jobDescription"
                    data-cy="jobDescriptionControl"
                    rows="3"
                    placeholder="Job Description(Default)"
                    bind:value={jobMatch.jobDescription}
                    disabled={isProjectStatusFinal}
                  />
                </div>
              </div>
              <div class="d-flex flex-wrap">
                <div class="form-group col-6">
                  <label for="jobMatchStatus" class="col-form-label required" data-cy="jobMatchStatusLabel">Status</label>
                  <div class="col-11">
                    <select
                      class="form-select"
                      data-cy="jobMatchStatusControl"
                      id="jobMatchStatusKey"
                      bind:value={jobMatch.jobMatchStatusKey}
                      disabled={isProjectStatusFinal}
                    >
                      <option value={JobMatchStatus.AnalystReviewed} selected>Analyst Reviewed</option>
                      <option value={JobMatchStatus.PeerReviewed}>Peer Reviewed</option>
                      <option value={JobMatchStatus.Complete}>Complete</option>
                    </select>
                  </div>
                </div>
                <div class="form-group col-6">
                  <label for="jobMatchNotes" class="col-form-label" data-cy="jobMatchNotesLabel">Job Match Notes</label>
                  <div class="col-11">
                    <textarea
                      class="form-control"
                      id="jobMatchNotes"
                      rows="2"
                      data-cy="jobMatchNotesControl"
                      placeholder="Job Match Notes(Default)"
                      bind:value={jobMatch.jobMatchNote}
                      disabled={isProjectStatusFinal}
                      maxlength="200"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  {#if !isProjectStatusFinal}
    <div class="card-footer d-flex justify-content-between">
      <div>
        <button class="btn btn-outline-secondary" data-cy="resetBtn" on:click={onReset} disabled={!isModified}>Reset</button>
        <button class="btn btn-primary" data-cy="saveBtn" disabled={!canSave} on:click={saveJobMatch}>Save and Close</button>
      </div>
      <div />
    </div>
  {/if}
</div>

<style>
  .client-code-label {
    white-space: nowrap;
    margin-right: 10px;
    margin-left: 5px;
  }

  .client-code-pills {
    background-color: #eeeeee;
    white-space: nowrap;
  }

  .col-form-label {
    padding: 0px !important;
    font-weight: 500;
  }

  .form-group {
    margin: 10px 0px !important;
  }

  .card-header-sticky {
    position: sticky;
    top: 0;
    background-color: lightgray;
    z-index: 1055;
    color: black;
    font-weight: 600;
  }

  .card-header {
    background-color: #d6d6d7 !important;
  }

  .btn-close {
    font-size: 12px;
  }
</style>
