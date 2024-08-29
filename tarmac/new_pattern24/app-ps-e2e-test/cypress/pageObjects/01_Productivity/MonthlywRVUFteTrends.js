/// <reference types="Cypress" />

class MonthlywRVUFteTrends {
    
    cardTitle() {
        return cy.get('[data-cy="monthlyFTETrenTitle"]')
    }
    surveyDropdown() {
        return cy.get('[data-cy="dropdownSurveys"]')
    }    
    rangesDropdown() {
        return cy.get(':nth-child(1) > [data-cy="checkboxDropdownButton"]')
    }
    P90Survey() {
        return cy.get('[data-cy="checkboxDropdownOption-0"]')
    }
    P75Survey() {
        return cy.get('[data-cy="checkboxDropdownOption-1"]')
    }
    P50Survey() {
        return cy.get('[data-cy="checkboxDropdownOption-2"]')
    }
    P25Survey() {
        return cy.get('[data-cy="checkboxDropdownOption-3"]')
    }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] button')
    }
    currentYearLegend() {
        return cy.get('[data-cy="monthlyFTETrendValueLabel1"]')
    }
    priorYearLegend() {
        return cy.get('[data-cy="monthlyFTETrendValueLabel2"]')
    }
}
const monthlywRVUFteTrends = new MonthlywRVUFteTrends();
export default monthlywRVUFteTrends;