/// <reference types="Cypress" />
import valBasedMeasures from '../../../../pageObjects/02_Performance/ValueBasedMeasures';

describe("Performance - ValueBasedMeasures", { testIsolation: false }, function () {
    let valBasedMeasuresData;
    before(function () {
        cy.fixture('02_Performance/ValueBasedMeasures/value_Based_Measures_data').then((data) => {
            valBasedMeasuresData = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('06: verify ValueBasedMeasures', function () {
        valBasedMeasures.valBasedMeasureTitle().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.ValBasedMeasuresTitle)
        valBasedMeasures.breastCancerScreeningTitle().eq(0).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.BreastCancerScreening)
        valBasedMeasures.qualityIndividual().eq(0).next().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.QualityIndividual)
        valBasedMeasures.YTDPerformance().eq(1).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.YTDPerformance)
        valBasedMeasures.breastCancerScreeningYTDPerformanceVal().eq(1).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.BreastCancerScreeningYTDPerformanceVal)
        valBasedMeasures.breastCancerScreeningProgressBarMarkVal().eq(2).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.BreastCancerScreeningProgressBarMarkVal)
        valBasedMeasures.depressionScreeningTitle().eq(1).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.DepressionScreening)
        valBasedMeasures.depressionScreeningQualityIndividual().eq(1).next().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.QualityIndividual)
        valBasedMeasures.depressionScreeningYTDPerformance().eq(9).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.YTDPerformance)
        valBasedMeasures.depressionScreeningYTDPerformanceVal().eq(9).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.DepressionScreeningYTDPerformanceVal)
        valBasedMeasures.depressionScreeningProgressBarMarkVal().eq(3).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.DepressionScreeningProgressBarMarkVal)
        valBasedMeasures.hypertensionTitle().eq(2).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.Hypertension)
        valBasedMeasures.hypertensionqualityIndividual().eq(2).next().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.QualityIndividual)
        valBasedMeasures.hypertensionYTDPerformance().eq(17).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.YTDPerformance)
        valBasedMeasures.hypertensionYTDPerformanceVal().eq(17).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.HypertensionYTDPerformanceVal)
        valBasedMeasures.hypertensionProgressBarMarkVal().eq(6).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.HypertensionProgressBarMarkVal)
        valBasedMeasures.wouldRecommendProviderTitle().eq(3).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.WouldRecommendProvider)
        valBasedMeasures.wouldRecommendProviderPatientExpInd().next().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.PatientExperienceIndividual)
        valBasedMeasures.wouldRecommendProviderYTDPerformance().eq(33).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.YTDPerformance)
        valBasedMeasures.wouldRecommendProviderYTDPerformanceVal().eq(33).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.WouldRecommendProviderYTDPerformanceVal)
        valBasedMeasures.wouldRecommendProviderProgressBarMarkVal().eq(9).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.WouldRecommendProviderProgressBarMarkVal)
        valBasedMeasures.A1CTitle().eq(4).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.A1C)
        valBasedMeasures.A1CQualityIndividual().next().should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.A1COutcomesGroup)
        valBasedMeasures.A1CYTDPerformance().eq(49).should('contain', valBasedMeasuresData.ValBasedMeasuresLabel.YTDPerformance)
        valBasedMeasures.A1CYTDPerformanceVal().eq(49).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.A1CYTDPerformanceVal)
        valBasedMeasures.A1CProgressBarMarkVal().eq(12).should('contain', valBasedMeasuresData.ValBasedMeasuresValue.A1CProgressBarMarkVal)
    })
})