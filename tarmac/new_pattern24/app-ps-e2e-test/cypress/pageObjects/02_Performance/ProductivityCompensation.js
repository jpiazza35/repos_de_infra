/// <reference types="Cypress" />

class ProductivityCompensation {

    productivityCompensationTitle() {
        return cy.get('[data-cy="productCompensationTitle"]')
    }
    currentYearAvgRateperwRVULabel() {
        return cy.get('[data-cy="productCompensationCurrentYearAvgRate"]')
    }
    priorYearAvgRateperwRVULabel() {
        return cy.get('[data-cy="productCompensationPriorYearAvgRate"]')
    }
    productCompensationYTDLabel() {
        return cy.get('[data-cy="productCompensationYTDLabel"]')
    }
    tier1() {
        return cy.get('[data-cy="productCompensationTierItem0"]')
    }
    tier2() {
        return cy.get('[data-cy="productCompensationTierItem1"]')
    }
    tier3() {
        return cy.get('[data-cy="productCompensationTierItem2"]')
    }
    currentYTDwRVUs() {
        return cy.get('[data-cy="productCompensationCurrentYTD"]')
    }
    priorYTDwRVUs() {
        return cy.get('[data-cy="productCompensationPriorYTD"]')
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

const productivityCompensation = new ProductivityCompensation();
export default productivityCompensation;