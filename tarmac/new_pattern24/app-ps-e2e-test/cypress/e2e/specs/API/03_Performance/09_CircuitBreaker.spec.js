/// <reference types="Cypress" />

describe('Performance - Ciruit Breaker API', function () {
    let ciruitBreakerData;
    before(function () {
        let username;
        let password;
        const enableRealData = Cypress.env("enableRealData");
        cy.getUserDetails(enableRealData).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            cy.generateAccessToken(username, password)
        });
    });

    beforeEach(function () {
        cy.fixture('API/00_Tenant/auth_data').as('authData')
        cy.fixture('API/02_Performance/circuit_breaker_data').then((data) => {
            ciruitBreakerData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('07: Circuit Breaker - GET /circuit-breaker - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker  - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('07: Circuit Breaker - GET /circuit-breaker - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realDatatenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
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

    it('07: Circuit Breaker - GET /circuit-breaker - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId,
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

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {

        it('07: Circuit Breaker - GET /circuit-breaker - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'specialties=' + ciruitBreakerData.realData.specialties + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.cardSettings.infoIcon)

                    expect(res.body.summary.isTargetMet).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.summary.isTargetMet)

                    expect(res.body.detail[0].targetValue).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].targetValue)
                    expect(res.body.detail[0].performanceValue).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].performanceValue)
                    expect(res.body.detail[0].name).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].name)

                })
        });

        it('07: Circuit Breaker - GET /circuit-breaker - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.realData.userId + '&' + 'tenant=' + ciruitBreakerData.realData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.realData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.realData.cardKey + '&' + 'periodId=' + ciruitBreakerData.realData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.cardSettings.infoIcon)

                    expect(res.body.summary.isTargetMet).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.summary.isTargetMet)

                    expect(res.body.detail[0].targetValue).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].targetValue)
                    expect(res.body.detail[0].performanceValue).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].performanceValue)
                    expect(res.body.detail[0].name).to.equal(ciruitBreakerData.realData.circuitBreakerResponse.detail[0].name)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {

        it('07: Circuit Breaker - GET /circuit-breaker - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.mockData.userId + '&' + 'tenant=' + ciruitBreakerData.mockData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.mockData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.mockData.cardKey + '&' + 'specialties=' + ciruitBreakerData.mockData.specialties + '&' + 'periodId=' + ciruitBreakerData.mockData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.cardSettings.infoIcon)

                    expect(res.body.summary.isTargetMet).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.summary.isTargetMet)

                    expect(res.body.detail[0].targetValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].targetValue)
                    expect(res.body.detail[0].performanceValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].performanceValue)
                    expect(res.body.detail[0].name).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].name)

                    expect(res.body.detail[1].targetValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].targetValue)
                    expect(res.body.detail[1].performanceValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].performanceValue)
                    expect(res.body.detail[1].name).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].name)
                })
        });

        it('07: Circuit Breaker - GET /circuit-breaker - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/circuit-breaker?' + 'userId=' + ciruitBreakerData.mockData.userId + '&' + 'tenant=' + ciruitBreakerData.mockData.tenant + '&' + 'dashboardKey=' + ciruitBreakerData.mockData.dashboardKey + '&' + 'cardKey=' + ciruitBreakerData.mockData.cardKey + '&' + 'periodId=' + ciruitBreakerData.mockData.periodId + '&' + 'yearMonth=' + ciruitBreakerData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.cardSettings.infoIcon)

                    expect(res.body.summary.isTargetMet).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.summary.isTargetMet)

                    expect(res.body.detail[0].targetValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].targetValue)
                    expect(res.body.detail[0].performanceValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].performanceValue)
                    expect(res.body.detail[0].name).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[0].name)

                    expect(res.body.detail[1].targetValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].targetValue)
                    expect(res.body.detail[1].performanceValue).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].performanceValue)
                    expect(res.body.detail[1].name).to.equal(ciruitBreakerData.mockData.circuitBreakerResponse.detail[1].name)
                })
        });

    }
})