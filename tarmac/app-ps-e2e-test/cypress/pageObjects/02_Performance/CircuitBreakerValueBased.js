/// <reference types="Cypress" />

class CircuitBreakerValueBased {

    circuitBreakervalBasedTitle() {
        return cy.get('[data-cy="circuitBreakerTitle"]')
    }
    chartClosureLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    problemListReviewLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    maintenanceHospitalPrivilegesLabel() {
        return cy.get('[data-cy="itemLabel"]')
    }
    chartClosurePercent() {
        return cy.get('[data-cy="itemValue"]')
    }
    problemListReviewPercent() {
        return cy.get('[data-cy="itemValue"]')
    }
    maintenanceHospitalPrivilPercent() {
        return cy.get('[data-cy="itemValue"]')
    }
    chartClosureprogressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    problemListReviewprogressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    maintenanceHospitalPrivilprogressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }

}
const circuitBreakerValueBased = new CircuitBreakerValueBased();
export default circuitBreakerValueBased;