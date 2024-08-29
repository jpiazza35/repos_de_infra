<script>
  // @ts-nocheck
  import { onDestroy, onMount } from "svelte";
  import { toggleFullScreen, updateKendoGridStyles } from "components/shared/functions";
  import { marketSummaryGridConfig, employeeSummaryGridConfig } from "./SummaryGridsConfig";
  import SideMenu from "./MarketSummaryReportSelections.svelte";
  import { projectVersionStore } from "store/project";
  import { useQuery } from "@sveltestack/svelte-query";
  import { getJobSummaries, getJobSummariesEmployee } from "api/marketSummaryApiCalls";
  import { marketSummaryTableStore, reportSelectionStore } from "store/reportSelections";
  import MarketSummaryHeader from "./MarketSummaryHeader.svelte";
  import { getBenchmarkInfo } from "api/apiCalls";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;

  let sideMenu;
  let marketSummaryGrid;
  let notificationWidget = null;
  let fullScreenName = "Full Screen";
  let fullscreen = false;
  let orgName;
  let showSideMenu = true;
  let staticColumns = [];
  let benchmarksFilter = [];
  let dataScopesFilter = [];
  let filterApplied = false;
  let jobSummariesData;
  let selectedView = "Job";

  const NOT_TABLE_HEIGHT = 300;

  const refetchEmployeeSummaries = () => {
    $fetchEmployeeSummaries.refetch();
  };

  const refetchJobSummaries = () => {
    $fetchJobSummaries.refetch();
    $queryBenchmarks.refetch();
  };

  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;
  $: isFiltersSelected && refetchJobSummaries();
  $: {
    reportSelectionStore.subscribe(store => {
      benchmarksFilter = store?.benchmarks;
      dataScopesFilter = store?.dataScopes;
    });
  }

  $: {
    filterApplied = $marketSummaryTableStore?.filterApplied || false;
    const { data } = $marketSummaryTableStore?.data || {};
    if ($marketSummaryTableStore?.filterApplied && $marketSummaryTableStore?.data?.data) {
      updateGridData(data, filterApplied);
    }
  }

  onMount(async () => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    registerKendoGrid();
  });

  onDestroy(() => {
    destroyKendoGrid();
  });

  const destroyKendoGrid = () => {
    if (jQuery(marketSummaryGrid).data("kendoGrid")) {
      jQuery(marketSummaryGrid).data("kendoGrid").destroy();
      marketSummaryGridConfig.columns = staticColumns;
      staticColumns = [];
    }
  };

  const filteredDataScopes = fetchedData => {
    if (dataScopesFilter.length === 0) return [];

    const checkedTitles = dataScopesFilter.filter(item => item.checked === true).map(item => item.title);

    if (checkedTitles.length === 0) return [];

    return fetchedData.filter(item => {
      const regexPattern = /eri/i;

      if (item.dataSource === "ERI" || regexPattern.test(item.dataScope.toLowerCase())) {
        return checkedTitles.some(title => {
          const titlePattern = /eri/i;
          return titlePattern.test(title);
        });
      }
      return checkedTitles.some(title => {
        return item.dataScope?.toLowerCase().replace("average", " ").replace(":", "").trim() === title.toLowerCase();
      });
    });
  };

  const setGridData = marketSummaryData => {
    jobSummariesData = marketSummaryData || [];
    if (jQuery(marketSummaryGrid).data("kendoGrid")) {
      jQuery(marketSummaryGrid)
        .data("kendoGrid")
        .dataSource.data([...jobSummariesData]);
    }
  };

  const percentilePrefix = "P";
  const comparisonPrefix = "C";

  const flatSummaryData = rawData => {
    const filteredFlattenedData = rawData.map(item => {
      const newData = { ...item };
      if ($reportSelectionStore.benchmarks) {
        let updatedBenchmarks = item.benchmarks
          .filter(benchmark => $reportSelectionStore.benchmarks?.some(filter => filter.id === benchmark.id && filter.checked))
          .map(benchmark => {
            const filteredSelectedPercentiles = $reportSelectionStore.benchmarks?.find(
              filter => filter.id === benchmark.id && filter.checked,
            )?.selectedPercentiles;
            if (filteredSelectedPercentiles.length > 0) {
              benchmark.percentiles = benchmark.percentiles.filter(percentile => filteredSelectedPercentiles.includes(percentile.percentile));
            } else {
              benchmark.percentiles = benchmark.percentiles.filter(percentile => filteredSelectedPercentiles.includes(percentile.percentile));
              benchmark.comparisons = new Array(); // this will exclude the flat so the grid dont build empty comparison
            }
            return benchmark;
          });
        newData.benchmarks = updatedBenchmarks;

        newData.benchmarks.forEach(benchmark => {
          const filteredComparisonsData = $reportSelectionStore.benchmarks?.find(filter => filter.id === benchmark.id && filter.checked);
          if (filteredComparisonsData) {
            benchmark.comparisons = benchmark.comparisons?.filter(comparison =>
              filteredComparisonsData.comparisons.some(selectedComparison => selectedComparison.id === comparison.id),
            );
            benchmark.title = filteredComparisonsData.longAlias;
            benchmark.shortAlias = filteredComparisonsData.shortAlias;
            benchmark.orderDataType = filteredComparisonsData.orderDataType;

            benchmark.percentiles.forEach(percentile => {
              const percentileField = `${benchmark.id}_benchmark_${benchmark.id}_${benchmark.title}_${percentilePrefix}${percentile.percentile}`;
              newData[percentileField] = percentile.marketValue;
            });
            let filteredComparisonFromCurrBenchmark = benchmarksFilter.find(filter => filter.id === benchmark.id && filter.checked).comparisons;
            if (filteredComparisonFromCurrBenchmark) {
              let arr = benchmark.comparisons.map(c => {
                if (filteredComparisonFromCurrBenchmark.find(fc => fc.id === c.id)) {
                  return { ...c, ...filteredComparisonFromCurrBenchmark.find(fc => fc.id === c.id) };
                }
              });
              arr.forEach(comparison => {
                const comparisonField = `${benchmark.id}_comparison_${comparison.id}_${comparison.title}_average`;
                newData[comparisonField] = comparison.average;

                let filteredRatios = Object.entries(comparison.ratios).filter(ratio => {
                  /* eslint-disable no-unused-vars */
                  const [ratioPercentile] = ratio;
                  return comparison.selectedPercentiles.includes(parseInt(ratioPercentile)) && ratio;
                });
                filteredRatios.forEach(([ratioKey, ratioValue]) => {
                  const ratioField = `${benchmark.id}_comparison_${comparison.id}_${comparison.title}_${comparisonPrefix}${ratioKey}`;
                  newData[ratioField] = ratioValue;
                });
              });
            }
          }
        });
      }

      return newData;
    });
    return filteredFlattenedData;
  };

  const updateGridData = (fetchedData, isFiltering) => {
    const grid = jQuery(marketSummaryGrid)?.data("kendoGrid");
    if (grid) {
      if (isFiltering) {
        const fetchedDataFiltered = filteredDataScopes(fetchedData);
        if (fetchedDataFiltered?.length > 0) {
          const flattenedData = flatSummaryData(fetchedDataFiltered);
          generateDefaultDynamicColumns(flattenedData);
          setGridData(flattenedData);
        } else {
          marketSummaryGridConfig.columns = [...staticColumns];
          grid.setDataSource([]);
          grid.setOptions(marketSummaryGridConfig);
          grid.refresh();
        }
      } else {
        const flattenedData = flatSummaryData(fetchedData);
        const dynamicColumnsExist = grid?.columns && grid?.columns.length > 13;

        if (!dynamicColumnsExist) {
          generateDefaultDynamicColumns(flattenedData);
        }
        generateDefaultDynamicColumns(flattenedData);
        setGridData(flattenedData);
      }
    }
    updateOrganizationHeader();
  };

  const updateOrganizationHeader = () => {
    orgName = $projectVersionStore.organizationName;
  };

  const fetchJobSummaries = useQuery(
    ["jobSummariesData", inputFilterProjectVersionId, isFiltersSelected],
    async () => {
      const data = await getJobSummaries(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  // load benchmarks
  const queryBenchmarks = useQuery(
    ["benchmarks", inputFilterProjectVersionId],
    async () => {
      const data = await getBenchmarkInfo(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($fetchJobSummaries.data) {
    updateGridData($fetchJobSummaries.data, false);
  }

  $: if ($fetchJobSummaries.error) {
    notificationWidget?.show("There was an error fetching data from server", "error");
  }

  const fetchEmployeeSummaries = useQuery(
    ["employeeSummariesData", inputFilterProjectVersionId, isFiltersSelected],
    async () => {
      const data = await getJobSummariesEmployee(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($fetchEmployeeSummaries.data) {
    updateGridData($fetchEmployeeSummaries.data, false);
  }

  $: if ($fetchEmployeeSummaries.error) {
    notificationWidget?.show("There was an erro fetching data from server", "error");
  }

  const registerKendoGrid = () => {
    jQuery(marketSummaryGrid).kendoGrid(marketSummaryGridConfig);
    staticColumns = marketSummaryGridConfig.columns;
    updateKendoGridStyles();
    jQuery(".k-grid-content").css({ "min-height": "150px", "max-height": document.documentElement.clientHeight - NOT_TABLE_HEIGHT });
    kendo.ui.progress(jQuery(marketSummaryGrid)?.data("kendoGrid").element, true);
  };

  const toggleFullScreenMode = () => {
    toggleFullScreen("marketSummaryTab");
    fullscreen = jQuery("#marketSummaryTab").hasClass("fullscreenlayer");
    fullScreenName = fullscreen ? "Exit Full Screen" : "Full Screen";
    if (jQuery(marketSummaryGrid).data("kendoGrid")) jQuery(marketSummaryGrid).data("kendoGrid").resize();
  };

  const ShowLeftMenu = () => {
    showSideMenu = !showSideMenu;
    const marketSummaryGrid = document.getElementById("MarketSummaryGrid");
    if (marketSummaryGrid) {
      marketSummaryGrid.className = showSideMenu ? "col-sm-9 col-md-9 col-lg-9" : "col-sm-12 col-md-12 col-lg-12";
    }
  };

  const benchmarkHeaderStyle =
    "justify-content: center; text-align: center; background-color:#48484C; color: #D6D6D7; border: 1px 0px 1px 1px; border-color: #D6D6D7";
  const comparisonHeaderStyle =
    "justify-content: center; text-align: center; background-color:#747477; color: #D6D6D7; border: 1px 0px 1px 1px; border-color: #D6D6D7";

  const benchmarkToolTipClass = "benchmarkToolTip";
  const noBenchmarkElement = value => {
    const style = { cursor: "pointer" };
    if (value) {
      return `<span>$${value.toFixed(2)}</span>`;
    }
    return `<span class=${benchmarkToolTipClass} style=${style}>---</span>`;
  };

  function generateBenchmarkColumn(key, benchmark, benchmarkColumns, processedBenchmarkIds) {
    let benchmarkColumn = benchmarkColumns.find(b => b.id === benchmark.id);
    benchmark.title = "Market " + $reportSelectionStore.benchmarks.find(b => b.id === parseInt(benchmark.id))?.longAlias;
    benchmark.shortAlias = $reportSelectionStore.benchmarks.find(b => b.id === parseInt(benchmark.id))?.shortAlias;
    benchmark.orderDataType = $reportSelectionStore.benchmarks.find(b => b.id === parseInt(benchmark.id))?.orderDataType;

    if (!benchmarkColumn) {
      benchmarkColumn = {
        width: 280,
        title: benchmark.title,
        id: benchmark.id,
        field: benchmark.title,
        shortAlias: benchmark.shortAlias,
        orderDataType: benchmark.orderDataType,
        headerAttributes: { "data-cy": benchmark.title, style: benchmarkHeaderStyle },
        columns: [],
      };
      benchmarkColumns.push(benchmarkColumn);
    }
    /* eslint-disable no-unused-vars */
    const [_, __, ___, ____, average] = key.split("_");
    const percentile = average.includes(percentilePrefix) ? average.split(percentilePrefix)[1] : null;
    benchmarkColumn.columns.push({
      title: `Market <br/> ${percentile}th`,
      field: key,
      headerAttributes: { "data-cy": `${benchmark.title}-${percentile}`, style: benchmarkHeaderStyle },
      width: 150,
      template: dataItem => {
        const value = dataItem[key];
        return noBenchmarkElement(value);
      },
    });
    if (benchmarkColumn.columns.length === benchmark.percentiles.length) {
      processedBenchmarkIds.set(benchmark.id, { id: parseInt(benchmark.id), comparisons: [] });
    }
  }

  function getBenchmarkShortAlias(benchmarkId) {
    return $reportSelectionStore?.benchmarks?.find(b => b.id === benchmarkId)?.shortAlias;
  }
  function getBenchmarkLongAlias(benchmarkId) {
    return $reportSelectionStore?.benchmarks?.find(b => b.id === benchmarkId)?.longAlias;
  }
  function getBenchmarkOrderDataType(benchmarkId) {
    return $reportSelectionStore?.benchmarks?.find(b => b.id === benchmarkId)?.orderDataType;
  }

  function createComparisonColumn(title, comparisonId, benchmarkId) {
    return {
      width: 280,
      title: `Client ${getBenchmarkLongAlias(comparisonId) || ""} Comparison`,
      comparisonId: comparisonId,
      benchmarkId: benchmarkId,
      field: title,
      shortAlias: getBenchmarkShortAlias(benchmarkId),
      orderDataType: getBenchmarkOrderDataType(benchmarkId),
      headerAttributes: { "data-cy": title, style: comparisonHeaderStyle },
      columns: [],
    };
  }

  function addAverageColumnToComparison(comparisonColumn, title, key, benchmarkId) {
    const subColumnTitle = selectedView === "Incumbent" ? getBenchmarkShortAlias(benchmarkId) : "Average";
    comparisonColumn.columns.push({
      title: subColumnTitle,
      orderDataType: getBenchmarkShortAlias(benchmarkId),
      field: key,
      headerAttributes: { "data-cy": `${title}-${subColumnTitle}`, style: comparisonHeaderStyle },
      width: 120,
      template: dataItem => {
        return dataItem[key] ? `$${dataItem[key].toFixed(2)}` : `---`;
      },
    });
  }

  function addRatioColumnToComparison(comparisonColumn, title, percentile, key) {
    comparisonColumn.columns.push({
      title: `Ratio to <br/> Market ${percentile}th`,
      field: key,
      headerAttributes: { "data-cy": `${title}${percentile}`, style: comparisonHeaderStyle },
      width: 150,
    });
  }

  function generateComparisonColumn(key, benchmark, benchmarkColumns, processedBenchmarkIds) {
    /* eslint-disable no-unused-vars */
    let [_, __, comparisonId, title, average] = key.split("_");

    comparisonId = parseInt(comparisonId);
    let comparisonColumn = benchmarkColumns.find(b => b.benchmarkId === benchmark.id && b.comparisonId === comparisonId);

    const FilteredRatios = Object.entries(benchmark.comparisons.find(c => c.id === comparisonId).ratios).map(([percentile, ratio]) => ({
      percentile: percentile,
      marketValue: ratio,
    }));

    const filteredComparison = benchmarksFilter
      .find(filter => filter.id === benchmark.id && filter.checked)
      .comparisons.find(c => c.id === comparisonId);

    if (!comparisonColumn) {
      title =
        filteredComparison.title && filteredComparison.title.includes("Client")
          ? filteredComparison.title?.replace("Client ", "")
          : getBenchmarkLongAlias(comparisonId);
      comparisonColumn = createComparisonColumn(title, comparisonId, benchmark.id);
      benchmarkColumns.push(comparisonColumn);
    }

    const isAverageSubColumn = average.includes("average");
    const isDefaultRatioSubColumn = average.includes("C50");

    if (filterApplied) {
      if (isAverageSubColumn) {
        addAverageColumnToComparison(comparisonColumn, title, key, benchmark.id);
      } else {
        const percentile = average.includes(comparisonPrefix) ? average.split(comparisonPrefix)[1] : null;
        if (filteredComparison.selectedPercentiles.length > 0) {
          const selectedPercentile = parseInt(percentile);
          const hasSelectedPercentile = filteredComparison.selectedPercentiles.includes(selectedPercentile);

          if (hasSelectedPercentile) {
            addRatioColumnToComparison(comparisonColumn, title, percentile, key);
          }
        }
      }
    } else {
      title = `Client ${filteredComparison.title} Comparison`;
      if (isAverageSubColumn) {
        addAverageColumnToComparison(comparisonColumn, title, key, benchmark.id);
      } else if (isDefaultRatioSubColumn) {
        const percentile = average.includes(comparisonPrefix) ? average.split(comparisonPrefix)[1] : null;
        addRatioColumnToComparison(comparisonColumn, title, percentile, key);
      }
    }
    const avgColumnLength = 1;
    const maxColumns =
      FilteredRatios.filter(r => filteredComparison.selectedPercentiles.includes(parseInt(r.percentile)) && r).length + avgColumnLength;

    if (comparisonColumn.columns.length === maxColumns) {
      let processedBenchmark = processedBenchmarkIds.get(parseInt(benchmark.id));
      processedBenchmark?.comparisons?.push(comparisonId);
    }
  }

  const generateDefaultDynamicColumns = fetchedData => {
    const grid = jQuery(marketSummaryGrid).data("kendoGrid");
    const processedBenchmarkIds = new Map();
    if (!fetchedData) return false;

    let benchmarkColumns = [];

    fetchedData.forEach(job => {
      benchmarkColumns.sort((a, b) => a.orderDataType - b.orderDataType);
      Object.keys(job).forEach(key => {
        if (!key.includes("_")) return;
        const [benchmarkId, type, comparisonId] = key.split("_");

        const benchmark = job.benchmarks.find(b => b.id === parseInt(benchmarkId));

        if (type.includes("benchmark") && benchmark && !processedBenchmarkIds.get(benchmark.id)) {
          generateBenchmarkColumn(key, benchmark, benchmarkColumns, processedBenchmarkIds);
        } else if (
          type.includes("comparison") &&
          benchmark &&
          !processedBenchmarkIds.get(benchmark.id)?.comparisons?.find(c => c === parseInt(comparisonId))
        ) {
          generateComparisonColumn(key, benchmark, benchmarkColumns, processedBenchmarkIds);
        }
      });
    });
    if (selectedView === "Incumbent") {
      addEmployeeColumns(benchmarkColumns);
    } else {
      addJobColumns(benchmarkColumns);
    }

    grid.setOptions(marketSummaryGridConfig);
    grid.refresh();
  };

  const exportGrid = () => {
    const grid = jQuery(marketSummaryGrid).data("kendoGrid");
    grid.saveAsExcel();
  };

  const updateView = view => {
    if (selectedView !== view) {
      sideMenu.handleReset();
      selectedView = view;
      if (selectedView === "Incumbent") {
        refetchEmployeeSummaries();
      } else {
        refetchJobSummaries();
      }
    }
  };

  const addEmployeeColumns = benchmarkColumns => {
    marketSummaryGridConfig.columns = marketSummaryGridConfig.columns.filter(column => column.field !== "incumbentCount");
    marketSummaryGridConfig.columns = [...employeeSummaryGridConfig.columns, ...benchmarkColumns];
  };

  const addJobColumns = benchmarkColumns => {
    marketSummaryGridConfig.columns = [...staticColumns, ...benchmarkColumns];
  };
</script>

<span id="notification" />

{#if !isFiltersSelected}
  <div data-cy="filterSelectCy" class="alert alert-primary" role="alert">
    To visualize Market Summary Tables, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{/if}

<div class="col-sm-12 col-md-12 col-lg-12 d-flex justify-content-between" class:d-none={!isFiltersSelected}>
  <SideMenu {inputFilterProjectVersionId} show={showSideMenu} bind:this={sideMenu} {selectedView} />
  <div id="MarketSummaryGrid" class="col-sm-9 col-md-9 col-lg-9">
    <div class="d-flex flex-row align-items-center justify-content-between">
      <button class="btn btn-primary" on:click={ShowLeftMenu} data-cy="hideShowFilterPaneBtn">
        <i class="fa {showSideMenu ? 'fa-angle-double-left' : 'fa-angle-double-right'}  fa-md" />
        {showSideMenu ? "Hide Pane" : "Show Pane"}
      </button>
      <div class="d-flex">
        <div class="dropdown dropdown-div status-change">
          <button
            class="btn btn-primary dropdown-toggle"
            data-cy="summaryViewBtn"
            id="summaryViewLink"
            data-bs-toggle="dropdown"
            aria-expanded="false"
          >
            Summary View
          </button>
          <ul class="dropdown-menu" aria-labelledby="summaryViewLink">
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li class="dropdown-item" class:selected={selectedView === "Job"} on:click={() => updateView("Job")}>Job View</li>
            <!-- svelte-ignore a11y-click-events-have-key-events -->
            <li class="dropdown-item" class:selected={selectedView === "Incumbent"} on:click={() => updateView("Incumbent")}>Incumbent View</li>
          </ul>
        </div>
        <button class="btn btn-primary mx-2" data-cy="exportMarketSummaryGrid" style="white-space: nowrap;" on:click={() => exportGrid()}
          >Export</button
        >
        <button class="btn btn-primary" data-cy="fullscreenMarketSummaryGrid" style="white-space: nowrap;" on:click={() => toggleFullScreenMode()}>
          <i class="fa fa-arrows-alt mr-2" />
          {fullScreenName}
        </button>
      </div>
    </div>

    {#if orgName && orgName.length > 0}
      <MarketSummaryHeader {orgName} {selectedView} />{:else}
      <div class="my-4" />
    {/if}

    <div class="mb-2 d-flex marketSummaryGrid" bind:this={marketSummaryGrid} id="TableToExport" data-cy="marketSummaryGridCy" />
  </div>
</div>

<style>
  .dropdown-menu {
    max-height: 300px;
    overflow-y: auto;
  }

  .dropdown-menu .selected {
    background-color: #0076be;
    color: white;
  }

  .status-change .dropdown-menu .dropdown-item:hover {
    background-color: #0076be;
    cursor: pointer;
    color: white;
  }
</style>
