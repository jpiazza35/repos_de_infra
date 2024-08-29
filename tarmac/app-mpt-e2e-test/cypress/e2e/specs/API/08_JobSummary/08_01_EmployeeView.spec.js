/// <reference types="Cypress" />
describe('Job Summary Tab: US-81262', { testIsolation: false }, function () {
    let data;
    before(function () {
      cy.generateAccessToken();
      //cy.logintoMPT();
    })
  
    beforeEach(function () {
      cy.fixture('APITestData/project_api_data').then((pData)=>{
        data=pData})
      cy.fixture('Auth/auth_data').as('authData')
    });
    after(function () {
      cy.deleteTokens()
    })
  
    it('01: 200 Get Employee Level api', function () {
        cy.request(
            {
            method: 'Get',
            true: true,
            url: Cypress.env("url") + '/api/projects/job-summary-table/'+data.EmployeeViewVersionID +'/employeeLevel',
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
    it('02: Post call: Employee level', function () {
       cy.request(
          {
             method: 'POST',
             true: true,
             url: Cypress.env("url") + 'api/projects/job-summary-table/'+data.EmployeeViewVersionID +'/employeeLevel',
             headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
              Authorization: this.authData.accessToken
                  },
                  body: data.EmployeeLevelPostData
                  
              }).then((res) => {
                  
                  expect(res.status).to.eq(200);
                  expect(res.body).to.not.be.null;
                  expect(res.body[0]).to.have.property('benchmarkJobCode')
                  expect(res.body[0]).to.have.property('benchmarkJobTitle')
              
                  })
                  })
 })