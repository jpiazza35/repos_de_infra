<script>
  import { useMutation } from "@sveltestack/svelte-query";
  import Modal from "components/shared/modal.svelte";
  import SurveyLevelDetails from "../modal/SurveyLevelDetails.svelte";
  import FilterMultipleSelect from "components/controls/filterMultipleSelect.svelte";
  import Loading from "components/shared/loading.svelte";
  import { saveFiltersSelectedCuts } from "api/apiCalls";
  import { MSSectionTypes, closeAllSections, navigateTo } from "./MSNavigationManager";
  import { filterStore, marketSegmentStore } from "./marketSegmentStore";

  const currentYear = new Date().getFullYear(),
    lastYear = new Date().getFullYear() - 1,
    beforeLastYear = new Date().getFullYear() - 2;

  export let isProjectStatusFinal = false;

  let showSurveyDetailsModal = false,
    surveyDetailsModalComponent = null,
    surveyDetailsModalData = {},
    publisherFilter = [],
    surveyFilter = [],
    industryFilter = [],
    orgTypeFilter = [],
    cutGroupFilter = [],
    cutSubFilter = [],
    surveyYears = [],
    surveyPublisherKeys = [],
    surveyKeys = [],
    industrySectorKeys = [],
    organizationTypeKeys = [],
    localCutGroupKeys = [],
    localCutSubGroupKeys = [],
    isEdit = false,
    notificationWidget = null,
    filterArray = [];

  // mutation to get the selected cuts
  const mutationFilterSelectedCuts = useMutation(
    async payload => {
      const response = await saveFiltersSelectedCuts(payload);
      return response.data;
    },
    {
      onSuccess: response => {
        marketSegmentStore.update(store => ({
          ...store,
          selectionCuts: response,
        }));
        navigateTo(MSSectionTypes.FILTERS, MSSectionTypes.CUTS);
      },
      onError: () => {
        notificationWidget?.show("There was an erro saving filters", "error");
      },
    },
  );

  const deleteFilterKey = cutGroupKeys => {
    localCutGroupKeys = cutGroupKeys;
    prevKeys = cutGroupKeys.slice(0, prevKeys.length - 1);
  };

  let prevKeys = [],
    isFiltersSelected;

  let keysNotEqual = cGroupKeys => cGroupKeys?.some((k, i) => k !== prevKeys[i]);
  let updateLocalCutGroupKeys = cGroupKeys => {
    cGroupKeys?.forEach((key, i) => {
      if (prevKeys[i] === undefined) {
        prevKeys.push(key);
        localCutGroupKeys = prevKeys;
      }
      if (key !== prevKeys[i]) {
        prevKeys.push(key);
        localCutGroupKeys === undefined ? (localCutGroupKeys = [key]) : localCutGroupKeys.push(key);
      }
    });
  };

  // Subscribe to filterStore to get the current filter values
  filterStore.subscribe(filters => {
    const {
      publisherFilter: publisherFilters,
      industrySectorFilter,
      surveyFilter: surveyFilters,
      organizationTypeFilter,
      cutGroupFilter: cutGroupFilters,
      cutSubGroupFilter,
      yearFilter,
      cutGroupKeys,
      cutSubGroupKeys,
    } = filters;

    publisherFilter = publisherFilters;
    industryFilter = industrySectorFilter;
    surveyFilter = surveyFilters;
    orgTypeFilter = organizationTypeFilter;
    cutGroupFilter = cutGroupFilters;
    cutSubFilter = cutSubGroupFilter;
    surveyYears = yearFilter?.map(filter => filter.name) || [];

    surveyPublisherKeys = createKeys(publisherFilter);
    surveyKeys = createKeys(surveyFilter);
    industrySectorKeys = createKeys(industrySectorFilter);
    organizationTypeKeys = createKeys(organizationTypeFilter);
    if (cutGroupKeys && cutGroupKeys.length !== 0) {
      if (cutGroupKeys.length < prevKeys.length) {
        deleteFilterKey(cutGroupKeys);
      } else if (keysNotEqual) {
        updateLocalCutGroupKeys(cutGroupKeys);
      }
    } else {
      if (cutGroupKeys !== undefined && cutGroupKeys.length === 0 && localCutGroupKeys.length > 0) {
        localCutGroupKeys = cutGroupKeys;
      }
    }
    localCutSubGroupKeys = cutSubGroupKeys; // implementar o filtro de id repetida
    isFiltersSelected = Object.values(filters).some(filter => filter.length > 0);
  });

  function createKeys(filter) {
    if (filter) return filter.flatMap(filter => filter?.keys.filter(c => !isNaN(c))) || [];
  }

  function createFilterKey(filter) {
    if (filter) {
      return filter.map(filter => {
        return {
          ...filter,
          keys: filter.keys,
        };
      });
    }
  }

  industryFilter = createFilterKey(industryFilter);
  surveyFilter = createFilterKey(surveyFilter);
  orgTypeFilter = createFilterKey(orgTypeFilter);
  publisherFilter = createFilterKey(publisherFilter);
  cutGroupFilter = createFilterKey(cutGroupFilter);
  cutSubFilter = createFilterKey(cutSubFilter);

  filterArray = [
    {
      title: "Publisher",
      key: "publisher",
      defaultValue: publisherFilter?.length > 0 && publisherFilter,
    },
    {
      title: "Year",
      key: "year",
      defaultValue: [
        {
          name: currentYear,
          key: 2,
        },
        {
          name: lastYear,
          key: 1,
        },
        {
          name: beforeLastYear,
          key: 0,
        },
      ],
    },
    {
      title: "Survey",
      key: "survey",
      defaultValue: surveyFilter?.length > 0 && surveyFilter,
    },
    {
      title: "Industry/Sector",
      key: "industrySector",
      defaultValue: industryFilter?.length > 0 && industryFilter,
    },
    {
      title: "Org Type",
      key: "organizationType",
      defaultValue: orgTypeFilter?.length > 0 && orgTypeFilter,
    },
    {
      title: "Cut Group",
      key: "cutGroup",
      defaultValue: cutGroupFilter?.length > 0 && cutGroupFilter,
    },
    {
      title: "Cut Sub Group",
      key: "cutSubGroup",
      defaultValue: cutSubFilter?.length > 0 && cutSubFilter,
    },
  ];

  marketSegmentStore.subscribe(store => {
    isEdit = store.isEditing;
  });

  function handleSaveFilters() {
    let payload = {
      SurveyPublisherKeys: surveyPublisherKeys || [],
      surveyYears: surveyYears || [],
      SurveyKeys: surveyKeys || [],
      IndustrySectorKeys: industrySectorKeys || [],
      OrganizationTypeKeys: organizationTypeKeys || [],
      CutGroupKeys: localCutGroupKeys || [],
      CutSubGroupKeys: localCutSubGroupKeys || [],
    };
    // @ts-ignore
    $mutationFilterSelectedCuts.mutate(payload);
  }

  function navigateNext() {
    if (!isProjectStatusFinal) {
      handleSaveFilters();
    } else {
      navigateTo(MSSectionTypes.FILTERS, MSSectionTypes.CUTS);
    }
  }

  function openSurveyDetailsModal() {
    showSurveyDetailsModal = true;
    surveyDetailsModalComponent = SurveyLevelDetails;
    surveyDetailsModalData = {
      selectedFilters: {
        surveyPublisherKeys,
        surveyYears,
        surveyKeys,
        industrySectorKeys,
        organizationTypeKeys,
        cutGroupKeys: localCutGroupKeys,
        cutSubGroupKeys: localCutSubGroupKeys,
      },
    };
  }
  notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
</script>

<div id="kendo-dialog" />
<div id="notification" />
<div class="accordion-item">
  <h2 class="accordion-header" id="headingFilters">
    <button
      class="accordion-button collapsed"
      data-cy="accordionFiltersBtn"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#collapseFilters"
      aria-expanded="false"
      aria-controls="collapseFilters"
      id="filtersAccordion"
      on:click={closeAllSections}
    >
      <i class="fa fa-filter" />&nbsp; Filters
    </button>
  </h2>
  <div id="collapseFilters" class="accordion-collapse collapse" aria-labelledby="headingFilters" data-bs-parent="#accordionExample">
    <div class="accordion-body" data-cy="msFilterSectionContainer">
      <div class="container-fluid msfilters">
        {#if $mutationFilterSelectedCuts.isLoading}
          <div class="overlay">
            <Loading isLoading={true} />
          </div>
        {/if}
        <div class="row mb-2 flex-column">
          {#each filterArray as autocomplete}
            <FilterMultipleSelect
              title={autocomplete.title}
              key={autocomplete.key}
              defaultValue={autocomplete.defaultValue ? autocomplete.defaultValue : []}
              disabled={isProjectStatusFinal}
            />
          {/each}
        </div>
        <div class="d-flex mt-4 mb-4">
          <div class="col-12 text-right space-between">
            <button class="btn btn-primary float-right" data-cy="viewDetailBtn" disabled={!isFiltersSelected} on:click={openSurveyDetailsModal}
              >View Details</button
            >
            <button
              class="btn btn-primary float-right"
              data-cy="nextBtnMSFilters"
              disabled={isEdit ? !isEdit : !isFiltersSelected}
              on:click={navigateNext}>Next</button
            >
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

{#if showSurveyDetailsModal}
  <Modal
    show={surveyDetailsModalComponent}
    props={surveyDetailsModalData}
    on:closed={() => {
      showSurveyDetailsModal = false;
      surveyDetailsModalComponent = null;
    }}
    closeOnEsc={true}
  />
{/if}

<style>
  .float-right {
    float: right;
    margin: 2px 5px 2px 0;
  }
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 999;
  }
</style>
