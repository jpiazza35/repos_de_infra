/// <reference types="Cypress" />
import benchmarkDataTiles from '../../../../pageObjects/01_Productivity/Benchmark';

describe("Productivity - Benchmark", { testIsolation: false }, function () {
    let benchmarkData;
    before(function () {
        let username;
        let password;
        let url;
        const enableRealData = Cypress.env("enableRealData");
        const reportingPeriod = Cypress.env("reportingPeriod");
        cy.getUserDetails(enableRealData, reportingPeriod).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            url = userDetails.url;
           cy.logintoPS2(username, password, url)
            cy.visit(url)
        });
            });

    beforeEach(function () {
        cy.fixture('UI/01_Productivity/benchmark_data').then((data) => {
            benchmarkData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //common tests for mock and real data users
   
        it('03: verify Benchmark Data Tiles', function () {
            benchmarkDataTiles.benchmarkTitle().should('contain', benchmarkData.cardTitle)

            benchmarkDataTiles.tileLabel().eq(0).should('contain', benchmarkData.benchmarkTiles[0])
            benchmarkDataTiles.tileLabel().eq(1).should('contain', benchmarkData.benchmarkTiles[1])
            benchmarkDataTiles.tileLabel().eq(2).should('contain', benchmarkData.benchmarkTiles[2])
            benchmarkDataTiles.tileLabel().eq(3).should('contain', benchmarkData.benchmarkTiles[3])

            benchmarkDataTiles.kebabMenu().eq(1).click()
            benchmarkDataTiles.exportDataPDF().eq(0).should('contain', benchmarkData.exportDataPDF)
        });
    

})