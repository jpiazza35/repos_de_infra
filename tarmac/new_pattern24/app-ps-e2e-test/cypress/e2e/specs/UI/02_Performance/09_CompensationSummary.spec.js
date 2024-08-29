/// <reference types="Cypress" />
import compSummary from '../../../../pageObjects/02_Performance/CompSummary';

describe("Performance - Compensation Summary", { testIsolation: false }, function () {
    let compSummData;
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
        compSummary.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/compensation_summary_data').then((data) => {
            compSummData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('09: verify Compensation summary', function () {
            cy.fiscalYearFilterJuly2022()
            compSummary.compSummaryTitle().should('contain', compSummData.realData.compSummaryLabel.cardname)
            compSummary.baseSalaryLabel().eq(0).should('contain', compSummData.realData.compSummaryLabel.baseSalary)
            compSummary.wRVUCompensationLabel().eq(1).should('contain', compSummData.realData.compSummaryLabel.wRVUCompensation)
            compSummary.estimatedValBasedIncentLabel().eq(2).should('contain', compSummData.realData.compSummaryLabel.estimatedValueBasedIncentive)
            compSummary.appSupervisorCompLabel().eq(3).should('contain', compSummData.realData.compSummaryLabel.appSupervisorComp)
            compSummary.otherCompLabel().eq(4).should('contain', compSummData.realData.compSummaryLabel.otherComp)
            compSummary.totalProjectedCompLabel().eq(5).should('contain', compSummData.mockData.compSummaryLabel.totalProjectedCompensation)
            compSummary.kebabMenu().eq(0).click()
            compSummary.exportDataPDF().eq(0).should('contain', compSummData.realData.compSummaryLabel.exportDataPDF)
        });
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('09: verify Compensation summary', function () {
            compSummary.compSummaryTitle().should('contain', compSummData.mockData.compSummaryLabel.cardname)
            compSummary.projectedCompLabel().eq(0).should('contain', compSummData.mockData.compSummaryLabel.projectedWorkRVUCompensation)
            compSummary.estimatedValBasedIncentLabel().eq(1).should('contain', compSummData.mockData.compSummaryLabel.estimatedValueBasedIncentive)
            compSummary.teachingLabel().eq(2).should('contain', compSummData.mockData.compSummaryLabel.teaching)
            compSummary.totalProjectedCompLabel().eq(3).should('contain', compSummData.mockData.compSummaryLabel.totalProjectedCompensation)
            compSummary.kebabMenu().eq(0).click()
            compSummary.exportDataPDF().eq(0).should('contain', compSummData.mockData.compSummaryLabel.exportDataPDF)
        });
    }
})
