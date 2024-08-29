/// <reference types="Cypress" />

class ValueBasedCompensation {
    valBasedCompensationTitle() {
        return cy.get('[data-cy="valueBasedTitle"]')
    }
    measureTypeDescLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div div')
    }
    compEligibleLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div div')
    }
    compEarnedLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div div')
    }
    outComesLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    outComesCompEligible() {
        return cy.get('[data-cy="itemCompEligible"]')
    }
    outComesCompEarned() {
        return cy.get('[data-cy="itemCompEarned"]')
    }
    patientExperienceLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    patientExperienceCompEligible() {
        return cy.get('[data-cy="itemCompEligible"]')
    }
    patientExperienceCompEarned() {
        return cy.get('[data-cy="itemCompEarned"]')
    }
    qualityLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    qualityCompEligible() {
        return cy.get('[data-cy="itemCompEligible"]')
    }
    qualityCompEarned() {
        return cy.get('[data-cy="itemCompEarned"]')
    }
    totalLabel() {
        return cy.get('[data-cy="totalMeasureType"]')
    }
    totalCompEligible() {
        return cy.get('[data-cy="totalCompEligible"]')
    }
    totalCompEarned() {
        return cy.get('[data-cy="totalCompEarned"]')
    }
}
const valBasedCompensation = new ValueBasedCompensation();
export default valBasedCompensation;
