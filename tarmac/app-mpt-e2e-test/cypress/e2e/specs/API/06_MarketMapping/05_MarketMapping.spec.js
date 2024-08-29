/// <reference types="Cypress" />
describe('Market Segment Mapping Endpoints', { testIsolation: false }, function () {
    before(function () {
      cy.generateAccessToken();
    })
  
    beforeEach(function () {
      cy.fixture('APITestData/project_api_data').as('projectData')
      cy.fixture('Auth/auth_data').as('authData')
    });
    after(function () {
      cy.log("Project API Tests Complete")
    })
  
    it('01: ProjectAPI - Project - GET /api/projects - verify 200 response', function () {
      cy.request(
        {
          method: 'GET',
          form: true,
          url: this.projectData.ProjectAPIUrl + '/api/projects/market-segment-mapping/2/jobs',
          headers: {
            'Content-Type': 'application/json',
            Authorization: this.authData.accessToken
          },
          body: {
            
          }
        }).then((res) => {
          expect(res.status).to.eq(200);
          expect(res.body).not.to.empty;
          //expect(res.body.sourceDataAgregationKey).to.eq(646);
        })
    })
    it.only('05: Market Segment Save  - verify 200 response', function () {
        cy.request(
          {
            method: 'POST',
            true: true,
            url: this.projectData.ProjectAPIUrl + 'api/projects/market-segment-mapping/2',
            headers: {
                "content-type": "application/problem+json; charset=utf-8",
              Authorization: this.authData.accessToken
            },
            body: [
                {
                    "aggregationMethodKey": 1,
                    "fileOrgKey": 10423,
                    "positionCode": "",
                    "jobCode": "91.141",
                    "jobGroup": "Anowar",
                    "marketSegmentId": 2
                }
            ]
          }).then((res) => {
            expect(res.status).to.eq(200);
            cy.wrap(res.body).as('PostResponse')
          })
      })
})