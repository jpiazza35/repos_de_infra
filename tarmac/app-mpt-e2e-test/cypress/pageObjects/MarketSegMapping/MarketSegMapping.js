class MarketSegMapping {

    //error messages
    orgErrorMessage() {
        return cy.get('[data-cy="organizationErrorMessage"]')
    }
    projectIdErrorMessage() {
        return cy.get('[data-cy="projectIdErrorMessage"]')
    }
    projectVersionErrorMessage() {
        return cy.get('[data-cy="projectVersionErrorMessage"]')
    }

    //market segment mapping

    marketSegmentMappingTab() {
        return cy.get('[data-cy="marketSegmentMapping"]')
    }

    methodologyInput(){
        return cy.get('#marketSegmentMappingTab #input-aggregation')
    }
    methodology(){
        return cy.get('#marketSegmentMappingTab label')
    }

    // buttons
    saveBtn() {
        return cy.get('#marketSegmentMappingTab [data-cy="save"]')
    }

    exportBtn() {
        return cy.get('#marketSegmentMappingTab [data-cy="export"]')
    }

    fullscrBtn(){
        return cy.get("#marketSegmentMappingTab button[data-cy='fullscreen']")
    }

    alert(){
        return cy.get('#marketSegmentMappingTab .alert.alert-primary')
    }

    marketsegmentcell(){
        return cy.get(".k-spreadsheet .k-spreadsheet-cell[style='font-family: Arial; font-size: 12px; white-space: pre; overflow-wrap: normal; left: 486px; top: 1px; width: 119px; height: 19px;']")
    }

    marketsegmentcell2(){
        return cy.get(".k-spreadsheet .k-spreadsheet-cell[style='font-family: Arial; font-size: 12px; white-space: pre; overflow-wrap: normal; left: 486px; top: 21px; width: 119px; height: 19px;']")
    }

    editcell(){
        return cy.get('.k-spreadsheet-cell-editor')
    }
    
    spreadSheet(){
        return cy.get('#kendo-spreadsheet')
    }

    undo(){
        return cy.get('#kendo-spreadsheet .k-svg-i-undo')
    }

    redo(){
        return cy.get('#kendo-spreadsheet .k-svg-i-redo')
    }

    merketSegmentFilter(){
        return cy.get('div:nth-child(4) > .k-filter-wrapper > span:nth-child(6) > .k-svg-icon > svg')
    }

    filter_popup(){
        return cy.get('.k-animation-container-shown')
    }

    checkbox(){
        return cy.get('.k-animation-container-shown li .k-treeview-leaf-text')
    }

    applyFilter(){
        return cy.get('.k-animation-container-shown button').contains('Apply')
    }

    filterSearch(){
        return cy.get(".k-animation-container-shown [placeholder='Search']")
    }

    clearFilter(){
        return cy.get('.k-animation-container-shown button').contains('Clear')
    }

    rows(){
        return cy.get('.k-spreadsheet-row-header .k-vertical-align-center')
    }

    sortasc(){
        return cy.get('.k-animation-container-shown .k-svg-i-sort-asc')
    }

    sortdesc(){
        return cy.get('.k-animation-container-shown .k-svg-i-sort-desc')
    }

    filterByCondition(){
        return cy.get('.k-animation-container-shown .k-details-summary').contains('Filter by condition')
    }

    filterByConditionInput(){
        return cy.get('.k-animation-container-shown .k-input-value-text')
    }

    filterByConditionOption(){
        return cy.get('.k-animation-container-shown li .k-list-item-text')
    }

    enterInputFilterCondition(){
        return cy.get(".k-animation-container-shown input[aria-label='string-value']")
    }

    errorPopup(){
        return cy.get("[data-role='draggable'] .k-action-window")
    }

    errorPopupMessage(){
        return cy.get("[data-role='draggable'] .k-spreadsheet-message-content")
    }

    errorRetry(){
        return cy.get("[data-role='draggable'] .k-action-window").find('button').contains('Retry')
    }

    errorCancel(){
        return cy.get("[data-role='draggable'] .k-action-window").find('button').contains('Cancel')
    }
}

const marketSegMapping = new MarketSegMapping();
export default marketSegMapping;
