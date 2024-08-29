/// <reference types="Cypress" />
import settlement from '../../../../pageObjects/02_Performance/Settlement';

describe("Performance - Settlement", { testIsolation: false }, function () {
    let settlementData;
    before(function () {
        cy.fixture('02_Performance/Settlement/settlement_data').then((data) => {
            settlementData = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('05: verify Settlement', function () {
        settlement.settlementTitle().eq(0).should('contain', settlementData.SettlementLabel.SettlementTitle)
        settlement.compensationEarnedTitle().eq(0).should('contain', settlementData.SettlementLabel.CompensationEarnedTitle)
        settlement.YTDCompEarnedValue().eq(0).should('contain', settlementData.SettlementValue.YTDCompEarned)
        settlement.YTDCompEarned().eq(0).should('contain', settlementData.SettlementLabel.YTDCompEarned)
        settlement.compensationPaidTitle().eq(1).should('contain', settlementData.SettlementLabel.CompensationPaidTitle)
        settlement.YTDCompPaidValue().eq(1).should('contain', settlementData.SettlementValue.YTDCompPaid)
        settlement.YTDCompPaid().eq(1).should('contain', settlementData.SettlementLabel.YTDCompPaid)
        settlement.cumulativeDifferenceTitle().eq(2).should('contain', settlementData.SettlementLabel.CumulativeDifferenceTitle)
        settlement.YTDCumulativeDiffValue().eq(2).should('contain', settlementData.SettlementValue.YTDCumulativeDiff)
        settlement.YTDCumulativeDiff().eq(2).should('contain', settlementData.SettlementLabel.YTDCumulativeDiff)
        settlement.settlementAdjustmentTitle().eq(3).should('contain', settlementData.SettlementLabel.SettlementAdjustmentTiltle)
        settlement.settlementAdjValue().eq(3).should('contain', settlementData.SettlementValue.SettlementAdj)
        settlement.settlementAdj().eq(3).should('contain', settlementData.SettlementLabel.SettlementAdj)
        settlement.finalSettlementTitle().eq(4).should('contain', settlementData.SettlementLabel.FinalSettlementTiltle)
        settlement.finalSettlementValue().eq(4).should('contain', settlementData.SettlementValue.FinalSettlement)
        settlement.finalSettlement().eq(4).should('contain', settlementData.SettlementLabel.FinalSettlement)
    })
})
