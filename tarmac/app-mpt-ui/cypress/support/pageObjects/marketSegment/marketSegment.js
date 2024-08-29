class MarketSegment {
  getMarketSegmentTab() {
    return cy.get("li[data-cy=marketSegment]");
  }

  getMarketSegmentInput() {
    return cy.get('[data-cy="marketSegmentNameControl"]');
  }

  getOrganizationInput() {
    return cy.get("input#organization-input");
  }

  getAddMarketSegmentBtn() {
    return cy.get("button[data-cy=addMarketSegmentBtn]");
  }
  getEditMarketSegmentBtn() {
    return cy.get("button[data-cy=editMarketSegmentBtn]");
  }
  getUnsavedDialogMarketSegment() {
    return cy.get("div[data-cy=unsavedDialogMarketSegment]");
  }

  getExportButton() {
    return cy.get("button[data-cy=export]");
  }

  getFullscreenButton() {
    return cy.get("button[data-cy=fullscreen]");
  }

  toggleFullScreen() {
    this.getFullScreenButton().click({ force: true });
  }

  getSection(section) {
    return cy.get(`button[data-cy=${section}]`);
  }

  getMSFilterContainer() {
    return cy.get("div[data-cy=msFilterSectionContainer");
  }

  getFilterMultipleSelect(key = "publisher") {
    return cy.get(`div[data-cy=${key}-filterMultipleSelect]`);
  }

  getAutocompleteFilterInput(key = "publisher") {
    return cy.get(`div[data-cy=${key}-filterMultipleSelect]`);
  }

  getNextBtn() {
    return cy.get("button[data-cy=nextBtnMSFilters]");
  }
  clickNext() {
    this.getNextBtn().click({ force: true });
  }

  getMSSelectionCutsContainer() {
    return cy.get("div[data-cy=selectedCutsSection");
  }

  getDeleteButton() {
    return cy.get(`[data-cy="deleteMarketSegmentBtn"]`);
  }
}

export const SectionArray = [
  "accordionFiltersBtn",
  "accordionSelectedCutsBtn",
  "accordionERIBtn",
  "accordionBlendBtn",
  "accordionCombinedAveragedBtn",
];

export const inputKeysMSFilterArray = [
  {
    key: "publisher",
  },
  {
    key: "year",
  },
  {
    key: "survey",
  },
  {
    key: "industrySector",
  },
  {
    key: "organizationType",
  },
  {
    key: "cutGroup",
  },
  {
    key: "cutSubGroup",
  },
];

export default MarketSegment;
