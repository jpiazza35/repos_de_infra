<script>
  import { getDateString } from "utils/functions";

  export let orgName, selectedView;
  const formattedDate = getDateString(new Date());
</script>

<div class="my-4" id="organizationHeader" data-cy="organizationHeaderMarketSummary">
  <div class="org-header-section d-flex justify-content-between">
    <span class="org-header" data-cy="organizationNameMarketSummary">{orgName}</span>
    <span class="org-header" data-cy="organizationTitleView">{`${selectedView || "Job"} Summary`}</span>
    <div data-cy="reportDateMarketSummary">
      <span class="org-header">Report Date:</span> <span data-cy="formatedTodayDateSummary">{formattedDate}</span>
    </div>
  </div>
</div>

<style>
  .org-header-section {
    background: #ffffff;
    border: 1px solid #d6d6d7;
    border-radius: 4px;
    padding: 12px;
  }
  .org-header {
    font-family: "Roboto";
    font-style: normal;
    font-weight: 600;
    font-size: 14px;
    color: #262628;
  }
</style>
