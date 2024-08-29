/// <reference types="Cypress" />
import productivityCompensation from '../../../../pageObjects/02_Performance/ProductivityCompensation';

describe("Performance - ProductivityCompensation", { testIsolation: false }, function () {
    let productivityCompensationData;
    before(function () {
        cy.fixture('02_Performance/ProductivityCompensation/productivity_Compensation_data').then((data) => {
            productivityCompensationData = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('09: verify ProductivityCompensation', function () {
        productivityCompensation.productivityCompensationTitle().should('contain', productivityCompensationData.ProductivityCompensationLabel.ProductivityCompensationTitle)
        productivityCompensation.currentYearAvgRateperwRVULabel().eq(0).should('contain', productivityCompensationData.ProductivityCompensationLabel.CurrentYearAvgRateperwRVU)
        productivityCompensation.currentYearAvgRateperwRVUValue().eq(1).should('contain', productivityCompensationData.ProductivityCompensationValue.CurrentYearAvgRateperwRVU)
        productivityCompensation.priorYearAvgRateperwRVULabel().eq(2).should('contain', productivityCompensationData.ProductivityCompensationLabel.PriorYearAvgRateperwRVU)
        productivityCompensation.priorYearAvgRateperwRVUValue().eq(3).should('contain', productivityCompensationData.ProductivityCompensationValue.PriorYearAvgRateperwRVU)
        productivityCompensation.productCompensationYTDValue().eq(0).should('contain', productivityCompensationData.ProductivityCompensationValue.productCompensationYTD)
        productivityCompensation.productCompensationYTDLabel().next().should('contain', productivityCompensationData.ProductivityCompensationLabel.ProductivityCompensationYTD)
        productivityCompensation.tier1().eq(0).should('contain', productivityCompensationData.ProductivityCompensationLabel.Tier1)
        productivityCompensation.tier2().eq(1).should('contain', productivityCompensationData.ProductivityCompensationLabel.Tier2)
        productivityCompensation.tier3().eq(2).should('contain', productivityCompensationData.ProductivityCompensationLabel.Tier3)
        productivityCompensation.currentYTDwRVUs().eq(17).should('contain', productivityCompensationData.ProductivityCompensationLabel.CurrentYTDwRVUs)
        productivityCompensation.priorYTDwRVUs().eq(18).should('contain', productivityCompensationData.ProductivityCompensationLabel.PriorYTDwRVUs)
    })

})