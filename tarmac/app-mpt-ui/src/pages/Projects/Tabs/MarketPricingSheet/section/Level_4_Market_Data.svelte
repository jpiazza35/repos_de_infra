<script>
  let showMarketSegmentNameInfo = true;
  import { onMount } from "svelte";
  import { get } from "svelte/store";
  import { SettingFilterState, UpdateSettingFilter } from "./settingsAndFilterStore.js";

  export let marketSegments = [];
  export let benchmarks = [];
  let marketSegmentInfo = null;
  let showExcludedCuts = get(SettingFilterState).ShowExcludedCuts;
  let loading = true;
  let jobMatch = null;
  export let globalSettings = null;
  import JobMatchDetailGrid from "./Level_4_Market_Data_Grid.svelte";
  import { getJobMatchDetail } from "../apiMarketPricingCalls.js";
  let mpSheetMarketGridDataDetail = null,
    gridToggleHeight = null;
  export let projectVersion = 0;
  export let marketPricingSheetID = 0;
  export function LayoutChanged() {
    mpSheetMarketGridDataDetail.LayoutChanged();
  }

  export function SettingsChanged(data) {
    loading = true;
    mpSheetMarketGridDataDetail.SettingsChanged(data);
    mpSheetMarketGridDataDetail.ChangeExcludedCuts(showExcludedCuts);
    showMarketSegmentNameInfo = data.MarketSegmentName;
  }

  export const FilterChanged = async filters => {
    loading = true;
    let localFilter = get(SettingFilterState);
    marketSegmentInfo = { MarketSegmentName: localFilter.SheetName };
    mpSheetMarketGridDataDetail.FilterChanged(filters);
    jobMatch = await getJobMatchDetail(filters, projectVersion);
  };

  function AdjustGridHeight() {
    mpSheetMarketGridDataDetail.AdjustGridHeight();
    jQuery(gridToggleHeight).find("i").toggleClass("fa-compress fa-expand");
  }

  onMount(() => {
    SettingsChanged(globalSettings);
  });

  function ChangeExcludedCuts(e) {
    showExcludedCuts = e.target.checked;
    mpSheetMarketGridDataDetail.ChangeExcludedCuts(showExcludedCuts);

    UpdateSettingFilter(SettingFilterState => {
      SettingFilterState.ShowExcludedCuts = showExcludedCuts;
      return SettingFilterState;
    });
  }

  $: sheetName = marketSegmentInfo && marketSegmentInfo.MarketSegmentName ? marketSegmentInfo.MarketSegmentName : "";

  function GridLoadingComplete() {
    loading = false;
  }

  $: loadingStyle = loading ? "contents" : "none";
</script>

<div class="row mb-4" id="divMarketData">
  <div class="col-sm-12 col-md-12 col-lg-12">
    <div class="card position-relative">
      <h6 class="card-header">
        Market Data Detail
        <div style="display:{loadingStyle}" id="gridLoadingStatus">
          <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true" />
        </div>
      </h6>
      {#if marketSegmentInfo != null}
        <button class="btn btn-secondary me-2 position-absolute" on:click={AdjustGridHeight} bind:this={gridToggleHeight}>
          <i class="fa fa-expand fa-md" />
        </button>
      {/if}

      <div class="row showExcludedCuts">
        <div class="col-10">Show Excluded Cuts</div>
        <div class="col-2 d-flex justify-content-end">
          <div class="form-check form-switch onoffbutton">
            <input
              class="form-check-input"
              type="checkbox"
              role="switch"
              id="chkShowExcludedCuts"
              bind:checked={showExcludedCuts}
              on:change={e => ChangeExcludedCuts(e)}
            />
          </div>
        </div>
      </div>

      <div class="card-body p-0">
        {#if marketSegmentInfo != null}
          <div style:display={!showMarketSegmentNameInfo ? "none" : ""} class="p-2" data-cy="div-marketSegmentNameSection">
            <span class="fw-bold">Market Segment Name:</span>
            {sheetName}
          </div>
        {/if}
        <JobMatchDetailGrid
          bind:this={mpSheetMarketGridDataDetail}
          bind:globalSettings
          bind:benchmarks
          bind:projectVersion
          bind:marketPricingSheetID
          bind:sheetName
          bind:marketSegments
          jobMatchNotes={jobMatch?.JobMatchNotes}
          on:LoadingComplete={GridLoadingComplete}
        />
      </div>
    </div>
  </div>
</div>

<style>
  .showExcludedCuts {
    width: 202px;
    position: absolute;
    right: 56px;
    top: 8px;
    height: 26px;
    padding-top: 1px;
    color: #00436c;
  }

  .card-header {
    padding: 12px 1rem;
    background: #d7f0ff;
    color: #00436c;
  }

  .card button {
    height: 27px;
    width: 30px;
    right: 0px;
    top: 7px;
    padding: 0px;
    background: #d7f0ff;
    color: #00436c;
    border: none;
  }
</style>
