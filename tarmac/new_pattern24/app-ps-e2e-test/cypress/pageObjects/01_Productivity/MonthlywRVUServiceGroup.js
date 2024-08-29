/// <reference types="Cypress" />

class MonthlywRVUServiceGroup {

    monthlywRVUServiceGroupTitle() {
        return cy.get('[data-cy="monthlyServiceGroupTitle"]')
    }
    chargePostDateSubTitle() {
        return cy.get('[data-cy="monthlyServiceGroupSubTitle"]')
    }
    serviceGroups() {
        return cy.get('[data-cy="checkboxDropdownButton"]')
    }
    hospital() {
        return cy.get('[data-cy="checkboxDropdownOption-0"]')
    }
    imaging() {
        return cy.get('[data-cy="checkboxDropdownOption-1"]')
    }
    officeEstablished() {
        return cy.get('[data-cy="checkboxDropdownOption-2"]')
    }
    officeNew() {
        return cy.get('[data-cy="checkboxDropdownOption-3"]')
    }
    other() {
        return cy.get('[data-cy="checkboxDropdownOption-4"]')
    }
    preventative() {
        return cy.get('[data-cy="checkboxDropdownOption-5"]')
    }
    SNF() {
        return cy.get('[data-cy="checkboxDropdownOption-6"]')
    }
    surgical() {
        return cy.get('[data-cy="checkboxDropdownOption-7"]')
    }
    legendHospital() {
        return cy.get('[data-cy="monthlyServiceGroupOption-0"]')
    }
    legendImaging() {
        return cy.get('[data-cy="monthlyServiceGroupOption-1"]')
    }
    legendOfficeEstablished() {
        return cy.get('[data-cy="monthlyServiceGroupOption-2"]')
    }
    legendOfficeNew() {
        return cy.get('[data-cy="monthlyServiceGroupOption-3"]')
    }
    legendOther() {
        return cy.get('[data-cy="monthlyServiceGroupOption-4"]')
    }
    legendPreventative() {
        return cy.get('[data-cy="monthlyServiceGroupOption-5"]')
    }
    legendSNF() {
        return cy.get('[data-cy="monthlyServiceGroupOption-6"]')
    }
    legendSurgical() {
        return cy.get('[data-cy="monthlyServiceGroupOption-7"]')
    }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
}
const monthlywRVUServiceGroup = new MonthlywRVUServiceGroup();
export default monthlywRVUServiceGroup;