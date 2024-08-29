/// <reference types="Cypress" />

describe('Performance - Value Based Measures API', function () {
    let valueBasedMeasuresData;
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
        cy.fixture('API/02_Performance/value_Based_Measures_data').then((data) => {
            valueBasedMeasuresData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('10: Value Based Measures - GET /value-based-measures - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('10: Value Based Measures - GET /value-based-measures - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter Dashboardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter Cardkey', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
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

    it('10: Value Based Measures - GET /value-based-measures - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId,
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
        it('10: Value Based Measures - GET /value-based-measures - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.realData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].measureGroupDescription)
                    expect(res.body.detail[0].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].measureTypeName)
                    expect(res.body.detail[0].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].participantGroupName)
                    expect(res.body.detail[0].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].ytdRatioDisplay)
                    expect(res.body.detail[0].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].ytdTargetDisplay)

                    expect(res.body.detail[1].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].measureGroupDescription)
                    expect(res.body.detail[1].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].measureTypeName)
                    expect(res.body.detail[1].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].participantGroupName)
                    expect(res.body.detail[1].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].ytdRatioDisplay)
                    expect(res.body.detail[1].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].ytdTargetDisplay)

                    expect(res.body.detail[2].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].measureGroupDescription)
                    expect(res.body.detail[2].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].measureTypeName)
                    expect(res.body.detail[2].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].participantGroupName)
                    expect(res.body.detail[2].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].ytdRatioDisplay)
                    expect(res.body.detail[2].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].ytdTargetDisplay)

                })
        });

        it('10: Value Based Measures - GET /value-based-measures - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.realData.userId + '&' + 'tenant=' + valueBasedMeasuresData.realData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.realData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.realData.cardKey + '&' + 'periodId=' + valueBasedMeasuresData.realData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.realData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].measureGroupDescription)
                    expect(res.body.detail[0].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].measureTypeName)
                    expect(res.body.detail[0].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].participantGroupName)
                    expect(res.body.detail[0].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].ytdRatioDisplay)
                    expect(res.body.detail[0].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[0].ytdTargetDisplay)

                    expect(res.body.detail[1].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].measureGroupDescription)
                    expect(res.body.detail[1].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].measureTypeName)
                    expect(res.body.detail[1].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].participantGroupName)
                    expect(res.body.detail[1].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].ytdRatioDisplay)
                    expect(res.body.detail[1].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[1].ytdTargetDisplay)

                    expect(res.body.detail[2].measureGroupDescription).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].measureGroupDescription)
                    expect(res.body.detail[2].measureTypeName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].measureTypeName)
                    expect(res.body.detail[2].participantGroupName).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].participantGroupName)
                    expect(res.body.detail[2].ytdRatioDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].ytdRatioDisplay)
                    expect(res.body.detail[2].ytdTargetDisplay).to.equal(valueBasedMeasuresData.realData.valueBasedMeasuresResponse.detail[2].ytdTargetDisplay)

                })
        });
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('10: Value Based Measures - GET /value-based-measures - verify 200 response', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.mockData.userId + '&' + 'tenant=' + valueBasedMeasuresData.mockData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.mockData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.mockData.cardKey + '&' + 'specialties=' + valueBasedMeasuresData.mockData.specialties + '&' + 'periodId=' + valueBasedMeasuresData.mockData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].measureGroupDescription1)
                    expect(res.body.detail[0].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].measureTypeName1)
                    expect(res.body.detail[0].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].participantGroupName1)
                    expect(res.body.detail[0].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].ytdRatioDisplay1)
                    expect(res.body.detail[0].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].ytdTargetDisplay1)

                    expect(res.body.detail[1].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].measureGroupDescription2)
                    expect(res.body.detail[1].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].measureTypeName2)
                    expect(res.body.detail[1].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].participantGroupName2)
                    expect(res.body.detail[1].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].ytdRatioDisplay2)
                    expect(res.body.detail[1].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].ytdTargetDisplay2)

                    expect(res.body.detail[2].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].measureGroupDescription3)
                    expect(res.body.detail[2].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].measureTypeName3)
                    expect(res.body.detail[2].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].participantGroupName3)
                    expect(res.body.detail[2].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].ytdRatioDisplay3)
                    expect(res.body.detail[2].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].ytdTargetDisplay3)

                    expect(res.body.detail[3].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].measureGroupDescription4)
                    expect(res.body.detail[3].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].measureTypeName4)
                    expect(res.body.detail[3].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].participantGroupName4)
                    expect(res.body.detail[3].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].ytdRatioDisplay4)
                    expect(res.body.detail[3].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].ytdTargetDisplay4)

                    expect(res.body.detail[4].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].measureGroupDescription5)
                    expect(res.body.detail[4].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].measureTypeName5)
                    expect(res.body.detail[4].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].participantGroupName5)
                    expect(res.body.detail[4].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].ytdRatioDisplay5)
                    expect(res.body.detail[4].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].ytdTargetDisplay5)

                })
        });

        it('10: Value Based Measures - GET /value-based-measures - verify 200 response - With Optional Param Specialty', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_performance_url') + '/value-based-measure?' + 'userId=' + valueBasedMeasuresData.mockData.userId + '&' + 'tenant=' + valueBasedMeasuresData.mockData.tenant + '&' + 'dashboardKey=' + valueBasedMeasuresData.mockData.dashboardKey + '&' + 'cardKey=' + valueBasedMeasuresData.mockData.cardKey + '&' + 'periodId=' + valueBasedMeasuresData.mockData.periodId + '&' + 'yearMonth=' + valueBasedMeasuresData.mockData.yearMonth,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body).to.not.be.empty

                    expect(res.body.cardSettings.title).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.cardSettings.title)
                    expect(res.body.cardSettings.infoIcon).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.cardSettings.infoIcon)

                    expect(res.body.detail[0].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].measureGroupDescription1)
                    expect(res.body.detail[0].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].measureTypeName1)
                    expect(res.body.detail[0].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].participantGroupName1)
                    expect(res.body.detail[0].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].ytdRatioDisplay1)
                    expect(res.body.detail[0].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[0].ytdTargetDisplay1)

                    expect(res.body.detail[1].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].measureGroupDescription2)
                    expect(res.body.detail[1].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].measureTypeName2)
                    expect(res.body.detail[1].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].participantGroupName2)
                    expect(res.body.detail[1].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].ytdRatioDisplay2)
                    expect(res.body.detail[1].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[1].ytdTargetDisplay2)

                    expect(res.body.detail[2].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].measureGroupDescription3)
                    expect(res.body.detail[2].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].measureTypeName3)
                    expect(res.body.detail[2].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].participantGroupName3)
                    expect(res.body.detail[2].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].ytdRatioDisplay3)
                    expect(res.body.detail[2].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[2].ytdTargetDisplay3)

                    expect(res.body.detail[3].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].measureGroupDescription4)
                    expect(res.body.detail[3].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].measureTypeName4)
                    expect(res.body.detail[3].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].participantGroupName4)
                    expect(res.body.detail[3].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].ytdRatioDisplay4)
                    expect(res.body.detail[3].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[3].ytdTargetDisplay4)

                    expect(res.body.detail[4].measureGroupDescription).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].measureGroupDescription5)
                    expect(res.body.detail[4].measureTypeName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].measureTypeName5)
                    expect(res.body.detail[4].participantGroupName).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].participantGroupName5)
                    expect(res.body.detail[4].ytdRatioDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].ytdRatioDisplay5)
                    expect(res.body.detail[4].ytdTargetDisplay).to.equal(valueBasedMeasuresData.mockData.valueBasedMeasuresResponse.detail[4].ytdTargetDisplay5)

                })
        });
    }

})