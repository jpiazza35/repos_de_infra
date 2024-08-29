// <reference types="Cypress" />

describe('Settings - UserDashboard API', function () {
    let userDashboardData;
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
        cy.fixture('API/01_Settings/user_dashboard_data').then((data) => {
            userDashboardData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('01: User Dashboard - GET /user-dashboard - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.fy_realData.tenant + '&dashboardKey=' + userDashboardData.fy_realData.dashboardKey,
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

    it('01: User Dashboard - GET /user-dashboard - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.fy_realData.tenant + '&dashboardKey=' + userDashboardData.fy_realData.dashboardKey,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('01: User Dashboard - GET /user-dashboard - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.fy_realData.tenant + '&dashboardKey=' + userDashboardData.fy_realData.dashboardKey,
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

    it('01: User Dashboard - GET /user-dashboard - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'dashboardKey=' + userDashboardData.fy_realData.dashboardKey,
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

        it('01: User Dashboard - GET /user-dashboard - verify 200 response', function () {

            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.fy_realData.tenant + '&dashboardKey=' + userDashboardData.fy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.dashboards[0].dashboardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].dashboardKey)
                    expect(res.body.dashboards[0].name).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].name)
                    expect(res.body.dashboards[0].dashboardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].dashboardOrder)

                    expect(res.body.dashboards[0].categories[0].name).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].name)
                    expect(res.body.dashboards[0].categories[0].type).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].type)
                    expect(res.body.dashboards[0].categories[0].order).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].order)

                    expect(res.body.dashboards[0].categories[0].cards[0].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[1].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[2].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[3].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[4].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].name).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].name)
                    expect(res.body.dashboards[0].categories[1].type).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].type)
                    expect(res.body.dashboards[0].categories[1].order).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].order)

                    expect(res.body.dashboards[0].categories[1].cards[0].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[1].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[2].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[3].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[4].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[5].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[6].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[7].cardSystemName).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardKey).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardOrder).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardScale).to.equal(userDashboardData.fy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardScale)

                })
        });
    }

    //Calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {

        it('01: User Dashboard - GET /user-dashboard - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.cy_realData.tenant + '&dashboardKey=' + userDashboardData.cy_realData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.dashboards[0].dashboardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].dashboardKey)
                    expect(res.body.dashboards[0].name).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].name)
                    expect(res.body.dashboards[0].dashboardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].dashboardOrder)

                    expect(res.body.dashboards[0].categories[0].cards[0].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[1].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[2].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[3].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[4].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].name).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].name)
                    expect(res.body.dashboards[0].categories[1].type).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].type)
                    expect(res.body.dashboards[0].categories[1].order).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].order)

                    expect(res.body.dashboards[0].categories[1].cards[0].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[1].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[2].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[3].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[4].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[5].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[6].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[7].cardSystemName).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardKey).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardOrder).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardScale).to.equal(userDashboardData.cy_realData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardScale)

                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('01: User Dashboard - GET /user-dashboard - verify 200 response', function () {

            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_settings_url') + '/user-dashboard?' + 'tenant=' + userDashboardData.mockData.tenant + '&dashboardKey=' + userDashboardData.mockData.dashboardKey,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.dashboards[0].dashboardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].dashboardKey)
                    expect(res.body.dashboards[0].name).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].name)
                    expect(res.body.dashboards[0].dashboardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].dashboardOrder)

                    expect(res.body.dashboards[0].categories[0].cards[0].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[0].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[1].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[1].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[2].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[2].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[3].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[3].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[0].cards[4].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[0].cards[4].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[0].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].name).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].name)
                    expect(res.body.dashboards[0].categories[1].type).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].type)
                    expect(res.body.dashboards[0].categories[1].order).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].order)

                    expect(res.body.dashboards[0].categories[1].cards[0].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[0].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[0].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[1].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[1].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[1].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[2].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[2].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[2].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[3].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[3].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[3].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[4].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[4].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[4].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[5].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[5].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[5].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[6].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[6].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[6].cardScale)

                    expect(res.body.dashboards[0].categories[1].cards[7].cardSystemName).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardSystemName)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardKey).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardKey)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardOrder).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardOrder)
                    expect(res.body.dashboards[0].categories[1].cards[7].cardScale).to.equal(userDashboardData.mockData.userDashboardResponse.dashboards[0].categories[1].cards[7].cardScale)
                })
        });
    }
})
