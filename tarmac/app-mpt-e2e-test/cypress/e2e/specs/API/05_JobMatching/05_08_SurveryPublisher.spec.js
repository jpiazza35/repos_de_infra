/// <reference types="Cypress" />
describe('Job Matching: Survery Publishers', { testIsolation: false }, function () {
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
  
it('01: 200 response code when for Survey Publisher', function () {
    cy.request(
      {
          method: 'POST',
          true: true,
        url: data.ProjectAPIUrl + 'api/survey/cuts-data/publishers',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "standardJobCodes": [
              data.standardJobCodes
            ]
          }
      }).then((res) => {
        let responseData=['publisherKey','publisherName']
        expect(res.status).to.eq(200);
        responseData.forEach((item)=>{
        expect(res.body[0]).to.have.property(item);
        })
        })
})
})