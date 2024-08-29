/// <reference types="Cypress" />
import benchmarkDataTiles from '../../../../pageObjects/01_Productivity/BenchmarkDataTiles';

describe("Productivity - BenchmarkDataTiles", { testIsolation: false }, function () {
    let benchmarkDataTilesData;
    before(function () {
        cy.fixture('01_Productivity/BenchmarkDataTiles/benchmark_Data_Tiles_data').then((data) => {
            benchmarkDataTilesData = data
        })
        cy.logintoPS2()
        cy.visit('/productivity')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('01: verify BenchmarkDataTiles', function () {
        benchmarkDataTiles.benchmarkDataTilesTitle().should('contain', benchmarkDataTilesData.BenchmarkDataTilesLabel.BenchmarkDataTilesTitle)
        benchmarkDataTiles.YTDwRVUsValue().eq(0).should('contain', benchmarkDataTilesData.BenchmarkDataTilesValue.YTDwRVUs)
        benchmarkDataTiles.YTDwRVUsLabel().eq(0).should('contain', benchmarkDataTilesData.BenchmarkDataTilesLabel.YTDwRVUs)
        benchmarkDataTiles.benchmarkDataTilesValue().eq(1).should('contain', benchmarkDataTilesData.BenchmarkDataTilesValue.BenchmarkFTE)
        benchmarkDataTiles.benchmarkDataTilesLabel().eq(1).should('contain', benchmarkDataTilesData.BenchmarkDataTilesLabel.BenchmarkFTE)
        benchmarkDataTiles.wRVUsFTEValue().eq(2).should('contain', benchmarkDataTilesData.BenchmarkDataTilesValue.wRVUsFTE)
        benchmarkDataTiles.wRVUsFTELabel().eq(2).should('contain', benchmarkDataTilesData.BenchmarkDataTilesLabel.wRVUsFTE)
        benchmarkDataTiles.YTDBenchmarkpercentileValue().eq(3).should('contain', benchmarkDataTilesData.BenchmarkDataTilesValue.YTDBenchmarkpercentile)
        benchmarkDataTiles.YTDBenchmarkpercentileLabel().eq(3).should('contain', benchmarkDataTilesData.BenchmarkDataTilesLabel.YTDBenchmarkpercentile)
    })
})