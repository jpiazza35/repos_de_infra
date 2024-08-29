/// <reference types="Cypress" />
describe('Project API - Project Endpoints', { testIsolation: false }, function () {
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
        url: this.projectData.ProjectAPIUrl + '/api/projects',
        headers: {
          'Content-Type': 'application/json',
          Authorization: this.authData.accessToken
        },
        body: {
          'orgId': this.projectData.OrgId
        }
      }).then((res) => {
        expect(res.status).to.eq(200);
      })
  });

  it('01: ProjectAPI - Project - GET /api/projects - verify 401 response', function () {
    cy.request(
      {
        method: 'GET',
        form: true,
        url: this.projectData.ProjectAPIUrl + '/api/projects',
        failOnStatusCode: false,
        headers: {
          'Content-Type': 'application/json',
          Authorization: this.authData.accessToken+"test"
        },
        body: {
          'orgId': this.projectData.OrgId
        }
      }).then((res) => {
        expect(res.status).to.eq(401);
      })
  });

  it('01: ProjectAPI - Project - GET /api/projects - verify 400 response', function () {
    cy.request(
      {
        method: 'GET',
        form: true,
        url: this.projectData.ProjectAPIUrl + '/api/projects',
        failOnStatusCode: false,
        headers: {
          'Content-Type': 'application/json',
          Authorization: this.authData.accessToken
        },
        body: {
          'orgId': "-1"
        }
      }).then((res) => {
        expect(res.status).to.eq(400);
      })
  });

})