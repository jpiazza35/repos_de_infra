/// <reference types="Cypress" />

class FTEAllocation {

    fteAllocationTitle() {
        return cy.get('[data-cy="allocationTitle"]')
    }
    YTDAvgLabel() {
        return cy.get('[data-cy="allocationCardYTDAvgHeader"]')
    }
    CurrentMonLabel() {
        return cy.get('[data-cy="allocationCardCurrentMonthHeader"]')
    }
    clinicalLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    clinicalYTDAvgValue() {
        return cy.get('[data-cy="allocationCardYTDAvg"]')
    }
    clinicalCurrentMonValue() {
        return cy.get('[data-cy="allocationCardCurrentMonth"]')
    }
    administrativeLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    administrativeYTDAvgValue() {
        return cy.get('[data-cy="allocationCardYTDAvg"]')
    }
    administrativeCurrentMonValue() {
        return cy.get('[data-cy="allocationCardCurrentMonth"]')
    }
    teachingLabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    teachingYTDAvgValue() {
        return cy.get('[data-cy="allocationCardYTDAvg"]')
    }
    teachingCurrentMonValue() {
        return cy.get('[data-cy="allocationCardCurrentMonth"]')
    }
    totalFTELabel() {
        return cy.get('[data-cy="allocationCardCategory"]')
    }
    totalFTEYTDAvgValue() {
        return cy.get('[data-cy="allocationCardYTDAvgTotal"]')
    }
    totalFTECurrentMonValue() {
        return cy.get('[data-cy="allocationCardCurrentMonthTotal"]')
    }

}
const fteAllocation = new FTEAllocation();
export default fteAllocation;
