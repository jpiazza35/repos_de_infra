/// <reference types="Cypress" />

describe('Performance - Compensation Summary API', function () {
    let compSummaryData;
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
        cy.fixture('API/02_Performance/compensation_summary_data').then((data) => {
            compSummaryData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('05: Comp Summary - GET /compensation-summary -  verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);

            })
    });

    it('05: Comp Summary - GET /compensation-summary - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
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

    it('05: Comp Summary - GET /compensation-summary - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId,
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

        it('05: Comp Summary - GET /compensation-summary - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'specialties=' + compSummaryData.fy_realData.specialties + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json'
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(compSummaryData.fy_realData.compSummaryResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(compSummaryData.fy_realData.compSummaryResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[0].categoryDescription)
                    expect(res.body.detail[0].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[0].categoryValue)

                    expect(res.body.detail[1].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[1].categoryDescription)
                    expect(res.body.detail[1].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[1].categoryValue)

                    expect(res.body.detail[2].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[2].categoryDescription)
                    expect(res.body.detail[2].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[2].categoryValue)

                    expect(res.body.detail[3].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[3].categoryDescription)
                    expect(res.body.detail[3].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[3].categoryValue)

                    expect(res.body.detail[4].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[4].categoryDescription)
                    expect(res.body.detail[4].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[4].categoryValue)

                })
        });

        it('05: Comp Summary - GET /compensation-summary - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.fy_realData.userId + '&' + 'tenant=' + compSummaryData.fy_realData.tenant + '&' + 'dashboardKey=' + compSummaryData.fy_realData.dashboardKey + '&' + 'cardKey=' + compSummaryData.fy_realData.cardKey + '&' + 'periodId=' + compSummaryData.fy_realData.periodId + '&' + 'yearMonth=' + compSummaryData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(compSummaryData.fy_realData.compSummaryResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(compSummaryData.fy_realData.compSummaryResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[0].categoryDescription)
                    expect(res.body.detail[0].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[0].categoryValue)

                    expect(res.body.detail[1].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[1].categoryDescription)
                    expect(res.body.detail[1].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[1].categoryValue)

                    expect(res.body.detail[2].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[2].categoryDescription)
                    expect(res.body.detail[2].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[2].categoryValue)

                    expect(res.body.detail[3].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[3].categoryDescription)
                    expect(res.body.detail[3].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[3].categoryValue)

                    expect(res.body.detail[4].categoryDescription).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[4].categoryDescription)
                    expect(res.body.detail[4].categoryValue).to.equal(compSummaryData.fy_realData.compSummaryResponse.detail[4].categoryValue)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('05: Comp Summary - GET /compensation-summary - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.mockData.userId + '&' + 'tenant=' + compSummaryData.mockData.tenant + '&' + 'dashboardKey=' + compSummaryData.mockData.dashboardKey + '&' + 'cardKey=' + compSummaryData.mockData.cardKey + '&' + 'specialties=' + compSummaryData.mockData.specialties + '&' + 'periodId=' + compSummaryData.mockData.periodId + '&' + 'yearMonth=' + compSummaryData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json'
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(compSummaryData.mockData.compSummaryResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(compSummaryData.mockData.compSummaryResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[0].categoryDescription)
                    expect(res.body.detail[0].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[0].categoryValue)

                    expect(res.body.detail[1].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[1].categoryDescription)
                    expect(res.body.detail[1].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[1].categoryValue)

                    expect(res.body.detail[2].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[2].categoryDescription)
                    expect(res.body.detail[2].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[2].categoryValue)


                })
        });

        it('05: Comp Summary - GET /compensation-summary - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/compensation-summary?' + 'userId=' + compSummaryData.mockData.userId + '&' + 'tenant=' + compSummaryData.mockData.tenant + '&' + 'dashboardKey=' + compSummaryData.mockData.dashboardKey + '&' + 'cardKey=' + compSummaryData.mockData.cardKey + '&' + 'periodId=' + compSummaryData.mockData.periodId + '&' + 'yearMonth=' + compSummaryData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {``
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(compSummaryData.mockData.compSummaryResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(compSummaryData.mockData.compSummaryResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[0].categoryDescription)
                    expect(res.body.detail[0].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[0].categoryValue)

                    expect(res.body.detail[1].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[1].categoryDescription)
                    expect(res.body.detail[1].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[1].categoryValue)

                    expect(res.body.detail[2].categoryDescription).to.equal(compSummaryData.mockData.compSummaryResponse.detail[2].categoryDescription)
                    expect(res.body.detail[2].categoryValue).to.equal(compSummaryData.mockData.compSummaryResponse.detail[2].categoryValue)

                })
        });

    }
})