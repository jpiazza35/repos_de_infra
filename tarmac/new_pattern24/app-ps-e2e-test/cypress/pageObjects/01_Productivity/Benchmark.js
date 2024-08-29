/// <reference types="Cypress" />

class Benchmark {

    benchmarkTitle() {
        return cy.get('[data-cy="benchmarkTitle"]')
    }
    tileLabel() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    // benchmarkDataTilesLabel() {
    //     return cy.get('[data-cy="valueCardLabel"]')
    // }
    // wRVUsFTELabel() {
    //     return cy.get('[data-cy="valueCardLabel"]')
    // }
    // YTDBenchmarkpercentileLabel() {
    //     return cy.get('[data-cy="valueCardLabel"]')
    // }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
}
const benchmark = new Benchmark();
export default benchmark;