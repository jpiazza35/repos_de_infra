/// <reference types="Cypress" />

class BenchmarkDataTiles {

    benchmarkDataTilesTitle() {
        return cy.get('[data-cy="benchmarkTitle"]')
    }
    YTDwRVUsValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    YTDwRVUsLabel() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    benchmarkDataTilesValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    benchmarkDataTilesLabel() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    wRVUsFTEValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    wRVUsFTELabel() {
        return cy.get('[data-cy="valueCardLabel"]')
    }
    YTDBenchmarkpercentileValue() {
        return cy.get('[data-cy="valueCardValue"]')
    }
    YTDBenchmarkpercentileLabel() {
        return cy.get('[data-cy="valueCardLabel"]')
    }

}
const benchmarkDataTiles = new BenchmarkDataTiles();
export default benchmarkDataTiles;