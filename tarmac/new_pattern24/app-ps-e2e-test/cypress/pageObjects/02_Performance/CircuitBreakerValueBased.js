/// <reference types="Cypress" />

class CircuitBreakerValueBased {

    circuitBreakervalBasedTitle() {
        return cy.get('[data-cy="circuitBreakerTitle"]')
    }
    circuitBreakerInfoIcon() {
        return cy.get('[data-cy="infoTooltipIcon"]')
    }
    circuitBreakerInfoToolTip() {
        return cy.get('[data-cy="infoTooltip"]')
    }
    chartClosureLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    wRVUProductivityLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    problemListReviewLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
    dashboardPerformanceButton() {
        return cy.get('[data-cy="buttonNavPerformance"]')
    }
}
const circuitBreakerValueBased = new CircuitBreakerValueBased();
export default circuitBreakerValueBased;