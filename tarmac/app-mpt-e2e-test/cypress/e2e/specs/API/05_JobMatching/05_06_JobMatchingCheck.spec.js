/// <reference types="Cypress" />
describe('Job Matching Check', { testIsolation: false }, function () {
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
  //// 200 response code returned when for Job code doesn't exist
it('01: 200 response code returned when for Job Matching Check', function () {
    cy.request(
      {
          method: 'POST',
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionId+'/matching/check-edition',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "selectedJobs":
            [
            {
            "aggregationMethodKey": 1,
            "fileOrgKey": data.OrgId,
            "positionCode": "",
            "jobCode": "client-job-1",
            },
            {
            "aggregationMethodKey": 1,
            "fileOrgKey": data.OrgId,
            "positionCode": "",
            "jobCode": "client-job-2",
            },
            ],
            }
      }).then((res) => {
        expect(res.status).to.eq(200);
        expect(res.body).to.have.property('valid');
      })
})
// 200 response code returned when for Job code is valid
it('01: Return 200 response code when Job Matching Check  ', function () {
    cy.request(
      {
          method: 'POST',
          failOnStatusCode: false,
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionId+'/matching/check-edition',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "selectedJobs":
            [
            {
            "aggregationMethodKey": 1,
            "fileOrgKey": 90,
            "positionCode": "",
            "jobCode": "2.201",
            },
            ],
            }
      }).then((res) => {
        expect(res.status).to.eq(200);
        expect(res.body).not.to.have.property('invalid');
      })
})
})