/// <reference types="Cypress" />
describe('Job Matching: Audit Calculations', { testIsolation: false }, function () {
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
      //cy.deleteTokens()
    })
  
it('01: 200 response code when for Client Jobs', function () {
    cy.request(
      {
          method: 'Post',
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionId+'/audit-calculations',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "clientJobCodes": [
              "57.03", "2.201"
            ],
            "standardJobCodes": [
              "3030"
            ]
          }
      }).then((res) => {
        let responseData=["annual","hourly"]
        expect(res.status).to.eq(200);
        expect(res.body).to.not.be.null;
        responseData.forEach((item)=>{
          expect(res.body).to.have.property(item);
        })
        })
})
})