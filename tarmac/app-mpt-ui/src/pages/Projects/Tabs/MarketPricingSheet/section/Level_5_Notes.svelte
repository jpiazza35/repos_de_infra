<script>
  import { escapeString } from "../../../../../utils/functions";
  import { getMarketSheetNotes, saveNotes } from "../apiMarketPricingCalls.js";
  import { ExpandCollaspePanel, showErrorMessage, getPricingFilterGlobalSettingsFromSession } from "../marketPricingCommon.js";

  let notes = null;
  export let globalSettings = null;
  export let benchmarks = [];
  export let marketPricingSheetID = 0;
  export let projectVersion = 0;

  export const FilterChanged = async () => {
    globalSettings = getPricingFilterGlobalSettingsFromSession();
    notes = await getMarketSheetNotes(globalSettings.AgeToDate, benchmarks, marketPricingSheetID, projectVersion);
  };

  export const SettingsChanged = async () => {
    notes = await getMarketSheetNotes(globalSettings.AgeToDate, benchmarks, marketPricingSheetID, projectVersion);
  };

  async function SaveMSPNote(event) {
    let notes = {
      Value: event.target.value && escapeString(event.target.value),
    };

    await saveNotes(marketPricingSheetID, projectVersion, notes)
      .then(() => {
        dispatchEvent(new Event("UpdateLastSave"));
      })
      .catch(() => {
        showErrorMessage("Error: Unable to save Job Match Adjustment Notes");
      });
  }

  addEventListener("FooterNotesChanged", e => {
    if (notes == null) return;

    notes.ExternalSurveyUserRestrictions = "";
    if (e.detail && e.detail.length > 0) {
      notes.ExternalSurveyUserRestrictions = e.detail.join("; ");
    }
  });
  $: notesUnescaped = notes => notes.unescapeWithTags();
</script>

<div class="row" data-cy="marketPricingNotesContainer">
  <div class="col-sm-12 col-md-12 col-lg-12">
    <div class="card">
      <h6 class="card-header pricing-header">
        Notes
        <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event)} />
      </h6>
      <div class="card-body">
        {#if notes != null}
          <form class="row g-3">
            <div class="col-sm-12 col-md-12 col-lg-12">
              <div class="row">
                <div class="col-lg-2 col-md-4 col-sm-4 fw-bold">Aging Factor</div>
                <div class="col-lg-10 col-md-8 col-sm-8" data-cy="agingFactor">
                  {notes.AgingFactor}
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-12 col-lg-12">
              <div class="row">
                <div class="col-lg-2 col-md-4 col-sm-4 fw-bold">Notes</div>
                <div class="col-lg-10 col-md-8 col-sm-8">
                  <textarea
                    class="form-control"
                    id="txtNotes"
                    data-cy="txtNotesMarketPricing"
                    rows="3"
                    value={notesUnescaped(notes.Notes)}
                    maxlength="200"
                    on:change={SaveMSPNote}
                  />
                </div>
              </div>
            </div>
            <div class="col-sm-12 col-md-12 col-lg-12">
              <div class="row">
                <div class="col-lg-2 col-md-4 col-sm-4 fw-bold">External Survey User Restrictions</div>
                <div class="col-lg-10 col-md-8 col-sm-8">
                  <textarea
                    class="form-control"
                    id="txtExternalSurveyUserRestrictions"
                    rows="3"
                    value={notes?.ExternalSurveyUserRestrictions}
                    readonly
                  />
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
  #txtExternalSurveyUserRestrictions {
    background-color: #f2f2f2;
  }

  .card-header {
    padding: 12px 1rem;
    background: #d7f0ff;
    color: #00436c;
  }
</style>
