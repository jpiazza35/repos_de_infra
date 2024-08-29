/// <reference types="Cypress" />
import benchmarkTrendsLineGraph from '../../../../pageObjects/01_Productivity/BenchmarkTrendsLineGraph';

describe("Productivity - BenchmarkTrendsLineGraph", { testIsolation: false }, function () {
    let benchmarkLineGraphData;
    before(function () {
        cy.fixture('01_Productivity/BenchmarkTrendsLineGraph/benchmark_Trends_Line_Graph_data').then((data) => {
            benchmarkLineGraphData = data
        })
        //cy.logintoPS2()
        cy.visit('/productivity')
    });

     beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('02: verify BenchmarkTrendsLineGraph', function () {
        benchmarkTrendsLineGraph.monthlywRVUFTETrendsTitle().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.MonthlywRVUFTETrendsTitle)
        benchmarkTrendsLineGraph.SCANational().eq(0).should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.SCANational2022)
        benchmarkTrendsLineGraph.SCANationalButton().eq(0).click()
        benchmarkTrendsLineGraph.P90Survey().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.P90Survey)
        benchmarkTrendsLineGraph.P75Survey().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.P75Survey)
        benchmarkTrendsLineGraph.P50Survey().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.P50Survey)
        benchmarkTrendsLineGraph.P25Survey().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.P25Survey)
        benchmarkTrendsLineGraph.kebabMenu().eq(0).click()
        benchmarkTrendsLineGraph.exportDataPDF().eq(0).should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.ExportDataPDF)
        benchmarkTrendsLineGraph.exportDataCSV().eq(1).should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.ExportDataCSV)
        benchmarkTrendsLineGraph.exportDataExcel().eq(2).should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.ExportDataExcel)
        benchmarkTrendsLineGraph.currentYTDLabel().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.currentYTD)
        benchmarkTrendsLineGraph.priorYTDLabel().should('contain', benchmarkLineGraphData.BenchmarkLineGraphLabel.PriorYTD)
    })
})