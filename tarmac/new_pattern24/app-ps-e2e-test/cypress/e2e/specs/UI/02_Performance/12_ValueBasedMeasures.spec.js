/// <reference types="Cypress" />
import valBasedMeasures from '../../../../pageObjects/02_Performance/ValueBasedMeasures';

describe("Performance - Value Based Measures", { testIsolation: false }, function () {
    let valBasedMeasuresData;
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
        valBasedMeasures.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/value_based_measures_data').then((data) => {
            valBasedMeasuresData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('12: verify Value Based Measures', function () {
            cy.fiscalYearFilterJuly2022()
            valBasedMeasures.valBasedMeasureTitle().should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.valBasedMeasuresTitle)
            valBasedMeasures.valBasedMeasureInfoIcon().eq(2).click()
            valBasedMeasures.valBasedMeasureInfoToolTip().should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.infoToolTip)

            valBasedMeasures.qualityTitle().eq(0).should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.quality)
            valBasedMeasures.PHQ9().eq(0).next().should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.PHQ9)

            valBasedMeasures.qualityTitle().eq(1).should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.quality)
            valBasedMeasures.STIScreening().eq(1).next().should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.STIScreening)

            valBasedMeasures.qualityTitle().eq(2).should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.quality)
            valBasedMeasures.teamwork().next().should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.teamwork)

            valBasedMeasures.kebabMenu().eq(7).click()
            valBasedMeasures.exportDataPDF().eq(0).should('contain', valBasedMeasuresData.realData.valBasedMeasuresLabel.exportDataPDF)
        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('12: verify Value Based Measures', function () {
            valBasedMeasures.valBasedMeasureTitle().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.valBasedMeasuresTitle)
            valBasedMeasures.valBasedMeasureInfoIcon().eq(3).click()
            valBasedMeasures.valBasedMeasureInfoToolTip().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.infoToolTip)

            valBasedMeasures.breastCancerScreeningTitle().eq(0).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.breastCancerScreening)
            valBasedMeasures.qualityIndividual().eq(0).next().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.qualityIndividual)
            valBasedMeasures.YTDPerformance().eq(0).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.YTDPerformance)

            valBasedMeasures.depressionScreeningTitle().eq(1).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.depressionScreening)
            valBasedMeasures.depressionScreeningQualityIndividual().eq(1).next().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.qualityIndividual)
            valBasedMeasures.depressionScreeningYTDPerformance().eq(1).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.YTDPerformance)

            valBasedMeasures.hypertensionTitle().eq(2).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.hypertension)
            valBasedMeasures.hypertensionqualityIndividual().eq(2).next().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.qualityIndividual)
            valBasedMeasures.hypertensionYTDPerformance().eq(2).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.YTDPerformance)

            valBasedMeasures.wouldRecommendProviderTitle().eq(3).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.wouldRecommendProvider)
            valBasedMeasures.wouldRecommendProviderPatientExpInd().next().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.patientExperienceIndividual)
            valBasedMeasures.wouldRecommendProviderYTDPerformance().eq(3).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.YTDPerformance)

            valBasedMeasures.A1CTitle().eq(4).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.A1C)
            valBasedMeasures.A1CPatientExperience().next().should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.patientExperienceIndividual)
            valBasedMeasures.A1CYTDPerformance().eq(4).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.YTDPerformance)

            valBasedMeasures.kebabMenu().eq(7).click()
            valBasedMeasures.exportDataPDF().eq(0).should('contain', valBasedMeasuresData.mockData.valBasedMeasuresLabel.exportDataPDF)
        })
    }
})