/// <reference types="Cypress" />

class CompSummary {

    compSummaryTitle() {
        return cy.get('[data-cy="summaryTitle"]')
    }
    projectedCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    projectedCompValue() {
        return cy.get('[data-cy="itemTotal"]')
    }
    estimatedValBasedIncentLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    estimatedValBasedIncentValue() {
        return cy.get('[data-cy="itemTotal"]')
    }
    teachingLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    teachingValue() {
        return cy.get('[data-cy="itemTotal"]')
    }
    totalProjectedCompLabel() {
        return cy.get('[data-cy="itemCategory"]')
    }
    totalProjectedCompValue() {
        return cy.get('[data-cy="itemTotal"]')
    }

}
const compSummary = new CompSummary();
export default compSummary;
