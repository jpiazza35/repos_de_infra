/// <reference types="Cypress" />
describe('Pricing Sheet: Report filters US-57963', { testIsolation: false }, function () {
    let data;
    before(function () {
      cy.generateAccessToken();
    })
    let aggregationMethodKey;
    let fileOrgKey;
  
    beforeEach(function () {
      cy.fixture('APITestData/project_api_data').then((pData)=>{
        data=pData})
      cy.fixture('Auth/auth_data').as('authData')
    });
    after(function () {
      cy.deleteTokens()
    })
  
    it('01: 200 response code for Report filters', function () {
        cy.request(
        {
            method: 'Get',
            true: true,
            url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionIdPricingSheet+'/market-segment/report-filters',
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            Authorization: this.authData.accessToken
            },
        }).then((res) => {
            expect(res.status).to.eq(200);
            expect(res.body).to.not.be.null;
            })
            })
  
  })