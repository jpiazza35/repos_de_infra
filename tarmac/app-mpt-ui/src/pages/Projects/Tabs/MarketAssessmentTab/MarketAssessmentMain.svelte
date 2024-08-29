<script>
  import { Accordion, AccordionItem, FormGroup, Input } from "sveltestrap";
  import DistributionOfBasePayCompetitiveness from "./Graphs/DistributionOfBasePayCompetitiveness.svelte";
  import BasePayCompetitiveness from "./Graphs/BasePayCompetitiveness.svelte";
  import { onMount } from "svelte";
  import { promiseWrap } from "utils/functions";
  import { getMarketComparisionData } from "api/apiCalls";

  export let inputFilterOrgId, inputFilterProjectId, inputFilterProjectVersionId;
  let showSideMenu = true;

  const graphicOptions = [
    "Base Pay Market Comparison",
    "Distribution of Incumbent Base Pay Competitiveness Against Market",
    "Base Pay Competitiveness Against Market by Years of Experience",
    "Base Pay Competitiveness Against Market by Tenure",
  ];
  let viewGraphicsGroup = graphicOptions[0];

  $: isFiltersSelected = inputFilterOrgId > 0 && inputFilterProjectId > 0 && inputFilterProjectVersionId > 0;

  const ShowLeftMenu = () => {
    showSideMenu = !showSideMenu;
    const marketAssesmentGraphsId = document.getElementById("market-assesment-graphs");
    if (marketAssesmentGraphsId) {
      marketAssesmentGraphsId.className = showSideMenu ? "col-sm-9 col-md-9 col-lg-9" : "col-sm-12 col-md-12 col-lg-12";
    }
  };

  onMount(async () => {
    const [response] = await promiseWrap(getMarketComparisionData(inputFilterProjectVersionId));
    console.log(response);
  });
</script>

{#if !isFiltersSelected}
  <div class="alert alert-primary" role="alert" data-cy="filterSelectCy">
    To visualize Market Assessment, please select
    <span class="alert-link">
      {!inputFilterOrgId ? "Organization, " : ""}
      {!inputFilterProjectId ? "Project ID, " : ""}
      {!inputFilterProjectVersionId ? " Project Version." : ""}
    </span>
  </div>
{:else}
  <div class="col-sm-12 col-md-12 col-lg-12 d-flex justify-content-between">
    {#if showSideMenu}
      <div id="market-assesment-side-menu" class="col-sm-3 col-md-3 col-lg-3 pe-3 d-flex flex-column justify-content-between">
        <Accordion style="overflow: visible">
          <AccordionItem active header="View Graphics" id="view-graphics-accordion-item">
            <!-- Add a radio button group with 4 possible options -->
            <FormGroup>
              <Input id="r1" type="radio" bind:group={viewGraphicsGroup} value={graphicOptions[0]} label={graphicOptions[0]} />
              <Input id="r2" type="radio" bind:group={viewGraphicsGroup} value={graphicOptions[1]} label={graphicOptions[1]} />
              <Input id="r3" type="radio" bind:group={viewGraphicsGroup} value={graphicOptions[2]} label={graphicOptions[2]} />
              <Input id="r4" type="radio" bind:group={viewGraphicsGroup} value={graphicOptions[3]} label={graphicOptions[3]} />
            </FormGroup>
          </AccordionItem>
          <AccordionItem header="Future Options" id="future-options-accordion-item" />
        </Accordion>
      </div>
    {/if}
    <div id="market-assesment-graphs" class="col-sm-9 col-md-9 col-lg-9">
      <div class="d-flex flex-row align-items-center justify-content-between">
        <button class="btn btn-primary" on:click={ShowLeftMenu} data-cy="hideShowFilterPaneBtn">
          <i class="fa {showSideMenu ? 'fa-angle-double-left' : 'fa-angle-double-right'}  fa-md" />
          {showSideMenu ? "Hide Pane" : "Show Pane"}
        </button>
      </div>
      <div>
        {#if viewGraphicsGroup === graphicOptions[0]}
          <h5 class="chart-label">{graphicOptions[0]}</h5>
          <BasePayCompetitiveness />
        {/if}
        {#if viewGraphicsGroup === graphicOptions[1]}
          <h5 class="chart-label">{graphicOptions[1]}</h5>
          <DistributionOfBasePayCompetitiveness />
        {/if}
        {#if viewGraphicsGroup === graphicOptions[2]}
          <h5 class="chart-label">{graphicOptions[2]}</h5>
          <BasePayCompetitiveness />
        {/if}
        {#if viewGraphicsGroup === graphicOptions[3]}
          <h5 class="chart-label">{graphicOptions[3]}</h5>
          <DistributionOfBasePayCompetitiveness />
        {/if}
      </div>
    </div>
  </div>
{/if}

<style>
  .chart-label {
    text-align: center;
    margin-top: 40px;
  }
</style>
