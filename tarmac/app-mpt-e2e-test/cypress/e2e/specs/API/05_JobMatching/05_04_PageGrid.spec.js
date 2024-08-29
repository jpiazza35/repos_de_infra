/// <reference types="Cypress" />
describe('Filter grid', { testIsolation: false }, function () {
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
          url: data.ProjectAPIUrl + 'api/projects/market-segment-mapping/'+data.projectVersion+'/jobs?filterInput='+data.filterInput+'&filterColumn='+data.filterColumn,
          headers: {
            'Content-Type': 'application/json',
            Authorization: this.authData.accessToken
          },
          body: {
          }
        }).then((res) => {
          //aggregationMethodKey = res.body[0].aggregationMethodKey;
          //fileOrgKey = res.body[0].fileOrgKey;
          expect(res.status).to.eq(200);
          expect(res.body).not.to.empty;
          data.mappingData.forEach((elm)=>{
            expect(res.body[0]).to.have.property(elm)
          })
        })
        //update the API response with the expected data
       
})
})