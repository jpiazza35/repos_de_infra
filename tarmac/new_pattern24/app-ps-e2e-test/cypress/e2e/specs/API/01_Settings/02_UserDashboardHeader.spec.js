// <reference types="Cypress" />

describe('Settings - User Dashboard Header API', function () {
    let userDashboardHeaderData;
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
        cy.fixture('API/01_Settings/user_dashboard_header_data.json').then((data) => {
            userDashboardHeaderData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('02: User Dashboard Header - GET /user-dashboard-header - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
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

    it('02: User Dashboard Header - GET /user-dashboard-header - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('02: User Dashboard Header- GET /user-dashboard-header - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
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

    it('02: User Dashboard Header - GET /user-dashboard-header - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'periodId=' + userDashboardHeaderData.fy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
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

    it('02: User Dashboard Header - GET /user-dashboard-header - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
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

    it('02: User Dashboard Header - GET /user-dashboard-header - verify 400 response - Missing required parameter categoryType', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.periodId,
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
        it('02: User Dashboard Header - GET /user-dashboard-header - verify 200 response for Productivity', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.productivityPeriodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[0],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.fy_realData.produtivityDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.fy_realData.produtivityDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.fy_realData.produtivityDashboardHeaderResponse.subHeader)
                })
        });

        it('02: User Dashboard Header - GET /user-dashboard-header - verify 200 response for Performance', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.fy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.fy_realData.performancePeriodId + '&' + 'categoryType=' + userDashboardHeaderData.fy_realData.categoryType[1],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.fy_realData.performanceDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.fy_realData.performanceDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.fy_realData.performanceDashboardHeaderResponse.subHeader)
                })
        });
    }

    //Calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('02: User Dashboard Header - GET /user-dashboard-header - verify 200 response for Productivity', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.cy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.cy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.cy_realData.categoryType[0],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.cy_realData.produtivityDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.cy_realData.produtivityDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.cy_realData.produtivityDashboardHeaderResponse.subHeader)
                })
        });

        it('02: User Dashboard Header - GET /user-dashboard-header - verify 200 response for Performance', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.cy_realData.tenant + '&' + 'periodId=' + userDashboardHeaderData.cy_realData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.cy_realData.categoryType[1],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.cy_realData.performanceDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.cy_realData.performanceDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.cy_realData.performanceDashboardHeaderResponse.subHeader)
                })
        });
    }


    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {

        it('02: User Dashboard Header Productivity - GET /user-dashboard-header-productivity - verify 200 response for Productivity', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.mockData.tenant + '&' + 'periodId=' + userDashboardHeaderData.mockData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.mockData.categoryType[0],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.mockData.produtivityDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.mockData.produtivityDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.mockData.produtivityDashboardHeaderResponse.subHeader)
                })
        });

        it('02: User Dashboard Header Performance - GET /user-dashboard-header-performance - verify 200 response for Performance', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard-header?' + 'tenant=' + userDashboardHeaderData.mockData.tenant + '&' + 'periodId=' + userDashboardHeaderData.mockData.periodId + '&' + 'categoryType=' + userDashboardHeaderData.mockData.categoryType[1],
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.name).to.equal(userDashboardHeaderData.mockData.performanceDashboardHeaderResponse.name)
                    expect(res.body.header).to.equal(userDashboardHeaderData.mockData.performanceDashboardHeaderResponse.header)
                    expect(res.body.subHeader).to.equal(userDashboardHeaderData.mockData.performanceDashboardHeaderResponse.subHeader)
                })
        });
    }
})