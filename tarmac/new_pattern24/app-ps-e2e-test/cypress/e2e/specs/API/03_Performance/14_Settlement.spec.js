/// <reference types="Cypress" />

describe('Performance - Settlement API', function () {
    let settlementData;
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
        cy.fixture('API/02_Performance/settlement_data').then((data) => {
            settlementData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('11: Settlement - GET /settlement - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('11: Settlement - GET /settlement - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
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

    it('11: Settlement - GET /settlement - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId,
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
        it('11: Settlement - GET /settlement - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'specialties=' + settlementData.realData.specialties + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(settlementData.realData.settlementResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(settlementData.realData.settlementResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].title).to.equal(settlementData.realData.settlementResponse.detail[0].title)
                    expect(res.body.detail[0].value).to.equal(settlementData.realData.settlementResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(settlementData.realData.settlementResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(settlementData.realData.settlementResponse.detail[0].image)

                    expect(res.body.detail[1].title).to.equal(settlementData.realData.settlementResponse.detail[1].title)
                    expect(res.body.detail[1].value).to.equal(settlementData.realData.settlementResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(settlementData.realData.settlementResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(settlementData.realData.settlementResponse.detail[1].image)

                    expect(res.body.detail[2].title).to.equal(settlementData.realData.settlementResponse.detail[2].title)
                    expect(res.body.detail[2].value).to.equal(settlementData.realData.settlementResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(settlementData.realData.settlementResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(settlementData.realData.settlementResponse.detail[2].image)

                    expect(res.body.detail[3].title).to.equal(settlementData.realData.settlementResponse.detail[3].title)
                    expect(res.body.detail[3].value).to.equal(settlementData.realData.settlementResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(settlementData.realData.settlementResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(settlementData.realData.settlementResponse.detail[3].image)

                    expect(res.body.detail[4].title).to.equal(settlementData.realData.settlementResponse.detail[4].title)
                    expect(res.body.detail[4].value).to.equal(settlementData.realData.settlementResponse.detail[4].value)
                    expect(res.body.detail[4].label).to.equal(settlementData.realData.settlementResponse.detail[4].label)
                    expect(res.body.detail[4].image).to.equal(settlementData.realData.settlementResponse.detail[4].image)
                })
        });

        it('11: Settlement - GET /settlement - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.realData.userId + '&' + 'tenant=' + settlementData.realData.tenant + '&' + 'dashboardKey=' + settlementData.realData.dashboardKey + '&' + 'cardKey=' + settlementData.realData.cardKey + '&' + 'periodId=' + settlementData.realData.periodId + '&' + 'yearMonth=' + settlementData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(settlementData.realData.settlementResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(settlementData.realData.settlementResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].title).to.equal(settlementData.realData.settlementResponse.detail[0].title)
                    expect(res.body.detail[0].value).to.equal(settlementData.realData.settlementResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(settlementData.realData.settlementResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(settlementData.realData.settlementResponse.detail[0].image)

                    expect(res.body.detail[1].title).to.equal(settlementData.realData.settlementResponse.detail[1].title)
                    expect(res.body.detail[1].value).to.equal(settlementData.realData.settlementResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(settlementData.realData.settlementResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(settlementData.realData.settlementResponse.detail[1].image)

                    expect(res.body.detail[2].title).to.equal(settlementData.realData.settlementResponse.detail[2].title)
                    expect(res.body.detail[2].value).to.equal(settlementData.realData.settlementResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(settlementData.realData.settlementResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(settlementData.realData.settlementResponse.detail[2].image)

                    expect(res.body.detail[3].title).to.equal(settlementData.realData.settlementResponse.detail[3].title)
                    expect(res.body.detail[3].value).to.equal(settlementData.realData.settlementResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(settlementData.realData.settlementResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(settlementData.realData.settlementResponse.detail[3].image)

                    expect(res.body.detail[4].title).to.equal(settlementData.realData.settlementResponse.detail[4].title)
                    expect(res.body.detail[4].value).to.equal(settlementData.realData.settlementResponse.detail[4].value)
                    expect(res.body.detail[4].label).to.equal(settlementData.realData.settlementResponse.detail[4].label)
                    expect(res.body.detail[4].image).to.equal(settlementData.realData.settlementResponse.detail[4].image)
                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('11: Settlement - GET /settlement - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.mockData.userId + '&' + 'tenant=' + settlementData.mockData.tenant + '&' + 'dashboardKey=' + settlementData.mockData.dashboardKey + '&' + 'cardKey=' + settlementData.mockData.cardKey + '&' + 'specialties=' + settlementData.mockData.specialties + '&' + 'periodId=' + settlementData.mockData.periodId + '&' + 'yearMonth=' + settlementData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(settlementData.mockData.settlementResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(settlementData.mockData.settlementResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].title).to.equal(settlementData.mockData.settlementResponse.detail[0].title)
                    expect(res.body.detail[0].value).to.equal(settlementData.mockData.settlementResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(settlementData.mockData.settlementResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(settlementData.mockData.settlementResponse.detail[0].image)

                    expect(res.body.detail[1].title).to.equal(settlementData.mockData.settlementResponse.detail[1].title)
                    expect(res.body.detail[1].value).to.equal(settlementData.mockData.settlementResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(settlementData.mockData.settlementResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(settlementData.mockData.settlementResponse.detail[1].image)

                    expect(res.body.detail[2].title).to.equal(settlementData.mockData.settlementResponse.detail[2].title)
                    expect(res.body.detail[2].value).to.equal(settlementData.mockData.settlementResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(settlementData.mockData.settlementResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(settlementData.mockData.settlementResponse.detail[2].image)

                    expect(res.body.detail[3].title).to.equal(settlementData.mockData.settlementResponse.detail[3].title)
                    expect(res.body.detail[3].value).to.equal(settlementData.mockData.settlementResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(settlementData.mockData.settlementResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(settlementData.mockData.settlementResponse.detail[3].image)

                    expect(res.body.detail[4].title).to.equal(settlementData.mockData.settlementResponse.detail[4].title)
                    expect(res.body.detail[4].value).to.equal(settlementData.mockData.settlementResponse.detail[4].value)
                    expect(res.body.detail[4].label).to.equal(settlementData.mockData.settlementResponse.detail[4].label)
                    expect(res.body.detail[4].image).to.equal(settlementData.mockData.settlementResponse.detail[4].image)
                })
        });

        it('11: Settlement - GET /settlement - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/settlement?' + 'userId=' + settlementData.mockData.userId + '&' + 'tenant=' + settlementData.mockData.tenant + '&' + 'dashboardKey=' + settlementData.mockData.dashboardKey + '&' + 'cardKey=' + settlementData.mockData.cardKey + '&' + 'periodId=' + settlementData.mockData.periodId + '&' + 'yearMonth=' + settlementData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(settlementData.mockData.settlementResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(settlementData.mockData.settlementResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].title).to.equal(settlementData.mockData.settlementResponse.detail[0].title)
                    expect(res.body.detail[0].value).to.equal(settlementData.mockData.settlementResponse.detail[0].value)
                    expect(res.body.detail[0].label).to.equal(settlementData.mockData.settlementResponse.detail[0].label)
                    expect(res.body.detail[0].image).to.equal(settlementData.mockData.settlementResponse.detail[0].image)

                    expect(res.body.detail[1].title).to.equal(settlementData.mockData.settlementResponse.detail[1].title)
                    expect(res.body.detail[1].value).to.equal(settlementData.mockData.settlementResponse.detail[1].value)
                    expect(res.body.detail[1].label).to.equal(settlementData.mockData.settlementResponse.detail[1].label)
                    expect(res.body.detail[1].image).to.equal(settlementData.mockData.settlementResponse.detail[1].image)

                    expect(res.body.detail[2].title).to.equal(settlementData.mockData.settlementResponse.detail[2].title)
                    expect(res.body.detail[2].value).to.equal(settlementData.mockData.settlementResponse.detail[2].value)
                    expect(res.body.detail[2].label).to.equal(settlementData.mockData.settlementResponse.detail[2].label)
                    expect(res.body.detail[2].image).to.equal(settlementData.mockData.settlementResponse.detail[2].image)

                    expect(res.body.detail[3].title).to.equal(settlementData.mockData.settlementResponse.detail[3].title)
                    expect(res.body.detail[3].value).to.equal(settlementData.mockData.settlementResponse.detail[3].value)
                    expect(res.body.detail[3].label).to.equal(settlementData.mockData.settlementResponse.detail[3].label)
                    expect(res.body.detail[3].image).to.equal(settlementData.mockData.settlementResponse.detail[3].image)

                    expect(res.body.detail[4].title).to.equal(settlementData.mockData.settlementResponse.detail[4].title)
                    expect(res.body.detail[4].value).to.equal(settlementData.mockData.settlementResponse.detail[4].value)
                    expect(res.body.detail[4].label).to.equal(settlementData.mockData.settlementResponse.detail[4].label)
                    expect(res.body.detail[4].image).to.equal(settlementData.mockData.settlementResponse.detail[4].image)
                })
        });
    }
})