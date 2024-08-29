/// <reference types="Cypress" />
class EngagementTab {

    defaultEngmntTab() {
        return cy.get('.manengagement')
    }

    engmntAddBtn() {
        return cy.get('#btnAdd')
    }

    engmntExportBtn() {
        return cy.get('#btnExport')
    }

    engmntSearchBtn() {
        return cy.get('#btnSearch')
    }

    engmntClearBtn() {
        return cy.get('#btnClear')
    }

    cesOrg() {
        return cy.get('.dynamicSearch > :nth-child(1)')
    }

    cesOrgSearchField() {
        return cy.get('#OrgStep_Text')
    }

    cesOrgDropDownList() {
        return cy.get('#OrgStep_Text_listbox')
    }

    engmntDate() {
        return cy.get('.dynamicSearch > :nth-child(2)')
    }

    datePicker() {
        return cy.get('.k-datepicker > .k-input-button')
    }

    calendar() {
        return cy.get('#SearchEngagementDate_dateview')
    }

    engmntStatus() {
        return cy.get('.dynamicSearch > :nth-child(3)')
    }

    engmntStatusDropDownArrow() {
        return cy.get(':nth-child(3) > :nth-child(2) > .k-picker > .k-input-button')
    }

    engmntStatusDropDownList() {
        return cy.get('#SearchEngagementStatus_listbox li span')
    }

    versionYr() {
        return cy.get('.dynamicSearch > :nth-child(4)')
    }

    versionYrDropDownArrow() {
        return cy.get(':nth-child(4) > :nth-child(2) > .k-picker > .k-input-button')
    }

    versionYrDropDownList() {
        return cy.get('#SearchEngagementPublicationYear_listbox li span ')
    }

    gridHeader() {
        return cy.get('.k-grid-header table tr th')
    }

    newEngmntRowFields() {
        return cy.get('tr[class="k-master-row k-grid-edit-row"]')
    }

    addNewEngmntLine() {
        return cy.get('tr[class="k-master-row k-grid-edit-row"] td')
    }

    addNewCESField() {
        return cy.get('#CESOrg')
    }
    
    addNewEngmntNameField() {
        return cy.get('#EngagementName')
    }

    addNewVersionYearField() {
        return cy.get('#VersionYearDisplay')
    }

    addNewEngmntDate() {
        return cy.get('#EngagementDate')
    }

    addNewReportYear1() {
        return cy.get('#ReportYear1Display')
    }

    addNewReportYear2() {
        return cy.get('#ReportYear2Display')
    }

    addPatientMngmntFactor() {
        return cy.get('[data-container-for="PatientMgmtFactor"] > .k-picker > .k-input-button')
    }

    newEngmntPatientMngmntValue() {
        return cy.get('.k-animation-container')
    }

    saveBtn() {
        return cy.get('.k-grid-update')
    }
 





}
const engagementTab = new EngagementTab()
export default engagementTab