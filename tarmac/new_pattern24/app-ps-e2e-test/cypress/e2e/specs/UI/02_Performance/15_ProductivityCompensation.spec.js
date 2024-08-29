/// <reference types="Cypress" />
import productivityCompensation from '../../../../pageObjects/02_Performance/ProductivityCompensation';

describe("Performance - Productivity Compensation", { testIsolation: false }, function () {
    let productivityCompensationData;
    before(function () {
        let username;
        let password;
        const enableRealData = Cypress.env("enableRealData");
        cy.getUserDetails(enableRealData).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            //cy.logintoPS2(username, password)
        });
        cy.visit('/dashboard')
        productivityCompensation.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/productivity_compensation_data').then((data) => {
            productivityCompensationData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('15: verify Productivity Compensation', function () {
            productivityCompensation.productivityCompensationTitle().should('contain', productivityCompensationData.realData.productivityCompensationLabel.productivityCompensationTitle)
            productivityCompensation.currentYearAvgRateperwRVULabel().should('contain', productivityCompensationData.realData.productivityCompensationLabel.currentYearAvgRateperwRVU)
            productivityCompensation.priorYearAvgRateperwRVULabel().should('contain', productivityCompensationData.realData.productivityCompensationLabel.priorYearAvgRateperwRVU)
            productivityCompensation.productCompensationYTDLabel().should('contain', productivityCompensationData.realData.productivityCompensationLabel.productivityCompensationYTD)
            productivityCompensation.tier1().should('contain', productivityCompensationData.realData.productivityCompensationLabel.tier1)
            productivityCompensation.tier2().should('contain', productivityCompensationData.realData.productivityCompensationLabel.tier2)
            productivityCompensation.currentYTDwRVUs().should('contain', productivityCompensationData.realData.productivityCompensationLabel.currentYTDwRVUs)
            productivityCompensation.priorYTDwRVUs().should('contain', productivityCompensationData.realData.productivityCompensationLabel.priorYTDwRVUs)
            productivityCompensation.kebabMenu().eq(4).click()
            productivityCompensation.exportDataPDF().eq(0).should('contain', productivityCompensationData.realData.productivityCompensationLabel.exportDataPDF)
        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('15: verify Productivity Compensation', function () {
            productivityCompensation.productivityCompensationTitle().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.productivityCompensationTitle)
            productivityCompensation.currentYearAvgRateperwRVULabel().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.currentYearAvgRateperwRVU)
            productivityCompensation.priorYearAvgRateperwRVULabel().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.priorYearAvgRateperwRVU)
            productivityCompensation.productCompensationYTDLabel().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.productivityCompensationYTD)
            productivityCompensation.tier1().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.tier1)
            productivityCompensation.tier2().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.tier2)
            productivityCompensation.tier3().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.tier3)
            productivityCompensation.currentYTDwRVUs().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.currentYTDwRVUs)
            productivityCompensation.priorYTDwRVUs().should('contain', productivityCompensationData.mockData.productivityCompensationLabel.priorYTDwRVUs)
            productivityCompensation.kebabMenu().eq(4).click()
            productivityCompensation.exportDataPDF().eq(0).should('contain', productivityCompensationData.mockData.productivityCompensationLabel.exportDataPDF)
        })
    }
})