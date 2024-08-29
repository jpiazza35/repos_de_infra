/// <reference types="Cypress" />
import circuitBreakerValueBased from '../../../../pageObjects/02_Performance/CircuitBreakerValueBased';

describe("Performance - Circuit Breaker Value Based", { testIsolation: false }, function () {
    let circuitBreakerValBasedData;
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
        circuitBreakerValueBased.dashboardPerformanceButton().click()

    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/circuit_breaker_data').then((data) => {
            circuitBreakerValBasedData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('13: verify Circuit Breaker Value Based', function () {
            cy.fiscalYearFilterJuly2022()
            circuitBreakerValueBased.circuitBreakervalBasedTitle().should('contain', circuitBreakerValBasedData.realData.circuitBreakerValBasedLabel.circuitBreakerValBasedTitle)
            circuitBreakerValueBased.circuitBreakerInfoIcon().eq(0).click()
            circuitBreakerValueBased.circuitBreakerInfoToolTip().should('contain', circuitBreakerValBasedData.realData.circuitBreakerValBasedLabel.infoToolTip)
            circuitBreakerValueBased.wRVUProductivityLabel().eq(0).should('contain', circuitBreakerValBasedData.realData.circuitBreakerValBasedLabel.wRVUProductivity)
            circuitBreakerValueBased.kebabMenu().eq(5).click()
            circuitBreakerValueBased.exportDataPDF().eq(0).should('contain', circuitBreakerValBasedData.realData.circuitBreakerValBasedLabel.exportDataPDF)
        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('13: verify Circuit Breaker Value Based', function () {
            circuitBreakerValueBased.circuitBreakervalBasedTitle().should('contain', circuitBreakerValBasedData.mockData.circuitBreakerValBasedLabel.circuitBreakerValBasedTitle)
            circuitBreakerValueBased.circuitBreakerInfoIcon().eq(1).click()
            circuitBreakerValueBased.circuitBreakerInfoToolTip().should('contain', circuitBreakerValBasedData.mockData.circuitBreakerValBasedLabel.infoToolTip)
            circuitBreakerValueBased.chartClosureLabel().eq(0).should('contain', circuitBreakerValBasedData.mockData.circuitBreakerValBasedLabel.chartClosure)
            circuitBreakerValueBased.problemListReviewLabel().eq(1).should('contain', circuitBreakerValBasedData.mockData.circuitBreakerValBasedLabel.problemListReview)
            circuitBreakerValueBased.kebabMenu().eq(5).click()
            circuitBreakerValueBased.exportDataPDF().eq(0).should('contain', circuitBreakerValBasedData.mockData.circuitBreakerValBasedLabel.exportDataPDF)
        })
    }
})