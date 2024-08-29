/// <reference types="Cypress" />
import monthlywRVUFteTrends from '../../../../pageObjects/01_Productivity/MonthlywRVUFteTrends';

describe("Productivity - Monthly wRVU Per FTE Trends", { testIsolation: false }, function () {
    let monthlywRVUFteTrendsData;
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
        cy.fixture('UI/01_Productivity/monthly_wRVU_fte_trends_data').then((data) => {
            monthlywRVUFteTrendsData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //common tests for mock and real data users

    it('04: verify Monthly wRVU Per FTE Trends card labels', function () {
        monthlywRVUFteTrends.cardTitle().should('contain', monthlywRVUFteTrendsData.cardTitle)
        monthlywRVUFteTrends.surveyDropdown().should('be.visible')
        monthlywRVUFteTrends.rangesDropdown().should('be.visible')

        monthlywRVUFteTrends.currentYearLegend().should('contain', monthlywRVUFteTrendsData.valueLabels[0])
        monthlywRVUFteTrends.priorYearLegend().should('contain', monthlywRVUFteTrendsData.valueLabels[1])

        monthlywRVUFteTrends.kebabMenu().eq(0).click()
        monthlywRVUFteTrends.exportDataPDF().eq(0).should('contain', monthlywRVUFteTrendsData.exportDataPDF)
    });


    //fiscal year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'fiscal') {
        it('04: verify survey name and percentile ranges', function () {
            monthlywRVUFteTrends.surveyDropdown().eq(0).should('contain', monthlywRVUFteTrendsData.fy_realData.survey)
            monthlywRVUFteTrends.rangesDropdown().eq(0).click()
            monthlywRVUFteTrends.P90Survey().should('contain', monthlywRVUFteTrendsData.fy_realData.ranges[0])
            monthlywRVUFteTrends.P75Survey().should('contain', monthlywRVUFteTrendsData.fy_realData.ranges[1])
            monthlywRVUFteTrends.P50Survey().should('contain', monthlywRVUFteTrendsData.fy_realData.ranges[2])
            monthlywRVUFteTrends.P25Survey().should('contain', monthlywRVUFteTrendsData.fy_realData.ranges[3])

        });
    }

    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('04: verify survey name and percentile ranges', function () {
            monthlywRVUFteTrends.surveyDropdown().eq(0).should('contain', monthlywRVUFteTrendsData.cy_realData.survey)
            monthlywRVUFteTrends.rangesDropdown().eq(0).click()
            monthlywRVUFteTrends.P90Survey().should('contain', monthlywRVUFteTrendsData.cy_realData.ranges[0])
            monthlywRVUFteTrends.P75Survey().should('contain', monthlywRVUFteTrendsData.cy_realData.ranges[1])
            monthlywRVUFteTrends.P50Survey().should('contain', monthlywRVUFteTrendsData.cy_realData.ranges[2])
            monthlywRVUFteTrends.P25Survey().should('contain', monthlywRVUFteTrendsData.cy_realData.ranges[3])

        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('04: verify survey name and percentile ranges', function () {
            monthlywRVUFteTrends.surveyDropdown().eq(0).should('contain', monthlywRVUFteTrendsData.mockData.survey)
            monthlywRVUFteTrends.rangesDropdown().eq(0).click()
            monthlywRVUFteTrends.P90Survey().should('contain', monthlywRVUFteTrendsData.mockData.ranges[0])
            monthlywRVUFteTrends.P75Survey().should('contain', monthlywRVUFteTrendsData.mockData.ranges[1])
            monthlywRVUFteTrends.P50Survey().should('contain', monthlywRVUFteTrendsData.mockData.ranges[2])
            monthlywRVUFteTrends.P25Survey().should('contain', monthlywRVUFteTrendsData.mockData.ranges[3])

        });
    }
})


