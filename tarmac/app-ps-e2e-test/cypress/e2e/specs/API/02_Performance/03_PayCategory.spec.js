/// <reference types="Cypress" />

describe('Performance - Pay Category API', function () {
    let PayCategorydata;

    before(function () {
        cy.generateAccessToken();
    });

    beforeEach(function () {
        cy.fixture('00_Auth/auth_data').as('authData')
        cy.fixture('02_Performance/PayCategory/pay_category_data').then((data) => {
            PayCategorydata = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    it('03: Pay Category - GET /Pay-Category - verify 200 response', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Mandatoryparams,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json',
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                expect(res.body.settings.infoIcon).to.equal(PayCategorydata.PayCategoryLabel.InfoIcon)
                expect(res.body.detail[0].amount).to.equal(PayCategorydata.PayCategoryValue.Amount)
                expect(res.body.detail[0].total).to.equal(PayCategorydata.PayCategoryValue.Total)
                expect(res.body.detail[0].percentaje).to.equal(PayCategorydata.PayCategoryValue.Percentage)
                expect(res.body.detail[0].name).to.equal(PayCategorydata.PayCategoryValue.Name)
                expect(res.body.detail[1].amount).to.equal(PayCategorydata.PayCategoryValue.Amount1)
                expect(res.body.detail[1].total).to.equal(PayCategorydata.PayCategoryValue.Total1)
                expect(res.body.detail[1].percentaje).to.equal(PayCategorydata.PayCategoryValue.Percentage1)
                expect(res.body.detail[1].name).to.equal(PayCategorydata.PayCategoryValue.Name1)

            })
    });

    it('03: Pay Category - GET /Pay-Category - verify 200 response - With Optional Param Specialty', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Mandatoryparams + PayCategorydata.Specialty,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json',
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                expect(res.body.settings.infoIcon).to.equal(PayCategorydata.PayCategoryLabel.InfoIcon)
                expect(res.body.detail[0].amount).to.equal(PayCategorydata.PayCategoryValue.Amount)
                expect(res.body.detail[0].total).to.equal(PayCategorydata.PayCategoryValue.Total)
                expect(res.body.detail[0].percentaje).to.equal(PayCategorydata.PayCategoryValue.Percentage)
                expect(res.body.detail[0].name).to.equal(PayCategorydata.PayCategoryValue.Name)
                expect(res.body.detail[1].amount).to.equal(PayCategorydata.PayCategoryValue.Amount1)
                expect(res.body.detail[1].total).to.equal(PayCategorydata.PayCategoryValue.Total1)
                expect(res.body.detail[1].percentaje).to.equal(PayCategorydata.PayCategoryValue.Percentage1)
                expect(res.body.detail[1].name).to.equal(PayCategorydata.PayCategoryValue.Name1)
            })
    });

    it('03: Pay Category - GET /Pay-Category - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Mandatoryparams,
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

    it('03: Pay Category - GET /Pay-Category - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Mandatoryparams,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('03: Pay Category - GET /Pay-Category - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Mandatoryparams,
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

    it('03: Pay Category - GET /Pay-Category - verify 400 response - Missing required parameter UserId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.Tenant + PayCategorydata.PeriodId + PayCategorydata.YearMonth,
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

    it('03: Pay Category - GET /Pay-Category - verify 400 response - Missing required parameter Tenant', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.UserId + PayCategorydata.PeriodId + PayCategorydata.YearMonth,
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

    it('03: Pay Category - GET /Pay-Category - verify 400 response - Missing required parameter PeriodId', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.UserId + PayCategorydata.Tenant + PayCategorydata.YearMonth,
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

    it('03: Pay Category - GET /Pay-Category - verify 400 response - Missing required parameter YearMonth', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: PayCategorydata.PayCategoryAPIUrl + PayCategorydata.UserId + PayCategorydata.Tenant + PayCategorydata.PeriodId,
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
})