/// <reference types="Cypress" />
describe('Pricing Sheet: Global Settings', { testIsolation: false }, function () {
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
  
  it('01: 200 response for Global Settings update', function () {
      cy.request(
        {
            method: 'POST',
            true: true,
          url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionIdPricingSheet+'/global-settings',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            Authorization: this.authData.accessToken
          },
          body: {
            "sections": {
              "Organization Name": true,
              "Report Date": false,
              "Client Position Detail": true
            },
            "columns": {
              "Short Code": true,
              "Publisher": true,
              "Name": false,
              "Year": false
            },
            "ageToDate": "2023-08-28T03:00:00.000Z",
            "benchmarks": [
              {
                "id": 1,
                "title": "Hourly Base Pay",
                "agingFactor": null,
                "percentiles": [
                  25,
                  50,
                  75
                ]
              },
              {
                "id": 2,
                "title": "Hourly TCC",
                "agingFactor": 2.1,
                "percentiles": [
                  25,
                  50,
                  75
                ]
              }
            ]
          }
        }).then((res) => {
          expect(res.status).to.eq(200);
          })
          })
  it('01: 200 response code for Global Settings Get request', function () {
    cy.request(
      {
                method: 'Get',
                true: true,
              url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionIdPricingSheet+'/global-settings',
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                Authorization: this.authData.accessToken
              }
            
            }).then((res) => {
              expect(res.status).to.eq(200);
              })
              })
      })