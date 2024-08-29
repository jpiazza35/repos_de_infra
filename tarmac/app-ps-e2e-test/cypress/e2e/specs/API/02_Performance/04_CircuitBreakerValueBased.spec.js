/// <reference types="Cypress" />

describe('Performance - CiruitBreakerValueBased API', function () {
    let CiruitBreakerdata;

    before(function () {
        cy.generateAccessToken();
    });

    beforeEach(function () {
        cy.fixture('00_Auth/auth_data').as('authData')
        cy.fixture('02_Performance/CircuitBreakerValueBased/circuit_Breaker_Value_Based_data').then((data) => {
            CiruitBreakerdata = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 200 response', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Mandatparams,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json',
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                expect(res.body.settings.infoIcon).to.equal(CiruitBreakerdata.CircuitBreakerValBasedLabel.InfoIcon)
                expect(res.body.summary.isTargetMet).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetMet)
                expect(res.body.detail[0].targetValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetValue1)
                expect(res.body.detail[0].performanceValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.PerformanceValue1)
                expect(res.body.detail[0].name).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.Name1)
                expect(res.body.detail[1].targetValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetValue2)
                expect(res.body.detail[1].performanceValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.PerformanceValue2)
                expect(res.body.detail[1].name).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.Name2)
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 200 response - With Optional Param Specialty', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Mandatparams + CiruitBreakerdata.Specialty,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json',
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                expect(res.body.settings.infoIcon).to.equal(CiruitBreakerdata.CircuitBreakerValBasedLabel.InfoIcon)
                expect(res.body.summary.isTargetMet).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetMet)
                expect(res.body.detail[0].targetValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetValue1)
                expect(res.body.detail[0].performanceValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.PerformanceValue1)
                expect(res.body.detail[0].name).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.Name1)
                expect(res.body.detail[1].targetValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.TargetValue2)
                expect(res.body.detail[1].performanceValue).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.PerformanceValue2)
                expect(res.body.detail[1].name).to.equal(CiruitBreakerdata.CircuitBreakerValBasedValue.Name2)
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Mandatparams,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.invalidToken,
                    'Content-Type': 'application/json'

                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.invalidTokenMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Mandatparams,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Mandatparams,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.expiredToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.expiredTokenMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.Tenant + CiruitBreakerdata.PeriodId + CiruitBreakerdata.YearMonth,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(400);
                expect(res.body).to.include(this.authData.missingParameterMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.UserId + CiruitBreakerdata.PeriodId + CiruitBreakerdata.YearMonth,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(400);
                expect(res.body).to.include(this.authData.missingParameterMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.UserId + CiruitBreakerdata.Tenant + CiruitBreakerdata.YearMonth,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(400);
                expect(res.body).to.include(this.authData.missingParameterMessage);
            })
    });

    it('04: Circuit Breaker Value Based - GET /CircuitBreaker-ValueBased - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: CiruitBreakerdata.CiruitBreakAPIUrl + CiruitBreakerdata.UserId + CiruitBreakerdata.Tenant + CiruitBreakerdata.PeriodId,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(400);
                expect(res.body).to.include(this.authData.missingParameterMessage);
            })
    });
})