/// <reference types="Cypress" />
import fteAllocation from '../../../../pageObjects/02_Performance/FTEAllocation';

describe("Performance - FTE Allocation", { testIsolation: false }, function () {
    let FTEallocationdata;
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
        fteAllocation.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/fte_allocation_data').then((data) => {
            FTEallocationdata = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('10: verify FTE Allocation', function () {
            fteAllocation.fteAllocationTitle().should('contain', 'FTE Allocation')

            fteAllocation.YTDAvgLabel().should('contain', FTEallocationdata.realData.FTEAllocationLabel.YTDAvg)
            fteAllocation.currentMonLabel().should('contain', FTEallocationdata.realData.FTEAllocationLabel.currentMonth)

            fteAllocation.clinicalFTELabel().eq(0).should('contain', FTEallocationdata.realData.FTEAllocationLabel.clinicalFTE)
            fteAllocation.totalFTELabel().eq(1).should('contain', FTEallocationdata.realData.FTEAllocationLabel.totalFTE)

            fteAllocation.kebabMenu().eq(1).click()
            fteAllocation.exportDataPDF().eq(0).should('contain', FTEallocationdata.realData.FTEAllocationLabel.exportDataPDF)
        });
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('10: verify FTE Allocation', function () {
            fteAllocation.fteAllocationTitle().should('contain', 'FTE Allocation')

            fteAllocation.YTDAvgLabel().should('contain', FTEallocationdata.mockData.FTEAllocationLabel.YTDAvg)
            fteAllocation.currentMonLabel().should('contain', FTEallocationdata.mockData.FTEAllocationLabel.currentMonth)

            fteAllocation.clinicalLabel().eq(0).should('contain', FTEallocationdata.mockData.FTEAllocationLabel.clinical)
            fteAllocation.administrativeLabel().eq(1).should('contain', FTEallocationdata.mockData.FTEAllocationLabel.administrative)
            fteAllocation.teachingLabel().eq(2).should('contain', FTEallocationdata.mockData.FTEAllocationLabel.teaching)
            fteAllocation.totalFTELabel().eq(3).should('contain', FTEallocationdata.mockData.FTEAllocationLabel.totalFTE)

            fteAllocation.kebabMenu().eq(1).click()
            fteAllocation.exportDataPDF().eq(0).should('contain', FTEallocationdata.mockData.FTEAllocationLabel.exportDataPDF)
        });
    }
})