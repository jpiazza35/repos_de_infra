/// <reference types="Cypress" />
import compSummary from '../../../../pageObjects/02_Performance/CompSummary';

describe("Performance - Compensation Summary", { testIsolation: false }, function () {
    let compSummData;
    before(function () {
        cy.fixture('02_Performance/CompensationSummary/compensation_summary_data').then((data) => {
            compSummData = data
        })
        cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('03: verify Compensation summary', function () {
        compSummary.compSummaryTitle().should('contain', compSummData.CompSummaryLabel.Cardname)
        compSummary.projectedCompLabel().eq(0).should('contain', compSummData.CompSummaryLabel.ProjectedWorkRVUCompensation)
        compSummary.projectedCompValue().eq(0).should('contain', compSummData.CompSummaryValue.ProjectedWorkRVUCompensation)
        compSummary.estimatedValBasedIncentLabel().eq(1).should('contain', compSummData.CompSummaryLabel.EstimatedValueBasedIncentive)
        compSummary.estimatedValBasedIncentValue().eq(1).should('contain', compSummData.CompSummaryValue.EstimatedValueBasedIncentive)
        compSummary.teachingLabel().eq(2).should('contain', compSummData.CompSummaryLabel.Teaching)
        compSummary.teachingValue().eq(2).should('contain', compSummData.CompSummaryValue.Teaching)
        compSummary.totalProjectedCompLabel().eq(3).should('contain', compSummData.CompSummaryLabel.TotalProjectedCompensation)
        compSummary.totalProjectedCompValue().eq(3).should('contain', compSummData.CompSummaryValue.TotalProjectedCompensation)

    });
})
