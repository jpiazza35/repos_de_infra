/// <reference types="Cypress" />

describe('Productivity - Benchmark API', function () {
    let benchmarkData;
    before(function () {
        let username;
        let password;
        const enableRealData = Cypress.env("enableRealData");
        const reportingPeriod = Cypress.env("reportingPeriod");
        cy.getUserDetails(enableRealData, reportingPeriod).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            cy.generateAccessToken(username, password)
        });
    });

    beforeEach(function () {
        cy.fixture('API/00_Tenant/auth_data').as('authData')
        cy.fixture('API/02_Productivity/benchmark_data').then((data) => {
            benchmarkData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('05: Benchmark - GET /benchmark - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('05: Benchmark - GET /benchmark - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
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

    it('05: Benchmark - GET /benchmark - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId,
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

    //Fiscal year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'fiscal') {
        it('05: Benchmark - GET /benchmark - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'specialties=' + benchmarkData.fy_realData.specialties + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.fy_realData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.fy_realData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].image)

                })
        });

        it('05: Benchmark - GET /benchmark - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.fy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.fy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.fy_realData.cardKey + '&' + 'periodId=' + benchmarkData.fy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.fy_realData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.fy_realData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.fy_realData.benchmarkResponse.detail[3].image)

                })
        });
    }

    //Calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('05: Benchmark - GET /benchmark - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.cy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.cy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.cy_realData.cardKey + '&' + 'specialties=' + benchmarkData.cy_realData.specialties + '&' + 'periodId=' + benchmarkData.cy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.cy_realData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.cy_realData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].image)

                })
        });

        it('05: Benchmark - GET /benchmark - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.cy_realData.tenant + '&' + 'dashboardKey=' + benchmarkData.cy_realData.dashboardKey + '&' + 'cardKey=' + benchmarkData.cy_realData.cardKey + '&' + 'periodId=' + benchmarkData.cy_realData.periodId + '&' + 'yearMonth=' + benchmarkData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.cy_realData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.cy_realData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.cy_realData.benchmarkResponse.detail[3].image)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('05: Benchmark - GET /benchmark - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.mockData.tenant + '&' + 'dashboardKey=' + benchmarkData.mockData.dashboardKey + '&' + 'cardKey=' + benchmarkData.mockData.cardKey + '&' + 'specialties=' + benchmarkData.mockData.specialties + '&' + 'periodId=' + benchmarkData.mockData.periodId + '&' + 'yearMonth=' + benchmarkData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.mockData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.mockData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].image)

                })
        });

        it('05: Benchmark - GET /benchmark - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/benchmark?' + 'tenant=' + benchmarkData.mockData.tenant + '&' + 'dashboardKey=' + benchmarkData.mockData.dashboardKey + '&' + 'cardKey=' + benchmarkData.mockData.cardKey + '&' + 'periodId=' + benchmarkData.mockData.periodId + '&' + 'yearMonth=' + benchmarkData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(benchmarkData.mockData.benchmarkResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(benchmarkData.mockData.benchmarkResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[0].image)

                    expect(res.body.detail[1].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[1].image)

                    expect(res.body.detail[2].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[2].image)

                    expect(res.body.detail[3].value).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(benchmarkData.mockData.benchmarkResponse.detail[3].image)

                })
        });
    }
})