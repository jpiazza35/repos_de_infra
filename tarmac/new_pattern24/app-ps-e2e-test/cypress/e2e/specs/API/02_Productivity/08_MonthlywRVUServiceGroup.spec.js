/// <reference types="Cypress" />

describe('Productivity - Monthly wRVU Service Group API', function () {
    let monthlywRVUServiceGroupData;
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
        cy.fixture('API/02_Productivity/monthly_wRVU_service_group_data').then((data) => {
            monthlywRVUServiceGroupData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
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

    it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId,
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
        it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.fy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.fy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.fy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.fy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.fy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.fy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                })
        })
    }
    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {
        it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + '&' + 'tenant=' + monthlywRVUServiceGroupData.cy_realData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.cy_realData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.cy_realData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.cy_realData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.cy_realData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.cy_realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                })
        })
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.mockData.cardKey + '&' + 'specialties=' + monthlywRVUServiceGroupData.mockData.specialties + '&' + 'periodId=' + monthlywRVUServiceGroupData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.cardSettings.infoIcon)

                    expect(res.body.detail.data[0].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[0])
                    expect(res.body.detail.data[0].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[1])
                    expect(res.body.detail.data[0].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[2])
                    expect(res.body.detail.data[0].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[3])
                    expect(res.body.detail.data[0].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[4])
                    expect(res.body.detail.data[0].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[5])
                    expect(res.body.detail.data[0].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[6])
                    expect(res.body.detail.data[0].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[7])
                    expect(res.body.detail.data[0].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].name)

                    expect(res.body.detail.data[1].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[0])
                    expect(res.body.detail.data[1].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[1])
                    expect(res.body.detail.data[1].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[2])
                    expect(res.body.detail.data[1].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[3])
                    expect(res.body.detail.data[1].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[4])
                    expect(res.body.detail.data[1].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[5])
                    expect(res.body.detail.data[1].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[6])
                    expect(res.body.detail.data[1].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[7])
                    expect(res.body.detail.data[1].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].name)

                    expect(res.body.detail.data[2].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[0])
                    expect(res.body.detail.data[2].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[1])
                    expect(res.body.detail.data[2].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[2])
                    expect(res.body.detail.data[2].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[3])
                    expect(res.body.detail.data[2].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[4])
                    expect(res.body.detail.data[2].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[5])
                    expect(res.body.detail.data[2].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[6])
                    expect(res.body.detail.data[2].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[7])
                    expect(res.body.detail.data[2].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].name)

                    expect(res.body.detail.data[3].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[0])
                    expect(res.body.detail.data[3].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[1])
                    expect(res.body.detail.data[3].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[2])
                    expect(res.body.detail.data[3].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[3])
                    expect(res.body.detail.data[3].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[4])
                    expect(res.body.detail.data[3].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[5])
                    expect(res.body.detail.data[3].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[6])
                    expect(res.body.detail.data[3].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[7])
                    expect(res.body.detail.data[3].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].name)

                    expect(res.body.detail.data[4].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[0])
                    expect(res.body.detail.data[4].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[1])
                    expect(res.body.detail.data[4].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[2])
                    expect(res.body.detail.data[4].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[3])
                    expect(res.body.detail.data[4].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[4])
                    expect(res.body.detail.data[4].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[5])
                    expect(res.body.detail.data[4].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[6])
                    expect(res.body.detail.data[4].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[7])
                    expect(res.body.detail.data[4].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].name)

                    expect(res.body.detail.data[5].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[0])
                    expect(res.body.detail.data[5].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[1])
                    expect(res.body.detail.data[5].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[2])
                    expect(res.body.detail.data[5].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[3])
                    expect(res.body.detail.data[5].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[4])
                    expect(res.body.detail.data[5].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[5])
                    expect(res.body.detail.data[5].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[6])
                    expect(res.body.detail.data[5].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[7])
                    expect(res.body.detail.data[5].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].name)

                    expect(res.body.detail.data[6].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[0])
                    expect(res.body.detail.data[6].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[1])
                    expect(res.body.detail.data[6].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[2])
                    expect(res.body.detail.data[6].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[3])
                    expect(res.body.detail.data[6].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[4])
                    expect(res.body.detail.data[6].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[5])
                    expect(res.body.detail.data[6].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[6])
                    expect(res.body.detail.data[6].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[7])
                    expect(res.body.detail.data[6].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].name)

                    expect(res.body.detail.data[7].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[0])
                    expect(res.body.detail.data[7].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[1])
                    expect(res.body.detail.data[7].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[2])
                    expect(res.body.detail.data[7].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[3])
                    expect(res.body.detail.data[7].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[4])
                    expect(res.body.detail.data[7].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[5])
                    expect(res.body.detail.data[7].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[6])
                    expect(res.body.detail.data[7].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[7])
                    expect(res.body.detail.data[7].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].name)

                    expect(res.body.detail.dates[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[0])
                    expect(res.body.detail.dates[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[1])
                    expect(res.body.detail.dates[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[2])
                    expect(res.body.detail.dates[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[3])
                    expect(res.body.detail.dates[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[4])
                    expect(res.body.detail.dates[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[5])
                    expect(res.body.detail.dates[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[6])
                    expect(res.body.detail.dates[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[7])
                })
        })

        it('08: Monthly wRVU Service Group - GET /monthly wRVU service group - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_productivity_url') + '/rvu-service-group-trend?' + 'tenant=' + monthlywRVUServiceGroupData.mockData.tenant + '&' + 'dashboardKey=' + monthlywRVUServiceGroupData.mockData.dashboardKey + '&' + 'cardKey=' + monthlywRVUServiceGroupData.mockData.cardKey + '&' + 'periodId=' + monthlywRVUServiceGroupData.mockData.periodId + '&' + 'yearMonth=' + monthlywRVUServiceGroupData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.cardSettings.infoIcon)

                    expect(res.body.detail.data[0].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[0])
                    expect(res.body.detail.data[0].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[1])
                    expect(res.body.detail.data[0].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[2])
                    expect(res.body.detail.data[0].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[3])
                    expect(res.body.detail.data[0].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[4])
                    expect(res.body.detail.data[0].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[5])
                    expect(res.body.detail.data[0].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[6])
                    expect(res.body.detail.data[0].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].values[7])
                    expect(res.body.detail.data[0].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[0].name)

                    expect(res.body.detail.data[1].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[0])
                    expect(res.body.detail.data[1].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[1])
                    expect(res.body.detail.data[1].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[2])
                    expect(res.body.detail.data[1].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[3])
                    expect(res.body.detail.data[1].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[4])
                    expect(res.body.detail.data[1].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[5])
                    expect(res.body.detail.data[1].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[6])
                    expect(res.body.detail.data[1].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].values[7])
                    expect(res.body.detail.data[1].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[1].name)

                    expect(res.body.detail.data[2].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[0])
                    expect(res.body.detail.data[2].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[1])
                    expect(res.body.detail.data[2].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[2])
                    expect(res.body.detail.data[2].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[3])
                    expect(res.body.detail.data[2].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[4])
                    expect(res.body.detail.data[2].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[5])
                    expect(res.body.detail.data[2].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[6])
                    expect(res.body.detail.data[2].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].values[7])
                    expect(res.body.detail.data[2].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[2].name)

                    expect(res.body.detail.data[3].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[0])
                    expect(res.body.detail.data[3].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[1])
                    expect(res.body.detail.data[3].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[2])
                    expect(res.body.detail.data[3].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[3])
                    expect(res.body.detail.data[3].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[4])
                    expect(res.body.detail.data[3].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[5])
                    expect(res.body.detail.data[3].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[6])
                    expect(res.body.detail.data[3].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].values[7])
                    expect(res.body.detail.data[3].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[3].name)

                    expect(res.body.detail.data[4].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[0])
                    expect(res.body.detail.data[4].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[1])
                    expect(res.body.detail.data[4].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[2])
                    expect(res.body.detail.data[4].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[3])
                    expect(res.body.detail.data[4].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[4])
                    expect(res.body.detail.data[4].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[5])
                    expect(res.body.detail.data[4].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[6])
                    expect(res.body.detail.data[4].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].values[7])
                    expect(res.body.detail.data[4].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[4].name)

                    expect(res.body.detail.data[5].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[0])
                    expect(res.body.detail.data[5].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[1])
                    expect(res.body.detail.data[5].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[2])
                    expect(res.body.detail.data[5].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[3])
                    expect(res.body.detail.data[5].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[4])
                    expect(res.body.detail.data[5].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[5])
                    expect(res.body.detail.data[5].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[6])
                    expect(res.body.detail.data[5].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].values[7])
                    expect(res.body.detail.data[5].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[5].name)

                    expect(res.body.detail.data[6].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[0])
                    expect(res.body.detail.data[6].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[1])
                    expect(res.body.detail.data[6].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[2])
                    expect(res.body.detail.data[6].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[3])
                    expect(res.body.detail.data[6].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[4])
                    expect(res.body.detail.data[6].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[5])
                    expect(res.body.detail.data[6].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[6])
                    expect(res.body.detail.data[6].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].values[7])
                    expect(res.body.detail.data[6].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[6].name)

                    expect(res.body.detail.data[7].values[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[0])
                    expect(res.body.detail.data[7].values[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[1])
                    expect(res.body.detail.data[7].values[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[2])
                    expect(res.body.detail.data[7].values[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[3])
                    expect(res.body.detail.data[7].values[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[4])
                    expect(res.body.detail.data[7].values[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[5])
                    expect(res.body.detail.data[7].values[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[6])
                    expect(res.body.detail.data[7].values[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].values[7])
                    expect(res.body.detail.data[7].name).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.data[7].name)

                    expect(res.body.detail.dates[0]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[0])
                    expect(res.body.detail.dates[1]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[1])
                    expect(res.body.detail.dates[2]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[2])
                    expect(res.body.detail.dates[3]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[3])
                    expect(res.body.detail.dates[4]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[4])
                    expect(res.body.detail.dates[5]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[5])
                    expect(res.body.detail.dates[6]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[6])
                    expect(res.body.detail.dates[7]).to.equal(monthlywRVUServiceGroupData.mockData.monthlywRVUServiceGroupResponse.detail.dates[7])
                })
        })
    }
})
