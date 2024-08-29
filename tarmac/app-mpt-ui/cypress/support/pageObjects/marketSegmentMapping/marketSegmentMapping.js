 class MarketSegmentMapping {
  getMarketSegmentMappingTab() {
    return cy.get("li[data-cy=marketSegmentMapping]");
  }

  getOrganizationInput() {
    return cy.get("input#organization-input");
  }

  marketSegmentCell(){
    return cy.get(".k-spreadsheet .k-spreadsheet-cell[style='font-family: Arial; font-size: 12px; white-space: pre; overflow-wrap: normal; left: 486px; top: 1px; width: 119px; height: 19px;']")
  }

  marketSegmentCell2(){
    return cy.get(".k-spreadsheet .k-spreadsheet-cell[style='font-family: Arial; font-size: 12px; white-space: pre; overflow-wrap: normal; left: 486px; top: 21px; width: 119px; height: 19px;']")
  }

  editCell(){
    return cy.get('.k-spreadsheet-cell-editor')
  }

  exportBtn() {
    return cy.get('#marketSegmentMappingTab [data-cy="export"]')
  }

}
export default MarketSegmentMapping;