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
    YTDCompEarnedValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    YTDCompPaid() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    YTDCompPaidValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    YTDCumulativeDiff() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    YTDCumulativeDiffValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    settlementAdj() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    settlementAdjValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    finalSettlement() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    finalSettlementValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
}
const settlement = new Settlement();
export default settlement;
