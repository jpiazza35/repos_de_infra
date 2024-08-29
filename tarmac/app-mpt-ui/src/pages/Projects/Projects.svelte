<script>
  import { onMount } from "svelte";
  import { useQuery } from "@sveltestack/svelte-query";
  import CryptoJS from "crypto-js";
  import { getProjectVersionList, getProjectListForOrganization } from "api/apiCalls";
  import Tabs from "components/controls/tabs.svelte";
  import Project from "pages/Projects/Tabs/ProjectTab/ProjectMain.svelte";
  import MarketSegment from "pages/Projects/Tabs/MarketSegmentTab/MarketSegmentMain.svelte";
  import MarketSegmentMapping from "pages/Projects/Tabs/MarketSegmentMappingTab/MarketSegmentMappingMain.svelte";
  import JobMatching from "pages/Projects/Tabs/JobMatchingTab/JobMatchingMain.svelte";
  import MarketSummaryMain from "pages/Projects/Tabs/MarketSummaryTab/MarketSummaryMain.svelte";
  import MarketPricingSheet from "pages/Projects/Tabs/MarketPricingSheet/MarketPricingSheetMain.svelte";
  import Organization from "components/shared/organization.svelte";
  import UnsavedWarning from "components/shared/unsavedWarning.svelte";
  import { projectVersionStore } from "../../store/project";
  import MarketAssessmentMain from "./Tabs/MarketAssessmentTab/MarketAssessmentMain.svelte";

  const ENCRYPTION_KEY = "MPT";
  const PERMISSION_TYPE_NONE = "NONE";

  let inputOrgId = 0;
  let inputProjectId = 0;
  let inputProjectVersionId = 0;
  let projectsList = [];
  let projectVersionList = [];
  let disableClearButton = false;
  let isOrgDisabled = false;
  let inputOrgValue = "";

  let items = [
    {
      label: "Project",
      datacy: "project",
      value: 1,
      component: Project,
      code: "PRJLSTDET",
    },
    {
      label: "Market Segment",
      datacy: "marketSegment",
      value: 2,
      component: MarketSegment,
      code: "MARSEG",
    },
    {
      label: "Market Segment Mapping",
      datacy: "marketSegmentMapping",
      value: 3,
      component: MarketSegmentMapping,
      code: "MARSEGMAP",
    },
    {
      label: "Job Matching",
      datacy: "jobMatching",
      value: 4,
      component: JobMatching,
      code: "JOBMAT",
    },
    {
      label: "Market Pricing Sheet",
      datacy: "marketpricingsheet",
      value: 5,
      component: MarketPricingSheet,
      code: "MPSHEET",
    },
    {
      label: "Market Summary Tables",
      datacy: "marketSummary",
      value: 6,
      component: MarketSummaryMain,
      code: "JOBSUM",
    },
    {
      label: "Market Assessment",
      datacy: "marketAssessment",
      value: 7,
      component: MarketAssessmentMain,
      code: "ASSESSMENT",
    },
  ];

  // load projects from selected org
  const queryProjectList = useQuery(
    ["projectListForOgn", inputOrgId],
    async () => {
      const data = await getProjectListForOrganization(inputOrgId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryProjectList.data) {
    projectsList = $queryProjectList.data;
  }

  // load project versions from selected project
  const queryProjectVersionList = useQuery(
    ["projectVersionList", inputProjectId],
    async () => {
      const data = await getProjectVersionList(inputProjectId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryProjectVersionList.data) {
    projectVersionList = $queryProjectVersionList.data;
  }

  const projectIdChange = event => {
    inputProjectId = parseInt(event.target.value);
    projectVersionList = [];
    inputProjectVersionId = 0;
    let projName = $queryProjectList.data.find(d => d.id === inputProjectId).name || "";

    if (inputProjectId) {
      projectVersionStore.update(store => ({
        ...store,
        projectName: projName,
      }));
      $queryProjectVersionList.refetch();
    }
    window.sessionStorage.setItem("projectID", inputProjectId.toString());
  };

  const selectOrganization = (orgName, orgId) => {
    inputOrgId = orgId;
    inputOrgValue = orgName;
    onOrgSelected({ detail: { id: orgId, name: inputOrgValue } });
  };

  const resetProjectFilter = () => {
    inputProjectId = 0;
    inputProjectVersionId = 0;
  };

  export const reloadFilters = event => {
    const { orgName, orgId, resetProjectFilters } = event.detail && event.detail;
    if (resetProjectFilters) {
      resetProjectFilter();
      selectOrganization(orgName, orgId);
    }
  };

  /**
   * if the new org id is different thant the current one, reset the project and project version
   * the filter selection will be maintained when a new project is saved and popup is closed
   */
  const onOrgSelected = event => {
    const { id, name } = event?.detail || {};
    const newInputOrgId = id || 0;

    projectVersionStore.update(store => ({
      ...store,
      organizationName: name || "",
      organizationID: newInputOrgId,
    }));

    if (newInputOrgId === 0 || inputOrgId != newInputOrgId) {
      inputProjectId = 0;
      inputProjectVersionId = 0;
      projectsList = [];
      projectVersionList = [];
    }

    inputOrgId = newInputOrgId;
    if (inputOrgId) {
      $queryProjectList.refetch();
    }
    window.sessionStorage.setItem("projectOrgId", inputOrgId.toString());
  };

  const updateProjectVersion = () => {
    projectVersionStore.update(store => {
      const updatedItem = projectVersionList.find(item => item.id === inputProjectVersionId);
      const updatedStore = { ...store, ...updatedItem };
      return updatedStore;
    });
    window.sessionStorage.setItem("projectVersionId", inputProjectVersionId.toString());
  };

  const onClearClick = () => {
    disableClearButton = true;
    inputProjectId = 0;
    inputProjectVersionId = 0;
    projectVersionList = [];

    const orgValueInput = document.querySelector(".add-project-modal-input-organization");

    if (!isOrgDisabled && orgValueInput) {
      const orgList = orgValueInput.parentNode ? orgValueInput.parentNode.lastChild : null;
      // @ts-ignore
      if (orgList && orgList.style) orgList.style.display = "none";
    }

    disableClearButton = false;
  };

  onMount(() => {
    // Decrypt user roles data
    const encrypted = localStorage.getItem("userRoles");
    const bytes = CryptoJS.AES.decrypt(encrypted, ENCRYPTION_KEY);
    const userRoles = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));
    const permissions = userRoles.map(item => ({
      permissionType: item.split("_")[0],
      tabCode: item.split("_")[1],
    }));

    items = items.filter(item => permissions.some(p => p.tabCode === item.code && p.permissionType !== PERMISSION_TYPE_NONE));
  });
</script>

<div class="page-content fade-in-up">
  <div class="row">
    <div class="col-md-12">
      <div class="ibox">
        <div class="ibox-head">
          <div class="ibox-title">Projects</div>
        </div>
        <div class="ibox-body">
          <div class="row">
            <div class="col-lg-3 col-md-6 col-sm-12">
              <Organization
                customClassName={"add-project-modal-input-organization"}
                bind:inputValue={inputOrgValue}
                on:orgSelected={onOrgSelected}
                bind:disabled={isOrgDisabled}
              />
            </div>

            <div class="col-lg-3 col-md-6 col-sm-12">
              <div class="form-group">
                <label class="col-form-label float-left textAlign" data-cy="orgLabel" for="ptProjectID">Project (Name or ID)</label>
                <UnsavedWarning>
                  <select class="form-control" data-cy="projectId" id="ptProjectID" bind:value={inputProjectId} on:change={projectIdChange}>
                    <option selected value={0}>Select a Project</option>
                    {#each projectsList as project}
                      <option value={project.id}> {project.name} - {project.id}</option>
                    {/each}
                  </select>
                </UnsavedWarning>
              </div>
            </div>
            <div class="col-lg-3 col-md-6 col-sm-12">
              <div class="form-group">
                <label class="col-form-label float-left textAlign" data-cy="projVerLabel" for="pjProductVersion">Project Version (Label or ID)</label>
                <UnsavedWarning>
                  <select
                    class="form-control"
                    data-cy="projectVersion"
                    id="pjProductVersion"
                    bind:value={inputProjectVersionId}
                    on:change={updateProjectVersion}
                  >
                    <option selected value={0}>Select a Project Version</option>
                    {#each projectVersionList as projectVersion}
                      <option value={projectVersion.id}>
                        {projectVersion.versionLabel} - {projectVersion.id}
                      </option>
                    {/each}
                  </select>
                </UnsavedWarning>
              </div>
            </div>
            <div class="col-lg-1 col-md-6 col-sm-12">
              <div class="form-group" style="margin-top: 33px;">
                <button class="btn btn-primary s-uMLV6TsjDlau" data-cy="clear" on:click={onClearClick} disabled={disableClearButton}
                  ><UnsavedWarning>Clear</UnsavedWarning></button
                >
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<Tabs {items} bind:inputOrgId bind:inputProjectId bind:inputProjectVersionId on:reloadFilters={reloadFilters} />

<style>
  .textAlign {
    text-align: right;
  }

  .ibox .ibox-body {
    padding: 5px 20px 20px 20px;
  }
</style>
