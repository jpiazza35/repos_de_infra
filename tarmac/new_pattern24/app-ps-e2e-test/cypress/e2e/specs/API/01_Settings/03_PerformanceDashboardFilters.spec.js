// <reference types="Cypress" />

describe('Performance - Performance Dashboard Filters API', function () {
    let performanceFilterData;
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
        cy.fixture('API/01_Settings/performance_dashboard_filters_data').then((data) => {
            performanceFilterData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + performanceFilterData.fy_realData.dashboardKey,
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

    it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + performanceFilterData.fy_realData.dashboardKey,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + performanceFilterData.fy_realData.dashboardKey,
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

    it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 400 response - Missing required parameter Tenantkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'dashboardKey=' + performanceFilterData.fy_realData.dashboardKey,
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

    it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 400 response - Missing required parameter dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.fy_realData.tenantKey,
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
        it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.fy_realData.tenant + '&' + 'dashboardKey=' + performanceFilterData.fy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].id)
                    expect(res.body.periodTypes[0].period.years[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].name)
                    expect(res.body.periodTypes[0].period.years[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].id)
                    expect(res.body.periodTypes[0].period.years[1].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].name)
                    expect(res.body.periodTypes[0].period.years[1].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].id).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].name).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].isDefault).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].isDefault)
                    //expect(res.body.periodTypes[0].period.years[1].quarters[0]).to.equal(performanceFilterData.fy_realData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[0])
                })
        });
    }


    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.cy_realData.tenant + '&' + 'dashboardKey=' + performanceFilterData.cy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].id)
                    expect(res.body.periodTypes[0].period.years[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].name)
                    expect(res.body.periodTypes[0].period.years[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].id)
                    expect(res.body.periodTypes[0].period.years[1].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].name)
                    expect(res.body.periodTypes[0].period.years[1].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].id).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].name).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].isDefault).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].isDefault)
                    //expect(res.body.periodTypes[0].period.years[1].quarters[0]).to.equal(performanceFilterData.cy_realData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[0])
                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it.skip('03: Performance Dashboard Filters - GET /performance-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/performance-dashboard-filters?' + 'tenantKey=' + performanceFilterData.mockData.tenantKey + '&' + 'dashboardKey=' + performanceFilterData.mockData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].id)
                    expect(res.body.periodTypes[0].period.years[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].name)
                    expect(res.body.periodTypes[0].period.years[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].id)
                    expect(res.body.periodTypes[0].period.years[1].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].name)
                    expect(res.body.periodTypes[0].period.years[1].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].id).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].name).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].isDefault).to.equal(performanceFilterData.mockData.performanceFilterResponse.periodTypes[0].period.years[1].quarters[1].isDefault)

                })
        });
    }
})