/// <reference types="Cypress" />
describe('Pricing Sheet: Adjustment notes', { testIsolation: false }, function () {
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
  
it('01: 200 response code when for Adjustment notes', function () {
    cy.request(
      {
          method: 'GET',
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/adjustment-notes',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
      }).then((res) => {
        let responseData=['Level','Scope','Complexity','Other']
        expect(res.status).to.eq(200);
        let lent=responseData.length
        expect(res.body.length).to.eq(lent);
        for (let i = 0; i < lent; i++) {
          expect(res.body[i]).to.deep.contains({name: responseData[i]})
        }}) 
          

})
})