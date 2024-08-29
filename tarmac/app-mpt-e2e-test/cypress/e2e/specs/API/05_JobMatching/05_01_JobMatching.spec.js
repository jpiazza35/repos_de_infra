/// <reference types="Cypress" />
describe('Market Segment Mapping Endpoints', { testIsolation: false }, function () {
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
  
    it.only('01: ProjectAPI - Project - GET /api/projects - verify 200 response', function () {
      cy.request(
        {
          method: 'GET',
          form: true,
          url: data.ProjectAPIUrl + 'api/projects/market-segment-mapping/'+data.projectVersionId+'/jobs',
          headers: {
            'Content-Type': 'application/json',
            Authorization: this.authData.accessToken
          },
          body: {
          }
        }).then((res) => {
          aggregationMethodKey = res.body[0].aggregationMethodKey;
          fileOrgKey = res.body[0].fileOrgKey;
          expect(res.status).to.eq(200);
          expect(res.body).not.to.empty;
          //data.mappingData.forEach((elm)=>{
          //  expect(res.body[0]).to.have.property(elm)
         // })
        })
        //update the API response with the expected data
        cy.request(
          {
            method: 'POST',
            true: true,
            url: data.ProjectAPIUrl + 'api/projects/market-segment-mapping/'+data.projectVersionId,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              Authorization: this.authData.accessToken
            },
            body: [
              {
                  "aggregationMethodKey": aggregationMethodKey,
                  "fileOrgKey": fileOrgKey,
                  "positionCode": "",
                  //"jobCode": "91.141",
                  "jobGroup": "Anowar",
                  //"marketSegmentId": 2
              }
          ]
          }).then((res1) => {
            expect(res1.status).to.eq(200);
            //expect(res.body).not.to.empt
          })
    
          cy.request(
            {
              method: 'GET',
              form: true,
              url: data.ProjectAPIUrl + 'api/projects/market-segment-mapping/'+data.projectVersionId+'/jobs',
              headers: {
                'Content-Type': 'application/json',
                Authorization: this.authData.accessToken
              },
              body: {
              }
            }).then((res) => {
              
              expect(res.status).to.eq(200);
              expect(res.body).not.to.empty;
              //data.mappingData.forEach((elm)=>{
              //expect(res.body[0]).to.have.property(elm)
             //})
             expect(res.body[0].jobCode).to.eq("91.141")
            })
    })

    it('05: Market Segment Save  - verify 200 response', function () {
        cy.request(
          {
            method: 'POST',
            true: true,
            url: data.ProjectAPIUrl + 'api/projects/market-segment-mapping/'+data.projectVersionId,
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