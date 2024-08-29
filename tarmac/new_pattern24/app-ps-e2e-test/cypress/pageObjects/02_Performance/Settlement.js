/// <reference types="Cypress" />

class Settlement {

    settlementTitle() {
        return cy.get('[data-cy="settlementTitle"]')
    }
    compensationEarnedTitle() {
        return cy.get('[data-cy="valueCardTitle"]')
    }
    compensationPaidTitle() {
        return cy.get('[data-cy="valueCardTitle"]')
    }
    cumulativeDifferenceTitle() {
        return cy.get('[data-cy="valueCardTitle"]')
    }
    settlementAdjustmentTitle() {
        return cy.get('[data-cy="valueCardTitle"]')
    }
    finalSettlementTitle() {
        return cy.get('[data-cy="valueCardTitle"]')
    }
    YTDCompEarned() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    YTDCompPaid() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    YTDCumulativeDiff() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    settlementAdj() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    finalSettlement() {
        return cy.get('[data-cy="valueCardLabel"]')
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
const settlement = new Settlement();
export default settlement;
