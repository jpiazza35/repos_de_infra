/// <reference types="Cypress" />
import monthlywRVUTrend from '../../../../pageObjects/01_Productivity/MonthlywRVUTrend';

describe("Productivity - Monthly wRVU Trend", { testIsolation: false }, function () {
    let monthlywRVUTrendData;
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
        cy.fixture('UI/01_Productivity/monthly_wRVU_trend_data').then((data) => {
            monthlywRVUTrendData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //common tests for mock and real data users 

    it('05: verify Monthly wRVU Trend', function () {
        monthlywRVUTrend.monthlywRVUTrendTitle().should('contain', monthlywRVUTrendData.cardTitle)
        monthlywRVUTrend.YTDLabel().should('contain', monthlywRVUTrendData.headerLabels[0])
        monthlywRVUTrend.annualizedLabel().should('contain', monthlywRVUTrendData.headerLabels[1])

        monthlywRVUTrend.currentYearLabel().should('contain', monthlywRVUTrendData.rowLabels[0])
        monthlywRVUTrend.priorYearLabel().should('contain', monthlywRVUTrendData.rowLabels[1])

        monthlywRVUTrend.incrementLabel().eq(0).should('contain', monthlywRVUTrendData.rowLabels[2])
        monthlywRVUTrend.incrementPercentLabel().eq(0).should('contain', monthlywRVUTrendData.rowLabels[3])

        monthlywRVUTrend.kebabMenu().eq(2).click()
        monthlywRVUTrend.exportDataPDF().eq(0).should('contain', monthlywRVUTrendData.exportDataPDF)
    });
})