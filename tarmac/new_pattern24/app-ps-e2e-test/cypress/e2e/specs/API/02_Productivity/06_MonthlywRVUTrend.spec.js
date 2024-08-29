/// <reference types="Cypress" />

describe('Productivity - Monthly wRVu Trend API', function () {
    let monthlywRVUTrendData;
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
        cy.fixture('API/02_Productivity/monthly_wRVU_trend_data').then((data) => {
            monthlywRVUTrendData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
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

    it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId,
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

    //fiscal year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'fiscal') {
        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });

        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.fy_realData.cardKey + '&' + 'periodId=' + monthlywRVUTrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.fy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });
    }

    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.cy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.cy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.cy_realData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.cy_realData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.cy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });

        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.cy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.cy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.cy_realData.cardKey + '&' + 'periodId=' + monthlywRVUTrendData.cy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.cy_realData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.mockData.cardKey + '&' + 'specialties=' + monthlywRVUTrendData.mockData.specialties + '&' + 'periodId=' + monthlywRVUTrendData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });

        it('06: Monthly wRVu Trend - GET /monthly wRVU Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-trend?' + 'tenant=' + monthlywRVUTrendData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUTrendData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUTrendData.mockData.cardKey + '&' + 'periodId=' + monthlywRVUTrendData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUTrendData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.currentYear.ytd).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.currentYear.ytd)
                    expect(res.body.detail.currentYear.annualized).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.currentYear.annualized)

                    expect(res.body.detail.priorYear.ytd).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.priorYear.ytd)
                    expect(res.body.detail.priorYear.annualized).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.priorYear.annualized)

                    expect(res.body.detail.dataCurrent[0].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[0].date)
                    expect(res.body.detail.dataCurrent[0].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[0].value)

                    expect(res.body.detail.dataCurrent[1].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[1].date)
                    expect(res.body.detail.dataCurrent[1].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[1].value)

                    expect(res.body.detail.dataCurrent[2].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[2].date)
                    expect(res.body.detail.dataCurrent[2].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[2].value)

                    expect(res.body.detail.dataCurrent[3].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[3].date)
                    expect(res.body.detail.dataCurrent[3].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[3].value)

                    expect(res.body.detail.dataCurrent[4].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[4].date)
                    expect(res.body.detail.dataCurrent[4].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[4].value)

                    expect(res.body.detail.dataCurrent[5].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[5].date)
                    expect(res.body.detail.dataCurrent[5].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[5].value)

                    expect(res.body.detail.dataCurrent[6].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[6].date)
                    expect(res.body.detail.dataCurrent[6].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[6].value)

                    expect(res.body.detail.dataCurrent[7].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[7].date)
                    expect(res.body.detail.dataCurrent[7].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[7].value)

                    expect(res.body.detail.dataCurrent[8].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[8].date)
                    expect(res.body.detail.dataCurrent[8].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[8].value)

                    expect(res.body.detail.dataCurrent[9].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[9].date)
                    expect(res.body.detail.dataCurrent[9].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[9].value)

                    expect(res.body.detail.dataCurrent[10].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[10].date)
                    expect(res.body.detail.dataCurrent[10].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[10].value)

                    expect(res.body.detail.dataCurrent[11].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[11].date)
                    expect(res.body.detail.dataCurrent[11].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataCurrent[11].value)

                    expect(res.body.detail.dataPrior[0].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[0].date)
                    expect(res.body.detail.dataPrior[0].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[0].value)

                    expect(res.body.detail.dataPrior[1].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[1].date)
                    expect(res.body.detail.dataPrior[1].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[1].value)

                    expect(res.body.detail.dataPrior[2].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[2].date)
                    expect(res.body.detail.dataPrior[2].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[2].value)

                    expect(res.body.detail.dataPrior[3].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[3].date)
                    expect(res.body.detail.dataPrior[3].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[3].value)

                    expect(res.body.detail.dataPrior[4].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[4].date)
                    expect(res.body.detail.dataPrior[4].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[4].value)

                    expect(res.body.detail.dataPrior[5].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[5].date)
                    expect(res.body.detail.dataPrior[5].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[5].value)

                    expect(res.body.detail.dataPrior[6].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[6].date)
                    expect(res.body.detail.dataPrior[6].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[6].value)

                    expect(res.body.detail.dataPrior[7].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[7].date)
                    expect(res.body.detail.dataPrior[7].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[7].value)

                    expect(res.body.detail.dataPrior[8].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[8].date)
                    expect(res.body.detail.dataPrior[8].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[8].value)

                    expect(res.body.detail.dataPrior[9].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[9].date)
                    expect(res.body.detail.dataPrior[9].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[9].value)

                    expect(res.body.detail.dataPrior[10].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[10].date)
                    expect(res.body.detail.dataPrior[10].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[10].value)

                    expect(res.body.detail.dataPrior[11].date).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[11].date)
                    expect(res.body.detail.dataPrior[11].value).to.equal(monthlywRVUTrendData.mockData.monthlywRVUTrendResponse.detail.dataPrior[11].value)

                })
        });
    }
})