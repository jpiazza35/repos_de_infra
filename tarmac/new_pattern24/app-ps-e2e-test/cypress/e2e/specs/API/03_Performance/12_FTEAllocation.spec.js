/// <reference types="Cypress" />

describe('Performance - FTE Allocation API', function () {
    let fteAllocationData;
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
        cy.fixture('API/02_Performance/fte_allocation_data').then((data) => {
            fteAllocationData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('08: FTE Allocation - GET /FTE-allocation - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {

                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('08: FTE Allocation - GET /FTE-allocation - verify 401 response - Expired Token', function () {

        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
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

    it('08: FTE Allocation - GET /FTE-allocation - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId,
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

        it('08: FTE Allocation - GET /FTE-allocation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'specialties=' + fteAllocationData.realData.specialties + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json'
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(fteAllocationData.realData.fteAllocationResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(fteAllocationData.realData.fteAllocationResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].category)
                    expect(res.body.detail[0].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].ytdAvg)
                    expect(res.body.detail[0].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].currentMonth)

                    expect(res.body.detail[1].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].category)
                    expect(res.body.detail[1].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].ytdAvg)
                    expect(res.body.detail[1].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].currentMonth)

                    expect(res.body.detail[2].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].category)
                    expect(res.body.detail[2].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].ytdAvg)
                    expect(res.body.detail[2].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].currentMonth)
                })
        });

        it('08: FTE Allocation - GET /FTE-allocation - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.realData.userId + '&' + 'tenant=' + fteAllocationData.realData.tenant + '&' + 'dashboardKey=' + fteAllocationData.realData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.realData.cardKey + '&' + 'periodId=' + fteAllocationData.realData.periodId + '&' + 'yearMonth=' + fteAllocationData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(fteAllocationData.realData.fteAllocationResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(fteAllocationData.realData.fteAllocationResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].category)
                    expect(res.body.detail[0].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].ytdAvg)
                    expect(res.body.detail[0].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[0].currentMonth)

                    expect(res.body.detail[1].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].category)
                    expect(res.body.detail[1].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].ytdAvg)
                    expect(res.body.detail[1].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[1].currentMonth)

                    expect(res.body.detail[2].category).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].category)
                    expect(res.body.detail[2].ytdAvg).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].ytdAvg)
                    expect(res.body.detail[2].currentMonth).to.equal(fteAllocationData.realData.fteAllocationResponse.detail[2].currentMonth)
                })
        });

    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('08: FTE Allocation - GET /FTE-allocation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.mockData.userId + '&' + 'tenant=' + fteAllocationData.mockData.tenant + '&' + 'dashboardKey=' + fteAllocationData.mockData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.mockData.cardKey + '&' + 'specialties=' + fteAllocationData.mockData.specialties + '&' + 'periodId=' + fteAllocationData.mockData.periodId + '&' + 'yearMonth=' + fteAllocationData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json'
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(fteAllocationData.mockData.fteAllocationResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(fteAllocationData.mockData.fteAllocationResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].category)
                    expect(res.body.detail[0].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].ytdAvg)
                    expect(res.body.detail[0].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].currentMonth)

                    expect(res.body.detail[1].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].category)
                    expect(res.body.detail[1].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].ytdAvg)
                    expect(res.body.detail[1].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].currentMonth)

                    expect(res.body.detail[2].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].category)
                    expect(res.body.detail[2].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].ytdAvg)
                    expect(res.body.detail[2].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].currentMonth)
                })
        });

        it('08: FTE Allocation - GET /FTE-allocation - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/fte-allocation?' + 'userId=' + fteAllocationData.mockData.userId + '&' + 'tenant=' + fteAllocationData.mockData.tenant + '&' + 'dashboardKey=' + fteAllocationData.mockData.dashboardKey + '&' + 'cardKey=' + fteAllocationData.mockData.cardKey + '&' + 'periodId=' + fteAllocationData.mockData.periodId + '&' + 'yearMonth=' + fteAllocationData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(fteAllocationData.mockData.fteAllocationResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(fteAllocationData.mockData.fteAllocationResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].category)
                    expect(res.body.detail[0].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].ytdAvg)
                    expect(res.body.detail[0].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[0].currentMonth)

                    expect(res.body.detail[1].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].category)
                    expect(res.body.detail[1].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].ytdAvg)
                    expect(res.body.detail[1].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[1].currentMonth)

                    expect(res.body.detail[2].category).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].category)
                    expect(res.body.detail[2].ytdAvg).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].ytdAvg)
                    expect(res.body.detail[2].currentMonth).to.equal(fteAllocationData.mockData.fteAllocationResponse.detail[2].currentMonth)
                })
        });
    }
})