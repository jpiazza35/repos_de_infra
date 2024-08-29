<script>
  import { useQuery } from "@sveltestack/svelte-query";
  import LeftMenu from "./section/LeftMenu.svelte";
  import TopButtons from "./section/Level_1_Top_Buttons.svelte";
  import InfoHeader from "./section/Level_2_Info_Header.svelte";
  import ClientSection from "./section/Level_3_Client_Section.svelte";
  import JobMatchDetail from "./section/Level_4_Job_Match.svelte";
  import MarketDataDetail from "./section/Level_4_Market_Data.svelte";
  import Notes from "./section/Level_5_Notes.svelte";
  import { get } from "svelte/store";
  import { SettingFilterState, benchMarkStore } from "./section/settingsAndFilterStore.js";
  import {
    castGlobalSettings,
    getPricingFilterGlobalSettingsFromSession,
    savePricingFilterGlobalSettings,
    getInitialStateOfPricingGlobalSettings,
    getDefaultBenchmarks,
  } from "./marketPricingCommon.js";
  import { getBenchmarkInfo, getMainSettingsInfo, getMarketSegmentNames } from "api/apiCalls";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;

  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;
  let fullScreen = false;
  let mpSheetMarketDataDetail, mpLeftMenu, mpSheetClientDetail, mpSheetMarketJobMatch, mpSheetInfoheader, mpHeaderTopButtons, mpSheetNotes;
  let benchmarks = [];
  let marketSegments = [];
  let globalSettings = null;
  let filters = null;
  let notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  let isLeftMenuVisible = true;

  $: if (isFiltersSelected) {
    loadBasicData();
  }

  const loadBasicData = () => {
    $queryBenchmarks.refetch();
    $querySettings.refetch();
    $queryMarketSegment.refetch();
  };

  // load benchmarks
  const queryBenchmarks = useQuery(
    ["benchmarks", inputFilterProjectVersionId],
    async () => {
      const data = await getBenchmarkInfo(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryBenchmarks.data) {
    benchmarks = $queryBenchmarks.data.map(item => ({ Text: item.name, Value: item.id, AgingFactor: item.agingFactor }));
    benchMarkStore.set(benchmarks);
  }
  $: if ($queryBenchmarks.error) {
    notificationWidget.show("Error while fetching search standards data", "error");
  }

  // load settings
  const querySettings = useQuery(
    ["settings", inputFilterProjectVersionId],
    async () => {
      const data = await getMainSettingsInfo(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($querySettings.status === "success") {
    if ($querySettings.data && $querySettings.data.length > 0) {
      let castedData = castGlobalSettings($querySettings.data);

      globalSettings = castedData;
    } else {
      globalSettings = getPricingFilterGlobalSettingsFromSession();

      if (!globalSettings) {
        globalSettings = getInitialStateOfPricingGlobalSettings();
        globalSettings.Benchmarks = getDefaultBenchmarks(benchmarks);
        savePricingFilterGlobalSettings(globalSettings);
      }
    }
  }

  $: if ($querySettings.error) {
    notificationWidget.show("Error while fetching search standards data", "error");
  }

  // load market segments
  const queryMarketSegment = useQuery(
    ["marketSegment", inputFilterProjectVersionId],
    async () => {
      const data = await getMarketSegmentNames(inputFilterProjectVersionId);
      return data.data;
    },
    { enabled: false },
  );

  $: if ($queryMarketSegment.data) {
    marketSegments = $queryMarketSegment.data.map(item => ({ Title: item.name, ID: item.id }));
  }

  $: if ($queryMarketSegment.error) {
    notificationWidget.show("Error while fetching search standards data", "error");
  }

  const ShowLeftMenu = event => {
    if (event && event.detail.isLeftMenuVisible) {
      mpLeftMenu.ShowLeftMenu(true);
    } else {
      mpLeftMenu.ShowLeftMenu(false);
    }

    mpSheetMarketDataDetail.LayoutChanged();
  };

  const StatusChanged = event => {
    mpLeftMenu.StatusChanged(event.detail);
  };

  const SettingsChanged = event => {
    globalSettings = event.detail.settings;

    if (mpSheetMarketDataDetail != null) mpSheetMarketDataDetail.SettingsChanged(globalSettings);
    if (mpSheetClientDetail != null) mpSheetClientDetail.SettingsChanged(globalSettings);
    if (mpSheetMarketJobMatch != null) mpSheetMarketJobMatch.SettingsChanged(globalSettings);
    if (mpSheetInfoheader != null) mpSheetInfoheader.SettingsChanged(globalSettings);
    if (mpHeaderTopButtons != null) mpHeaderTopButtons.SettingsChanged(globalSettings);
    if (mpSheetNotes != null) mpSheetNotes.SettingsChanged(globalSettings);
  };

  const FilterChanged = () => {
    filters = get(SettingFilterState);

    setTimeout(() => {
      if (mpSheetMarketDataDetail != null) mpSheetMarketDataDetail.FilterChanged(filters);
      if (mpSheetClientDetail != null) mpSheetClientDetail.FilterChanged(filters);
      if (mpSheetMarketJobMatch != null) mpSheetMarketJobMatch.FilterChanged(filters);
      if (mpSheetInfoheader != null) mpSheetInfoheader.FilterChanged(filters);
      if (mpSheetNotes != null) mpSheetNotes.FilterChanged(filters);
      if (mpHeaderTopButtons != null) mpHeaderTopButtons.FilterChanged(filters);
    }, 10);
  };

  const reloadMarketDataDetailGrid = () => {
    mpSheetMarketDataDetail.FilterChanged(filters);
  };

  const toggleFullScreen = () => {
    var marketSegment = jQuery("#marketpricingsheetTab");

    if (!fullScreen) {
      marketSegment.attr("old_height", marketSegment.css("height"));
      jQuery("header,nav,footer").hide();
      marketSegment.addClass("fullscreenlayer").css("overflow", "auto").css("height", document.documentElement.clientHeight);
      jQuery("body").css("overflow", "hidden");
      fullScreen = true;
      mpHeaderTopButtons.SetFullScreenButtonText("Exit Full Screen");
      window.location.hash = "fullScreen";
      isLeftMenuVisible = mpHeaderTopButtons.getIsLeftMenuVisible();

      mpHeaderTopButtons.SetLeftMenuVisible(false);

      jQuery("#marketpricingsheetTab").animate(
        {
          scrollTop: jQuery("#divMarketData").offset().top,
        },
        300,
      );
    } else {
      jQuery("header,nav,footer").show();
      marketSegment.removeClass("fullscreenlayer").css("overflow", "");
      jQuery("body").css("overflow", "");
      marketSegment.css("height", marketSegment.attr("old_height"));
      fullScreen = false;
      mpHeaderTopButtons.SetFullScreenButtonText("Full Screen");
      window.location.hash = "";
      mpHeaderTopButtons.SetLeftMenuVisible(isLeftMenuVisible);
    }

    ShowLeftMenu({ detail: { isLeftMenuVisible: mpHeaderTopButtons.getIsLeftMenuVisible() } });
  };

  window.onhashchange = function () {
    if (fullScreen && window.location.hash != "#fullScreen") {
      toggleFullScreen();
    }
  };

  $: projectVersion = inputFilterProjectVersionId;
  $: marketPricingSheetID = filters && filters.MarketPricingSheetID ? filters.MarketPricingSheetID : -1;
</script>

{#if projectVersion <= 0}
  <div class="alert alert-primary" role="alert">
    To visualize Market Pricing Sheet, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{:else if $queryBenchmarks.isLoading || $querySettings.isLoading || $queryMarketSegment.isLoading || !globalSettings}
  <span class="alert-link">Loading...</span>
{:else}
  <div class="d-flex flex-row">
    {#if benchmarks && benchmarks.length > 0}
      <LeftMenu
        bind:this={mpLeftMenu}
        on:FilterChanged={FilterChanged}
        on:SettingsChanged={SettingsChanged}
        bind:benchmarks
        bind:globalSettings
        bind:projectVersion
        bind:marketSegments
      />
    {/if}
    <div style="width: 100%;">
      <TopButtons
        on:ShowLeftMenu={ShowLeftMenu}
        on:SettingsChanged={SettingsChanged}
        on:toggleFullScreen={toggleFullScreen}
        on:externalDataModalClose={reloadMarketDataDetailGrid}
        bind:this={mpHeaderTopButtons}
        {benchmarks}
        {globalSettings}
        bind:projectVersionId={inputFilterProjectVersionId}
        bind:marketPricingSheetID
        bind:organizationId={inputFilterOrgId}
      />
      {#if filters && filters.MarketPricingSheetID && filters.MarketPricingSheetID > 0 && benchmarks && benchmarks.length > 0}
        <div>
          <InfoHeader bind:this={mpSheetInfoheader} bind:globalSettings on:StatusChanged={StatusChanged} bind:projectVersion />
          <ClientSection bind:this={mpSheetClientDetail} bind:globalSettings bind:projectVersion />
          <JobMatchDetail bind:this={mpSheetMarketJobMatch} bind:globalSettings bind:projectVersion />
          <MarketDataDetail
            bind:this={mpSheetMarketDataDetail}
            bind:globalSettings
            bind:benchmarks
            bind:projectVersion
            bind:marketPricingSheetID
            bind:marketSegments
          />
          <Notes bind:this={mpSheetNotes} bind:globalSettings bind:benchmarks bind:projectVersion bind:marketPricingSheetID />
        </div>
      {:else}
        <div class="noresult">
          <div class="alert alert-danger" role="alert">Please refine your filter.</div>
        </div>
      {/if}
    </div>
  </div>
{/if}
<div id="notification" />

<style>
  .noresult {
    font-size: 14px;
    font-weight: bold;
    color: red;
    position: relative;
    top: 0px;
    left: 10px;
  }
</style>
