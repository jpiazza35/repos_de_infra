/// <reference types="Cypress" />

describe('Performance - Earning Codes API', function () {
    let earningCodesData;
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
        cy.fixture('API/02_Performance/earning_codes_data').then((data) => {
            earningCodesData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('06: Earning Codes - GET /earning-codes - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('06: Earning Codes - GET /earning-codes - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'tenant=' + earningCodesData.tenant + '&' + 'dashboardKey=' + earningCodesData.dashboardKey + '&' + 'cardKey=' + earningCodesData.cardKey + '&' + 'specialties=' + earningCodesData.specialties + '&' + 'periodId=' + earningCodesData.periodId + '&' + 'yearMonth=' + earningCodesData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
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

    it('06: Earning Codes - GET /earning-codes - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId,
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

        it('06: Earning Codes - GET /earning-codes - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'specialties=' + earningCodesData.realData.specialties + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(earningCodesData.realData.earningCodesResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(earningCodesData.realData.earningCodesResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].amount).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].amount)
                    expect(res.body.detail[0].total).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].total)
                    expect(res.body.detail[0].percentaje).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].percentaje)
                    expect(res.body.detail[0].name).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].name)

                    expect(res.body.detail[1].amount).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].amount)
                    expect(res.body.detail[1].total).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].total)
                    expect(res.body.detail[1].percentaje).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].percentaje)
                    expect(res.body.detail[1].name).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].name)

                })
        });

        it('06: Earning Codes - GET /earning-codes - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.realData.userId + '&' + 'tenant=' + earningCodesData.realData.tenant + '&' + 'dashboardKey=' + earningCodesData.realData.dashboardKey + '&' + 'cardKey=' + earningCodesData.realData.cardKey + '&' + 'periodId=' + earningCodesData.realData.periodId + '&' + 'yearMonth=' + earningCodesData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(earningCodesData.realData.earningCodesResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(earningCodesData.realData.earningCodesResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].amount).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].amount)
                    expect(res.body.detail[0].total).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].total)
                    expect(res.body.detail[0].percentaje).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].percentaje)
                    expect(res.body.detail[0].name).to.equal(earningCodesData.realData.earningCodesResponse.detail[0].name)

                    expect(res.body.detail[1].amount).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].amount)
                    expect(res.body.detail[1].total).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].total)
                    expect(res.body.detail[1].percentaje).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].percentaje)
                    expect(res.body.detail[1].name).to.equal(earningCodesData.realData.earningCodesResponse.detail[1].name)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('06: Earning Codes - GET /earning-codes - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.mockData.userId + '&' + 'tenant=' + earningCodesData.mockData.tenant + '&' + 'dashboardKey=' + earningCodesData.mockData.dashboardKey + '&' + 'cardKey=' + earningCodesData.mockData.cardKey + '&' + 'specialties=' + earningCodesData.mockData.specialties + '&' + 'periodId=' + earningCodesData.mockData.periodId + '&' + 'yearMonth=' + earningCodesData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(earningCodesData.mockData.earningCodesResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(earningCodesData.mockData.earningCodesResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].amount)
                    expect(res.body.detail[0].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].total)
                    expect(res.body.detail[0].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].percentage)
                    expect(res.body.detail[0].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].name)

                    expect(res.body.detail[1].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].amount1)
                    expect(res.body.detail[1].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].total1)
                    expect(res.body.detail[1].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].percentage1)
                    expect(res.body.detail[1].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].name1)

                    expect(res.body.detail[2].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].amount2)
                    expect(res.body.detail[2].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].total2)
                    expect(res.body.detail[2].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].percentage2)
                    expect(res.body.detail[2].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].name2)

                })
        });

        it('06: Earning Codes - GET /earning-codes - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/earning-codes?' + 'userId=' + earningCodesData.mockData.userId + '&' + 'tenant=' + earningCodesData.mockData.tenant + '&' + 'dashboardKey=' + earningCodesData.mockData.dashboardKey + '&' + 'cardKey=' + earningCodesData.mockData.cardKey + '&' + 'periodId=' + earningCodesData.mockData.periodId + '&' + 'yearMonth=' + earningCodesData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(earningCodesData.mockData.earningCodesResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(earningCodesData.mockData.earningCodesResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].amount)
                    expect(res.body.detail[0].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].total)
                    expect(res.body.detail[0].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].percentage)
                    expect(res.body.detail[0].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[0].name)

                    expect(res.body.detail[1].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].amount1)
                    expect(res.body.detail[1].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].total1)
                    expect(res.body.detail[1].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].percentage1)
                    expect(res.body.detail[1].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[1].name1)

                    expect(res.body.detail[2].amount).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].amount2)
                    expect(res.body.detail[2].total).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].total2)
                    expect(res.body.detail[2].percentaje).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].percentage2)
                    expect(res.body.detail[2].name).to.equal(earningCodesData.mockData.earningCodesResponse.detail[2].name2)
                })
        });
    }

})