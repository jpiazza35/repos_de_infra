/// <reference types="Cypress" />
describe('Pricing Sheet: Get Status Count', { testIsolation: false }, function () {
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
  
it.only('01: 200 response code when for Get Status Count', function () {
    cy.request(
      {
          method: 'POST',
          true: true,
        url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionIdPricingSheet+'/status',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Authorization: this.authData.accessToken
        },
        body:{
            "clientJobCodeTitle": "string",
            "clientJobGroupList": [
              "test"
            ],
            "marketSegmentList": [
              {
                "id": 1
              }
            ]
          }
      }).then((res) => {
        expect(res.status).to.eq(200);
        expect(res.body[0]).contains({'jobMatchStatus': 'Not Started'});
        expect(res.body[1]).contains({'jobMatchStatus': 'Analyst Reviewed'});
        expect(res.body[2]).contains({'jobMatchStatus': 'Peer Reviewed'});
        expect(res.body[3]).contains({'jobMatchStatus': 'Complete'});
        expect(res.body[4]).contains({'jobMatchStatus': 'Total'});
        

      })
})
})