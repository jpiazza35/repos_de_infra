/// <reference types="Cypress" />
import circuitBreakerValueBased from '../../../../pageObjects/02_Performance/CircuitBreakerValueBased';

describe("Performance - CircuitBreakerValueBased", { testIsolation: false }, function () {
    let circuitBreakerValBasedData;
    before(function () {
        cy.fixture('02_Performance/CircuitBreakerValueBased/circuit_Breaker_Value_Based_data').then((data) => {
            circuitBreakerValBasedData = data
        })
        //cy.logintoPS2()
        cy.visit('/performance')
    });

    beforeEach(function () {
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    it('07: verify CircuitBreakerValueBased', function () {
        circuitBreakerValueBased.circuitBreakervalBasedTitle().should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedLabel.CircuitBreakerValBasedTitle)
        circuitBreakerValueBased.chartClosureLabel().eq(0).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedLabel.ChartClosure)
        circuitBreakerValueBased.problemListReviewLabel().eq(1).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedLabel.ProblemListReview)
        circuitBreakerValueBased.maintenanceHospitalPrivilegesLabel().eq(2).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedLabel.MaintenanceOfHospitalPrivileges)
        circuitBreakerValueBased.chartClosurePercent().eq(0).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedValue.ChartClosurePercent)
        circuitBreakerValueBased.problemListReviewPercent().eq(1).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedValue.ProblemListReviewPercent)
        circuitBreakerValueBased.maintenanceHospitalPrivilPercent().eq(2).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedValue.MaintenanceHospitalPrivilPercent)
        circuitBreakerValueBased.chartClosureprogressBarMarkVal().eq(0).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedValue.ChartClosureprogressBarMarkVal)
        circuitBreakerValueBased.problemListReviewprogressBarMarkVal().eq(1).should('contain', circuitBreakerValBasedData.CircuitBreakerValBasedValue.ProblemListReviewProgressBarMarkVal)
    })
})