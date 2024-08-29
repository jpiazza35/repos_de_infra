<script>
  import { onMount, createEventDispatcher } from "svelte";
  import { promiseWrap } from "utils/functions";
  import { getSearchStandards } from "api/apiCalls";

  export let selectedStandards = [];
  export let disabled = false;
  export let isValid;
  export let isLoading;
  export let searchStandards = [];
  export let searchStandardInput;

  let notificationWidget = null;
  let inProgress = false;
  let isSearchBtnClicked = false;

  const dispatch = createEventDispatcher();

  $: total = selectedStandards.map(item => item.blendPercent).reduce((a, b) => a + b, 0);
  $: isValid = selectedStandards.length > 0 && total == 100 && isBlendNoteValid && isBlendPercentValid;
  $: isBlendNoteValid = selectedStandards.length <= 1 || (selectedStandards.length > 1 && selectedStandards.some(item => item.blendNote.trim()));
  $: isBlendPercentValid =
    (selectedStandards.length == 1 && total == 100) ||
    (selectedStandards.length > 1 && total == 100 && selectedStandards.every(item => item.blendPercent <= 99));
  $: if (searchStandardInput) {
    isSearchBtnClicked = false;
  }

  onMount(async () => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");

    // Adding keypress event listener to the search standard input.
    var input = document.getElementById("searchStandardsInput");
    input.addEventListener("keypress", function (event) {
      if (event.key === "Enter") {
        event.preventDefault();
        getSearchStandardsData();
      }
    });
  });

  const getSearchStandardsData = async () => {
    searchStandards = [];
    if (searchStandardInput?.length < 3) {
      return;
    }

    isSearchBtnClicked = true;

    inProgress = true;
    const request = { standardJobSearch: searchStandardInput };
    const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getSearchStandards(request));
    inProgress = false;
    if (searchStandardsDataError) {
      notificationWidget.show("Error while fetching search standards data", "error");
      return;
    }

    searchStandards = searchStandardsData || [];
    if (searchStandards.length > 0) {
      searchStandards = searchStandards.filter(item => !selectedStandards.some(selectedItem => selectedItem.standardJobCode == item.standardJobCode));
    }
  };

  const selectStandard = async standard => {
    standard.blendPercent = 0;
    standard.blendNote = "";
    selectedStandards = [...selectedStandards, standard];
    searchStandards = [];
    searchStandardInput = "";

    if (selectedStandards.length == 1) {
      selectedStandards[0].blendPercent = 100;
    }

    if (selectedStandards.length == 2) {
      selectedStandards[0].blendPercent = 0;
    }
    selectedStandards = [...selectedStandards];
    notifyParent();
  };

  const removeStandard = i => {
    selectedStandards = selectedStandards.filter((item, index) => index !== i);
    if (selectedStandards.length == 1) {
      selectedStandards[0].blendPercent = 100;
    }
    notifyParent();
  };

  const notifyParent = () => {
    const selectedStandardJobCodes = selectedStandards.map(item => item.standardJobCode);
    dispatch("standardSelectionChange", { selectedStandardJobCodes });
  };
</script>

<div class="row my-4">
  <div class="col-12">
    <div class="card border">
      <div class="card-header">
        <h6 class="my-1" data-cy="searchStandards">Search Standards</h6>
      </div>
      <div class="card-body">
        <div>
          <div style="height: 20px;">
            {#if searchStandardInput?.length > 0 && searchStandardInput?.length < 3}
              <span class="my-3 text-danger" data-cy="searchInputLengthWarning">Must type at least 3 characters to search</span>
            {/if}
          </div>

          <div class="d-flex col-lg-6 col-sm-12 col-md-8">
            <input
              type="text"
              class="form-control searchStandardsInput"
              id="searchStandardsInput"
              data-cy="searchStandardsInput"
              autocomplete="off"
              placeholder="Search by Job Code and Job Title"
              bind:value={searchStandardInput}
              {disabled}
            />
            <button
              class="btn btn-secondary rounded-0"
              data-cy="searchStandardSearchButton"
              on:click={getSearchStandardsData}
              disabled={searchStandardInput.length < 3 || inProgress}
            >
              <i class="bi bi-search" />
            </button>
          </div>
          {#if inProgress}
            <ul id="autocomplete-items-list">
              <li class="autocomplete-items p-0">
                <table class="table mb-0">
                  <thead>
                    <tr class="col-12">
                      <td class="border border-right col-3">Loading...</td>
                    </tr>
                  </thead>
                </table>
              </li>
            </ul>
          {/if}
          {#if searchStandards.length > 0}
            <ul id="autocomplete-items-list">
              <li class="autocomplete-items p-0">
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a href="javascript:void(0)" class="w-100 d-flex text-decoration-none autocomplete-header">
                  <div class="border border-right text-truncate p-2 header" style="width: 10%;" data-cy="headerCode">Code</div>
                  <div class="border border-right text-truncate p-2 header" style="width: 40%;" data-cy="headerTitle">Title</div>
                  <div class="border border-right text-truncate p-2 header" style="width: 50%;" data-cy="headerDescription">Description</div>
                </a>
              </li>
              {#each searchStandards as searchStandard}
                <li class="autocomplete-items p-0">
                  <!-- svelte-ignore a11y-invalid-attribute -->
                  <a href="javascript:void(0)" class="w-100 d-flex text-decoration-none text-dark" on:click={() => selectStandard(searchStandard)}>
                    <div class="border border-right text-truncate p-2" style="width: 10%;" title={searchStandard.standardJobCode}>
                      {searchStandard.standardJobCode}
                    </div>
                    <div class="border border-right text-truncate p-2" style="width: 40%;" title={searchStandard.standardJobTitle}>
                      {searchStandard.standardJobTitle}
                    </div>
                    <div class="border border-right text-truncate p-2" style="width: 50%;" title={searchStandard.standardJobDescription}>
                      {searchStandard.standardJobDescription}
                    </div>
                  </a>
                </li>
              {/each}
            </ul>
          {/if}
          {#if !inProgress && searchStandards.length == 0 && searchStandardInput.length > 2 && isSearchBtnClicked}
            <ul id="autocomplete-items-list">
              <li class="autocomplete-items p-0">
                <table class="table mb-0">
                  <thead>
                    <tr class="col-12">
                      <td class="border border-right col-3">No results found</td>
                    </tr>
                  </thead>
                </table>
              </li>
            </ul>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>
<div class="row my-4">
  <div class="col-12">
    <div class="card border">
      <div class="card-header">
        <h6 class="my-1" data-cy="selectedStandards">Selected Standards</h6>
      </div>
      <div class="card-body">
        <table class="standard-table m-2 col-12">
          <thead>
            <tr style="background: #D6D6D7">
              {#if !disabled}
                <th style="width: 3%" />
              {/if}
              <th style="width: 18%">Job Code</th>
              <th style="width: 30%">Job Title</th>
              <th style="width: 30%">Job Description</th>
              <th style="width: 20%">Blend Percent</th>
            </tr>
          </thead>
          <tbody>
            {#if isLoading}
              <tr>
                <td colspan="6" style="text-align: center;">Loading...</td>
              </tr>
            {:else if selectedStandards.length === 0}
              <tr>
                <td colspan="6" style="text-align: center;">No Standards Selected</td>
              </tr>
            {:else}
              {#each selectedStandards as standard, i}
                <tr>
                  {#if !disabled}
                    <td style="text-align: center; font-size: 15px; cursor: pointer;">
                      <!-- svelte-ignore a11y-click-events-have-key-events -->
                      <i class="bi bi-trash" on:click={() => removeStandard(i)} />
                    </td>
                  {/if}
                  <td>{standard.standardJobCode}</td>
                  <td style="max-width: 100px;"><div class="text-truncate" title={standard.standardJobTitle}>{standard.standardJobTitle}</div></td>
                  <td style="max-width: 100px;"
                    ><div class="text-truncate" title={standard.standardJobDescription}>{standard.standardJobDescription}</div></td
                  >
                  <td>
                    <input type="number" class="form-control" placeholder="Blend Percentage" step="1" bind:value={standard.blendPercent} {disabled} />
                  </td>
                </tr>
              {/each}
              <tr style="background: #EBF6FE">
                <td colspan={disabled ? 3 : 4} style="text-align: right;">Total</td>
                <td>{total === 100 ? total : total.toFixed(2)}</td>
              </tr>
              <tr style="background: #F5F5F5">
                <td colspan={disabled ? 3 : 4} style="text-align: right;">Blend Notes</td>
                <td>
                  <input type="text" class="form-control" placeholder="Enter Blend Note" bind:value={selectedStandards[0].blendNote} {disabled} />
                </td>
              </tr>
            {/if}
          </tbody>
        </table>
        {#if !isBlendNoteValid}
          <div style="font-size: 12px; margin-left: 10px">
            <i class="fa fa-exclamation-triangle text-danger" />
            <span class="text-danger">A blend note is required to save this job match</span>
          </div>
        {/if}
        {#if selectedStandards?.length > 0 && total !== 100}
          <div style="font-size: 12px; margin-left: 10px">
            <i class="fa fa-exclamation-triangle text-danger" />
            <span class=" text-danger">A blend percent total must be equal to 100</span>
          </div>
        {/if}
        {#if selectedStandards.some(standard => !standard.blendPercent)}
          <div style="font-size: 12px; margin-left: 10px">
            <i class="fa fa-exclamation-triangle text-danger" />
            <span class=" text-danger">Each blend percent must be greater than 0</span>
          </div>
        {/if}
        {#if selectedStandards.length > 1 && selectedStandards.some(standard => standard.blendPercent > 99)}
          <div style="font-size: 12px; margin-left: 10px">
            <i class="fa fa-exclamation-triangle text-danger" />
            <span class=" text-danger">Each blend percent must be less than 99</span>
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>

<style>
  .card-header {
    background-color: #d6d6d7 !important;
  }

  .searchStandardsInput {
    border-radius: 5px 0 0 5px !important;
  }

  .standard-table thead tr th {
    border: 1px solid #d6d6d7;
    background: #747477;
    color: #ffffff;
    font-size: 14px;
    padding: 5px;
    font-weight: 500;
  }

  .standard-table tbody tr td {
    border: 1px solid #d6d6d7;
    padding: 5px;
  }

  #autocomplete-items-list {
    /*position the autocomplete items to be the same width as the container:*/
    position: absolute;
    border-bottom: none;
    border-top: none;
    z-index: 99;
    left: 0;
    right: 0;
    height: auto;
    background: #fff;
    overflow-y: auto;
    padding-left: 0px;
    margin-left: 15px;
    width: 70%;
    max-height: 300px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3), 0 0 40px rgba(0, 0, 0, 0.1) inset;
  }

  li.autocomplete-items {
    list-style: none;
    /* border: 1px solid #d4d4d4; */
    z-index: 99;
    /*position the autocomplete items to be the same width as the container:*/
    top: 100%;
    left: 0;
    right: 0;
    padding: 10px;
    cursor: pointer;
    background-color: #fff;
  }

  li.autocomplete-items:hover {
    /*when hovering an item:*/
    background-color: gray;
    color: white;
  }

  li.autocomplete-items {
    /*when navigating through the items using the arrow keys:*/
    background-color: #fff;
    color: black;
  }

  .bi-trash {
    color: #d92d20;
  }

  .autocomplete-header {
    background-color: #747477 !important;
    color: white !important;
  }
</style>
