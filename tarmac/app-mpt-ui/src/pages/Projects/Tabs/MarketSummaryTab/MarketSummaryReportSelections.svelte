<script>
  // @ts-nocheck
  import { Accordion, AccordionItem, FormGroup, Input, Button, Alert, Label } from "sveltestrap";
  import { useQuery, useMutation } from "@sveltestack/svelte-query";
  import { reportSelectionStore, marketSummaryTableStore } from "store/reportSelections";
  import { getMPSGlobalSettings, getMarketSegmentReportFilters, getBenchmarkInfo, getJobGroups, getMarketSegmentNames } from "api/apiCalls";
  import { retrieveTableData, retrieveTableDataEmployee } from "api/marketSummaryApiCalls";
  import MultiSelect from "components/controls/multiSelect.svelte";
  import { onMount } from "svelte";

  export let inputFilterProjectVersionId, show, selectedView;

  let notificationWidget = null;
  let initialDataScopes = [];
  let initialBenchmarks = [];
  let showAllUnchecked = false;
  let showBenchmarkUnchecked = false;
  let initialMarketSegments = [];
  let initialClientJobGroups = [];

  // load combined average list
  const queryReportFilters = useQuery(
    ["reportFilters", inputFilterProjectVersionId],
    async () => {
      const data = await getMarketSegmentReportFilters(inputFilterProjectVersionId);
      return data.data;
    },
    {
      enabled: false,
    },
  );

  const queryClientJobGroups = useQuery(
    ["clientJobGroups", inputFilterProjectVersionId],
    async () => {
      const data = await getJobGroups(inputFilterProjectVersionId);
      initialClientJobGroups = [...data.data];
      return data.data;
    },
    {
      enabled: false,
    },
  );

  const queryMarketSegment = useQuery(
    ["marketSegment", inputFilterProjectVersionId],
    async () => {
      const data = await getMarketSegmentNames(inputFilterProjectVersionId);
      initialMarketSegments = [...data.data];
      return data.data;
    },
    { enabled: false },
  );

  const queryGlobalSetting = useQuery(
    ["globalSettings", inputFilterProjectVersionId],
    async () => {
      const data = await getMPSGlobalSettings(inputFilterProjectVersionId);
      return data.data;
    },
    {
      enabled: false,
    },
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

  const handleMutation = mutationFunction => {
    return useMutation(payload => mutationFunction(inputFilterProjectVersionId, payload), {
      onSuccess: async data => {
        kendo.ui.progress(jQuery(".marketSummaryGrid")?.data("kendoGrid").element, false);

        marketSummaryTableStore.update(store => ({
          ...store,
          data: data,
          filterApplied: true,
        }));
      },

      onError: () => {
        notificationWidget?.show("Error retrieving grid data", "error");
      },
    });
  };

  const mutationTableDataEmployee = handleMutation(retrieveTableDataEmployee);
  const mutationTableData = handleMutation(retrieveTableData);

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");

    jQuery(".filtersAccordion").on("click", function () {
      jQuery(".accordion-collapse").css("overflow", "visible");
      BindUIControls();
    });
  });

  let dataScopes = [],
    benchmarks = [];
  $: {
    dataScopes =
      $queryReportFilters?.data?.map((d, i) => ({
        title: d,
        checked: true,
        id: ++i,
      })) || [];
    benchmarks =
      $queryGlobalSetting?.data?.benchmarks?.map(b => ({
        shortAlias: $queryBenchmarks?.data?.find(a => a.id === b.id)?.shortAlias,
        longAlias: $queryBenchmarks?.data?.find(a => a.id === b.id)?.longAlias,
        orderDataType: $queryBenchmarks?.data?.find(a => a.id === b.id)?.orderDataType,
        title: b.title,
        id: b.id,
        percentiles: b.percentiles,
        selectedPercentiles: b.percentiles,
        checked: true,
        comparisons: [
          {
            id: b.id,
            title: b.title,
            selectedPercentiles: [50],
          },
        ],
      })) || [];
    initialClientJobGroups = $queryClientJobGroups?.data?.map(item => ({ title: item, id: item, checked: true })) || [];
    initialMarketSegments = $queryMarketSegment?.data?.map(item => ({ title: item.name, id: item.id, checked: true })) || [];

    reportSelectionStore.update(store => ({
      ...store,
      dataScopes,
      benchmarks,
      jobGroups: initialClientJobGroups,
      marketSegments: initialMarketSegments,
    }));

    initialBenchmarks = benchmarks;
    initialDataScopes = dataScopes;
  }

  $: {
    if (inputFilterProjectVersionId) {
      refetchQuery();
    }
  }

  const refetchQuery = () => {
    $queryReportFilters.refetch();
    $queryGlobalSetting.refetch();
    $queryBenchmarks.refetch();
    $queryClientJobGroups.refetch();
    $queryMarketSegment.refetch();

    setTimeout(() => {
      jQuery("#filterSelectJobGroup").multiselect("destroy");
      jQuery("#filterSelectMSName").multiselect("destroy");
      initialClientJobGroups = $queryClientJobGroups?.data?.map(item => ({ title: item, id: item })) || [];
      initialMarketSegments = $queryMarketSegment?.data?.map(item => ({ title: item.name, id: item.id })) || [];
      initialClientJobGroups = [...initialClientJobGroups];
      initialMarketSegments = [...initialMarketSegments];
      setTimeout(() => {
        BindUIControls();
      }, 100);
    }, 500);
  };

  const showDatascopeWarning = () => {
    showAllUnchecked = true;
    setTimeout(() => {
      if (showAllUnchecked) showAllUnchecked = !showAllUnchecked;
    }, 3000);
  };

  const showBenchmarksWarning = () => {
    showBenchmarkUnchecked = true;
    setTimeout(() => {
      if (showBenchmarkUnchecked) showBenchmarkUnchecked = !showBenchmarkUnchecked;
    }, 3000);
  };

  const updateReportSelection = (type, id, checked) => {
    reportSelectionStore.update(store => {
      const selection = store[type].map(b => {
        if (b.title === id || b.id === id) {
          b.checked = checked;
        }
        return b;
      });

      const allUnchecked = selection.every(b => !b.checked);
      if (allUnchecked) {
        if (type.includes("dataScopes")) {
          selection.find(s => s.title.includes(id)).checked = true;
          document.getElementById(`switch-${id}`).checked = true;
          showDatascopeWarning();
        } else {
          selection.find(s => s.id === id).checked = true;
          document.getElementById(`benchmark-switch-${id}`).checked = true;
          showBenchmarksWarning();
        }
      }

      return {
        ...store,
        [type]: selection,
      };
    });
  };

  const updatePercentiles = (key, selectedItems) => {
    const [propName, title] = key.split("-");
    reportSelectionStore.update(store => {
      const selection = selectedItems.map(item => {
        if (propName === "comparisons") {
          return {
            id: item.value,
            title: item.text,
            selectedPercentiles:
              store.benchmarks.find(b => b.id === item.value).comparisons?.find(c => c.id === item.value)?.selectedPercentiles || [],
          };
        }
        return item.value;
      });
      return {
        ...store,
        benchmarks: store.benchmarks.map(b => {
          if (b.title.includes(title)) {
            b[propName] = selection;
          }
          return b;
        }),
      };
    });
  };

  const updateComparisonPercentiles = (key, selectedItems) => {
    const [id, clientId] = key.split("-");
    reportSelectionStore.update(store => {
      const selection = selectedItems.map(item => item.value);
      return {
        ...store,
        benchmarks: store.benchmarks.map(b => {
          if (b.id == id) {
            b.comparisons = b.comparisons.map(c => {
              if (c.id == clientId) {
                c.selectedPercentiles = selection;
              }
              return c;
            });
          }
          return b;
        }),
      };
    });
  };

  const handleApply = e => {
    e?.preventDefault;

    kendo.ui.progress(jQuery(".marketSummaryGrid")?.data("kendoGrid").element, true);

    const payload = {
      benchmarks: $reportSelectionStore.benchmarks
        .filter(b => b.checked)
        .map(b => ({
          id: b.id,
          percentiles: b.percentiles,
          comparisons: b.comparisons.map(c => ({
            id: c.id,
            selectedPercentiles: c.selectedPercentiles,
          })),
        })),
      filter: {},
    };

    const selectedMarketSegments = $reportSelectionStore.marketSegments?.filter(ms => ms.checked);
    const selectedJobGroups = $reportSelectionStore.jobGroups?.filter(jg => jg.checked);
    if (selectedMarketSegments?.length > 0) {
      payload.filter.marketSegmentList = selectedMarketSegments.map(ms => ({ id: ms.id }));
    }

    if (selectedJobGroups?.length > 0) {
      payload.filter.clientJobGroupList = selectedJobGroups.map(jg => jg.id);
    }

    selectedView?.includes("Incumbent") ? $mutationTableDataEmployee.mutate(payload) : $mutationTableData.mutate(payload);
  };

  export const handleReset = () => {
    reportSelectionStore.update(store => {
      const updatedClientJobGroups = initialClientJobGroups.map(jg => ({ ...jg, checked: true }));
      const updatedMarketSegments = initialMarketSegments.map(ms => ({ ...ms, checked: true }));
      const updatedDataScopes = initialDataScopes.map(ds => ({ ...ds, checked: true }));
      const updatedBenchmarks = initialBenchmarks.map(b => {
        const benchmarkMultiSelect = jQuery(document.getElementById(`selectedPercentiles-${b.title}`)).data("kendoMultiSelect");
        const comparisonMultiSelect = jQuery(document.getElementById(`comparisons-${b.title}`)).data("kendoMultiSelect");
        const comparisonPercentileMultiSelect = jQuery(document.getElementById(`${b.id}-${b.id}-${b.title}`)).data("kendoMultiSelect");

        if (benchmarkMultiSelect) {
          benchmarkMultiSelect.value(b.percentiles);
        }
        if (comparisonMultiSelect) {
          comparisonMultiSelect.value(b.id);
        }
        if (comparisonPercentileMultiSelect) {
          comparisonPercentileMultiSelect.value(50);
        }

        const updatedComparison = {
          id: b.id,
          title: b.title,
          selectedPercentiles: [50],
        };

        return {
          ...b,
          checked: true,
          percentiles: b.percentiles,
          selectedPercentiles: b.percentiles,
          comparisons: [updatedComparison],
        };
      });

      return {
        ...store,
        dataScopes: updatedDataScopes,
        benchmarks: updatedBenchmarks,
        jobGroups: updatedClientJobGroups,
        marketSegmentIds: updatedMarketSegments,
      };
    });

    updateFiltersSelection(false);
    handleApply();
  };

  const updateFiltersSelection = selected => {
    if (jQuery("#filterSelectJobGroup")) {
      jQuery("#filterSelectJobGroup option:selected")?.prop("selected", selected);
      jQuery("#filterSelectJobGroup").multiselect("refresh");
      jQuery("#filterSelectMSName option:selected")?.prop("selected", selected);
      jQuery("#filterSelectMSName").multiselect("refresh");
    }
  };

  const BindUIControls = async () => {
    jQuery("#filterSelectJobGroup, #filterSelectMSName").multiselect({
      templates: {
        button:
          '<button style="width: 165px;text-align: right;border:1px solid #e2e2e2" type="button" class="multiselect dropdown-toggle btn" data-bs-toggle="dropdown" aria-expanded="false"><span class="multiselect-selected-text"></span></button>',
      },
      buttonWidth: "100%",
      includeSelectAllOption: true,
      onDropdownShow: function () {
        jQuery(".multiselect-container").css("width", "100%");
        jQuery(".multiselect-container label.checkbox").css("width", "100%");
        jQuery(".btn-group ul li:nth-child(1)").css("background", "#e2e2e2");
        jQuery(".btn-group ul li:nth-child(1) label a").css("color", "");
      },
      onDropdownHide: function () {},
      onChange: function () {
        updateSelectedFilterValues();
      },
      onSelectAll: function () {
        updateSelectedFilterValues();
      },
      onDeselectAll: function () {
        updateSelectedFilterValues();
      },
    });
  };

  const updateSelectedFilterValues = () => {
    const selectedJobGroups = jQuery("#filterSelectJobGroup").val();
    const selectedMarketSegments = jQuery("#filterSelectMSName").val();

    const updatedClientJobGroups = initialClientJobGroups?.map(jg => ({
      ...jg,
      checked: selectedJobGroups?.includes(jg.id),
    }));

    const updatedMarketSegments = initialMarketSegments?.map(ms => ({
      ...ms,
      checked: selectedMarketSegments?.includes(ms.id.toString()),
    }));

    reportSelectionStore.update(store => ({
      ...store,
      jobGroups: updatedClientJobGroups || [],
      marketSegments: updatedMarketSegments || [],
    }));
  };
</script>

<div
  id="leftMenu"
  data-cy="marketSummaryReportPane"
  class="col-sm-3 col-md-3 col-lg-3 pe-3 d-flex flex-column justify-content-between"
  class:d-none={!show}
>
  <Accordion style="overflow: visible">
    <AccordionItem active header="Data Scope" data-cy="DataScopeFilterAccordion" class="dataCyDataScopeFilterAccordion">
      {#if $reportSelectionStore.dataScopes.length === 0}
        <Alert data-cy="noDataScopFilterAlert" color="warning">There are no report filters associated with this project version.</Alert>
      {/if}

      {#each $reportSelectionStore.dataScopes as ds}
        <FormGroup data-cy="formGroupDataScope">
          <Input
            id={`switch-${ds.title}`}
            data-cy={`switch-${ds.title}`}
            type="switch"
            label={ds.title}
            checked={ds.checked}
            on:change={e => updateReportSelection("dataScopes", ds.title, e.target.checked)}
            reverse
          />
        </FormGroup>
      {/each}
      {#if showAllUnchecked}<span class="datascopeSpan" data-cy="datascopesSpan">You must have at least one Data Scope checked.</span>{/if}
    </AccordionItem>
    <AccordionItem header="Benchmark" data-cy="BenchmarkFilterAccordion" class="dataCyBenchmarkFilterAccordion">
      {#if $reportSelectionStore.benchmarks.length === 0}
        <Alert data-cy="noBenchmarksFilterAlert" color="warning">There are no benchmarks associated to this project version.</Alert>
      {/if}
      {#each $reportSelectionStore.benchmarks.sort((a, b) => a.orderDataType - b.orderDataType) as b, i}
        <FormGroup>
          <Input
            id={`benchmark-switch-${b.id}`}
            data-cy={`benchmark-switch-${b.id}`}
            type="switch"
            label={`Market ${b.longAlias}`}
            checked={b.checked}
            on:change={e => updateReportSelection("benchmarks", b.id, e.target.checked)}
            reverse
          />
        </FormGroup>
        <div class:d-none={!b.checked}>
          <MultiSelect
            title="percentiles"
            key={`selectedPercentiles-${b.title}`}
            id={`selectedPercentiles-${b.title}`}
            values={b.percentiles.map(p => ({ text: p, value: p }))}
            onChange={updatePercentiles}
            defaultValues={b.checked ? b.percentiles : []}
          />
          <FormGroup class="ms-3 mt-2">
            <Label for={`comparisons-${i}`}>Comparison</Label>
            <MultiSelect
              title="comparison"
              key={`comparisons-${b.title}`}
              id={`comparisons-${b.title}`}
              values={$reportSelectionStore.benchmarks.map(b => ({ text: `Client ${b.longAlias}`, value: b.id }))}
              onChange={updatePercentiles}
              defaultValues={[b.id]}
            />
          </FormGroup>
          {#if b.comparisons?.length > 0}
            {#each b.comparisons as client}
              <FormGroup class="ms-3 mt-2">
                <Label for={`comparisons-${i}`}>
                  Client {$reportSelectionStore.benchmarks.find(b => b.id === client.id).longAlias}
                  <br />Ratio to Market Percentiles
                </Label>
                <MultiSelect
                  title="comparison"
                  key={`${b.id}-${client.id}-${client.title}`}
                  id={`${b.id}-${client.id}-${client.title}`}
                  values={b.percentiles.map(p => ({ text: p, value: p }))}
                  defaultValues={[50]}
                  onChange={updateComparisonPercentiles}
                />
              </FormGroup>
            {/each}
          {/if}
        </div>
      {/each}
      {#if showBenchmarkUnchecked}
        <span class="benchmarksSpan" data-cy="benchmarksSpan"> You must have at least one Benchmark checked. </span>
      {/if}
    </AccordionItem>
    <AccordionItem header="Filters" class="filtersAccordion" data-cy="filtersAccordionJobGroup">
      {#if $reportSelectionStore.jobGroups.length === 0}
        <Alert data-cy="noJobGroupsFilterAlert" color="warning">There are no job groups associated to this project version.</Alert>
      {/if}

      {#if $reportSelectionStore.jobGroups?.length > 0}
        <div class="p-2">
          <div class="settingText" data-cy="clientJobGroupLabel">Client Job Group</div>
          <div>
            <div class="multiSelectHolder p-0">
              <select id="filterSelectJobGroup" multiple class="form-control" data-cy="clientJobGroupControl">
                {#if $reportSelectionStore.jobGroups != null}
                  {#each $reportSelectionStore.jobGroups as jg}
                    <option value={jg.id} selected={jg.checked}>{jg.title}</option>
                  {/each}
                {/if}
              </select>
            </div>
          </div>
        </div>
      {/if}

      {#if $reportSelectionStore.marketSegments.length === 0}
        <Alert data-cy="noMarketSegmentsFilterAlert" color="warning">There are no market segments associated to this project version.</Alert>
      {/if}

      {#if $reportSelectionStore.marketSegments.length > 0}
        <div class="p-2">
          <div class="settingText" data-cy="marketSegmentLabel">Market Segment Name</div>
          <div>
            <div class="multiSelectHolder p-0">
              <select id="filterSelectMSName" multiple class="form-control" data-cy="marketSegmentControl">
                {#if $reportSelectionStore.marketSegments != null}
                  {#each $reportSelectionStore.marketSegments as msn}
                    <option value={msn.id} selected={msn.checked}>{msn.title}</option>
                  {/each}
                {/if}
              </select>
            </div>
          </div>
        </div>
      {/if}
    </AccordionItem>
    <div>
      <hr class="mt-3 mb-3" />
      <div class="d-flex flex-row">
        <Button block outline color="secondary" class="me-1" on:click={handleReset} data-cy="handleResetSummaryBtn">Reset</Button>
        <Button block color="primary" class="ms-1" on:click={handleApply} data-cy="handleApplySummaryBtn">Apply</Button>
      </div>
    </div>
  </Accordion>
</div>

<style>
  :global(.form-check-reverse .form-check-label) {
    float: left;
  }

  .datascopeSpan {
    font-size: 11px;
    color: #0d6efd;
  }

  .benchmarksSpan {
    font-size: 11px;
    color: #0d6efd;
  }
</style>
