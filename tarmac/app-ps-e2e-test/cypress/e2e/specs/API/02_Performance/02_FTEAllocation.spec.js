/// <reference types="Cypress" />

describe('Performance - FTE Allocation API', function () {
    let FTEallocationdata;

    before(function () {
        cy.generateAccessToken();
    });

    beforeEach(function () {
        cy.fixture('00_Auth/auth_data').as('authData')
        cy.fixture('02_Performance/FTEAllocation/fte_allocation_data').then((data) => {
            FTEallocationdata = data
        })
    });

    after(function () {
        cy.deleteTokens()
    });

    it('02: FTE Allocation - GET /FTE-Allocation - verify 200 response', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: FTEallocationdata.FTEAllocationAPIUrl,
                headers: {
                    'Authorization': 'Bearer ' + this.authData.authToken,
                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body).to.not.be.empty
                cy.log(JSON.stringify(res.body))
                expect(res.body.allocationCategories[0].category).to.equal(FTEallocationdata.FTEAllocationLabel.Clinical)
                expect(res.body.allocationCategories[0].ytdAvg).to.equal(FTEallocationdata.FTEAllocationValue.ClinicalYTDAvg)
                expect(res.body.allocationCategories[0].currentMonth).to.equal(FTEallocationdata.FTEAllocationValue.ClinicalCurMonth)
                expect(res.body.allocationCategories[1].category).to.equal(FTEallocationdata.FTEAllocationLabel.Administrative)
                expect(res.body.allocationCategories[1].ytdAvg).to.equal(FTEallocationdata.FTEAllocationValue.AdministrativeYTDAvg)
                expect(res.body.allocationCategories[1].currentMonth).to.equal(FTEallocationdata.FTEAllocationValue.AdministrativeCurMonth)
                expect(res.body.allocationCategories[2].category).to.equal(FTEallocationdata.FTEAllocationLabel.Teaching)
                expect(res.body.allocationCategories[2].ytdAvg).to.equal(FTEallocationdata.FTEAllocationValue.TeachingYTDAvg)
                expect(res.body.allocationCategories[2].currentMonth).to.equal(FTEallocationdata.FTEAllocationValue.TeachingCurMonth)
            })
    });

    it('02: FTE Allocation - GET /FTE-Allocation - verify 401 response - Invalid Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: FTEallocationdata.FTEAllocationAPIUrl,
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

    it('02: FTE Allocation - GET /FTE-Allocation - verify 401 response - No Token', function () {
        cy.request(
            {
                method: 'GET',
                form: true,
                url: FTEallocationdata.FTEAllocationAPIUrl,
                failOnStatusCode: false,
                headers: {

                    'Content-Type': 'application/json'
                }
            }).then((res) => {
                expect(res.status).to.eq(401);
                expect(res.body.message).to.include(this.authData.noTokenMessage);
            })
    });

    it('02: FTE Allocation - GET /FTE-Allocation - verify 401 response - Expired Token', function () {

        cy.request(
            {
                method: 'GET',
                form: true,
                url: FTEallocationdata.FTEAllocationAPIUrl,
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