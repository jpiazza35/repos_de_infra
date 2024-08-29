<script>
  import { createEventDispatcher, onMount } from "svelte";
  import { searchOrganizationsByTerm, searchOrganizations } from "api/apiCalls";
  import { promiseWrap, debounce } from "utils/functions";
  import UnsavedWarning from "components/shared/unsavedWarning.svelte";

  export let removeLabel = false;
  export let isValid = true;
  export let selectedOrgValue = "";
  export let disabled = false;
  export let customClassName;
  export let inputValue = "";

  export const reset = () => resetInput();

  let searchInput;
  let hiLiteIndex = null;
  let organizationList = [];
  let filteredOrganizations = [];
  let hasUniqueOrganization = false;

  const dispatch = createEventDispatcher();

  onMount(async () => {
    inputValue = selectedOrgValue;
    await initianlSearchOrgs();
  });

  // Removing dropdown options when there is no input value
  $: if (!inputValue) {
    filteredOrganizations = [];
    hiLiteIndex = null;
  }

  // If the user has only one organization in his profile, disable the input and populate the unique org
  const initianlSearchOrgs = async () => {
    hasUniqueOrganization = false;
    const [orgData] = await promiseWrap(searchOrganizations());
    if (orgData?.length == 1) {
      hasUniqueOrganization = true;
      organizationList = orgData;
      organizationList.forEach(org => {
        filteredOrganizations = [...filteredOrganizations, org.name + " - " + org.id];
      });
      setInputVal(filteredOrganizations[0], 0);
    }
  };

  /* FILTERING org DATA BASED ON INPUT */
  const filterOrganization = async () => {
    organizationList = [];
    filteredOrganizations = [];

    if (inputValue && inputValue.length > 0) {
      const [orgData] = await promiseWrap(searchOrganizationsByTerm(inputValue));
      if (orgData) {
        organizationList = orgData;
        filteredOrganizations = [];

        organizationList.forEach(org => {
          filteredOrganizations = [...filteredOrganizations, org.name + " - " + org.id];
        });

        if (filteredOrganizations?.length == 1) {
          const canAutoSelect =
            filteredOrganizations[0].toLowerCase() === inputValue.toLowerCase() ||
            organizationList[0].name.toLowerCase() === inputValue.toLowerCase();

          if (canAutoSelect) {
            setInputVal(filteredOrganizations[0], 0);
          }
        }
      }
    } else {
      setInputVal("", 0);
    }
  };

  const setInputVal = (orgName, index) => {
    inputValue = removeBold(orgName);
    filteredOrganizations = [];
    hiLiteIndex = null;
    searchInput.focus();
    dispatch("orgSelected", organizationList[index]);
    isValid = true;
  };

  const resetInput = () => {
    inputValue = "";
    filteredOrganizations = [];
    hiLiteIndex = null;
    isValid = true;
  };

  const removeBold = str => {
    return str?.replace(/<(.)*?>/g, "");
  };

  function navigateList(e) {
    if (e.key === "ArrowDown" && hiLiteIndex <= filteredOrganizations.length - 1) {
      hiLiteIndex === null ? (hiLiteIndex = 0) : (hiLiteIndex += 1);
    } else if (e.key === "ArrowUp" && hiLiteIndex !== null) {
      hiLiteIndex === 0 ? (hiLiteIndex = filteredOrganizations.length - 1) : (hiLiteIndex -= 1);
    } else if (e.key === "Enter") {
      setInputVal(filteredOrganizations[hiLiteIndex], hiLiteIndex);
    } else {
      return;
    }
  }
</script>

<svelte:window />

<div class="form-group" on:keydown={navigateList}>
  {#if !removeLabel}
    <label for="organization-input" class="col-form-label float-left required textAlign" data-cy="orgLabel">Organization (Name or ID)</label>
  {/if}

  <div class="autocomplete">
    <UnsavedWarning onClick={() => {}}>
      <input
        id="organization-input"
        type="text"
        class={`${isValid ? "form-control" : "form-control is-invalid"} ${customClassName}`}
        data-cy="organization"
        placeholder="Select an Organization"
        bind:this={searchInput}
        bind:value={inputValue}
        on:keyup={() => {
          debounce(filterOrganization, 200)();
        }}
        autocomplete="off"
        disabled={disabled || hasUniqueOrganization}
      />

      {#if filteredOrganizations.length > 0}
        <ul id="autocomplete-items-list">
          {#each filteredOrganizations as org, i}
            <li class="autocomplete-items" class:autocomplete-active={i === hiLiteIndex} on:mouseup={() => setInputVal(org, i)}>
              {@html org}
            </li>
          {/each}
        </ul>
      {/if}
    </UnsavedWarning>
  </div>
</div>

<style>
  div.autocomplete {
    position: relative;
    display: inline-block !important;
    width: 100%;
  }

  #autocomplete-items-list {
    /*position the autocomplete items to be the same width as the container:*/
    position: absolute;
    border: 1px solid #d4d4d4;
    border-bottom: none;
    border-top: none;
    z-index: 99;
    top: 100%;
    left: 0;
    right: 0;
    height: auto;
    background: #fff;
    overflow-y: auto;
    padding-left: 0px;
    max-height: 50vh;
  }

  .textAlign {
    text-align: right;
  }

  li.autocomplete-items {
    list-style: none;
    border-bottom: 1px solid #d4d4d4;
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

  li.autocomplete-items:active {
    /*when navigating through the items using the arrow keys:*/
    background-color: DodgerBlue !important;
    color: #ffffff;
  }

  .autocomplete-active {
    /*when navigating through the items using the arrow keys:*/
    background-color: DodgerBlue !important;
    color: #ffffff;
  }
</style>
