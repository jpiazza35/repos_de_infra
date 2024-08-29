/// <reference types="Cypress" />
describe('Pricing Sheet: Job Match Detail', { testIsolation: false }, function () {
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
  
    it('01: 200 response code for Job Match Detail Get', function () {
              cy.request(
              {
                  method: 'Get',
                  true: true,
                  url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionId1+'/job-match-detail/'+data.MarketPriciingSheetId1,
                  headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  Authorization: this.authData.accessToken
                  }
              }).then((res) => {
                  
                  expect(res.status).to.eq(200);
                  //responseData.forEach((item)=>{
                  data.jobMatchDtl.forEach((val)=>{
                    expect(res.body).to.have.property(val)
                  })
              
                  })
                  })
    it('01: 200 response code for Job Match Update', function () {
                cy.request(
                {
                    method: 'PUT',
                    true: true,
                    url: data.ProjectAPIUrl + 'api/projects/market-pricing-sheet/'+data.projectVersionId1+'/job-match-detail/'+data.MarketPriciingSheetId1,
                    headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    Authorization: this.authData.accessToken
                    },
                    body: {
                      "value": "This is atest"
                    }
                }).then((res) => {
                    
                    expect(res.status).to.eq(200);
                
                    })
                    })
  
  })