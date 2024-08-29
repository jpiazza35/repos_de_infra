/// <reference types="Cypress" />

describe('Performance - Productivity Compensation API', function () {
    let productivityCompData;
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
        cy.fixture('API/02_Performance/productivity_compensation_data').then((data) => {
            productivityCompData = data
        })

    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users  
    it('12: Productivity Compensation - GET /productivity-compensation -  verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);

            })
    });

    it('12: Productivity Compensation - GET /productivity-compensation - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensationy - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation- verify 400 response - Missing required parameter period type', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
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

    it('12: Productivity Compensation - GET /productivity-compensation- verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'periodType=' + productivityCompData.realData.periodType,
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
        it('12: Productivity Compensation - GET /productivity-compensation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'specialties=' + productivityCompData.realData.specialties + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail.ytdProdCompensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.ytdProdCompensation)
                    expect(res.body.detail.currentAvgRate).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentAvgRate)
                    expect(res.body.detail.priorAvgRate).to.equal(productivityCompData.realData.productivityCompResponse.detail.priorAvgRate)

                    expect(res.body.detail.tierData[0].label).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].label)
                    expect(res.body.detail.tierData[0].value).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].value)
                    expect(res.body.detail.tierData[0].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].wrvu)

                    expect(res.body.detail.tierData[1].label).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].label)
                    expect(res.body.detail.tierData[1].value).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].value)
                    expect(res.body.detail.tierData[1].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].wrvu)

                    expect(res.body.detail.currentYearData[0].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].date)
                    expect(res.body.detail.currentYearData[0].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].wrvu)
                    expect(res.body.detail.currentYearData[0].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].compensation)

                    expect(res.body.detail.currentYearData[1].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].date)
                    expect(res.body.detail.currentYearData[1].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].wrvu)
                    expect(res.body.detail.currentYearData[1].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].compensation)

                    expect(res.body.detail.currentYearData[2].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].date)
                    expect(res.body.detail.currentYearData[2].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].wrvu)
                    expect(res.body.detail.currentYearData[2].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].compensation)

                    expect(res.body.detail.currentYearData[3].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].date)
                    expect(res.body.detail.currentYearData[3].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].wrvu)
                    expect(res.body.detail.currentYearData[3].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].compensation)

                    expect(res.body.detail.currentYearData[4].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].date)
                    expect(res.body.detail.currentYearData[4].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].wrvu)
                    expect(res.body.detail.currentYearData[4].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].compensation)

                    expect(res.body.detail.currentYearData[5].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].date)
                    expect(res.body.detail.currentYearData[5].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].wrvu)
                    expect(res.body.detail.currentYearData[5].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].compensation)

                    expect(res.body.detail.priorYearData[0]).to.equal(productivityCompData.realData.productivityCompResponse.detail.priorYearData[0])
                })
        });

        it('12: Productivity Compensation - GET /productivity-compensation - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.realData.userId + '&' + 'tenant=' + productivityCompData.realData.tenant + '&' + 'dashboardKey=' + productivityCompData.realData.dashboardKey + '&' + 'cardKey=' + productivityCompData.realData.cardKey + '&' + 'periodType=' + productivityCompData.realData.periodType + '&' + 'periodId=' + productivityCompData.realData.periodId + '&' + 'yearMonth=' + productivityCompData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty
                    expect(res.body.cardSettings.title).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.infoIcon)

                    expect(res.body.cardSettings.title).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(productivityCompData.realData.productivityCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail.ytdProdCompensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.ytdProdCompensation)
                    expect(res.body.detail.currentAvgRate).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentAvgRate)
                    expect(res.body.detail.priorAvgRate).to.equal(productivityCompData.realData.productivityCompResponse.detail.priorAvgRate)

                    expect(res.body.detail.tierData[0].label).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].label)
                    expect(res.body.detail.tierData[0].value).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].value)
                    expect(res.body.detail.tierData[0].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[0].wrvu)

                    expect(res.body.detail.tierData[1].label).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].label)
                    expect(res.body.detail.tierData[1].value).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].value)
                    expect(res.body.detail.tierData[1].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.tierData[1].wrvu)

                    expect(res.body.detail.currentYearData[0].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].date)
                    expect(res.body.detail.currentYearData[0].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].wrvu)
                    expect(res.body.detail.currentYearData[0].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[0].compensation)

                    expect(res.body.detail.currentYearData[1].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].date)
                    expect(res.body.detail.currentYearData[1].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].wrvu)
                    expect(res.body.detail.currentYearData[1].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[1].compensation)

                    expect(res.body.detail.currentYearData[2].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].date)
                    expect(res.body.detail.currentYearData[2].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].wrvu)
                    expect(res.body.detail.currentYearData[2].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[2].compensation)

                    expect(res.body.detail.currentYearData[3].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].date)
                    expect(res.body.detail.currentYearData[3].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].wrvu)
                    expect(res.body.detail.currentYearData[3].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[3].compensation)

                    expect(res.body.detail.currentYearData[4].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].date)
                    expect(res.body.detail.currentYearData[4].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].wrvu)
                    expect(res.body.detail.currentYearData[4].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[4].compensation)

                    expect(res.body.detail.currentYearData[5].date).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].date)
                    expect(res.body.detail.currentYearData[5].wrvu).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].wrvu)
                    expect(res.body.detail.currentYearData[5].compensation).to.equal(productivityCompData.realData.productivityCompResponse.detail.currentYearData[5].compensation)

                    expect(res.body.detail.priorYearData[0]).to.equal(productivityCompData.realData.productivityCompResponse.detail.priorYearData[0])

                })
        });
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('12: Productivity Compensation - GET /productivity-compensation - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.mockData.userId + '&' + 'tenant=' + productivityCompData.mockData.tenant + '&' + 'dashboardKey=' + productivityCompData.mockData.dashboardKey + '&' + 'cardKey=' + productivityCompData.mockData.cardKey + '&' + 'specialties=' + productivityCompData.mockData.specialties + '&' + 'periodType=' + productivityCompData.mockData.periodType + '&' + 'periodId=' + productivityCompData.mockData.periodId + '&' + 'yearMonth=' + productivityCompData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(productivityCompData.mockData.productivityCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(productivityCompData.mockData.productivityCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail.ytdProdCompensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].ytdProdCompensation)
                    expect(res.body.detail.currentAvgRate).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentAvgRate)
                    expect(res.body.detail.priorAvgRate).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorAvgRate)

                    expect(res.body.detail.tierData[0].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].label)
                    expect(res.body.detail.tierData[0].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].value)
                    expect(res.body.detail.tierData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].wrvu)

                    expect(res.body.detail.tierData[1].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].label)
                    expect(res.body.detail.tierData[1].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].value)
                    expect(res.body.detail.tierData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].wrvu)

                    expect(res.body.detail.tierData[2].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].label)
                    expect(res.body.detail.tierData[2].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].value)
                    expect(res.body.detail.tierData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].wrvu)

                    expect(res.body.detail.currentYearData[0].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].date)
                    expect(res.body.detail.currentYearData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].wrvu)
                    expect(res.body.detail.currentYearData[0].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].compensation)

                    expect(res.body.detail.currentYearData[1].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].date)
                    expect(res.body.detail.currentYearData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].wrvu)
                    expect(res.body.detail.currentYearData[1].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].compensation)

                    expect(res.body.detail.currentYearData[2].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].date)
                    expect(res.body.detail.currentYearData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].wrvu)
                    expect(res.body.detail.currentYearData[2].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].compensation)

                    expect(res.body.detail.currentYearData[3].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].date)
                    expect(res.body.detail.currentYearData[3].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].wrvu)
                    expect(res.body.detail.currentYearData[3].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].compensation)

                    expect(res.body.detail.currentYearData[4].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].date)
                    expect(res.body.detail.currentYearData[4].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].wrvu)
                    expect(res.body.detail.currentYearData[4].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].compensation)

                    expect(res.body.detail.currentYearData[5].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].date)
                    expect(res.body.detail.currentYearData[5].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].wrvu)
                    expect(res.body.detail.currentYearData[5].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].compensation)

                    expect(res.body.detail.currentYearData[6].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].date)
                    expect(res.body.detail.currentYearData[6].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].wrvu)
                    expect(res.body.detail.currentYearData[6].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].compensation)

                    expect(res.body.detail.currentYearData[7].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].date)
                    expect(res.body.detail.currentYearData[7].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].wrvu)
                    expect(res.body.detail.currentYearData[7].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].compensation)

                    expect(res.body.detail.currentYearData[8].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].date)
                    expect(res.body.detail.currentYearData[8].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].wrvu)
                    expect(res.body.detail.currentYearData[8].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].compensation)

                    expect(res.body.detail.currentYearData[9].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].date)
                    expect(res.body.detail.currentYearData[9].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].wrvu)
                    expect(res.body.detail.currentYearData[9].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].compensation)

                    expect(res.body.detail.currentYearData[10].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].date)
                    expect(res.body.detail.currentYearData[10].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].wrvu)
                    expect(res.body.detail.currentYearData[10].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].compensation)

                    expect(res.body.detail.currentYearData[11].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].date)
                    expect(res.body.detail.currentYearData[11].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].wrvu)
                    expect(res.body.detail.currentYearData[11].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].compensation)

                    expect(res.body.detail.priorYearData[0].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].date)
                    expect(res.body.detail.priorYearData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].wrvu)
                    expect(res.body.detail.priorYearData[0].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].compensation)

                    expect(res.body.detail.priorYearData[1].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].date)
                    expect(res.body.detail.priorYearData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].wrvu)
                    expect(res.body.detail.priorYearData[1].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].compensation)

                    expect(res.body.detail.priorYearData[2].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].date)
                    expect(res.body.detail.priorYearData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].wrvu)
                    expect(res.body.detail.priorYearData[2].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].compensation)

                    expect(res.body.detail.priorYearData[3].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].date)
                    expect(res.body.detail.priorYearData[3].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].wrvu)
                    expect(res.body.detail.priorYearData[3].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].compensation)

                    expect(res.body.detail.priorYearData[4].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].date)
                    expect(res.body.detail.priorYearData[4].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].wrvu)
                    expect(res.body.detail.priorYearData[4].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].compensation)

                    expect(res.body.detail.priorYearData[5].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].date)
                    expect(res.body.detail.priorYearData[5].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].wrvu)
                    expect(res.body.detail.priorYearData[5].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].compensation)

                    expect(res.body.detail.priorYearData[6].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].date)
                    expect(res.body.detail.priorYearData[6].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].wrvu)
                    expect(res.body.detail.priorYearData[6].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].compensation)

                    expect(res.body.detail.priorYearData[7].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].date)
                    expect(res.body.detail.priorYearData[7].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].wrvu)
                    expect(res.body.detail.priorYearData[7].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].compensation)

                    expect(res.body.detail.priorYearData[8].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].date)
                    expect(res.body.detail.priorYearData[8].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].wrvu)
                    expect(res.body.detail.priorYearData[8].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].compensation)

                    expect(res.body.detail.priorYearData[9].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].date)
                    expect(res.body.detail.priorYearData[9].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].wrvu)
                    expect(res.body.detail.priorYearData[9].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].compensation)

                    expect(res.body.detail.priorYearData[10].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].date)
                    expect(res.body.detail.priorYearData[10].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].wrvu)
                    expect(res.body.detail.priorYearData[10].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].compensation)

                    expect(res.body.detail.priorYearData[11].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].date)
                    expect(res.body.detail.priorYearData[11].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].wrvu)
                    expect(res.body.detail.priorYearData[11].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].compensation)

                })
        });

        it('12: Productivity Compensation - GET /productivity-compensation - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/productivity-compensation?' + 'userId=' + productivityCompData.mockData.userId + '&' + 'tenant=' + productivityCompData.mockData.tenant + '&' + 'dashboardKey=' + productivityCompData.mockData.dashboardKey + '&' + 'cardKey=' + productivityCompData.mockData.cardKey + '&' + 'periodType=' + productivityCompData.mockData.periodType + '&' + 'periodId=' + productivityCompData.mockData.periodId + '&' + 'yearMonth=' + productivityCompData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(productivityCompData.mockData.productivityCompResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(productivityCompData.mockData.productivityCompResponse.cardSettings.infoIcon)

                    expect(res.body.detail.ytdProdCompensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].ytdProdCompensation)
                    expect(res.body.detail.currentAvgRate).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentAvgRate)
                    expect(res.body.detail.priorAvgRate).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorAvgRate)

                    expect(res.body.detail.tierData[0].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].label)
                    expect(res.body.detail.tierData[0].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].value)
                    expect(res.body.detail.tierData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[0].wrvu)

                    expect(res.body.detail.tierData[1].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].label)
                    expect(res.body.detail.tierData[1].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].value)
                    expect(res.body.detail.tierData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[1].wrvu)

                    expect(res.body.detail.tierData[2].label).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].label)
                    expect(res.body.detail.tierData[2].value).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].value)
                    expect(res.body.detail.tierData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].tierData[2].wrvu)

                    expect(res.body.detail.currentYearData[0].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].date)
                    expect(res.body.detail.currentYearData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].wrvu)
                    expect(res.body.detail.currentYearData[0].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[0].compensation)

                    expect(res.body.detail.currentYearData[1].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].date)
                    expect(res.body.detail.currentYearData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].wrvu)
                    expect(res.body.detail.currentYearData[1].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[1].compensation)

                    expect(res.body.detail.currentYearData[2].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].date)
                    expect(res.body.detail.currentYearData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].wrvu)
                    expect(res.body.detail.currentYearData[2].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[2].compensation)

                    expect(res.body.detail.currentYearData[3].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].date)
                    expect(res.body.detail.currentYearData[3].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].wrvu)
                    expect(res.body.detail.currentYearData[3].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[3].compensation)

                    expect(res.body.detail.currentYearData[4].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].date)
                    expect(res.body.detail.currentYearData[4].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].wrvu)
                    expect(res.body.detail.currentYearData[4].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[4].compensation)

                    expect(res.body.detail.currentYearData[5].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].date)
                    expect(res.body.detail.currentYearData[5].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].wrvu)
                    expect(res.body.detail.currentYearData[5].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[5].compensation)

                    expect(res.body.detail.currentYearData[6].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].date)
                    expect(res.body.detail.currentYearData[6].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].wrvu)
                    expect(res.body.detail.currentYearData[6].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[6].compensation)

                    expect(res.body.detail.currentYearData[7].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].date)
                    expect(res.body.detail.currentYearData[7].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].wrvu)
                    expect(res.body.detail.currentYearData[7].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[7].compensation)

                    expect(res.body.detail.currentYearData[8].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].date)
                    expect(res.body.detail.currentYearData[8].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].wrvu)
                    expect(res.body.detail.currentYearData[8].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[8].compensation)

                    expect(res.body.detail.currentYearData[9].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].date)
                    expect(res.body.detail.currentYearData[9].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].wrvu)
                    expect(res.body.detail.currentYearData[9].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[9].compensation)

                    expect(res.body.detail.currentYearData[10].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].date)
                    expect(res.body.detail.currentYearData[10].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].wrvu)
                    expect(res.body.detail.currentYearData[10].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[10].compensation)

                    expect(res.body.detail.currentYearData[11].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].date)
                    expect(res.body.detail.currentYearData[11].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].wrvu)
                    expect(res.body.detail.currentYearData[11].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].currentYearData[11].compensation)

                    expect(res.body.detail.priorYearData[0].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].date)
                    expect(res.body.detail.priorYearData[0].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].wrvu)
                    expect(res.body.detail.priorYearData[0].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[0].compensation)

                    expect(res.body.detail.priorYearData[1].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].date)
                    expect(res.body.detail.priorYearData[1].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].wrvu)
                    expect(res.body.detail.priorYearData[1].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[1].compensation)

                    expect(res.body.detail.priorYearData[2].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].date)
                    expect(res.body.detail.priorYearData[2].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].wrvu)
                    expect(res.body.detail.priorYearData[2].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[2].compensation)

                    expect(res.body.detail.priorYearData[3].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].date)
                    expect(res.body.detail.priorYearData[3].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].wrvu)
                    expect(res.body.detail.priorYearData[3].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[3].compensation)

                    expect(res.body.detail.priorYearData[4].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].date)
                    expect(res.body.detail.priorYearData[4].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].wrvu)
                    expect(res.body.detail.priorYearData[4].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[4].compensation)

                    expect(res.body.detail.priorYearData[5].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].date)
                    expect(res.body.detail.priorYearData[5].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].wrvu)
                    expect(res.body.detail.priorYearData[5].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[5].compensation)

                    expect(res.body.detail.priorYearData[6].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].date)
                    expect(res.body.detail.priorYearData[6].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].wrvu)
                    expect(res.body.detail.priorYearData[6].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[6].compensation)

                    expect(res.body.detail.priorYearData[7].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].date)
                    expect(res.body.detail.priorYearData[7].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].wrvu)
                    expect(res.body.detail.priorYearData[7].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[7].compensation)

                    expect(res.body.detail.priorYearData[8].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].date)
                    expect(res.body.detail.priorYearData[8].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].wrvu)
                    expect(res.body.detail.priorYearData[8].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[8].compensation)

                    expect(res.body.detail.priorYearData[9].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].date)
                    expect(res.body.detail.priorYearData[9].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].wrvu)
                    expect(res.body.detail.priorYearData[9].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[9].compensation)

                    expect(res.body.detail.priorYearData[10].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].date)
                    expect(res.body.detail.priorYearData[10].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].wrvu)
                    expect(res.body.detail.priorYearData[10].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[10].compensation)

                    expect(res.body.detail.priorYearData[11].date).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].date)
                    expect(res.body.detail.priorYearData[11].wrvu).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].wrvu)
                    expect(res.body.detail.priorYearData[11].compensation).to.equal(productivityCompData.mockData.productivityCompResponse.detail[0].priorYearData[11].compensation)

                })
        });
    }

})
