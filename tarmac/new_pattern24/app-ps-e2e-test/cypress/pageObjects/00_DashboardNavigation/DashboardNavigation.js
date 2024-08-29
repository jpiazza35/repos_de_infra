/// <reference types="Cypress" />

class DashboardNavigation {
    dashboardProductivityButton() {
        return cy.get('[data-cy="buttonNavProductivity"]')
    }
    dashboardPerformanceButton() {
        return cy.get('[data-cy="buttonNavPerformance"]')
    }
    monthlyFTETrendCard() {
        return cy.get('[data-cy="monthlyFTETrendCard"]')
    }
    productivityPage() {
        return cy.get('[data-cy="productivityPage"]')
    }
    compSummaryCard() {
        return cy.get('[data-cy="summaryCard"]')
    }
    benchMarkCard() {
        return cy.get('[data-cy="benchmarkCard"]')
    }
    monthlyTrendCard() {
        return cy.get('[data-cy="monthlyTrendCard"]')
    }
    monthlyServiceGroupCard() {
        return cy.get('[data-cy="monthlyServiceGroupCard"]')
    }
    patientDetailCard() {
        return cy.get('[data-cy="patientDetailCard"]')
    }
    fteAllocationCard() {
        return cy.get('[data-cy="allocationCard"]')
    }
    settlementCard() {
        return cy.get('[data-cy="settlementCard"]')
    }
    earningCodesCard() {
        return cy.get('[data-cy="earningCodesCard"]')
    }
    productivityCompensationCard() {
        return cy.get('[data-cy="productCompensationCard"]')
    }
    circuitBreakerCard() {
        return cy.get('[data-cy="circuitBreakerCard"]')
    }
    valueBasedCompensationCard() {
        return cy.get('[data-cy="valueBasedCard"]')
    }
    ValueBasedMeasuresCard() {
        return cy.get('[data-cy="valueBasedMeasuresCard"]')
    }
    headerTitle() {
        return cy.get('[data-cy="headerTitle"]')
    }
    headerDate() {
        return cy.get('[data-cy="headerDate"]')
    }
    headerPeriod() {
        return cy.get('[data-cy="headerDate"]')
    }
    performanceHeaderDate() {
        return cy.get('[data-cy="headerDate"]')
    }
    performancHeaderCompPeriod() {
        return cy.get('[data-cy="headerDate"]')
    }
}
const dashboardNavigation = new DashboardNavigation();
export default dashboardNavigation;