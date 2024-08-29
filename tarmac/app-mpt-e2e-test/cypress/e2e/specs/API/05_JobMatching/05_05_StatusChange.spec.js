/// <reference types="Cypress" />
describe('Status Change', { testIsolation: false }, function () {
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
  
it('01: 200 response code returned when for Status Change', function () {
    cy.request(
      {
          method: 'POST',
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionId+'/status/'+data.jobMatchStatusKeyComplete,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:[
          {
            "aggregationMethodKey": 0,
            "fileOrgKey": 0,
            "positionCode": "string",
            "jobCode": "string"
          }
        ]
      }).then((res) => {
        expect(res.status).to.eq(200);
      })
})
it('05_02: Bad response code returned when Project Status Final', function () {
    cy.request(
      {
          method: 'POST',
          failOnStatusCode: false,
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionIdFinal+'/status/'+data.jobMatchStatusKey,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:[
          {
            "aggregationMethodKey": 0,
            "fileOrgKey": 0,
            "positionCode": "string",
            "jobCode": "string"
          }
        ]
      }).then((res) => {
        expect(res.status).to.eq(400);
      })
})

it('05_03: Bad response code returned when Project Status Deleted', function () {
    cy.request(
      {
          method: 'POST',
          failOnStatusCode: false,
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionIdDeleted+'/status/'+data.jobMatchStatusKey,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:[
          {
            "aggregationMethodKey": 0,
            "fileOrgKey": 0,
            "positionCode": "string",
            "jobCode": "string"
          }
        ]
      }).then((res) => {
        expect(res.status).to.eq(400);
      })
})
})