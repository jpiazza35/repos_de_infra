<script>
  import { afterUpdate, createEventDispatcher, onMount, onDestroy } from "svelte";
  import Modal from "components/shared/modal.svelte";
  import { getTokenToApi } from "../../../../auth/authHelper";
  import { projConfig, renderProjectColumns } from "./KendoGridOptions";
  import SaveProjectModal from "./modal/saveProjectModal.svelte";
  import DeleteProjectModal from "./modal/deleteProjectModal.svelte";
  import { promiseWrap } from "utils/functions";
  import { ProjectStatusOptionsArray } from "utils/constants";
  import { getSourceGroups, saveProjectDetails, getProjectDetails } from "api/apiCalls";
  import ProjectDetails from "./ProjectDetails/ProjectDetails.svelte";
  import { tabFullScreen } from "store/tabs";
  import { headerCustomStyles } from "components/shared/functions";

  export let inputFilterOrgId;
  export let inputFilterProjectId;
  export let inputFilterProjectVersionId;

  const dispatch = createEventDispatcher();
  const NOT_TABLE_HEIGHT = 200;

  $: {
    filterOrgId = inputFilterOrgId;
    filterProjectId = inputFilterProjectId;
    filterprojectVersionId = inputFilterProjectVersionId;
    refreshGrid();
  }

  let jsonData = null,
    notificationWidget,
    filterOrgId = 0,
    filterprojectVersionId = 0,
    filterProjectId = 0,
    token,
    surveySourceGroupDataProps,
    saveProjectProps,
    deleteProps,
    showSaveAsModal = false,
    showDeleteModal = false,
    container = null,
    showNoProjectsMessage = false;

  let searchUrl = "projects/search";

  let urlPrefix = import.meta.env.VITE_API_URL_PREFIX;
  let baseURL = import.meta.env.VITE_API_URL;

  if (urlPrefix.length > 0) {
    searchUrl = urlPrefix + searchUrl;
  }

  //if base url changed in Cloud front
  if (baseURL && baseURL.trim().length > 0) {
    searchUrl = baseURL + "/" + searchUrl;
    searchUrl = searchUrl.replace("projects/", "mpt-project/");
  }

  const dataSource = new kendo.data.DataSource({
    transport: {
      read: {
        url: searchUrl,
        type: "POST",
        beforeSend: function (req) {
          req.setRequestHeader("Authorization", `Bearer ${token}`);
        },
        dataType: "json",
        data: jsonData,
        processData: false,
        contentType: "application/json",
      },
      parameterMap: function (options, operation) {
        if (operation === "read") {
          if (options && options != null) {
            options.orgId = filterOrgId;
            options.projectId = filterProjectId;
            options.projectVersionId = filterprojectVersionId;
            jsonData = kendo.stringify(options);
            return jsonData;
          }
        }
      },
    },
    requestEnd: function (e) {
      if (e.type === "read") {
        if (e.response && e.response != null) {
          if (e.response.total === 0) {
            jQuery("#grid").data("kendoGrid")?.pager.element.hide();
            showNoProjectsMessage = true;
          } else {
            jQuery("#grid").data("kendoGrid")?.pager.element.show();
            showNoProjectsMessage = false;
          }
        }
      }
    },
    serverSorting: true,
    serverPaging: true,
    batch: true,
    pageSize: 15,
    page: 1,
    schema: {
      total: "total",
      data: function (response) {
        return response.searchProjects;
      },
      model: {
        id: "id",
        fields: {
          id: { editable: false, nullable: true },
          name: { validation: { required: true } },
          organization: {
            type: "string",
          },
          projectVersion: { type: "number" },
          projectVersionDate: {
            type: "string",
          },
          versionLabel: { type: "string" },
          sourceData: { type: "string" },
          status: { type: "string" },
          dataEffectiveDate: { type: "string" },
          workForceProjectType: { type: "number" },
        },
      },
    },
    sort: { field: "projectVersion", dir: "desc" },
  });

  afterUpdate(async () => {
    token = await getTokenToApi();
    if (token && jQuery(container)?.data()?.length) configureGrid();
  });

  onMount(async () => {
    token = await getTokenToApi();
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");

    const [sourceGroupsResponse, sourceGroupsError] = await promiseWrap(getSourceGroups());
    if (sourceGroupsResponse) {
      surveySourceGroupDataProps = sourceGroupsResponse;
    }
    if (sourceGroupsError) {
      notificationWidget.show("Error getting source groups", "error");
    }

    if (container != null && token && surveySourceGroupDataProps) {
      if (inputFilterOrgId) {
        dataSource.sort({ field: "projectVersion", dir: "desc" });
        dataSource.page(1);
      }

      configureGrid();
    }
  });

  const configureGrid = () => {
    jQuery(container).kendoGrid({
      ...projConfig,
      excelExport: exportProjectGrid,
      columns: [
        {
          field: "Action",
          headerAttributes: {
            style: headerCustomStyles,
            "data-cy": "Action",
          },
          title: "Action",
          command: [
            {
              text: "Details",
              className: "action-project-table",
              click: e => handleUpdateProject(e),
            },
            {
              text: "Save As",
              className: "action-project-table",
              click: e => handleOpenSaveProjectModal(e),
            },
            {
              text: "Delete",
              className: "action-project-table",
              click: e => handleOpenDeleteModal(e),
            },
          ],
          width: 180,
          exportable: false,
        },
        ...renderProjectColumns(surveySourceGroupDataProps),
      ],
      excel: {
        allPages: true,
      },
      dataSource: dataSource,
      dataBound() {
        const hyperLinkCss = "background: none; border: none; color: #3498db; text-decoration: underline; cursor: pointer;";
        const simpleTextCss = "background: none; border: none;";
        const hideElementCss = "display: none";
        this.tbody.find("tr").each((index, row) => {
          const dataItem = this.dataItem(row);
          const jQueryRow = jQuery(row);
          const commandButtons = jQueryRow.find(".action-project-table");
          const sourceDataCommand = jQueryRow.find(".k-grid-sourceData");
          const fileStatusCommand = jQueryRow.find(".k-grid-fileStatusName");
          commandButtons.each((_, element) => {
            if (element.textContent === "Delete" && dataItem.status === "Final") {
              element.disabled = true;
            }
            element.style = hyperLinkCss;
          });
          if (dataItem) {
            sourceDataCommand[0].style = dataItem.fileLogKey ? hyperLinkCss : simpleTextCss;
            fileStatusCommand[0].style = dataItem.fileLogKey ? hyperLinkCss : simpleTextCss;

            sourceDataCommand[0].textContent = dataItem.sourceData;
            fileStatusCommand[0].textContent = dataItem.fileStatusName;
          } else {
            sourceDataCommand[0].style = hideElementCss;
            fileStatusCommand[0].style = hideElementCss;
          }
        });
      },
    });

    jQuery(".k-grid-header span.k-icon").css({ color: "#fff" });
    jQuery(".k-grid-content").css({ "max-height": document.documentElement.clientHeight - NOT_TABLE_HEIGHT });
  };

  function exportProjectGrid(e) {
    e.workbook.fileName = "ProjectExport.xlsx";
    let sheet = e.workbook.sheets[0];
    let templateVersionDate = kendo.template(this.columns.find(x => x.field == "projectVersionDate").template);
    let templateDataEffectiveDate = kendo.template(this.columns.find(x => x.field == "dataEffectiveDate").template);
    let templateWorkforceProjectType = kendo.template(this.columns.find(x => x.field == "workForceProjectType").template);

    let organizationColumn = this.columns.findIndex(column => column.field === "organization") - 1;
    let versionDateColumn = this.columns.findIndex(column => column.field === "projectVersionDate") - 1;
    let dataEffectiveDateColumn = this.columns.findIndex(column => column.field === "dataEffectiveDate") - 1;
    let workForceProjectTypeColumn = this.columns.findIndex(column => column.field === "workForceProjectType") - 1;

    for (let i = 1; i < sheet.rows.length; i++) {
      let row = sheet.rows[i];

      let dataItemVersionDate = {
        projectVersionDate: row.cells[versionDateColumn].value,
      };

      let dataItemDataEffectiveDate = {
        dataEffectiveDate: row.cells[dataEffectiveDateColumn].value,
      };

      let dataItemWorkforceProjectType = {
        workForceProjectType: row.cells[workForceProjectTypeColumn].value,
      };

      row.cells[organizationColumn].value = `${row.cells[organizationColumn].value} - ${inputFilterOrgId}`;
      row.cells[versionDateColumn].value = templateVersionDate(dataItemVersionDate);
      row.cells[dataEffectiveDateColumn].value = templateDataEffectiveDate(dataItemDataEffectiveDate);
      row.cells[workForceProjectTypeColumn].value = templateWorkforceProjectType(dataItemWorkforceProjectType);
    }
  }

  const handleSaveAsProject = async projectInfo => {
    if (!projectInfo) return;
    const payload = {
      ...projectInfo,
      versionLabel: projectInfo.versionLabel?.toString(),
      projectStatus: ProjectStatusOptionsArray.find(i => i.id === projectInfo.projectStatus)?.id,
      sourceDataInfo: {
        ...{
          sourceData: projectInfo.sourceData?.toString(),
          sourceDataType: projectInfo.sourceDataType,
          fileLogKey: projectInfo.fileLogKey,
        },
      },
      workforceProjectType: surveySourceGroupDataProps.find(s => s.id === projectInfo.workforceProjectType)?.id,
      versionDate: new Date(projectInfo.versionDate),
    };

    try {
      const [projectDetailsResponse, projectDetailsError] = await promiseWrap(saveProjectDetails(payload));
      if (projectDetailsResponse) {
        notificationWidget.show("Data has been saved successfully", "success");
        const data = {
          detail: {
            isProjectSaved: true,
            orgId: projectDetailsResponse.organizationID,
            orgName: projectDetailsResponse.organizationName,
          },
        };

        onModalClose(data);
      }
      if (projectDetailsError) {
        notificationWidget.show("Error in saving the project", "error");
      }
    } catch (error) {
      notificationWidget.show("Error in saving the project", "error");
    }
    handleShowSaveAsModal();
  };

  const handleShowSaveAsModal = () => {
    showSaveAsModal = !showSaveAsModal;
  };

  const handleShowDeleteModal = (isProjectDeleted = false) => {
    showDeleteModal = !showDeleteModal;
    isProjectDeleted && refreshGrid();
  };

  const handleUpdateProject = e => {
    const grid = jQuery("#grid").data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));
    if (dataItem) {
      const { id, projectVersion } = dataItem;
      projectId = id;
      projectVersionId = projectVersion;
      showProjectDetailsModal = true;
    }
  };

  const handleOpenSaveProjectModal = async e => {
    const grid = jQuery("#grid").data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));

    if (dataItem) {
      const {
        id,
        organization,
        organizationId,
        projectVersion,
        projectVersionDate,
        status,
        name,
        sourceData,
        fileKey,
        dataEffectiveDate,
        fileLogKey,
        projectVersionLabel,
        workForceProjectType,
        aggregationMethodologyKey,
        aggregationMethodologyName,
      } = dataItem;

      const [projectDetails] = await promiseWrap(getProjectDetails(dataItem.id, dataItem.projectVersion));

      saveProjectProps = {
        id,
        organization,
        organizationId,
        projectVersion,
        projectVersionDate,
        status,
        dataEffectiveDate,
        fileLogKey,
        fileKey,
        name,
        projectVersionLabel,
        workForceProjectType: workForceProjectType,
        sourceData,
        aggregationMethodologyKey,
        aggregationMethodologyName,
        surveySourceGroupDataProps,
        benchmarkDataTypes: projectDetails?.benchmarkDataTypes,
        handleShowSaveAsModal,
        handleSaveAsProject,
      };
    }
    handleShowSaveAsModal();
  };

  const handleOpenDeleteModal = e => {
    const grid = jQuery("#grid").data("kendoGrid");
    const dataItem = grid.dataItem(e.target.closest("tr"));
    if (dataItem) {
      const { id, projectVersion } = dataItem;
      deleteProps = {
        projectId: id,
        projectVersionId: projectVersion,
        handleShowDeleteModal: isProjectDeleted => handleShowDeleteModal(isProjectDeleted),
      };
      handleShowDeleteModal();
    }
  };

  let showProjectDetailsModal = false;
  let projectId = -1;
  let projectVersionId = -1;

  $: props = {
    projectId: projectId,
    projectVersionId: projectVersionId,
    surveySourceGroups: surveySourceGroupDataProps,
  };

  const handleAddButtonClick = () => {
    projectId = -1;
    showProjectDetailsModal = true;
  };

  const onModalClose = event => {
    showProjectDetailsModal = false;
    projectId = -1;
    if (event && event.detail.isProjectSaved) {
      dispatch("reloadFilters", { orgId: event.detail.orgId, orgName: event.detail.orgName, resetProjectFilters: event.detail.isProjectCreate });
      if (inputFilterOrgId > 0) refreshGrid();
    }
  };

  const exportFile = () => {
    const grid = jQuery("#grid").data("kendoGrid");
    grid.saveAsExcel();
  };

  const refreshGrid = () => {
    let grid = jQuery("#grid").data("kendoGrid");
    grid?.dataSource.sort({ field: "projectVersion", dir: "desc" });
    grid?.dataSource.page(1);
    grid?.dataSource.read();
  };

  let fullScreenName = "Full Screen";
  const unsubscribeToTabFullScreen = tabFullScreen.subscribe(value => {
    fullScreenName = value ? "Exit Full Screen" : "Full Screen";
    window.location.hash = value ? "fullScreen" : "";
  });

  const toggleFullScreen = () => {
    tabFullScreen.update(() => !$tabFullScreen);
  };

  window.onhashchange = function () {
    if ($tabFullScreen && window.location.hash != "#fullScreen") {
      toggleFullScreen();
    }
  };

  window.onresize = function (e) {
    jQuery(".k-grid-content").css({ "max-height": e.target.outerHeight - NOT_TABLE_HEIGHT });
    const grid = jQuery("#grid").data("kendoGrid");
    if (grid) {
      grid.resize();
    }
  };

  onDestroy(() => {
    unsubscribeToTabFullScreen();
  });
</script>

<span id="notification" />
<div class="d-flex flex-wrap mb-2">
  <button type="button" class="btn btn-primary" data-cy="addProject" on:click={handleAddButtonClick}>Add Project</button>

  <div class="dropdown dropdown-div mx-1">
    <button class="btn btn-primary dropdown-toggle" data-cy="downloadTemplate" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
      Download Template
    </button>

    <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
      <li>
        <a class="dropdown-item" href="./assets/csvtemplates/mpt_incumbent_template.csv" data-cy="downloadIncumbentTemplate">Incumbent</a>
      </li>
      <li>
        <a class="dropdown-item" href="./assets/csvtemplates/mpt_job_template.csv" data-cy="downloadJobTemplate">Job</a>
      </li>
    </ul>
  </div>

  <button class="btn btn-primary" data-cy="export" on:click={exportFile} disabled={!inputFilterOrgId}>
    <i class="bi bi-file-earmark-excel" /> Export
  </button>

  <button class="btn btn-primary" style="margin-left: auto;" data-cy="fullscreenProjectMain" on:click={toggleFullScreen}>
    <i class="fa fa-arrows-alt" />
    {fullScreenName}
  </button>
</div>

{#if !inputFilterOrgId}
  <div class="alert alert-primary" role="alert">
    To visualize Projects, please select
    <span class="alert-link">Organization</span>
  </div>
{/if}

<div class:d-none={!inputFilterOrgId}>
  <div id="grid" bind:this={container} />
</div>

{#if inputFilterOrgId && showNoProjectsMessage}
  <div class="mt-2 alert alert-warning" role="alert">No projects exist for this organization</div>
{/if}

{#if showProjectDetailsModal}
  <Modal show={ProjectDetails} {props} on:closed={onModalClose} />
{/if}

{#if showSaveAsModal}
  <Modal show={SaveProjectModal} props={saveProjectProps} />
{/if}

{#if showDeleteModal}
  <Modal show={DeleteProjectModal} props={deleteProps} styleWindow={{ width: "50%" }} />
{/if}

<style>
  .dropdown-div {
    display: inline-block;
  }

  .dropdown-toggle::after {
    display: inline-block;
    margin-left: 0.255em;
    vertical-align: 0.255em;
    content: "";
    border-top: 0.3em solid;
    border-right: 0.3em solid transparent;
    border-bottom: 0;
    border-left: 0.3em solid transparent;
  }
</style>
