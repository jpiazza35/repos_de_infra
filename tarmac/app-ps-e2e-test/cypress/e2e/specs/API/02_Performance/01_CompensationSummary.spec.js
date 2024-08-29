/// <reference types="Cypress" />

describe('Performance - Compensation Summary API', function () {
    let compSummaryData;

    before(function () {
        cy.generateAccessToken();
    });

    beforeEach(function () {
        cy.fixture('00_Auth/auth_data').as('authData')
        cy.fixture('02_Performance/CompensationSummary/compensation_summary_data').then((data) => {
            compSummaryData = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    it('01: Comp Summary - GET /compensation-summary - verify 200 response', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: compSummaryData.CompSummaryAPIUrl,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                expect(res.body.compensationCategories[0].category).to.equal(compSummaryData.CompSummaryLabel.ProductionCompensation)
                expect(res.body.compensationCategories[0].total).to.equal(compSummaryData.CompSummaryValue.ProductionComp)
                expect(res.body.compensationCategories[1].category).to.equal(compSummaryData.CompSummaryLabel.EstimatedValueBased)
                expect(res.body.compensationCategories[1].total).to.equal(compSummaryData.CompSummaryValue.EstimatedValueBased)
                expect(res.body.compensationCategories[2].category).to.equal(compSummaryData.CompSummaryLabel.BaseSalary)
                expect(res.body.compensationCategories[2].total).to.equal(compSummaryData.CompSummaryValue.BaseSalary)
                expect(res.body.compensationCategories[3].category).to.equal(compSummaryData.CompSummaryLabel.Other)
                expect(res.body.compensationCategories[3].total).to.equal(compSummaryData.CompSummaryValue.Other)
                expect(res.body.name).to.equal(compSummaryData.CompSummaryLabel.Name)
                expect(res.body.specialty).to.equal(compSummaryData.CompSummaryLabel.Specialty)
                expect(res.body.fte).to.equal(compSummaryData.CompSummaryValue.FTE)
                expect(res.body.ytdBenchmarkPercentile).to.equal(compSummaryData.CompSummaryValue.YTDBenchmarkPercentile)
                expect(res.body.ytdwRVUs).to.equal(compSummaryData.CompSummaryValue.ytdwRVUs)
                expect(res.body.benchmarkFTE).to.equal(compSummaryData.CompSummaryValue.benchmarkFTE)
                expect(res.body.wRVUsFTE).to.equal(compSummaryData.CompSummaryValue.wRVUsFTE)
                expect(res.body.cardname).to.equal(compSummaryData.CompSummaryLabel.Cardname)
            })
    });

    it('01: Comp Summary - GET /compensation-summary -  verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: compSummaryData.CompSummaryAPIUrl,
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

    it('01: Comp Summary - GET /compensation-summary - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: compSummaryData.CompSummaryAPIUrl,
                failOnStatusCode: false,
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);

            })
    });

    it('01: Comp Summary - GET /compensation-summary - verify 401 response - Expired Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: compSummaryData.CompSummaryAPIUrl,
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
})