/// <reference types="Cypress" />
import valBasedCompensation from '../../../../pageObjects/02_Performance/ValueBasedCompensation';

describe("Performance - Value Based Compensation", { testIsolation: false }, function () {
    let valBasedCompensationData;
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
        valBasedCompensation.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/value_based_compensation_data').then((data) => {
            valBasedCompensationData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('14: verify Value Based Compensation', function () {
            valBasedCompensation.valBasedCompensationTitle().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.valBasedCompensationTitle)
            valBasedCompensation.valBasedCompensationInfoIcon().eq(1).click()
            //valBasedCompensation.valBasedCompensationInfoToolTip().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.infoToolTip)

            // valBasedCompensation.measureTypeDescLabel().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.measureTypeDescLabel)
            // valBasedCompensation.compEligibleLabel().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.compEligibleLabel)
            // valBasedCompensation.compEarnedLabel().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.compEarnedLabel)

            // valBasedCompensation.outComesLabel().eq(0).should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.outComesLabel)
            // valBasedCompensation.patientExperienceLabel().eq(1).should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.patientExperience)
            // valBasedCompensation.qualityLabel().eq(2).should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.quality)
            // valBasedCompensation.totalLabel().should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.total)

            valBasedCompensation.kebabMenu().eq(6).click({ force: true })
            valBasedCompensation.exportDataPDF().eq(0).should('contain', valBasedCompensationData.realData.valBasedCompensationLabel.exportDataPDF)

        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('14: verify Value Based Compensation', function () {
            valBasedCompensation.valBasedCompensationTitle().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.valBasedCompensationTitle)
            valBasedCompensation.valBasedCompensationInfoIcon().eq(2).click()
            valBasedCompensation.valBasedCompensationInfoToolTip().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.infoToolTip)

            valBasedCompensation.measureTypeDescLabel().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.measureTypeDescLabel)
            valBasedCompensation.compEligibleLabel().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.compEligibleLabel)
            valBasedCompensation.compEarnedLabel().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.compEarnedLabel)

            valBasedCompensation.outComesLabel().eq(0).should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.outComesLabel)
            valBasedCompensation.patientExperienceLabel().eq(1).should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.patientExperience)
            valBasedCompensation.qualityLabel().eq(2).should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.quality)
            valBasedCompensation.totalLabel().should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.total)

            valBasedCompensation.kebabMenu().eq(6).click()
            valBasedCompensation.exportDataPDF().eq(0).should('contain', valBasedCompensationData.mockData.valBasedCompensationLabel.exportDataPDF)

        })
    }
})