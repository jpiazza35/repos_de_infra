// <reference types="Cypress" />

describe('Productivity - Productivity Dashboard Filters API', function () {
    let productivityFilterData;
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
        cy.fixture('API/01_Settings/productivity_dashboard_filters_data').then((data) => {
            productivityFilterData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.fy_realData.dashboardKey,
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

    it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.fy_realData.dashboardKey,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.fy_realData.dashboardKey,
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

    it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 400 response - Missing required parameter dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.fy_realData.tenantKey,
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

    it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 400 response - Missing required parameter Tenantkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'dashboardKey=' + productivityFilterData.fy_realData.dashboardKey,
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
        it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.fy_realData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.fy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].id)
                    expect(res.body.periodTypes[0].period.years[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].name)
                    expect(res.body.periodTypes[0].period.years[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].id)
                    expect(res.body.periodTypes[0].period.years[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].name)
                    expect(res.body.periodTypes[0].period.years[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].isDefault)

                    expect(res.body.periodTypes[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[1].id)
                    expect(res.body.periodTypes[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[1].name)
                    expect(res.body.periodTypes[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[1].isDefault)
                    expect(res.body.periodTypes[1].period.years).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.periodTypes[1].period.years)

                    expect(res.body.serviceGroup[0].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[0].id)
                    expect(res.body.serviceGroup[0].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[0].name)
                    expect(res.body.serviceGroup[0].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[0].isDefault)

                    expect(res.body.serviceGroup[1].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[1].id)
                    expect(res.body.serviceGroup[1].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[1].name)
                    expect(res.body.serviceGroup[1].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[1].isDefault)

                    expect(res.body.serviceGroup[2].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[2].id)
                    expect(res.body.serviceGroup[2].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[2].name)
                    expect(res.body.serviceGroup[2].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[2].isDefault)

                    expect(res.body.serviceGroup[3].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[3].id)
                    expect(res.body.serviceGroup[3].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[3].name)
                    expect(res.body.serviceGroup[3].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[3].isDefault)

                    expect(res.body.serviceGroup[4].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[4].id)
                    expect(res.body.serviceGroup[4].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[4].name)
                    expect(res.body.serviceGroup[4].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[4].isDefault)

                    expect(res.body.serviceGroup[5].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[5].id)
                    expect(res.body.serviceGroup[5].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[5].name)
                    expect(res.body.serviceGroup[5].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[5].isDefault)

                    expect(res.body.serviceGroup[6].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[6].id)
                    expect(res.body.serviceGroup[6].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[6].name)
                    expect(res.body.serviceGroup[6].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[6].isDefault)

                    expect(res.body.serviceGroup[7].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[7].id)
                    expect(res.body.serviceGroup[7].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[7].name)
                    expect(res.body.serviceGroup[7].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[7].isDefault)

                    expect(res.body.serviceGroup[8].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[8].id)
                    expect(res.body.serviceGroup[8].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[8].name)
                    expect(res.body.serviceGroup[8].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[8].isDefault)

                    expect(res.body.serviceGroup[9].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[9].id)
                    expect(res.body.serviceGroup[9].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[9].name)
                    expect(res.body.serviceGroup[9].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[9].isDefault)

                    expect(res.body.serviceGroup[10].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[10].id)
                    expect(res.body.serviceGroup[10].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[10].name)
                    expect(res.body.serviceGroup[10].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[10].isDefault)

                    expect(res.body.serviceGroup[11].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[11].id)
                    expect(res.body.serviceGroup[11].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[11].name)
                    expect(res.body.serviceGroup[11].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[11].isDefault)

                    expect(res.body.serviceGroup[12].id).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[12].id)
                    expect(res.body.serviceGroup[12].name).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[12].name)
                    expect(res.body.serviceGroup[12].isDefault).to.equal(productivityFilterData.fy_realData.productivityFilterResponse.serviceGroup[12].isDefault)
                })
        });
    }

    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.cy_realData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.cy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years).to.be.null;

                    expect(res.body.periodTypes[1].period.years[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].id)
                    expect(res.body.periodTypes[1].period.years[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].name)
                    expect(res.body.periodTypes[1].period.years[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[1].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[1].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[1].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[2].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[2].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[2].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[3].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[3].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[3].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[4].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[4].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[4].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[5].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[5].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[5].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[6].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[6].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[6].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[7].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[7].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[7].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[8].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[8].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[8].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[9].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[9].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[9].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[10].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[10].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[10].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[1].period.years[0].yearMonths[11].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[11].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[1].period.years[0].yearMonths[11].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[1].period.years[0].quarters[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[1].period.years[0].quarters[1].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[1].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[1].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[1].period.years[0].quarters[2].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[2].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[2].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[1].period.years[0].quarters[3].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[3].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[1].period.years[0].quarters[3].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[1].period.years[1].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].id)
                    expect(res.body.periodTypes[1].period.years[1].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].name)
                    expect(res.body.periodTypes[1].period.years[1].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].isDefault)

                    expect(res.body.periodTypes[1].period.years[1].yearMonths[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[1].period.years[1].yearMonths[1].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[1].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[1].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[1].period.years[1].yearMonths[2].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[2].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[1].period.years[1].yearMonths[2].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].yearMonths[2].isDefault)

                    // expect(res.body.periodTypes[1].period.years[1].quarters[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].quarters[0].id)
                    // expect(res.body.periodTypes[1].period.years[1].quarters[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].quarters[0].name)
                    // expect(res.body.periodTypes[1].period.years[1].quarters[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.periodTypes[1].period.years[1].quarters[0].isDefault)

                    expect(res.body.serviceGroup[0].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[0].id)
                    expect(res.body.serviceGroup[0].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[0].name)
                    expect(res.body.serviceGroup[0].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[0].isDefault)

                    expect(res.body.serviceGroup[1].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[1].id)
                    expect(res.body.serviceGroup[1].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[1].name)
                    expect(res.body.serviceGroup[1].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[1].isDefault)

                    expect(res.body.serviceGroup[2].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[2].id)
                    expect(res.body.serviceGroup[2].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[2].name)
                    expect(res.body.serviceGroup[2].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[2].isDefault)

                    expect(res.body.serviceGroup[3].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[3].id)
                    expect(res.body.serviceGroup[3].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[3].name)
                    expect(res.body.serviceGroup[3].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[3].isDefault)

                    expect(res.body.serviceGroup[4].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[4].id)
                    expect(res.body.serviceGroup[4].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[4].name)
                    expect(res.body.serviceGroup[4].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[4].isDefault)

                    expect(res.body.serviceGroup[5].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[5].id)
                    expect(res.body.serviceGroup[5].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[5].name)
                    expect(res.body.serviceGroup[5].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[5].isDefault)

                    expect(res.body.serviceGroup[6].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[6].id)
                    expect(res.body.serviceGroup[6].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[6].name)
                    expect(res.body.serviceGroup[6].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[6].isDefault)

                    expect(res.body.serviceGroup[7].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[7].id)
                    expect(res.body.serviceGroup[7].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[7].name)
                    expect(res.body.serviceGroup[7].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[7].isDefault)

                    expect(res.body.serviceGroup[8].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[8].id)
                    expect(res.body.serviceGroup[8].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[8].name)
                    expect(res.body.serviceGroup[8].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[8].isDefault)

                    expect(res.body.serviceGroup[9].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[9].id)
                    expect(res.body.serviceGroup[9].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[9].name)
                    expect(res.body.serviceGroup[9].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[9].isDefault)

                    expect(res.body.serviceGroup[10].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[10].id)
                    expect(res.body.serviceGroup[10].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[10].name)
                    expect(res.body.serviceGroup[10].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[10].isDefault)

                    expect(res.body.serviceGroup[11].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[11].id)
                    expect(res.body.serviceGroup[11].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[11].name)
                    expect(res.body.serviceGroup[11].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[11].isDefault)

                    expect(res.body.serviceGroup[12].id).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[12].id)
                    expect(res.body.serviceGroup[12].name).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[12].name)
                    expect(res.body.serviceGroup[12].isDefault).to.equal(productivityFilterData.cy_realData.productivityFilterResponse.serviceGroup[12].isDefault)
                })
        });
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('04: Productivity Dashboard Filters - GET /productivity-dashboard-filters - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/productivity-dashboard-filters?' + 'tenantKey=' + productivityFilterData.mockData.tenantKey + '&' + 'dashboardKey=' + productivityFilterData.mockData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.specialty[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.specialty[0].id)
                    expect(res.body.specialty[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.specialty[0].name)
                    expect(res.body.specialty[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.specialty[0].isDefault)

                    expect(res.body.periodTypes[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].id)
                    expect(res.body.periodTypes[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].name)
                    expect(res.body.periodTypes[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].id)
                    expect(res.body.periodTypes[0].period.years[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].name)
                    expect(res.body.periodTypes[0].period.years[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[0].yearMonths[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[0].quarters[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[0].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].id)
                    expect(res.body.periodTypes[0].period.years[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].name)
                    expect(res.body.periodTypes[0].period.years[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[1].yearMonths[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[1].quarters[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[1].quarters[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[1].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].id)
                    expect(res.body.periodTypes[0].period.years[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].name)
                    expect(res.body.periodTypes[0].period.years[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[2].yearMonths[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[2].yearMonths[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[2].quarters[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[2].quarters[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[2].quarters[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[2].quarters[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[2].quarters[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[2].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].id)
                    expect(res.body.periodTypes[0].period.years[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].name)
                    expect(res.body.periodTypes[0].period.years[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[3].yearMonths[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[3].yearMonths[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[3].quarters[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[3].quarters[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[3].quarters[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[2].isDefault)

                    // expect(res.body.periodTypes[0].period.years[3].quarters[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[3].id)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[3].name)
                    // expect(res.body.periodTypes[0].period.years[3].quarters[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[3].quarters[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].id)
                    expect(res.body.periodTypes[0].period.years[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].name)
                    expect(res.body.periodTypes[0].period.years[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[0].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[0].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[0].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[1].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[1].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[1].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[2].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[2].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[2].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[3].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[3].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[3].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[4].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[4].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[4].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[5].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[5].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[5].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[6].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[6].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[6].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[7].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[7].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[7].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[8].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[8].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[8].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[9].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[9].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[9].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[10].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[10].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[10].isDefault)

                    expect(res.body.periodTypes[0].period.years[4].yearMonths[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[11].id)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[11].name)
                    expect(res.body.periodTypes[0].period.years[4].yearMonths[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].yearMonths[11].isDefault)

                    // expect(res.body.periodTypes[0].period.years[4].quarters[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[0].id)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[0].name)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[0].isDefault)

                    // expect(res.body.periodTypes[0].period.years[4].quarters[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[1].id)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[1].name)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[1].isDefault)

                    // expect(res.body.periodTypes[0].period.years[4].quarters[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[2].id)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[2].name)
                    // expect(res.body.periodTypes[0].period.years[4].quarters[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.periodTypes[0].period.years[4].quarters[2].isDefault)

                    expect(res.body.serviceGroup[0].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[0].id)
                    expect(res.body.serviceGroup[0].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[0].name)
                    expect(res.body.serviceGroup[0].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[0].isDefault)

                    expect(res.body.serviceGroup[1].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[1].id)
                    expect(res.body.serviceGroup[1].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[1].name)
                    expect(res.body.serviceGroup[1].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[1].isDefault)

                    expect(res.body.serviceGroup[2].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[2].id)
                    expect(res.body.serviceGroup[2].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[2].name)
                    expect(res.body.serviceGroup[2].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[2].isDefault)

                    expect(res.body.serviceGroup[3].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[3].id)
                    expect(res.body.serviceGroup[3].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[3].name)
                    expect(res.body.serviceGroup[3].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[3].isDefault)

                    expect(res.body.serviceGroup[4].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[4].id)
                    expect(res.body.serviceGroup[4].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[4].name)
                    expect(res.body.serviceGroup[4].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[4].isDefault)

                    expect(res.body.serviceGroup[5].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[5].id)
                    expect(res.body.serviceGroup[5].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[5].name)
                    expect(res.body.serviceGroup[5].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[5].isDefault)

                    expect(res.body.serviceGroup[6].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[6].id)
                    expect(res.body.serviceGroup[6].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[6].name)
                    expect(res.body.serviceGroup[6].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[6].isDefault)

                    expect(res.body.serviceGroup[7].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[7].id)
                    expect(res.body.serviceGroup[7].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[7].name)
                    expect(res.body.serviceGroup[7].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[7].isDefault)

                    expect(res.body.serviceGroup[8].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[8].id)
                    expect(res.body.serviceGroup[8].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[8].name)
                    expect(res.body.serviceGroup[8].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[8].isDefault)

                    expect(res.body.serviceGroup[9].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[9].id)
                    expect(res.body.serviceGroup[9].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[9].name)
                    expect(res.body.serviceGroup[9].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[9].isDefault)

                    expect(res.body.serviceGroup[10].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[10].id)
                    expect(res.body.serviceGroup[10].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[10].name)
                    expect(res.body.serviceGroup[10].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[10].isDefault)

                    expect(res.body.serviceGroup[11].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[11].id)
                    expect(res.body.serviceGroup[11].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[11].name)
                    expect(res.body.serviceGroup[11].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[11].isDefault)

                    expect(res.body.serviceGroup[12].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[12].id)
                    expect(res.body.serviceGroup[12].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[12].name)
                    expect(res.body.serviceGroup[12].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[12].isDefault)

                    expect(res.body.serviceGroup[13].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[13].id)
                    expect(res.body.serviceGroup[13].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[13].name)
                    expect(res.body.serviceGroup[13].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[13].isDefault)

                    expect(res.body.serviceGroup[14].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[14].id)
                    expect(res.body.serviceGroup[14].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[14].name)
                    expect(res.body.serviceGroup[14].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[14].isDefault)

                    expect(res.body.serviceGroup[15].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[15].id)
                    expect(res.body.serviceGroup[15].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[15].name)
                    expect(res.body.serviceGroup[15].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[15].isDefault)

                    expect(res.body.serviceGroup[16].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[16].id)
                    expect(res.body.serviceGroup[16].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[16].name)
                    expect(res.body.serviceGroup[16].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[16].isDefault)

                    expect(res.body.serviceGroup[17].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[17].id)
                    expect(res.body.serviceGroup[17].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[17].name)
                    expect(res.body.serviceGroup[17].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[17].isDefault)

                    expect(res.body.serviceGroup[18].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[18].id)
                    expect(res.body.serviceGroup[18].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[18].name)
                    expect(res.body.serviceGroup[18].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[18].isDefault)

                    expect(res.body.serviceGroup[19].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[19].id)
                    expect(res.body.serviceGroup[19].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[19].name)
                    expect(res.body.serviceGroup[19].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[19].isDefault)

                    expect(res.body.serviceGroup[20].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[20].id)
                    expect(res.body.serviceGroup[20].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[20].name)
                    expect(res.body.serviceGroup[20].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[20].isDefault)

                    expect(res.body.serviceGroup[21].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[21].id)
                    expect(res.body.serviceGroup[21].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[21].name)
                    expect(res.body.serviceGroup[21].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[21].isDefault)

                    expect(res.body.serviceGroup[22].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[22].id)
                    expect(res.body.serviceGroup[22].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[22].name)
                    expect(res.body.serviceGroup[22].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[22].isDefault)

                    expect(res.body.serviceGroup[23].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[23].id)
                    expect(res.body.serviceGroup[23].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[23].name)
                    expect(res.body.serviceGroup[23].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[23].isDefault)

                    expect(res.body.serviceGroup[24].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[24].id)
                    expect(res.body.serviceGroup[24].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[24].name)
                    expect(res.body.serviceGroup[24].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[24].isDefault)

                    expect(res.body.serviceGroup[25].id).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[25].id)
                    expect(res.body.serviceGroup[25].name).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[25].name)
                    expect(res.body.serviceGroup[25].isDefault).to.equal(productivityFilterData.mockData.productivityFilterResponse.serviceGroup[25].isDefault)
                })
        });
    }
})