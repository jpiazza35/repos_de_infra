<script>
  import { getJobMatchDetail, saveJobMatchDetail } from "../apiMarketPricingCalls.js";
  import { onMount } from "svelte";
  import { ExpandCollaspePanel, showErrorMessage, showSuccessMessage } from "../marketPricingCommon.js";
  import { marketPricingSheetStore } from "store/marketPricingSheet.js";

  let jobMatch = null;
  let showJobMatchInfo = true;
  export let globalSettings = null;
  export function SettingsChanged(data) {
    showJobMatchInfo = data.JobMatchDetail;
  }
  export let projectVersion = 0;
  export const FilterChanged = async filters => {
    jobMatch = await getJobMatchDetail(filters, projectVersion);

    marketPricingSheetStore.update(state => {
      return {
        ...state,
        jobMatchDetail: jobMatch,
      };
    });
  };

  onMount(async () => {
    SettingsChanged(globalSettings);
  });

  async function SaveJobMatchNotes(event) {
    let jobMatchDetail = {
      Value: event.target.value?.escape(),
    };

    // @ts-ignore
    let hasAdjustment = document.getElementById("hdnHasAdjustment").value == "true";

    if (hasAdjustment && event.target.value.trim().length == 0) {
      showErrorMessage("Error: Job Match Adjustment Notes cannot be empty, when there is an adjustment.");
      return;
    }
    await saveJobMatchDetail(projectVersion, jobMatch.MarketPricingSheetID, jobMatchDetail)
      .then(() => {
        showSuccessMessage("Job Match Adjustment Notes updated successfully.");
        dispatchEvent(new Event("UpdateLastSave"));
        dispatchEvent(
          new CustomEvent("JobNotesChanged", {
            detail: { text: () => event.target.value },
          }),
        );
      })
      .catch(() => {
        showErrorMessage("Error: Unable to save Job Match Adjustment Notes");
      });
  }
</script>

<div class="row mb-4" id="divJobMatchHolder" style:display={!showJobMatchInfo ? "none" : ""} data-cy="div-jobmatchdetail">
  <div class="col-sm-12 col-md-12 col-lg-12">
    <div class="card">
      <h6 class="card-header pricing-header">
        Job Match Detail
        <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event)} />
      </h6>
      <div class="card-body">
        {#if jobMatch != null}
          <form class="row g-3">
            <div class="col-sm-12 col-md-12 col-lg-12 col-xl-6 col-xxl-6">
              <div class="form-row">
                <div class="form-group col-12">
                  <div style="display:contents" class="fw-bold" title="Survey Job Match Title">Survey Job Match Title :</div>
                  <div class="dataflow2" title={jobMatch.JobTitle}>{jobMatch.JobTitle}</div>
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-12 col-lg-12 col-xl-6 col-xxl-6">
              <div class="row">
                <div class="col-lg-4 col-md-4 col-sm-4 fw-bold" data-cy="jobMatchNotesLabel">Job Match Adjustment Notes</div>
                <div class="col-lg-8 col-md-8 col-sm-8">
                  <input
                    class="form-control"
                    id="jobMatchNotes"
                    name="jobMatchNotes"
                    data-cy="jobMatchNotes-input"
                    title=""
                    type="text"
                    value={jobMatch.JobMatchNotes?.unescape()}
                    maxlength="200"
                    on:change={SaveJobMatchNotes}
                  />
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12">
              <div class="form-row">
                <div style="display:contents" class="fw-bold">Job Match Description :</div>
                <div style="display:contents">
                  {jobMatch.Description}
                </div>
              </div>
            </div>
          </form>
        {/if}
      </div>
    </div>
  </div>
</div>

<style>
  .card-header {
    padding: 12px 1rem;
    background: #d7f0ff;
    color: #00436c;
  }

  .dataflow2 {
    display: flow;
    width: 100%;
    position: relative;
    top: 6px;
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
