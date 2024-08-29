<script>
  import { getHeaderInfo, getStatusAndCount, updateJobMatchStatusInfo } from "../apiMarketPricingCalls.js";
  import { onMount, createEventDispatcher } from "svelte";
  import { showErrorMessage } from "../marketPricingCommon.js";
  import { marketPricingSheetStore } from "store/marketPricingSheet.js";

  let headerInfo = null;
  let statusList = null;
  let marketPricingSheetID = null;
  const dispatch = createEventDispatcher();
  export let projectVersion = 0;
  export let showOrgName = true,
    showReportDate = true;
  export let globalSettings = null;

  export function SettingsChanged(data) {
    showOrgName = data.OrgName;
    showReportDate = data.ReportDate;
  }

  export const FilterChanged = async filters => {
    const [Promise1Result, Promise2Result] = await Promise.allSettled([
      getHeaderInfo(filters, projectVersion),
      getStatusAndCount(filters, projectVersion),
    ]);

    // @ts-ignore
    headerInfo = Promise1Result.value;
    // @ts-ignore
    statusList = Promise2Result.value;
    marketPricingSheetID = filters.MarketPricingSheetID;

    marketPricingSheetStore.update(state => {
      return {
        ...state,
        headerInfo,
        marketPricingSheetID,
      };
    });
  };

  onMount(async () => {
    SettingsChanged(globalSettings);
  });

  export const StatusChange = event => {
    let dataKey = parseInt(event.target.attributes["data-key"].value);

    updateJobMatchStatusInfo({ MarketPricingSheetID: marketPricingSheetID, StatusKey: dataKey }, projectVersion)
      .then(() => {
        dispatchEvent(new Event("UpdateLastSave"));
        headerInfo.Status = event.target.text;
        dispatch("StatusChanged", { Status: event.target.text, StatusKey: dataKey });
      })
      .catch(error => {
        if (error && error.response && error.response.data) showErrorMessage("Error: " + error.response.data);
        else showErrorMessage("Error: Unable to change the status");
      });
  };
</script>

<div class="card mb-4">
  <h5 class="card-header py-2 position-relative">
    <span class="position-absolute" style="top: 12px;">Market Pricing Sheet</span>
    {#if headerInfo != null}
      <div class="dropdown dropdown-div mx-1 float-end">
        <button class="btn btn-primary dropdown-toggle" data-cy="msp-export" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
          Status Change
        </button>

        <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
          {#each statusList as sl}
            {#if sl.StatusName != "Total" && sl.StatusName != "Not Started"}
              <li>
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a class="dropdown-item" href="javascript:void(0)" data-key={sl.StatusKey} on:click={e => StatusChange(e)}>{sl.StatusName}</a>
              </li>
            {/if}
          {/each}
        </ul>
      </div>
    {/if}
  </h5>
  <div class="card-body row pb-0">
    {#if headerInfo != null}
      <div class="form-row col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12">
        <div class="form-group col-sm-12 col-lg-6 col-xl-6 col-xxl-3" style:display={!showOrgName ? "none" : ""}>
          <div style="display:contents" class="fw-bold" title="{headerInfo.Org_Name}-{headerInfo.Org_ID}">
            {headerInfo.Org_Name}-{headerInfo.Org_ID}
          </div>
        </div>
        <div class="form-group col-sm-12 col-lg-6 col-xl-6 col-xxl-3">
          <div style="display:contents" class="fw-bold" title="Market Pricing Sheet ID">Market Pricing Sheet ID:</div>
          <div style="display:contents" title={headerInfo.SheetID}>{headerInfo.SheetID}</div>
        </div>
        <div class="form-group col-sm-12 col-lg-6 col-xl-6 col-xxl-3">
          <div style="display:contents" class="fw-bold" title="Market Pricing Status">Status:</div>
          <div style="display:contents" title={headerInfo.Status}>{headerInfo.Status}</div>
        </div>
        <div class="form-group col-sm-12 col-lg-6 col-xl-6 col-xxl-3" style:display={!showReportDate ? "none" : ""}>
          <div style="display:contents" class="fw-bold" title="Report Date">Report Date:</div>
          <div style="display:contents" title={headerInfo.ReportDate}>{headerInfo.ReportDate}</div>
        </div>
      </div>
    {/if}
  </div>
</div>

<style>
  .card-header {
    padding: 15px 1rem;
    background: #fff;
  }

  .dropdown-item {
    cursor: pointer;
  }

  .form-row {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
  }

  .form-group {
    margin-bottom: 1rem;
  }
</style>
