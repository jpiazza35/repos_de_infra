<script>
  // @ts-nocheck
  import { onMount, onDestroy } from "svelte";
  import { promiseWrap, getKeysWithEmptyStringOrNull } from "utils/functions";
  import { useMutation, useQuery } from "@sveltestack/svelte-query";
  import { headerCustomStyles } from "components/shared/functions";
  import UnsavedWarning from "components/shared/unsavedWarning.svelte";
  import { gridConfig, columnsStore, JobMatchStatus } from "./JobMatchingGridConfig";
  import Modal from "components/shared/modal.svelte";
  import JobMatchModal from "./JobMatchModal.svelte";
  import BulkEdit from "./BulkEdit.svelte";
  import { getJobMatchings, getProjectStatus, updateJobMatchStatus, noBenchmarkMatch } from "api/apiCalls";
  import { ProjectStatus } from "models/project/projectDetails";
  import { projectVersionStore } from "store/project";
  import { tabFullScreen } from "store/tabs";
  import { getAggregationMethodologyName } from "utils/project";
  import PopoverColumns from "./PopoverColumns.svelte";
  import { featureFlagStore } from "store/launchdarkly";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;

  let container;
  let updateColumns = false;
  let notificationWidget = null;
  let jobMatchings = [];
  let jobMatchingsGridLength = 0;
  let fullScreenName = "Full Screen";
  let aggregationMethodologyKey = 1;
  let isProjectStatusFinal = null;
  let jobMatchModalComponant = null;
  let jobMatchModalData = null;
  let selectedStatusType = null;
  let isBulkEdit = false;
  let bulkEditRef;
  let gridFilters = {};
  const NOT_TABLE_HEIGHT = 200;

  $: filterChange = false;
  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;
  $: inputFilterProjectVersionId && refetchJobMatchings(true) && getProjectStatusOnChange();
  $: (inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId) && clearFilters();
  $: if (filterChange) {
    updateGridHeight();
  }

  // query to load job matchings
  const queryJobMatchings = useQuery(
    ["jobMarchings", inputFilterProjectVersionId],
    async () => {
      const data = await getJobMatchings(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryJobMatchings.data && jQuery(container).data("kendoGrid")) {
    if (updateColumns) updateBenchmarkDataTypeColumns($queryJobMatchings.data);
    setGridData($queryJobMatchings.data);
  }

  $: if ($queryJobMatchings.error) {
    notificationWidget.show("Error while fetching job matching data", "error");
  }

  const refetchJobMatchings = updateTableColumns => {
    updateColumns = updateTableColumns;
    $queryJobMatchings.refetch();
  };

  const updateGridHeight = () => {
    jobMatchingsGridLength = jQuery(container).data("kendoGrid").dataSource.view().length;
    filterChange = false;
    let rowHeight = jobMatchingsGridLength * 60; // Assuming a row height of 60 pixels
    jQuery(".k-grid-content").css({ height: rowHeight + "px", "min-height": "75px" });
    jQuery(".k-grid-content-locked").css({ height: rowHeight + "px", "min-height": "75px" });
  };

  // mutation to update job match status
  const mutationUpdateJobMatchStatus = useMutation(
    async data => {
      const response = await updateJobMatchStatus(inputFilterProjectVersionId, data.statusType, data.selectedJobs);
      return response.data;
    },
    {
      onSuccess: () => {
        const selectedJobMatches = getSelectedJobMatches();
        const selectedJobCodes = selectedJobMatches.map(jobMatch => jobMatch.jobCode);
        jobMatchings.forEach(jobMatch => {
          if (selectedJobCodes.includes(jobMatch.jobCode)) {
            jobMatch.jobMatchStatusName = JobMatchStatus[selectedStatusType];
          }
        });
        jQuery(container).data("kendoGrid").dataSource?.data(jobMatchings);
        notificationWidget.show("Status updated successfully", "success");
      },
      onError: () => {
        notificationWidget.show("Error while updating job match status", "error");
      },
    },
  );

  const mutationSetToNoBenchmark = useMutation(
    async data => {
      const response = await noBenchmarkMatch(inputFilterProjectVersionId, data);
      return response.data;
    },
    {
      onSuccess: () => {
        refetchJobMatchings(true);
      },
      onError: () => {
        notificationWidget.show("Error while updating", "error");
      },
    },
  );

  const clearFilters = () => {
    if (container) {
      jQuery(container).data("kendoGrid").dataSource.filter({});
    }
  };

  onMount(() => {
    projectVersionStore?.subscribe(store => {
      if (store) {
        aggregationMethodologyKey = store.aggregationMethodologyKey;
      }
    });

    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    registerKendoGrid();
  });

  const getProjectStatusOnChange = async () => {
    if (!inputFilterProjectId) return false;

    const [projectResponseStatus, projectStatusError] = await promiseWrap(getProjectStatus(inputFilterProjectId));
    if (projectStatusError) {
      notificationWidget.show("Error while getting project status", "error");
      return false;
    }

    isProjectStatusFinal = projectResponseStatus === ProjectStatus.FINAL;
  };

  const updateBenchmarkDataTypeColumns = jobMatchingData => {
    const grid = jQuery(container).data("kendoGrid");
    let props = [];
    jobMatchingData.forEach(jobMatching => {
      props = props.concat(Object.keys(jobMatching.formattedBenchmarkDataTypes));
    });

    props = [...new Set(props)];
    let filteredProps = props.filter(prop => jobMatchingData.some(d => d.formattedBenchmarkDataTypes[prop]));

    filteredProps.forEach(prop => {
      jobMatchingData.forEach(jobMatching => {
        if (jobMatching.formattedBenchmarkDataTypes[prop]) {
          jobMatching[prop] = jobMatching.formattedBenchmarkDataTypes[prop];
        }
      });

      if (!gridConfig.columns.some(column => column.field === prop)) {
        gridConfig.columns.push({
          field: prop,
          title: prop,
          width: 200,
          visible: true,
          hidden: false,
          headerAttributes: { "data-cy": prop, style: headerCustomStyles },
        });

        columnsStore.update(columns => {
          if (!columns.some(column => column.field === prop)) {
            return [...columns, { field: prop, title: prop, show: true }];
          }
          return columns;
        });
      }
    });

    grid.setOptions(gridConfig);
    displayColumnsInGrid($columnsStore, grid);
  };

  const setGridData = jobMatchingData => {
    jobMatchings = jobMatchingData || [];
    jobMatchingsGridLength = jobMatchings.length;

    var grid = jQuery(container).data("kendoGrid");
    if (grid) {
      grid.dataSource.filter(gridFilters);
      grid.dataSource.data([...jobMatchings]);
      filterChange = false;

      let columnsWithoutData = getKeysWithEmptyStringOrNull(jobMatchings);
      columnsWithoutData = columnsWithoutData.filter(col => col !== "jobMatchStatusName");
      columnsStore.update(store => {
        // iterate over columnsWithoutData and find the column in store and set visible to false
        columnsWithoutData.forEach(columnNoData => {
          const column = store.find(c => c.field === columnNoData);
          if (column) {
            column.visible = false;
          }
        });

        return store;
      });
      columnsWithoutData.forEach(column => {
        jQuery(container).data("kendoGrid").hideColumn(column);
      });
    }
  };

  const registerKendoGrid = () => {
    gridConfig.excelExport = e => (e.workbook.fileName = `JobMatchingExport_ProjectID_${inputFilterProjectId}.xlsx`);
    gridConfig.filter = () => (filterChange = true);
    jQuery(container).kendoGrid(gridConfig);
    jQuery(".k-grid-content").css({ "min-height": "100px", "max-height": document.documentElement.clientHeight - NOT_TABLE_HEIGHT });
  };

  const exportGrid = () => {
    const grid = jQuery(container).data("kendoGrid");
    grid.saveAsExcel();
  };

  const unsubscribeToTabFullScreen = tabFullScreen.subscribe(value => {
    fullScreenName = value ? "Exit Full Screen" : "Full Screen";
  });

  const toggleFullScreenMode = () => {
    tabFullScreen.update(() => !$tabFullScreen);
    if (jQuery(container).data("kendoGrid")) jQuery(container).data("kendoGrid").resize();
  };

  const openJobMatchModal = () => {
    let selectedJobMatchs = getSelectedJobMatches();
    if (selectedJobMatchs && selectedJobMatchs?.length == 0) {
      notificationWidget.show("Please select at least one job match", "error");
      return;
    }

    if (selectedJobMatchs?.length) {
      jobMatchModalData = {
        selectedJobMatchs,
        isProjectStatusFinal,
        projectVersionId: inputFilterProjectVersionId,
      };
      jobMatchModalComponant = JobMatchModal;
    }
  };

  const onJobMatchModalClosed = event => {
    jobMatchModalComponant = null;
    jobMatchModalData = null;

    if (event?.detail?.isSaved) {
      gridFilters = jQuery(container).data("kendoGrid").dataSource.filter();
      refetchJobMatchings(true);
    }
  };

  const updateTheStatus = statusType => {
    selectedStatusType = statusType;
    let selectedJobMatches = getSelectedJobMatches();
    if (selectedJobMatches.length == 0) {
      notificationWidget.show("Please select at least one job match", "error");
    } else {
      let selectedJobs = [];
      selectedJobMatches.forEach(job => {
        selectedJobs.push({
          aggregationMethodKey: aggregationMethodologyKey,
          fileOrgKey: job.fileOrgKey,
          positionCode: job.positionCode,
          jobCode: job.jobCode,
        });
      });
      $mutationUpdateJobMatchStatus.mutate({ statusType, selectedJobs });
    }
  };

  const setToNoBenchmark = () => {
    let selectedJobMatches = getSelectedJobMatches();
    if (selectedJobMatches.length == 0) {
      notificationWidget.show("Please select at least one job match", "error");
    } else {
      let selectedJobs = [];
      selectedJobMatches.forEach(job => {
        selectedJobs.push({
          marketPricingJobCode: "",
          marketPricingJobTitle: "",
          marketPricingJobDescription: "",
          publisherName: "",
          publisherKey: 0,
          jobMatchNote: "",
          jobMatchStatusKey: 0,
          selectedJobs: [
            {
              aggregationMethodKey: job.aggregationMethodKey,
              fileOrgKey: job.fileOrgKey,
              positionCode: job.positionCode,
              jobCode: job.jobCode,
              noBenchmarkMatch: true,
            },
          ],
          standardJobs: [
            {
              standardJobCode: "",
              standardJobTitle: "",
              standardJobDescription: "",
              blendNote: "",
              blendPercent: 0,
            },
          ],
        });
        selectedJobs.forEach(job => {
          $mutationSetToNoBenchmark.mutate(job);
        });
      });
    }
  };

  const getSelectedJobMatches = () => {
    const grid = jQuery(container).data("kendoGrid");
    const selectedRows = grid.select();
    let selectedJobMatches = [];

    for (let i = 0; i < selectedRows.length / 2; i++) {
      const dataItem = grid.dataItem(selectedRows[i]);
      selectedJobMatches.push(dataItem);
    }
    return selectedJobMatches;
  };

  // hide/show columns based on columns store
  const displayColumnsInGrid = (columns, grid) => {
    columns.forEach(column => {
      if (column.show) {
        grid.showColumn(column.field);
      } else {
        grid.hideColumn(column.field);
      }
    });
  };

  $: columnsStore.subscribe(columns => {
    const grid = jQuery(container).data("kendoGrid");
    if (columns && grid) {
      displayColumnsInGrid(columns, grid);
    }
  });

  onDestroy(() => {
    unsubscribeToTabFullScreen();
  });

  const saveBulkEdit = () => {
    bulkEditRef.saveChanges();
  };
</script>

<span id="notification" />

{#if !isFiltersSelected}
  <div class="alert alert-primary" role="alert">
    To visualize Job Matching, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{/if}

<div class="row my-2" class:d-none={!isFiltersSelected}>
  <div class="d-flex justify-content-between align-items-center">
    <div class={$tabFullScreen ? "" : "d-none"}>
      <span style="color: #262628; font-size: 16px">Job Matching</span>
    </div>

    <div class="form-group d-flex align-items-center flex-wrap">
      <!-- svelte-ignore a11y-label-has-associated-control -->
      <label class="mr-1 col-form-label" data-cy="LabelOrganization">Aggregation Methodology</label>
      <div style="margin: 5px 0px;">
        <input
          type="text"
          id="input-organization"
          list="dlOganizationData"
          class="form-control"
          disabled
          value={getAggregationMethodologyName(aggregationMethodologyKey)}
          data-cy="organization"
        />
      </div>
      {#if !isBulkEdit}
        <button class="btn btn-primary m-2" data-cy="jobmatchbtn" on:click={() => openJobMatchModal()}>Job Match</button>
        <div class="dropdown dropdown-div status-change">
          <button
            class="btn btn-primary dropdown-toggle"
            data-cy="statusChangeBtn"
            id="statusChangeLink"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            disabled={isProjectStatusFinal}
          >
            Status change
          </button>
          <ul class="dropdown-menu" aria-labelledby="statusChangeLink">
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li class="dropdown-item" on:click={() => updateTheStatus(JobMatchStatus.AnalystReviewed)}>Analyst Reviewed</li>
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li class="dropdown-item" on:click={() => updateTheStatus(JobMatchStatus.PeerReviewed)}>Peer Reviewed</li>
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li class="dropdown-item" on:click={() => updateTheStatus(JobMatchStatus.Complete)}>Complete</li>
          </ul>
        </div>
      {/if}
      <button class="btn btn-primary m-2" data-cy="export" on:click={exportGrid}>Export</button>
      {#if isBulkEdit}
        <button class="btn btn-primary m-2" data-cy="saveBulkEdit" on:click={saveBulkEdit}>Save</button>
      {/if}
      {#if $featureFlagStore.JobMatchingBulkEdit}
        <div class="dropdown">
          <button
            class="btn btn-primary dropdown-toggle d-flex align-items-center"
            type="button"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            data-cy="bulkEditBtn"
          >
            <UnsavedWarning>{isBulkEdit ? "Bulk Edit" : "Single Edit"}</UnsavedWarning>
          </button>
          <ul class="dropdown-menu">
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li
              data-cy={isBulkEdit ? "editOptionBtnSingleEdit" : "editOptionBtnBulkEdit"}
              class="dropdown-item"
              on:click={() => (isBulkEdit = !isBulkEdit)}
            >
              {isBulkEdit ? "Single Edit" : "Bulk Edit"}
            </li>
          </ul>
        </div>
      {/if}
      {#if !isBulkEdit}
        <div>
          <button class="btn btn-primary m-2" data-cy="setNoBenchmark" on:click={() => setToNoBenchmark()}> Set to No Benchmark </button>
        </div>
      {/if}
    </div>
    <div class="d-flex align-items-center flex-wrap">
      <PopoverColumns />
      <button class="btn btn-primary" data-cy="fullscreen" style="white-space: nowrap;" on:click={() => toggleFullScreenMode()}>
        <i class="fa fa-arrows-alt" />
        {fullScreenName}
      </button>
    </div>
  </div>
</div>

<div class="mb-2" class:d-none={!isFiltersSelected || isBulkEdit}>
  <div bind:this={container} />
  <div>
    <p class="items-count-indicator">{jobMatchingsGridLength} items found</p>
  </div>
</div>
{#if isBulkEdit}
  <BulkEdit {jobMatchings} bind:this={bulkEditRef} projVersionId={inputFilterProjectVersionId} />
{/if}

<Modal
  show={jobMatchModalComponant}
  props={jobMatchModalData}
  classWindowWrap="d-flex align-items-center justify-content-center"
  on:closed={onJobMatchModalClosed}
/>

<style>
  .mr-1 {
    margin-right: 10px;
  }

  .items-count-indicator {
    background: #eeeeee;
    padding: 8px;
    text-align: right;
    border: 1px solid #dee2e6;
  }

  .dropdown-menu {
    max-height: 300px;
    overflow-y: auto;
  }

  .dropdown-menu .dropdown-item:hover {
    background-color: #0076be;
    cursor: pointer;
    color: white;
  }
</style>
