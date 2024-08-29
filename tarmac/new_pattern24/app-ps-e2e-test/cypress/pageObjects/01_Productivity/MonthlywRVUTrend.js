/// <reference types="Cypress" />

class MonthlywRVUTrend {

    monthlywRVUTrendTitle() {
        return cy.get('[data-cy="monthlyTrendTitle"]')
    }
    YTDLabel() {
        return cy.get('[data-cy="headerYtd"]')
    }
    annualizedLabel() {
        return cy.get('[data-cy="headerAnnualized"]')
    }
    currentYearLabel() {
        return cy.get('[data-cy="currentYear"] td div')
    }
    priorYearLabel() {
        return cy.get('[data-cy="priorYear"] td div')
    }
    incrementLabel() {
        return cy.get('[data-cy="increment"] td')
    }
    incrementPercentLabel() {
        return cy.get('[data-cy="incrementPercent"] td')
    }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }

}
const monthlywRVUTrend = new MonthlywRVUTrend();
export default monthlywRVUTrend;