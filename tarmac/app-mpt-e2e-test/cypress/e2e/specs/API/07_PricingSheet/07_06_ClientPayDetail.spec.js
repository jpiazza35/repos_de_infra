/// <reference types="Cypress" />
describe('Pricing Sheet: Client Pay Detail', { testIsolation: false }, function () {
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
  
    it('01: 200 response code for Job Match Detail Get', function () {
        cy.request(
        {
            method: 'Get',
            true: true,
            url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionIdPricingSheet+'/client-pay-detail/'+data.MarketPriciingSheetId,
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            Authorization: this.authData.accessToken
            },
        }).then((res) => {
            expect(res.status).to.eq(200);
            expect(res.body).to.not.be.null;
            expect(res.body).to.have.property(data.benchMarkData.BaseHourlyRate);
            expect(res.body).to.have.property(data.benchMarkData.PayMidPoint);
            expect(res.body).to.have.property(data.benchMarkData.PayRngMax); 
            expect(res.body).to.have.property(data.benchMarkData.PayRngMin);
            })
            })
  
  })