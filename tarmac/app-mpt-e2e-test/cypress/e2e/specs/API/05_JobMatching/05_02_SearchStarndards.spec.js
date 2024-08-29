/// <reference types="Cypress" />
describe('Job Matching: Search Standards Endpoint', { testIsolation: false }, function () {
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
  
    it('01: Search by job title', function () {
      
        cy.request(
          {
            method: 'POST',
            url: data.ProjectAPIUrl + 'api/survey/cuts-data/standard-jobs',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json, text/plain, */*',
              Authorization: this.authData.accessToken
            },
            body: 
              {
                  "standardJobSearch": data.standardJobSearch
              }
          }).then((res1) => {
            expect(res1.status).to.eq(200);
            expect(res1.body).to.not.be.null;
            expect(res1.body).to.not.be.undefined;
            data.searchStandardsData.forEach((item)=>{
                expect(res1.body[0]).to.have.property(item);
            })
          })
    })
    it('05_02: Search by job code', function () {
      
        cy.request(
          {
            method: 'POST',
            url: data.ProjectAPIUrl + 'api/survey/cuts-data/standard-jobs',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json, text/plain, */*',
              Authorization: this.authData.accessToken
            },
            body: 
              {
                  "standardJobSearch": data.searchStandardsJobcode
              }
          }).then((res1) => {
            expect(res1.status).to.eq(200);
            expect(res1.body).to.not.be.null;
            expect(res1.body).to.not.be.undefined;
            data.searchStandardsData.forEach((item)=>{
                expect(res1.body[0]).to.have.property(item);
            })
          })
    })
})