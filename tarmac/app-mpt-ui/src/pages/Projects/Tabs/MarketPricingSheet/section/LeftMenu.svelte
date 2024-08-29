<script>
  import {
    getJobGroup,
    getStatusAndCount,
    getJobCode,
    getSurveyCutColumns,
    getPercentileValues,
    getMandatoryColumns,
    getSortingFields,
  } from "../apiMarketPricingCalls.js";
  import { onMount, createEventDispatcher } from "svelte";
  import { get } from "svelte/store";
  import { SettingFilterState, UpdateSettingFilter } from "./settingsAndFilterStore.js";
  import {
    ExpandCollaspePanel,
    getPricingFilterGlobalSettingsFromSession,
    savePricingFilterGlobalSettings,
    showErrorMessage,
    getDefaultBenchmarks,
  } from "../marketPricingCommon.js";

  const dispatch = createEventDispatcher();
  let statusAndCountData = [];
  let jobCodeData = [];
  let jobGroups = null,
    leftMenu = null,
    iAgeToDate = null;
  export let globalSettings = {};
  export let projectVersion = 0;
  let mainSettingsCardBody = null,
    percentileCardBody = null,
    filterCardBody = null,
    sortByCardBody = null;

  let sortByFields = [];
  let selectedSortByFields = [];

  let mandatoryColumns = getMandatoryColumns();
  let surveyCutColumns = getSurveyColumns();

  export let marketSegments = [];
  export let benchmarks = [];
  function getSurveyColumns() {
    let list = getSurveyCutColumns();

    mandatoryColumns.forEach(function (item) {
      let itemToRemove = list.filter(sc => sc.field === item);

      if (itemToRemove.length > 0) list.splice(list.indexOf(itemToRemove[0]), 1);
    });

    return list;
  }

  const FilterByStatus = async event => {
    let filters = get(SettingFilterState);
    filters.FilterStatus = jQuery(event.target).attr("data-statuskey");

    jQuery("#statusList>button").removeClass("btn-primary").addClass("btn-secondary");
    jQuery(event.target).removeClass("btn-secondary").addClass("btn-primary");

    let marketPricingSheetID = 0;
    const sortBy = filters.SelectedSortByFields?.map(f => f.value).filter(f => f != "") || [];
    jobCodeData = await getJobCode(filters, projectVersion, sortBy);

    setTimeout(() => {
      if (jQuery("#list-jobCode>a").length != 0) {
        jQuery("#list-jobCode>a").removeClass("active");
        jQuery("#list-jobCode>a:nth-child(1)").addClass("active");
        marketPricingSheetID = jQuery("#list-jobCode>a:nth-child(1)").attr("data-jobcode");

        jQuery("#list-jobCode").animate({ scrollTop: 0 }, "fast");
      }

      UpdateSettingFilter(SettingFilterState => {
        SettingFilterState.FilterStatus = filters.FilterStatus;
        SettingFilterState.MarketPricingSheetID = marketPricingSheetID;
        return SettingFilterState;
      });

      dispatch("FilterChanged");
    }, 100);
  };

  export const StatusChanged = async detail => {
    let filters = GetFilters();
    statusAndCountData = await getStatusAndCount(filters, projectVersion);

    setTimeout(() => {
      jQuery("#statusList>button").removeClass("btn-primary").addClass("btn-secondary");
      jQuery("#statusList>button[data-statuskey=" + detail.StatusKey + "]")
        .removeClass("btn-secondary")
        .addClass("btn-primary");
    }, 100);
  };

  const FilterByJobCode = function (event) {
    let filters = get(SettingFilterState);
    filters.MarketPricingSheetID = jQuery(event.target).attr("data-jobcode");
    filters.SheetName = jQuery(event.target).attr("data-sheetname");

    UpdateSettingFilter(SettingFilterState => {
      SettingFilterState.MarketPricingSheetID = filters.MarketPricingSheetID;
      SettingFilterState.SheetName = filters.SheetName;
      return SettingFilterState;
    });

    jQuery("#list-jobCode>a").removeClass("active");
    jQuery(event.target).addClass("active");

    dispatch("FilterChanged");
  };

  onMount(async () => {
    LoadFilters();
  });

  const BindUIControls = async () => {
    // This is the survey Cut Columns dropdown
    jQuery("#filterSelectJobGroup,#filterSelectMSName,#selColumns").multiselect({
      templates: {
        button:
          '<button style="width: 165px;text-align: right;border:1px solid #e2e2e2" type="button" class="multiselect dropdown-toggle btn" data-bs-toggle="dropdown" aria-expanded="false"><span class="multiselect-selected-text"></span></button>',
      },
      buttonWidth: "203px",
      includeSelectAllOption: true,
      onDropdownShow: function () {
        jQuery(".multiselect-container label.checkbox").css("width", "203px");
        jQuery(".btn-group ul li:nth-child(1)").css("background", "#e2e2e2");
        jQuery(".btn-group ul li:nth-child(1) label a").css("color", "");
      },
      onDropdownHide: function (e) {
        let selectControl = jQuery(e.currentTarget).prev();

        if (selectControl.attr("id") != "selColumns") {
          ApplyFilter();
          RefreshResult();
        } else {
          if (selectControl.val() == null) {
            showErrorMessage("Please select at least one Survey Cut column.");
          } else {
            UpdateGlobalFilter();
          }
        }
      },
      onChange: function () {
        //UpdateGlobalFilter();
      },
      onSelectAll: function () {
        //UpdateGlobalFilter();
      },
      onDeselectAll: function () {
        //UpdateGlobalFilter();
      },
    });

    jQuery(iAgeToDate).kendoDatePicker({
      change: function () {
        if (this.value() == null) {
          const today = new Date();
          const yyyy = today.getFullYear();

          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          const formattedToday = mm + "/" + dd + "/" + yyyy;

          this.value(formattedToday);
        }

        UpdateGlobalFilter(true);
      },
      format: "MM/dd/yyyy",
      value: globalSettings.AgeToDate,
    });

    let benchmarkPercentileSelects = jQuery(".benchmarkPercentileSelect");
    benchmarkPercentileSelects.each(function () {
      jQuery(this).kendoMultiSelect({
        tagTemplate: kendo.template(
          "# if (values.length < 5) { # # for (var idx = 0; idx < values.length; idx++) { # #:values[idx]# # if (idx < values.length - 1) {#, # } # # } # # } else { # #:values.length# out of #:maxTotal# # } #",
        ),
        tagMode: "single",
        change: function () {
          UpdateGlobalFilter();
        },
      });
    });
  };

  const RefreshResult = async () => {
    let currentJobCode = 0;
    let jobCodeChanged = false;

    setTimeout(async () => {
      jQuery("#statusList>button").removeClass("btn-primary").addClass("btn-secondary");
      jQuery("#statusList>button:nth-child(1)").removeClass("btn-secondary").addClass("btn-primary");

      if (jQuery("#list-jobCode>a.active").length > 0) currentJobCode = parseInt(jQuery("#list-jobCode>a.active").attr("data-jobcode"));

      let filterStatus = 0,
        jobCode = 0,
        sheetName = "";

      if (jQuery("#statusList>button").length != 0) filterStatus = jQuery("#statusList>button:nth-child(1)").attr("data-statuskey");

      let filters = GetFilters();
      filters.FilterStatus = filterStatus;
      const sortBy =
        get(SettingFilterState)
          .SelectedSortByFields?.map(f => f.value)
          .filter(f => f != "") || [];

      jobCodeData = await getJobCode(filters, projectVersion, sortBy);

      setTimeout(() => {
        if (jQuery("#list-jobCode>a[data-jobcode=" + currentJobCode + "]").length == 0) {
          if (jQuery("#list-jobCode>a").length != 0) {
            jQuery("#list-jobCode>a").removeClass("active");
            let firstNode = jQuery("#list-jobCode>a:nth-child(1)");

            firstNode.addClass("active");
            jobCode = firstNode.attr("data-jobcode");
            sheetName = firstNode.attr("data-sheetname");

            jQuery("#list-jobCode").animate({ scrollTop: 0 }, "fast");

            jobCodeChanged = true;
          }
        }

        UpdateSettingFilter(SettingFilterState => {
          SettingFilterState.FilterStatus = filterStatus;
          SettingFilterState.MarketPricingSheetID = jobCode;
          SettingFilterState.SheetName = sheetName;
          return SettingFilterState;
        });
        if (jobCodeChanged) {
          dispatch("FilterChanged");
        }
      }, 150);
    }, 150);
  };

  export function ShowLeftMenu(show) {
    if (show) {
      jQuery(leftMenu).show();
    } else {
      jQuery(leftMenu).hide();
    }

    UpdateSettingFilter(SettingFilterState => {
      SettingFilterState.LeftMenu = show;
      return SettingFilterState;
    });
  }

  async function ApplyFilter() {
    let filters = GetFilters();

    UpdateSettingFilter(SettingFilterState => {
      SettingFilterState.JobCodeTitle = filters.JobCodeTitle;
      SettingFilterState.JobGroup = filters.JobGroup;
      SettingFilterState.MarketSegmentName = filters.MarketSegmentName;
      return SettingFilterState;
    });

    statusAndCountData = await getStatusAndCount(filters, projectVersion);
  }

  const JobTitleBlur = async () => {
    ApplyFilter();
    RefreshResult();
  };

  const JobTitleKeyUp = async e => {
    if (e.key === "Enter" || e.keyCode === 13) {
      JobTitleBlur();
    }
  };

  function GetFilters() {
    let filters = $SettingFilterState;
    filters.JobCodeTitle = jQuery("#txtFilterJobCodeTitle").val();
    filters.JobGroup = jQuery("#filterSelectJobGroup").val();
    filters.MarketSegmentName = jQuery("#filterSelectMSName").val();

    return filters;
  }

  function findNewElements(oldArray, newArray) {
    return newArray.filter(newItem => !oldArray?.find(oldItem => oldItem.ID === newItem.ID));
  }

  const LoadFilters = async () => {
    let filters = get(SettingFilterState);

    jobGroups = await getJobGroup(filters, projectVersion);

    const currentState = get(SettingFilterState);

    const newJobGroups = findNewElements(currentState.oldJobGroups, jobGroups);
    if (newJobGroups?.length > 0)
      UpdateSettingFilter(state => {
        return {
          ...state,
          oldJobGroups: jobGroups,
        };
      });

    const newMarketSegments = findNewElements(currentState.oldMarketSegments, marketSegments);
    if (newMarketSegments?.length > 0)
      UpdateSettingFilter(state => {
        return {
          ...state,
          oldMarketSegments: marketSegments,
        };
      });

    if (filters.LeftMenu) jQuery(leftMenu).show();
    else jQuery(leftMenu).hide();

    setTimeout(async () => {
      jQuery("#txtFilterJobCodeTitle").val(filters.JobCodeTitle);

      if (filters.JobGroup && filters.JobGroup.length == 1 && filters.JobGroup[0] == -1)
        jQuery("#filterSelectJobGroup option").prop("selected", true);
      else jQuery("#filterSelectJobGroup").val(filters.JobGroup);

      if (newJobGroups) {
        let correspondingOption = jQuery("#filterSelectJobGroup option").filter(function () {
          return this.value === newJobGroups[0]?.ID;
        });
        if (correspondingOption.length > 0) {
          const newCheck = jQuery("#filterSelectJobGroup option").filter(function () {
            return jQuery(this).val() === correspondingOption.text();
          });
          if (newCheck?.length > 0) newCheck.prop("selected", true);
        }
      }

      if (filters.MarketSegmentName && filters.MarketSegmentName.length == 1 && filters.MarketSegmentName[0] == -1)
        jQuery("#filterSelectMSName option").prop("selected", true);
      else jQuery("#filterSelectMSName").val(filters.MarketSegmentName);

      if (newMarketSegments) {
        let correspondingOption = jQuery("#filterSelectMSName option").filter((_, obj) => {
          return obj.text === newMarketSegments[0]?.Title;
        });

        if (correspondingOption.length > 0) {
          jQuery(correspondingOption).prop("selected", true);
        }
      }

      statusAndCountData = await getStatusAndCount(filters, projectVersion);
      sortByFields = filters.SortByFields || [];
      if (sortByFields.length == 0) {
        sortByFields = await getSortingFields();
      }

      if (filters.SelectedSortByFields?.length > 0) {
        selectedSortByFields = filters.SelectedSortByFields;
      } else {
        for (let i = 0; i < 4; i++) {
          selectedSortByFields.push({
            value: "",
            options: sortByFields,
          });
        }
      }

      RefreshResult();
      BindUIControls();

      InitExpandCollaspeLeftChildMenu(filters.LeftMainSettingsMenu, mainSettingsCardBody);
      InitExpandCollaspeLeftChildMenu(filters.LeftFilterMenu, filterCardBody);
      InitExpandCollaspeLeftChildMenu(filters.LeftPercentileMenu, percentileCardBody);
      InitExpandCollaspeLeftChildMenu(filters.LeftSortByMenu, sortByCardBody);
    }, 50);
  };

  const InitExpandCollaspeLeftChildMenu = (show, cardBody) => {
    if (show) {
      jQuery(cardBody).show();
      jQuery(cardBody).closest(".card").find(".card-header .fa-angle-down").removeClass("fa-angle-down").addClass("fa-angle-up");
    } else {
      jQuery(cardBody).hide();
      jQuery(cardBody).closest(".card").find(".card-header .fa-angle-up").removeClass("fa-angle-up").addClass("fa-angle-down");
    }
  };

  const ValidateGlobalFilter = () => {
    let result = true;

    jQuery(".benchmarkPercentileSelect select").each(function () {
      let benchmarkFilterContainer = jQuery(this).closest(".benchmarkFilterContainer");

      if (benchmarkFilterContainer.find(".onoffbutton .form-check-input").is(":checked")) {
        if (jQuery(this).data("kendoMultiSelect")?.value().length == 0) {
          showErrorMessage("Please select at least one value for " + benchmarkFilterContainer.attr("data-btitle"));
          result = false;
        }
      }
    });

    return result;
  };

  const UpdateGlobalFilter = avgReCalc => {
    if (!ValidateGlobalFilter()) return false;

    globalSettings = getPricingFilterGlobalSettingsFromSession();
    let mainSettingsCard = jQuery(mainSettingsCardBody);

    globalSettings.OrgName = mainSettingsCard.find("#chkShowOrgName").is(":checked");
    globalSettings.ReportDate = mainSettingsCard.find("#chkShowReportDate").is(":checked");
    globalSettings.ClientPosDetail = mainSettingsCard.find("#chkShowClientPosDetail").is(":checked");
    globalSettings.ClientPayDetail = mainSettingsCard.find("#chkShowClientPayDetail").is(":checked");
    globalSettings.MarketSegmentName = mainSettingsCard.find("#chkShowMarketSegmentName").is(":checked");
    globalSettings.JobMatchDetail = mainSettingsCard.find("#chkShowJobMatchDetail").is(":checked");

    if (jQuery(iAgeToDate).length > 0) {
      let dateValue = jQuery(iAgeToDate).data("kendoDatePicker")?.value();
      let isoDateString = dateValue.toISOString();
      globalSettings.AgeToDate = isoDateString;
    }

    globalSettings.SurveyCutColumns = mainSettingsCard.find("#selColumns").val();
    globalSettings.AgeChanged = avgReCalc;
    globalSettings.Benchmarks = [];

    if (avgReCalc) {
      benchmarks = getDefaultBenchmarks(benchmarks);
    }

    jQuery(".benchmarkPercentileSelect").each(function () {
      const benchmarkFilterContainer = jQuery(this).closest(".benchmarkFilterContainer");
      const currBenchmark = benchmarks.find(c => c.Value === parseInt(benchmarkFilterContainer.attr("data-key")));
      const percentileMultiSelect = jQuery(this)?.data("kendoMultiSelect");

      let percentileObject = {};
      if (benchmarkFilterContainer.find(".onoffbutton .form-check-input").is(":checked")) {
        if (avgReCalc) {
          percentileObject = {
            id: currBenchmark.Value,
            title: currBenchmark.Text,
            agingFactor: currBenchmark.AgingFactor,
            percentiles: percentileMultiSelect ? percentileMultiSelect.value() || [] : [],
          };
        } else {
          percentileObject = {
            id: currBenchmark.Value,
            title: currBenchmark.Text,
            agingFactor: 0,
            percentiles: percentileMultiSelect ? percentileMultiSelect.value() || [] : [],
          };
        }
      }

      if (percentileMultiSelect) {
        const existingBenchmarkIndex = globalSettings.Benchmarks.findIndex(b => b.id === percentileObject.id);
        if (existingBenchmarkIndex !== -1) {
          globalSettings.Benchmarks[existingBenchmarkIndex] = percentileObject;
        } else {
          globalSettings.Benchmarks.push(percentileObject);
        }
      }
    });

    savePricingFilterGlobalSettings(globalSettings);

    dispatch("SettingsChanged", {
      settings: globalSettings,
    });
  };

  if (
    globalSettings?.SurveyCutColumns?.length == 0 ||
    (globalSettings?.SurveyCutColumns?.length == 1 && globalSettings?.SurveyCutColumns[0] == "-1")
  ) {
    surveyCutColumns.forEach(item => {
      item.selected = true;
    });
  } else {
    surveyCutColumns.forEach(item => {
      globalSettings?.SurveyCutColumns?.forEach(item2 => {
        if (item2 == item.field) item.selected = true;
      });
    });
  }

  benchmarks.forEach(function (item) {
    globalSettings.Benchmarks.forEach(item2 => {
      if (item2.id == item.Value) {
        item["Selected"] = true;
        item["Percentile"] = item2.percentiles;
      }
    });
  });
  let myBenchmarks = benchmarks;

  if (globalSettings.Benchmarks && globalSettings.Benchmarks.length == 0) {
    benchmarks = getDefaultBenchmarks(benchmarks);
    myBenchmarks = JSON.parse(JSON.stringify(benchmarks));
  }

  const resetSortByFields = () => {
    selectedSortByFields.forEach(sf => {
      sf.value = "";
      sf.options = sortByFields;
    });

    selectedSortByFields = [...selectedSortByFields];
    applySortByFields();
  };

  const applySortByFields = async () => {
    UpdateSettingFilter(SettingFilterState => {
      SettingFilterState.SelectedSortByFields = selectedSortByFields;
      SettingFilterState.SortByFields = sortByFields;
      return SettingFilterState;
    });

    jQuery("#list-jobCode>a").removeClass("active");
    await RefreshResult();
  };

  const getNumberSuffix = i => {
    if (i == 1) return "st";
    if (i == 2) return "nd";
    if (i == 3) return "rd";
    return "th";
  };

  $: if (selectedSortByFields) {
    selectedSortByFields.forEach(sf => {
      sf.options = sortByFields.filter(s => !selectedSortByFields.some(s2 => s2.value == s.id && s2.value != sf.value));
    });
  }
</script>

<div id="leftMenu" bind:this={leftMenu}>
  <div class="card">
    <h6 class="card-header pricing-header">
      Main Settings <i
        class="fa fa-info-circle circle1"
        aria-hidden="true"
        data-toggle="tooltip"
        data-placement="right"
        title="*All changes made here will affect everyone working on this project version."
      />
      <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event, "LeftMainSettingsMenu")} />
    </h6>
    <div class="card-body pb-0 mb-1" bind:this={mainSettingsCardBody}>
      <div class="d-flex mainSettings mt-1">
        <div class="settingText">Organization Name</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowOrgName"
            checked={globalSettings.OrgName}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>

      <div class="d-flex mainSettings">
        <div class="settingText">Report Date</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowReportDate"
            checked={globalSettings.ReportDate}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>

      <div class="d-flex mainSettings">
        <div class="settingText">Client Position Detail</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowClientPosDetail"
            checked={globalSettings.ClientPosDetail}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>

      <div class="d-flex mainSettings">
        <div class="settingText">Client Pay Detail</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowClientPayDetail"
            checked={globalSettings.ClientPayDetail}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>

      <div class="d-flex mainSettings">
        <div class="settingText">Job Match Detail</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowJobMatchDetail"
            checked={globalSettings.JobMatchDetail}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>

      <div class="d-flex mainSettings">
        <div class="settingText">Market Segment Name</div>
        <div style="flex:auto" />
        <div class="form-check form-switch onoffbutton">
          <input
            class="form-check-input"
            type="checkbox"
            role="switch"
            id="chkShowMarketSegmentName"
            checked={globalSettings.MarketSegmentName}
            on:change={() => UpdateGlobalFilter()}
          />
        </div>
      </div>
      <hr class="hr m-0" />
      <div class="p-2">
        <div class="settingText">Survey Cut Columns</div>
        <div>
          <div class="multiSelectHolder">
            <select id="selColumns" multiple class="form-control" on:change={UpdateGlobalFilter}>
              {#if surveyCutColumns != null}
                {#each surveyCutColumns as column}
                  <option value={column.field} selected={column.selected}>{column.title}</option>
                {/each}
              {/if}
            </select>
          </div>
        </div>
      </div>
      <hr class="hr mt-1 mb-1" />
      <div class="d-flex mainSettings" data-cy="ageToDateSection">
        <div class="settingText" data-cy="ageToDateLabel">Age to Date</div>
        <div style="flex:auto" />
        <div style="width:140px">
          <input class="datepicker me-2" id="iAgeToDate" bind:this={iAgeToDate} data-cy="ageToDatePicker" />
        </div>
      </div>
    </div>
  </div>

  <div class="card mt-3">
    <h6 class="card-header pricing-header">
      Percentiles <i
        class="fa fa-info-circle circle2"
        aria-hidden="true"
        title="*All changes made here will affect everyone working on this project version."
      />
      <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event, "LeftPercentileMenu")} />
    </h6>
    <div class="card-body pb-0 mb-2" bind:this={percentileCardBody}>
      {#each myBenchmarks as bc}
        <div class="benchmarkFilterContainer" data-btitle={bc.Text} data-key={bc.Value}>
          <div class="d-flex mainSettings percentileSetting">
            <div class="settingText">
              {bc.Text}
            </div>
            <div style="flex:auto" />
            <div class="form-check form-switch onoffbutton">
              <input class="form-check-input" type="checkbox" role="switch" checked={bc["Selected"]} on:change={UpdateGlobalFilter} />
            </div>
          </div>
          <div class="mpsFilterLeft">
            <select multiple data-placeholder="Select Percentile..." class="benchmarkPercentileSelect">
              {#each getPercentileValues(bc["Percentile"]) as percentile}
                <option value={percentile.Text} selected={percentile.Selected}>{percentile.Text}</option>
              {/each}
            </select>
          </div>
        </div>
      {/each}
    </div>
  </div>

  <div class="card mt-3">
    <h6 class="card-header pricing-header">
      Filters
      <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event, "LeftFilterMenu")} />
    </h6>
    <div class="card-body pb-0" bind:this={filterCardBody}>
      <div class="d-flex flex-column">
        <div class="p-2">
          <div class="settingText">Client Job Code or Title</div>
          <div class="">
            <input
              class="form-control"
              id="txtFilterJobCodeTitle"
              on:blur={JobTitleBlur}
              on:keyup={JobTitleKeyUp}
              name=""
              data-cy="txtFilterJobCodeTitle-input"
              title=""
              type="text"
            />
          </div>
        </div>
        <div class="p-2">
          <div class="settingText">Client Job Group</div>
          <div>
            <div class="multiSelectHolder p-0">
              <select id="filterSelectJobGroup" multiple class="form-control">
                {#if jobGroups != null}
                  {#each jobGroups as jg}
                    <option value={jg.ID}>{jg.Title}</option>
                  {/each}
                {/if}
              </select>
            </div>
          </div>
        </div>
        <div class="p-2">
          <div class="settingText">Market Segment Name</div>
          <div>
            <div class="multiSelectHolder p-0">
              <select id="filterSelectMSName" multiple class="form-control">
                {#if marketSegments != null}
                  {#each marketSegments as msn}
                    <option value={msn.ID}>{msn.Title}</option>
                  {/each}
                {/if}
              </select>
            </div>
          </div>
        </div>
        <div class="p-2">
          <hr class="m-0" />
        </div>
        <div class="p-2">
          <div id="statusList">
            {#each statusAndCountData as status}
              <button
                type="button"
                class="btn btn-secondary mt-1"
                data-statusKey={status.StatusKey}
                data-toggle="button"
                aria-pressed="false"
                on:click={e => FilterByStatus(e)}
              >
                {status.StatusName} - {status.Count}
              </button>
            {/each}
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mt-3">
    <h6 class="card-header pricing-header">
      Sort By
      <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event, "LeftSortByMenu")} />
    </h6>
    <div class="card-body pb-0" bind:this={sortByCardBody}>
      {#if selectedSortByFields?.length > 0}
        <div class="d-flex flex-column">
          {#each selectedSortByFields as sf, i}
            <div class="p-2 d-flex align-items-center">
              <div class="settingText">{i + 1}{getNumberSuffix(i + 1)}</div>
              <div class="pl-3 w-100">
                <select class="form-select" data-cy="sortByField-{i + 1}" bind:value={sf.value}>
                  <option value="">Select</option>
                  {#each sf.options as s}
                    <option value={s.id}>{s.name}</option>
                  {/each}
                </select>
              </div>
            </div>
          {/each}
          <div class="p-2">
            <hr class="m-0" />
          </div>
          <div class="p-2">
            <div class="d-flex justify-content-end pl-3">
              <button class="btn btn-outline-primary mx-2 text-align-center" on:click={resetSortByFields}>Reset</button>
              <button class="btn btn-primary text-align-center" on:click={applySortByFields}>Apply</button>
            </div>
          </div>
        </div>
      {/if}
    </div>
  </div>

  <hr class="mt-4" />
  <div id="list-jobCode" class="list-group">
    {#each jobCodeData as code}
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="javascript:void(0)" class="jobTitleMSP" on:click={e => FilterByJobCode(e)} data-jobcode={code.Value} data-sheetName={code.SheetName}
        >{code.Text}</a
      >
    {/each}
  </div>
</div>

<style>
  .text-align-center {
    text-align: center !important;
  }

  .jobTitleMSP {
    width: 220px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    padding: 2px 6px;
    color: var(--bs-primary);
    cursor: pointer;
    text-decoration: none;
  }

  .mpsFilterLeft {
    padding: 0px 7px;
  }

  :global(.mpsFilterLeft .k-input-inner) {
    width: 60px;
  }

  .pl-3 {
    padding-left: 0.5rem !important;
  }

  .pricing-header i.fa {
    top: 2px;
    font-size: 25px;
  }

  .circle1 {
    font-size: 10px;
    left: 93px;
  }

  .circle2 {
    font-size: 10px;
    left: 80px;
  }

  #leftMenu {
    /*display: none;*/
    width: 265px;
    padding-right: 9px;
  }

  #leftMenu button {
    width: 200px;
    text-align: left;
    font-size: 12px;
  }

  #list-jobCode {
    max-height: 600px;
    overflow-y: auto;
    border-radius: 0px;
    font-style: italic;
  }

  :global(#list-jobCode > .active) {
    color: #fff;
    background-color: #0076be;
    text-decoration: none;
  }

  .card-body {
    padding: 0px;
  }

  .mainSettings {
    padding: 3px 0px 3px 5px;
  }

  .settingText {
    font-size: 12px;
    font-weight: bold;
  }

  .card-header:first-child {
    padding: 6px 7px;
    color: #262628;
    background-color: #ffff;
    font-size: 13px;
  }

  .pricing-header i.fa {
    top: 3px;
    font-size: 20px;
  }

  .percentileSetting {
    position: relative;
    top: 3px;
  }

  .percentileSetting > .settingText {
    top: 5px;
    position: relative;
  }
</style>
