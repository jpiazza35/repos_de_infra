/// <reference types="Cypress" />
import fteAllocation from '../../../../pageObjects/02_Performance/FTEAllocation';

describe("Performance - FTE Allocation", { testIsolation: false }, function () {
    let FTEallocationdata;
    before(function () {
        cy.fixture('02_Performance/FTEAllocation/fte_allocation_data').then((data) => {
            FTEallocationdata = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('04: verify FTE Allocation', function () {
        fteAllocation.fteAllocationTitle().should('contain', 'FTE Allocation')
        fteAllocation.YTDAvgLabel().should('contain', FTEallocationdata.FTEAllocationLabel.YTDAvg)
        fteAllocation.CurrentMonLabel().should('contain', FTEallocationdata.FTEAllocationLabel.CurrentMonth)
        fteAllocation.clinicalLabel().eq(0).should('contain', FTEallocationdata.FTEAllocationLabel.Clinical)
        fteAllocation.clinicalYTDAvgValue().eq(0).should('contain', FTEallocationdata.FTEAllocationValue.ClinicalYTDAvg)
        fteAllocation.clinicalCurrentMonValue().eq(0).should('contain', FTEallocationdata.FTEAllocationValue.ClinicalCurMonth)
        fteAllocation.administrativeLabel().eq(1).should('contain', FTEallocationdata.FTEAllocationLabel.Administrative)
        fteAllocation.administrativeYTDAvgValue().eq(1).should('contain', FTEallocationdata.FTEAllocationValue.AdministrativeYTDAvg)
        fteAllocation.administrativeCurrentMonValue().eq(1).should('contain', FTEallocationdata.FTEAllocationValue.AdministrativeCurMonth)
        fteAllocation.teachingLabel().eq(2).should('contain', FTEallocationdata.FTEAllocationLabel.Teaching)
        fteAllocation.teachingYTDAvgValue().eq(2).should('contain', FTEallocationdata.FTEAllocationValue.TeachingYTDAvg)
        fteAllocation.teachingCurrentMonValue().eq(2).should('contain', FTEallocationdata.FTEAllocationValue.TeachingCurMonth)
        fteAllocation.totalFTELabel().eq(3).should('contain', FTEallocationdata.FTEAllocationLabel.TotalFTE)
        fteAllocation.totalFTEYTDAvgValue().eq(0).should('contain', FTEallocationdata.FTEAllocationValue.TotalFTEYTDAvg)
        fteAllocation.totalFTECurrentMonValue().eq(0).should('contain', FTEallocationdata.FTEAllocationValue.TotalFTECurMonth)
    });
})