/// <reference types="Cypress" />

describe('Productivity - Monthly wRVu FTE Trend API', function () {
    let monthlywRVUFTETrendData;
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
        cy.fixture('API/02_Productivity/monthly_wRVU_fte_trend_data').then((data) => {
            monthlywRVUFTETrendData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
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

    it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId,
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
        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });

        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.fy_realData.cardKey + '&' + 'periodId=' + monthlywRVUFTETrendData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.fy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });
    }
    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.cy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.cy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.cy_realData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.cy_realData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.cy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });

        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.cy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.cy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.cy_realData.cardKey + '&' + 'periodId=' + monthlywRVUFTETrendData.cy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.cy_realData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.mockData.cardKey + '&' + 'specialties=' + monthlywRVUFTETrendData.mockData.specialties + '&' + 'periodId=' + monthlywRVUFTETrendData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].ranges[3].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[3].label)
                    expect(res.body.detail.surveys[0].ranges[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[3].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)

                    expect(res.body.detail.surveys[1].name).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].name)

                    expect(res.body.detail.surveys[1].ranges[0].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[0].label)
                    expect(res.body.detail.surveys[1].ranges[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[0].value)

                    expect(res.body.detail.surveys[1].ranges[1].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[1].label)
                    expect(res.body.detail.surveys[1].ranges[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[1].value)

                    expect(res.body.detail.surveys[1].ranges[2].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[2].label)
                    expect(res.body.detail.surveys[1].ranges[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[2].value)

                    expect(res.body.detail.surveys[1].ranges[3].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[3].label)
                    expect(res.body.detail.surveys[1].ranges[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[3].value)

                    expect(res.body.detail.surveys[1].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].date)
                    expect(res.body.detail.surveys[1].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].value)
                    expect(res.body.detail.surveys[1].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].date)
                    expect(res.body.detail.surveys[1].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].value)
                    expect(res.body.detail.surveys[1].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].date)
                    expect(res.body.detail.surveys[1].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].value)
                    expect(res.body.detail.surveys[1].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].date)
                    expect(res.body.detail.surveys[1].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].value)
                    expect(res.body.detail.surveys[1].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].date)
                    expect(res.body.detail.surveys[1].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].value)
                    expect(res.body.detail.surveys[1].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].date)
                    expect(res.body.detail.surveys[1].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].value)
                    expect(res.body.detail.surveys[1].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].date)
                    expect(res.body.detail.surveys[1].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].value)
                    expect(res.body.detail.surveys[1].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].date)
                    expect(res.body.detail.surveys[1].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].value)
                    expect(res.body.detail.surveys[1].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].date)
                    expect(res.body.detail.surveys[1].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].value)
                    expect(res.body.detail.surveys[1].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].date)
                    expect(res.body.detail.surveys[1].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].value)
                    expect(res.body.detail.surveys[1].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].date)
                    expect(res.body.detail.surveys[1].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].value)
                    expect(res.body.detail.surveys[1].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].date)
                    expect(res.body.detail.surveys[1].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].value)
                    expect(res.body.detail.surveys[1].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[1].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].date)
                    expect(res.body.detail.surveys[1].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].value)
                    expect(res.body.detail.surveys[1].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].fte)

                    expect(res.body.detail.surveys[1].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].date)
                    expect(res.body.detail.surveys[1].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].value)
                    expect(res.body.detail.surveys[1].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].fte)

                    expect(res.body.detail.surveys[1].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].date)
                    expect(res.body.detail.surveys[1].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].value)
                    expect(res.body.detail.surveys[1].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].fte)

                    expect(res.body.detail.surveys[1].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].date)
                    expect(res.body.detail.surveys[1].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].value)
                    expect(res.body.detail.surveys[1].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].fte)

                    expect(res.body.detail.surveys[1].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].date)
                    expect(res.body.detail.surveys[1].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].value)
                    expect(res.body.detail.surveys[1].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].fte)

                    expect(res.body.detail.surveys[1].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].date)
                    expect(res.body.detail.surveys[1].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].value)
                    expect(res.body.detail.surveys[1].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].fte)

                    expect(res.body.detail.surveys[1].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].date)
                    expect(res.body.detail.surveys[1].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].value)
                    expect(res.body.detail.surveys[1].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].fte)

                    expect(res.body.detail.surveys[1].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].date)
                    expect(res.body.detail.surveys[1].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].value)
                    expect(res.body.detail.surveys[1].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].fte)

                    expect(res.body.detail.surveys[1].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].date)
                    expect(res.body.detail.surveys[1].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].value)
                    expect(res.body.detail.surveys[1].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].fte)

                    expect(res.body.detail.surveys[1].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].date)
                    expect(res.body.detail.surveys[1].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].value)
                    expect(res.body.detail.surveys[1].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].fte)

                    expect(res.body.detail.surveys[1].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].date)
                    expect(res.body.detail.surveys[1].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].value)
                    expect(res.body.detail.surveys[1].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].fte)

                    expect(res.body.detail.surveys[1].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].date)
                    expect(res.body.detail.surveys[1].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].value)
                    expect(res.body.detail.surveys[1].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });

        it('07: Monthly wRVu FTE Trend - GET /monthly wRVU FTE Trend - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-fte-trend?' + 'tenant=' + monthlywRVUFTETrendData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUFTETrendData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUFTETrendData.mockData.cardKey + '&' + 'periodId=' + monthlywRVUFTETrendData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUFTETrendData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty


                    expect(res.body.cardSettings.title).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.cardSettings.infoIcon)

                    expect(res.body.detail.surveys[0].name).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].name)

                    expect(res.body.detail.surveys[0].ranges[0].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].label)
                    expect(res.body.detail.surveys[0].ranges[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[0].value)

                    expect(res.body.detail.surveys[0].ranges[1].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].label)
                    expect(res.body.detail.surveys[0].ranges[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[1].value)

                    expect(res.body.detail.surveys[0].ranges[2].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].label)
                    expect(res.body.detail.surveys[0].ranges[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[2].value)

                    expect(res.body.detail.surveys[0].ranges[3].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[3].label)
                    expect(res.body.detail.surveys[0].ranges[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].ranges[3].value)

                    expect(res.body.detail.surveys[0].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].date)
                    expect(res.body.detail.surveys[0].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].value)
                    expect(res.body.detail.surveys[0].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].date)
                    expect(res.body.detail.surveys[0].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].value)
                    expect(res.body.detail.surveys[0].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].date)
                    expect(res.body.detail.surveys[0].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].value)
                    expect(res.body.detail.surveys[0].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].date)
                    expect(res.body.detail.surveys[0].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].value)
                    expect(res.body.detail.surveys[0].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].date)
                    expect(res.body.detail.surveys[0].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].value)
                    expect(res.body.detail.surveys[0].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].date)
                    expect(res.body.detail.surveys[0].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].value)
                    expect(res.body.detail.surveys[0].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].date)
                    expect(res.body.detail.surveys[0].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].value)
                    expect(res.body.detail.surveys[0].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].date)
                    expect(res.body.detail.surveys[0].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].value)
                    expect(res.body.detail.surveys[0].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].date)
                    expect(res.body.detail.surveys[0].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].value)
                    expect(res.body.detail.surveys[0].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].date)
                    expect(res.body.detail.surveys[0].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].value)
                    expect(res.body.detail.surveys[0].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].date)
                    expect(res.body.detail.surveys[0].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].value)
                    expect(res.body.detail.surveys[0].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[0].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].date)
                    expect(res.body.detail.surveys[0].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].value)
                    expect(res.body.detail.surveys[0].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[0].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].date)
                    expect(res.body.detail.surveys[0].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].value)
                    expect(res.body.detail.surveys[0].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[0].fte)

                    expect(res.body.detail.surveys[0].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].date)
                    expect(res.body.detail.surveys[0].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].value)
                    expect(res.body.detail.surveys[0].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[1].fte)

                    expect(res.body.detail.surveys[0].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].date)
                    expect(res.body.detail.surveys[0].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].value)
                    expect(res.body.detail.surveys[0].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[2].fte)

                    expect(res.body.detail.surveys[0].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].date)
                    expect(res.body.detail.surveys[0].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].value)
                    expect(res.body.detail.surveys[0].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[3].fte)

                    expect(res.body.detail.surveys[0].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].date)
                    expect(res.body.detail.surveys[0].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].value)
                    expect(res.body.detail.surveys[0].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[4].fte)

                    expect(res.body.detail.surveys[0].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].date)
                    expect(res.body.detail.surveys[0].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].value)
                    expect(res.body.detail.surveys[0].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[5].fte)

                    expect(res.body.detail.surveys[0].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].date)
                    expect(res.body.detail.surveys[0].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].value)
                    expect(res.body.detail.surveys[0].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[6].fte)

                    expect(res.body.detail.surveys[0].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].date)
                    expect(res.body.detail.surveys[0].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].value)
                    expect(res.body.detail.surveys[0].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[7].fte)

                    expect(res.body.detail.surveys[0].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].date)
                    expect(res.body.detail.surveys[0].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].value)
                    expect(res.body.detail.surveys[0].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[8].fte)

                    expect(res.body.detail.surveys[0].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].date)
                    expect(res.body.detail.surveys[0].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].value)
                    expect(res.body.detail.surveys[0].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[9].fte)

                    expect(res.body.detail.surveys[0].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].date)
                    expect(res.body.detail.surveys[0].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].value)
                    expect(res.body.detail.surveys[0].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[10].fte)

                    expect(res.body.detail.surveys[0].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].date)
                    expect(res.body.detail.surveys[0].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].value)
                    expect(res.body.detail.surveys[0].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)

                    expect(res.body.detail.surveys[1].name).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].name)

                    expect(res.body.detail.surveys[1].ranges[0].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[0].label)
                    expect(res.body.detail.surveys[1].ranges[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[0].value)

                    expect(res.body.detail.surveys[1].ranges[1].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[1].label)
                    expect(res.body.detail.surveys[1].ranges[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[1].value)

                    expect(res.body.detail.surveys[1].ranges[2].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[2].label)
                    expect(res.body.detail.surveys[1].ranges[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[2].value)

                    expect(res.body.detail.surveys[1].ranges[3].label).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[3].label)
                    expect(res.body.detail.surveys[1].ranges[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].ranges[3].value)

                    expect(res.body.detail.surveys[1].dataCurrent[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].date)
                    expect(res.body.detail.surveys[1].dataCurrent[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].value)
                    expect(res.body.detail.surveys[1].dataCurrent[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[0].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].date)
                    expect(res.body.detail.surveys[1].dataCurrent[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].value)
                    expect(res.body.detail.surveys[1].dataCurrent[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[1].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].date)
                    expect(res.body.detail.surveys[1].dataCurrent[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].value)
                    expect(res.body.detail.surveys[1].dataCurrent[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[2].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].date)
                    expect(res.body.detail.surveys[1].dataCurrent[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].value)
                    expect(res.body.detail.surveys[1].dataCurrent[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[3].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].date)
                    expect(res.body.detail.surveys[1].dataCurrent[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].value)
                    expect(res.body.detail.surveys[1].dataCurrent[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[4].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].date)
                    expect(res.body.detail.surveys[1].dataCurrent[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].value)
                    expect(res.body.detail.surveys[1].dataCurrent[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[5].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].date)
                    expect(res.body.detail.surveys[1].dataCurrent[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].value)
                    expect(res.body.detail.surveys[1].dataCurrent[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[6].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].date)
                    expect(res.body.detail.surveys[1].dataCurrent[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].value)
                    expect(res.body.detail.surveys[1].dataCurrent[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[7].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].date)
                    expect(res.body.detail.surveys[1].dataCurrent[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].value)
                    expect(res.body.detail.surveys[1].dataCurrent[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[8].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].date)
                    expect(res.body.detail.surveys[1].dataCurrent[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].value)
                    expect(res.body.detail.surveys[1].dataCurrent[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[9].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].date)
                    expect(res.body.detail.surveys[1].dataCurrent[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].value)
                    expect(res.body.detail.surveys[1].dataCurrent[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[10].fte)

                    expect(res.body.detail.surveys[1].dataCurrent[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].date)
                    expect(res.body.detail.surveys[1].dataCurrent[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].value)
                    expect(res.body.detail.surveys[1].dataCurrent[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataCurrent[11].fte)

                    expect(res.body.detail.surveys[1].dataPrior[0].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].date)
                    expect(res.body.detail.surveys[1].dataPrior[0].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].value)
                    expect(res.body.detail.surveys[1].dataPrior[0].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[0].fte)

                    expect(res.body.detail.surveys[1].dataPrior[1].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].date)
                    expect(res.body.detail.surveys[1].dataPrior[1].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].value)
                    expect(res.body.detail.surveys[1].dataPrior[1].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[1].fte)

                    expect(res.body.detail.surveys[1].dataPrior[2].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].date)
                    expect(res.body.detail.surveys[1].dataPrior[2].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].value)
                    expect(res.body.detail.surveys[1].dataPrior[2].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[2].fte)

                    expect(res.body.detail.surveys[1].dataPrior[3].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].date)
                    expect(res.body.detail.surveys[1].dataPrior[3].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].value)
                    expect(res.body.detail.surveys[1].dataPrior[3].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[3].fte)

                    expect(res.body.detail.surveys[1].dataPrior[4].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].date)
                    expect(res.body.detail.surveys[1].dataPrior[4].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].value)
                    expect(res.body.detail.surveys[1].dataPrior[4].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[4].fte)

                    expect(res.body.detail.surveys[1].dataPrior[5].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].date)
                    expect(res.body.detail.surveys[1].dataPrior[5].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].value)
                    expect(res.body.detail.surveys[1].dataPrior[5].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[5].fte)

                    expect(res.body.detail.surveys[1].dataPrior[6].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].date)
                    expect(res.body.detail.surveys[1].dataPrior[6].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].value)
                    expect(res.body.detail.surveys[1].dataPrior[6].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[6].fte)

                    expect(res.body.detail.surveys[1].dataPrior[7].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].date)
                    expect(res.body.detail.surveys[1].dataPrior[7].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].value)
                    expect(res.body.detail.surveys[1].dataPrior[7].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[7].fte)

                    expect(res.body.detail.surveys[1].dataPrior[8].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].date)
                    expect(res.body.detail.surveys[1].dataPrior[8].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].value)
                    expect(res.body.detail.surveys[1].dataPrior[8].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[8].fte)

                    expect(res.body.detail.surveys[1].dataPrior[9].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].date)
                    expect(res.body.detail.surveys[1].dataPrior[9].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].value)
                    expect(res.body.detail.surveys[1].dataPrior[9].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[9].fte)

                    expect(res.body.detail.surveys[1].dataPrior[10].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].date)
                    expect(res.body.detail.surveys[1].dataPrior[10].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].value)
                    expect(res.body.detail.surveys[1].dataPrior[10].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[10].fte)

                    expect(res.body.detail.surveys[1].dataPrior[11].date).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].date)
                    expect(res.body.detail.surveys[1].dataPrior[11].value).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].value)
                    expect(res.body.detail.surveys[1].dataPrior[11].fte).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[1].dataPrior[11].fte)

                    expect(res.body.detail.surveys[0].SurveyKey).to.equal(monthlywRVUFTETrendData.mockData.monthlywRVUfteTrendResponse.detail.surveys[0].SurveyKey)
                })
        });

    }
})