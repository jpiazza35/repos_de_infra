/// <reference types="Cypress" />
import settlement from '../../../../pageObjects/02_Performance/Settlement';

describe("Performance - Settlement", { testIsolation: false }, function () {
    let settlementData;
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
        settlement.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/settlement_data').then((data) => {
            settlementData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('11: verify Settlement', function () {
            cy.fiscalYearFilterJuly2022()
            settlement.settlementTitle().eq(0).should('contain', settlementData.realData.settlementLabel.settlementTitle)

            settlement.compensationEarnedTitle().eq(0).should('contain', settlementData.realData.settlementLabel.compensationEarnedTitle)
            settlement.YTDCompEarned().eq(0).should('contain', settlementData.realData.settlementLabel.YTDCompEarned)

            settlement.compensationPaidTitle().eq(1).should('contain', settlementData.realData.settlementLabel.compensationPaidTitle)
            settlement.YTDCompPaid().eq(1).should('contain', settlementData.realData.settlementLabel.YTDCompPaid)

            settlement.cumulativeDifferenceTitle().eq(2).should('contain', settlementData.realData.settlementLabel.cumulativeDifferenceTitle)
            settlement.YTDCumulativeDiff().eq(2).should('contain', settlementData.realData.settlementLabel.YTDCumulativeDiff)

            settlement.settlementAdjustmentTitle().eq(3).should('contain', settlementData.realData.settlementLabel.settlementAdjustmentTitle)
            settlement.settlementAdj().eq(3).should('contain', settlementData.realData.settlementLabel.settlementAdj)

            settlement.finalSettlementTitle().eq(4).should('contain', settlementData.realData.settlementLabel.finalSettlementTitle)
            settlement.finalSettlement().eq(4).should('contain', settlementData.realData.settlementLabel.finalSettlement)

            settlement.kebabMenu().eq(2).click()
            settlement.exportDataPDF().eq(0).should('contain', settlementData.realData.settlementLabel.exportDataPDF)
        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('11: verify Settlement', function () {
            settlement.settlementTitle().eq(0).should('contain', settlementData.mockData.settlementLabel.settlementTitle)

            settlement.compensationEarnedTitle().eq(0).should('contain', settlementData.mockData.settlementLabel.compensationEarnedTitle)
            settlement.YTDCompEarned().eq(0).should('contain', settlementData.mockData.settlementLabel.YTDCompEarned)

            settlement.compensationPaidTitle().eq(1).should('contain', settlementData.mockData.settlementLabel.compensationPaidTitle)
            settlement.YTDCompPaid().eq(1).should('contain', settlementData.mockData.settlementLabel.YTDCompPaid)

            settlement.cumulativeDifferenceTitle().eq(2).should('contain', settlementData.mockData.settlementLabel.cumulativeDifferenceTitle)
            settlement.YTDCumulativeDiff().eq(2).should('contain', settlementData.mockData.settlementLabel.YTDCumulativeDiff)

            settlement.settlementAdjustmentTitle().eq(3).should('contain', settlementData.mockData.settlementLabel.settlementAdjustmentTitle)
            settlement.settlementAdj().eq(3).should('contain', settlementData.mockData.settlementLabel.settlementAdj)

            settlement.finalSettlementTitle().eq(4).should('contain', settlementData.mockData.settlementLabel.finalSettlementTitle)
            settlement.finalSettlement().eq(4).should('contain', settlementData.mockData.settlementLabel.finalSettlement)

            settlement.kebabMenu().eq(2).click()
            settlement.exportDataPDF().eq(0).should('contain', settlementData.mockData.settlementLabel.exportDataPDF)
        })
    }
})
