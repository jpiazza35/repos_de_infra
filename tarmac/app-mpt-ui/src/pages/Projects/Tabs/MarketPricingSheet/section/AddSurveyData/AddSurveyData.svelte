<script>
  import { marketPricingSheetStore, marketPricingModalStore } from "store/marketPricingSheet";

  const handleOnClickAddExternalData = () => {
    marketPricingModalStore.update(store => ({
      ...store,
      addSurveyData: false,
      addExternalData: true,
    }));
  };

  const MPSId = $marketPricingSheetStore.marketPricingSheetID;
  const clientPosDet = $marketPricingSheetStore.clientPositionDetail[0];
</script>

<div data-cy="addSurveyDataPopup">
  <div class="row">
    <div class="col-12">
      <div class="card-header card-header-sticky">
        <h5 class="my-2" data-cy="modelTitle">Add Survey Data</h5>
      </div>
      <div class="card-body pb-0">
        <div class="d-flex justify-content-between">
          <div class="d-flex align-items-center col-lg-6 col-sm-12 col-md-12">
            <span class="client-code-label">MPS ID / Client Job Code / Client Job Tittle</span>
            <div class="d-flex align-items-center flex-wrap ml-4">
              <span class="m-1 px-2 py-1 border rounded client-code-pills">
                {MPSId} - {clientPosDet.jobCode} - {clientPosDet.jobTitle}
              </span><!-- make it load dynamically-->
            </div>
          </div>
          <button class="btn btn-primary" id="mpsAddExternalData" data-cy="mpsAddExternalData" on:click={handleOnClickAddExternalData}>
            Add External Data
          </button>
        </div>

        <div class="row my-4">
          <div class="col-12">
            <div class="card border">
              <div class="card-header">
                <h6 class="my-1" data-cy="searchStandards">Search Survey Library</h6>
              </div>
              <div class="card-body">
                <div class="d-flex justify-content-between">
                  <!-- commented as this is on criteria but not in Figma -->
                  <!-- <div class="d-flex col-3">
                    <input
                      type="text"
                      class="form-control searchStandardsInput"
                      id="surveyPublisherOrName"
                      data-cy="surveyPublisherOrName"
                      autocomplete="off"
                      placeholder="Search by Survey Publisher or Survey Name"
                    />
                    <button class="btn btn-secondary rounded-0" data-cy="searchSurveyPublisherOrNameButton">
                      <i class="bi bi-search" />
                    </button>
                  </div> -->
                  <div class="d-flex col-3">
                    <input
                      type="text"
                      class="form-control searchStandardsInput"
                      id="searchSurveyCodeOrTitle"
                      data-cy="searchSurveyCodeOrTitle"
                      autocomplete="off"
                      placeholder="Search by Survey Code or Survey Title"
                    />
                    <button class="btn btn-secondary rounded-0" data-cy="searchSurveyCodeOrTitleButton">
                      <i class="bi bi-search" />
                    </button>
                  </div>
                  <div class="d-flex col-3">
                    <input
                      type="text"
                      class="form-control searchStandardsInput"
                      id="searchSurveyCut"
                      data-cy="searchSurveyCut"
                      autocomplete="off"
                      placeholder="Search by Survey Cut"
                    />
                    <button class="btn btn-secondary rounded-0" data-cy="searchSurveyCutButton">
                      <i class="bi bi-search" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="row my-4">
          <div class="col-12">
            <div class="card border">
              <div class="card-header">
                <h6 class="my-1" data-cy="selectedStandards">Selected Cut(s)</h6>
              </div>
              <div class="card-body">
                <table class="standard-table m-2 col-12">
                  <thead>
                    <tr style="background: #D6D6D7">
                      <th>Market Pricing Cut</th>
                      <th>Survey Job Code</th>
                      <th>Survey Job Title</th>
                      <th>Survey Publisher</th>
                      <th>Survey Year</th>
                      <th>Survey Name</th>
                      <th>Organization Type</th>
                      <th>Cut Group</th>
                      <th>Cut Sub-Group</th>
                      <th>Cut</th>
                    </tr>
                  </thead>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="card-footer d-flex justify-content-between">
        <div>
          <button class="btn btn-primary" data-cy="saveBtn">Save and Close</button>
        </div>
        <div />
      </div>
    </div>
  </div>
</div>

<style>
  .client-code-label {
    white-space: nowrap;
    margin-right: 10px;
    margin-left: 5px;
  }

  .standard-table thead tr th {
    border: 1px solid #d6d6d7;
    background: #747477;
    color: #ffffff;
    font-size: 14px;
    padding: 5px;
    font-weight: 500;
  }

  .searchStandardsInput {
    border-radius: 5px 0 0 5px !important;
  }
</style>
