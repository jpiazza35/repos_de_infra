/// <reference types="Cypress" />
import valBasedCompensation from '../../../../pageObjects/02_Performance/ValueBasedCompensation';

describe("Performance - ValueBasedCompensation", { testIsolation: false }, function () {
    let valBasedCompensationData;
    before(function () {
        cy.fixture('02_Performance/ValueBasedCompensation/value_Based_Compensation_data').then((data) => {
            valBasedCompensationData = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('08: verify ValueBasedCompensation', function () {
        valBasedCompensation.valBasedCompensationTitle().should('contain', valBasedCompensationData.ValBasedCompensationLabel.ValBasedCompensationTitle)
        valBasedCompensation.measureTypeDescLabel().eq(1).should('contain', valBasedCompensationData.ValBasedCompensationLabel.MeasureTypeDescLabel)
        valBasedCompensation.compEligibleLabel().eq(2).should('contain', valBasedCompensationData.ValBasedCompensationLabel.CompEligibleLabel)
        valBasedCompensation.compEarnedLabel().eq(2).should('contain', valBasedCompensationData.ValBasedCompensationLabel.CompEarnedLabel)
        valBasedCompensation.outComesLabel().eq(0).should('contain', valBasedCompensationData.ValBasedCompensationLabel.OutComesLabel)
        valBasedCompensation.outComesCompEligible().eq(0).should('contain', valBasedCompensationData.ValBasedCompensationValue.OutComesCompEligible)
        valBasedCompensation.outComesCompEarned().eq(0).should('contain', valBasedCompensationData.ValBasedCompensationValue.OutComesCompEarned)
        valBasedCompensation.patientExperienceLabel().eq(1).should('contain', valBasedCompensationData.ValBasedCompensationLabel.PatientExperience)
        valBasedCompensation.patientExperienceCompEligible().eq(1).should('contain', valBasedCompensationData.ValBasedCompensationValue.PatientExpCompEligible)
        valBasedCompensation.patientExperienceCompEarned().eq(1).should('contain', valBasedCompensationData.ValBasedCompensationValue.PatientExpCompEarned)
        valBasedCompensation.qualityLabel().eq(2).should('contain', valBasedCompensationData.ValBasedCompensationLabel.Quality)
        valBasedCompensation.qualityCompEligible().eq(2).should('contain', valBasedCompensationData.ValBasedCompensationValue.QualityCompEligible)
        valBasedCompensation.qualityCompEarned().eq(2).should('contain', valBasedCompensationData.ValBasedCompensationValue.QualityCompEarned)
        valBasedCompensation.totalLabel().should('contain', valBasedCompensationData.ValBasedCompensationLabel.Total)
        valBasedCompensation.totalCompEligible().should('contain', valBasedCompensationData.ValBasedCompensationValue.TotalCompEligible)
        valBasedCompensation.totalCompEarned().should('contain', valBasedCompensationData.ValBasedCompensationValue.TotalCompEarned)
    })
})