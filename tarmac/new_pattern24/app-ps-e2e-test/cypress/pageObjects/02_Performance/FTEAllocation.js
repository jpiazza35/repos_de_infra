/// <reference types="Cypress" />

class FTEAllocation {

    fteAllocationTitle() {
        return cy.get('[data-cy="allocationTitle"]')
    }
    YTDAvgLabel() {
        return cy.get('[data-cy="allocationCardYTDAvgHeader"]')
    }
    currentMonLabel() {
        return cy.get('[data-cy="allocationCardCurrentMonthHeader"]')
    }
    clinicalLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    clinicalFTELabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    administrativeLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    teachingLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    totalFTELabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
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
const fteAllocation = new FTEAllocation();
export default fteAllocation;
