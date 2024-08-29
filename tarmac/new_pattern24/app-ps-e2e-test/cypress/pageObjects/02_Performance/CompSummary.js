/// <reference types="Cypress" />

class CompSummary {

    compSummaryTitle() {
        return cy.get('[data-cy="summaryTitle"]')
    }
    projectedCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    baseSalaryLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    wRVUCompensationLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    estimatedValBasedIncentLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    teachingLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    panelCompensationLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    appSupervisorCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    totalProjectedCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    otherCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
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
    FY2023Button() {
        return cy.get('[data-cy="yearCalendarButton"]')
    }
    periodButton() {
        return cy.get('[data-cy="periodButton"]')
    }
    periodMonthButton() {
        return cy.get('[data-cy="periodMonthButton"]')
    }
    monthYear() {
        return cy.get('[data-cy="periodMonth"] div ul li')
    }
    applyPeriodButton() {
        return cy.get('[data-cy="applyPeriodButton"]')
    }
}
const compSummary = new CompSummary();
export default compSummary;
