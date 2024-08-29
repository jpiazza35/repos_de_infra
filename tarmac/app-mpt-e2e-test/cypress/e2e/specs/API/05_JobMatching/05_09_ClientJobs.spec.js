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
  
it('01: 200 response code when for Client Jobs', function () {
    cy.request(
      {
          method: 'Post',
          true: true,
          
        url: data.ProjectAPIUrl + 'api/projects/job-matching/'+data.projectVersionId+'/matching/client-jobs',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
          "marketPricingJobCode": "MP-JC01",
          "marketPricingJobTitle": "MP-Title",
          "marketPricingJobDescription": "MP-Description",
          "publisherName": "SurveyPublisher",
          "publisherKey": 1,
          "jobMatchNote": "Some note",
          "jobMatchStatusKey": 8,
          "selectedJobs": [
          {
            "aggregationMethodKey": 1,
             "fileOrgKey": 12345,
             "positionCode": "",
             "jobCode": "DC001"
          }
        ],
          "standardJobs": [
            {
              "standardJobCode": "DC001-ST",
              "standardJobTitle": "Title standard Job",
              "standardJobDescription": "Another description",
              "blendNote": "some note",
              "blendPercent": 80
            }
          ]
        }
      }).then((res) => {
        expect(res.status).to.eq(200);
        expect(res.body).to.not.be.null;
        })
})
})