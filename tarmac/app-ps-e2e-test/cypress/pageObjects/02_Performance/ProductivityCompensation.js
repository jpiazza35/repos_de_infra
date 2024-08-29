/// <reference types="Cypress" />

class ProductivityCompensation {

    productivityCompensationTitle() {
        return cy.get('[data-cy="productCompensationTitle"]')
    }
    currentYearAvgRateperwRVULabel() {
        return cy.get('[data-cy="productCompensationCard"] div div div div')
    }
    currentYearAvgRateperwRVUValue() {
        return cy.get('[data-cy="productCompensationCard"] div div div div')
    }
    priorYearAvgRateperwRVULabel() {
        return cy.get('[data-cy="productCompensationCard"] div div div div')
    }
    priorYearAvgRateperwRVUValue() {
        return cy.get(' [data-cy="productCompensationCard"] div div div div')
    }
    productCompensationYTDValue() {
        return cy.get('[data-cy="productCompensationYTD"]')
    }
    productCompensationYTDLabel() {
        return cy.get('[data-cy="productCompensationYTD"]')
    }
    tier1() {
        return cy.get('[data-cy="productCompensationTierItem"]')
    }
    tier2() {
        return cy.get('[data-cy="productCompensationTierItem"]')
    }
    tier3() {
        return cy.get('[data-cy="productCompensationTierItem"]')
    }
    currentYTDwRVUs() {
        return cy.get('[data-cy="productCompensationCard"] div div div div')
    }
    priorYTDwRVUs() {
        return cy.get('[data-cy="productCompensationCard"] div div div div')
    }
}

const productivityCompensation = new ProductivityCompensation();
export default productivityCompensation;