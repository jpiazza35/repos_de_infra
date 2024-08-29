/// <reference types="Cypress" />

describe('Performance - Value Based Compensation API', function () {
    let valueBasedCompData;
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
        cy.fixture('API/02_Performance/value_based_compensation_data').then((data) => {
            valueBasedCompData = data
        })

    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('09: Value Based Compensation - GET /value-based-compensation -  verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);

            })
    });

    it('09: Value Based Compensation - GET /value-based-compensation - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation  - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
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

    it('09: Value Based Compensation - GET /value-based-compensation - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'specialties=' + valueBasedCompData.realData.specialties + '&' + 'periodId=' + valueBasedCompData.realData.periodId,
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

        it('09: Value Based Compensation - GET /value-based-compensation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.realData.userId + '&' + 'tenant=' + valueBasedCompData.realData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.realData.cardKey + '&' + 'periodId=' + valueBasedCompData.realData.periodId + '&' + 'yearMonth=' + valueBasedCompData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedCompData.realData.valueBasedCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedCompData.realData.valueBasedCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureTypeDescription).to.equal(valueBasedCompData.realData.valueBasedCompResponse.detail[0].measureTypeDescription)
                    expect(res.body.detail[0].compEligible).to.equal(valueBasedCompData.realData.valueBasedCompResponse.detail[0].compEligible)
                    expect(res.body.detail[0].compEarned).to.equal(valueBasedCompData.realData.valueBasedCompResponse.detail[0].compEarned)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('09: Value Based Compensation - GET /value-based-compensation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.mockData.userId + '&' + 'tenant=' + valueBasedCompData.mockData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.mockData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.mockData.cardKey + '&' + 'specialties=' + valueBasedCompData.mockData.specialties + '&' + 'periodId=' + valueBasedCompData.mockData.periodId + '&' + 'yearMonth=' + valueBasedCompData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].measureTypeDescription)
                    expect(res.body.detail[0].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].compEligible)
                    expect(res.body.detail[0].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].compEarned)

                    expect(res.body.detail[1].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].measureTypeDescription)
                    expect(res.body.detail[1].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].compEligible)
                    expect(res.body.detail[1].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].compEarned)

                    expect(res.body.detail[2].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].measureTypeDescription)
                    expect(res.body.detail[2].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].compEligible)
                    expect(res.body.detail[2].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].compEarned)
                })
        });

        it('09: Value Based Compensation - GET /value-based-compensation - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-compensation?' + 'userId=' + valueBasedCompData.mockData.userId + '&' + 'tenant=' + valueBasedCompData.mockData.tenant + '&' + 'dashboardKey=' + valueBasedCompData.mockData.dashboardKey + '&' + 'cardKey=' + valueBasedCompData.mockData.cardKey + '&' + 'periodId=' + valueBasedCompData.mockData.periodId + '&' + 'yearMonth=' + valueBasedCompData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].measureTypeDescription)
                    expect(res.body.detail[0].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].compEligible)
                    expect(res.body.detail[0].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[0].compEarned)

                    expect(res.body.detail[1].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].measureTypeDescription)
                    expect(res.body.detail[1].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].compEligible)
                    expect(res.body.detail[1].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[1].compEarned)

                    expect(res.body.detail[2].measureTypeDescription).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].measureTypeDescription)
                    expect(res.body.detail[2].compEligible).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].compEligible)
                    expect(res.body.detail[2].compEarned).to.equal(valueBasedCompData.mockData.valueBasedCompResponse.detail[2].compEarned)
                })
        });

    }
})