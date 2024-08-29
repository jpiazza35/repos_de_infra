/// <reference types="Cypress" />
describe('Pricing Sheet: Repopulate pricing sheet after glue job run 80191', { testIsolation: false }, function () {
    let data;
    before(function () {
      cy.generateAccessToken();
    })
  
    beforeEach(function () {
      cy.fixture('APITestData/project_api_data').then((pData)=>{
        data=pData})
      cy.fixture('Auth/auth_data').as('authData')
    });
    after(function () {
      cy.deleteTokens()
    })
  
    it('01: 200 response code to repopulate pricing sheet', function () {
        cy.request(
            {
            method: 'Post',
            true: true,
            url: data.ProjectAPIUrl + 'api/projects/details/file/'+data.fileLogKey,
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            Authorization: this.authData.accessToken
            },
        }).then((res) => {
            expect(res.status).to.eq(200);
            expect(res.body).to.not.be.null;
            })
            })
  
  })