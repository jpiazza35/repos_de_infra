<script>
  import { getClientPosition, getClientPayDetails } from "../apiMarketPricingCalls.js";
  import { onMount } from "svelte";
  import { ExpandCollaspePanel } from "../marketPricingCommon.js";

  let clientPosDet = null;
  let clientPayDet = null;
  let showClientInfo = true,
    showClientPay = true,
    showClientPos = true;
  export let globalSettings = null;
  export let projectVersion = 0;

  export function SettingsChanged(data) {
    showClientPay = data.ClientPayDetail;
    showClientPos = data.ClientPosDetail;
    showClientInfo = !(!showClientPay && !showClientPos);
  }

  export const FilterChanged = async filters => {
    let clientPosDetRes = getClientPosition(filters, projectVersion);
    let clientPayDetRes = getClientPayDetails(filters, projectVersion);

    [clientPosDet, clientPayDet] = [await clientPosDetRes, await clientPayDetRes];
  };

  onMount(async () => {
    SettingsChanged(globalSettings);
  });
</script>

<div class="row" style:display={!showClientInfo ? "none" : ""}>
  {#if clientPosDet != null && clientPosDet.length > 0}
    <div style:display={!showClientPos ? "none" : ""} class="col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12 mb-4" data-cy="div-clientposdetail">
      <div class="card">
        <h6 class="card-header pricing-header">
          Client Position Detail
          <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event)} />
        </h6>
        <div class="card-body pb-0">
          <div class="row" data-length={clientPosDet == null ? 0 : clientPosDet.length}>
            {#each clientPosDet as posDet, index}
              <div class="form-row col-sm-12 col-md-12 col-lg-6 col-xl-6 col-xxl-4" data-page={index}>
                <div class="form-group col-12">
                  <div style="display:contents" class="fw-bold" title={posDet.Text}>{posDet.Text} :</div>
                  <div style="display:contents" class="dataflow" title={posDet.Value}>{posDet.Value}</div>
                </div>
              </div>
            {/each}
          </div>
        </div>
      </div>
    </div>
  {/if}

  {#if clientPayDet != null && clientPayDet.length > 0}
    <div style:display={!showClientPay ? "none" : ""} class="col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12 mb-4" data-cy="div-clientpaydetail">
      <div class="card">
        <h6 class="card-header pricing-header">
          Client Pay Details
          <i class="fa fa-angle-up" aria-hidden="true" on:click={event => ExpandCollaspePanel(event)} />
        </h6>
        <div class="card-body pb-0">
          <div class="row" data-length={clientPayDet == null ? 0 : clientPayDet.length}>
            {#each clientPayDet as payDet, index}
              <div class="form-row col-sm-12 col-md-12 col-lg-6 col-xl-6 col-xxl-4" data-page={index}>
                <div class="form-group col-12">
                  <div style="display:contents" class="fw-bold" title={payDet.Text}>{payDet.Text} :</div>
                  <div style="display:contents" class="dataflow" title={payDet.Value}>{payDet.Value}</div>
                </div>
              </div>
            {/each}
          </div>
        </div>
      </div>
    </div>
  {/if}
</div>

<style>
  .dataflow {
    display: inline-block;
    width: 206px;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    position: relative;
    top: 6px;
  }
  .card-header {
    padding: 12px 1rem;
    background: #d7f0ff;
    color: #00436c;
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

  :global(.fa-disabled) {
    opacity: 0.6;
    cursor: not-allowed !important;
  }
</style>
