class JobMatching {
  getJobMatchingTab() {
    return cy.get("li[data-cy=jobMatching]");
  }

  // buttons
  getJobMatchButton() {
    return cy.get("button[data-cy=jobmatchbtn]");
  }

  getStatusChangeButton() {
    return cy.get("button[data-cy=statusChangeBtn]");
  }

  getExportButton() {
    return cy.get("button[data-cy=export]");
  }

  getFullscreenButton() {
    return cy.get("button[data-cy=fullscreen]");
  }

  getSetToNoBenchmarkButton() {
    return cy.get("button[data-cy=setNoBenchmark]");
  }

  // inputs
  getOrganizationInput() {
    return cy.get("input#organization-input");
  }
  getStandardsInput() {
    return cy.get("input[data-cy=searchStandardsInput]");
  }
  getJobDescriptionControl() {
    return cy.get("textarea[data-cy=jobDescriptionControl]");
  }

  getSearchBtnInStandardSection() {
    return cy.get("button[data-cy=searchStandardSearchButton]");
  }

  getSearchInputLengthWarningText() {
    return cy.get("span[data-cy=searchInputLengthWarning]");
  }
}

export default JobMatching;
