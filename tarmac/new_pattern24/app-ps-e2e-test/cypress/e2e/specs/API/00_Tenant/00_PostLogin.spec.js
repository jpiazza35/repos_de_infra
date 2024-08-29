/// <reference types="Cypress" />
describe('Tenant - Post Login API', function () {
    let postLogindata;
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
        cy.fixture('API/00_Tenant/post_login_tenant_service_data').then((data) => {
            postLogindata = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    // common tests for both mock and real data users
    it('00: Post Login - GET /Post-Login - verify 200 response - Unauthorized User', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.fy_realData.auth0Id,
                failOnStatusCode: false,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json',
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
            })
    });


    it('00: Post Login - GET /Post-Login - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.fy_realData.auth0Id,
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


    it('00: Post Login - GET /Post-Login - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.fy_realData.auth0Id,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });


    it('00: Post Login - GET /Post-Login - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.fy_realData.auth0Id,
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

    //Fiscal year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'fiscal') {

        it('00: Post Login - GET /Post-Login - verify 200 response - Authenticated User ', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.fy_realData.auth0Id,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body[0].userID).to.equal(postLogindata.fy_realData.postLoginResponse.userID)
                    expect(res.body[0].applicationKey).to.equal(postLogindata.fy_realData.postLoginResponse.applicationKey)
                    expect(res.body[0].tenantKey).to.equal(postLogindata.fy_realData.postLoginResponse.tenantKey)
                    expect(res.body[0].persona[0]).to.equal(postLogindata.fy_realData.postLoginResponse.persona[0])
                    expect(res.body[0].role).to.deep.equal(postLogindata.fy_realData.postLoginResponse.role)
                })
        });
    }

    //Calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {

        it('00: Post Login - GET /Post-Login - verify 200 response - Authenticated User ', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.cy_realData.auth0Id,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body[0].userID).to.equal(postLogindata.cy_realData.postLoginResponse.userID)
                    expect(res.body[0].applicationKey).to.equal(postLogindata.cy_realData.postLoginResponse.applicationKey)
                    expect(res.body[0].tenantKey).to.equal(postLogindata.cy_realData.postLoginResponse.tenantKey)
                    expect(res.body[0].persona[0]).to.equal(postLogindata.cy_realData.postLoginResponse.persona[0])
                    expect(res.body[0].role).to.deep.equal(postLogindata.cy_realData.postLoginResponse.role)
                })
        });
    }

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {

        it('00: Post Login - GET /Post-Login - verify 200 response - Authenticated User ', function () {
            cy.request(
                {
                    method: 'GET',
                    form: true,
                    url: Cypress.env('api_tenant_url') + '/post-login?' + 'auth0id=' + postLogindata.mockData.auth0Id,
                    headers: {
                        'Authorization': 'Bearer ' + this.authData.authToken,
                        'Content-Type': 'application/json',
                    }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body[0].userID).to.equal(postLogindata.mockData.postLoginResponse.userID)
                    expect(res.body[0].applicationKey).to.equal(postLogindata.mockData.postLoginResponse.applicationKey)
                    expect(res.body[0].tenantKey).to.equal(postLogindata.mockData.postLoginResponse.tenantKey)
                    expect(res.body[0].persona[0]).to.equal(postLogindata.mockData.postLoginResponse.persona[0])
                    expect(res.body[0].persona[1]).to.equal(postLogindata.mockData.postLoginResponse.persona[1])
                    expect(res.body[0].role[0]).to.deep.equal(postLogindata.mockData.postLoginResponse.role[0])
                    expect(res.body[0].role[1]).to.deep.equal(postLogindata.mockData.postLoginResponse.role[1])
                })
        });
    }
})
