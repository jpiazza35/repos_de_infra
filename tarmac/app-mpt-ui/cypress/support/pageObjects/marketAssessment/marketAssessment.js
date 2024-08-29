class MarketAssessment {
  getMarketAssessmentTab() {
    return cy.get("li[data-cy=marketAssessment]");
  }
}

export default MarketAssessment;
