/// <reference types="Cypress" />
describe('Job Matching: Survery Jobs', { testIsolation: false }, function () {
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
  
it('01: 200 response code when for Get Client Position Detail', function () {
    cy.request(
      {
          method: 'post',
          true: true,
        url: data.ProjectAPIUrl + 'api/survey/cuts-data/survey-jobs/',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "standardJobCodes": [
              data.standardJobCodes
            ],
            "publisherKey": 1
          }
      }).then((res) => {
        let responseData=['fteCount','incumbentCount','jobCode','jobFamily','jobLevel','jobTitle','locationDescription','payGrade','payType','positionCode','positionCodeDescription']
        expect(res.status).to.eq(200);
        responseData.forEach((item)=>{
        expect(res.body[0]).to.have.property(item);
        })
        })
})
})