class MarketSummary {
  getMarketSummaryTab() {
    return cy.get("li[data-cy=marketSummary]");
  }
  getSideFilterPanel() {
    return cy.get("div[data-cy=marketSummaryReportPane]");
  }

  getApplyFilterBtn() {
    return cy.get('button[data-cy="handleApplySummaryBtn"]');
  }

  getResetFilterBtn() {
    return cy.get('button[data-cy="handleResetSummaryBtn"]');
  }

  getSideMenuBtn() {
    return cy.get("button[data-cy=hideShowFilterPaneBtn]");
  }

  getExportButton() {
    return cy.get("button[data-cy=export]");
  }

  getOrganizationInput() {
    return cy.get("input#organization-input");
  }

  getFullscreenButton() {
    return cy.get("button[data-cy=fullscreen]");
  }

  hideSideMenu() {
    this.getSideMenuBtn().click({ force: true });
  }

  getDataScopeFormGroup() {
    return cy.get("div[data-cy=formGroupDataScope]");
  }

  showSideMenu() {
    this.getSideMenuBtn().click({ force: true });
  }

  getFullScreenButton() {
    return cy.get("button[data-cy=fullscreenMarketSummaryGrid]");
  }

  toggleFullScreen() {
    this.getFullScreenButton().click({ force: true });
  }

  getSummaryGrid() {
    return cy.get("div[data-cy=marketSummaryGridCy]");
  }

  exportGrid() {
    cy.get("button[data-cy=exportMarketSummaryGrid]").click({ force: true });
  }

  getOrganizationHeader() {
    return cy.get("div[data-cy=organizationHeaderMarketSummary]");
  }

  getOrganizationName() {
    return cy.get("span[data-cy=organizationNameMarketSummary]");
  }

  getOrganizationHeaderView() {
    return cy.get("span[data-cy=organizationTitleView]");
  }

  getReportDateLabel() {
    return cy.get("div[data-cy=reportDateMarketSummary]");
  }

  getReportDateValue() {
    return cy.get("span[data-cy=formatedTodayDateSummary]");
  }

  getSummaryViewBtn() {
    return cy.get("button[data-cy=summaryViewBtn]");
  }

  getNoFilterAvailableShown(type) {
    return cy.get(`div[data-cy=${type}]`);
  }

  getFilterAccordion(type) {
    return cy.get("button").filter(`:contains("${type}")`);
  }

  getSwitchInput(input) {
    return cy.get(`input[data-cy="switch-${input}"]`);
  }

  getBenchmarkSwitchInput(id) {
    return cy.get(`input[data-cy="benchmark-switch-${id}"]`);
  }

  getFilterWarningSpan(filter = "datascopes") {
    return cy.get(`span[data-cy="${filter}Span"]`);
  }

  getBenchmarkPercentile(filter = "Market Hourly Base Pay-25") {
    return cy.get(`th[data-cy="${filter}"]`);
  }
}
export default MarketSummary;
