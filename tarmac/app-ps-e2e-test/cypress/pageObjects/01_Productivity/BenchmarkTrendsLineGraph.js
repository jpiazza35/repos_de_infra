/// <reference types="Cypress" />

class BenchmarkTrendsLineGraph {

    monthlywRVUFTETrendsTitle() {
        return cy.get('[data-cy="monthlyFTETrenTitle"]')
    }
    SCANational() {
        return cy.get('[data-cy="checkboxDropdownButton"]')
    }
    SCANationalButton() {
        return cy.get('[data-cy="checkboxDropdownButton"]')
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
        return cy.get('[data-cy="exportData"]')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
    exportDataCSV() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
    exportDataExcel() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
    currentYTDLabel() {
        return cy.get('[data-cy="monthlyFTETrendValueLabel1"]')
    }
    priorYTDLabel() {
        return cy.get('[data-cy="monthlyFTETrendValueLabel2"]')
    }
}
const benchmarkTrendsLineGraph = new BenchmarkTrendsLineGraph();
export default benchmarkTrendsLineGraph;