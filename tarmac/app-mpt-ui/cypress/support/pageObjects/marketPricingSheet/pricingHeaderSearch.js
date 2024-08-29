class ProjectHeader {
  getPricingTab() {
    return cy.get("li[data-cy=marketpricingsheet]");
  }

  getOrgInputControl() {
    return "input#organization-input";
  }

  getProjectSelect() {
    return "select[data-cy=projectId]";
  }

  getProjectVersion() {
    return "select[data-cy=projectVersion]";
  }

  getPricingTabDefaultData() {
    return "#marketpricingsheetTab div.noresult";
  }

  getNotesSection() {
    return cy.get("[data-cy=marketPricingNotesContainer]");
  }

  getNotesTextArea() {
    return cy.get("textarea[data-cy=txtNotesMarketPricing]");
  }
}

export default ProjectHeader;
