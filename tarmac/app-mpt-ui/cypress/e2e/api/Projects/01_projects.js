let orgID = 0;
let projID = 0;
let projVersion = 0;
let projectData = null;
let workforceProjectType = -1;
let orgSearchStart = null;

describe("project spec", () => {
  before(function () {
    cy.GenerateAPIToken();

    cy.fixture("project").then(function (projectDatas) {
      projectData = projectDatas;
      orgSearchStart = projectData.orgName;
      orgID = projectData.orgID;
    });
  });

  it("Project::Get Orgs for Auto Complete", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      form: true,
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "user/organizations?term=" + orgSearchStart,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body[0].name).to.eq(projectData.orgName);
    });
  });

  it("Project::Get Source groups", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      form: true,
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/source-groups",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.be.greaterThan(4);

      for (let i = 0; i < response.body.length; i++) {
        if (response.body[i].name == "Employee") {
          workforceProjectType = response.body[i].id;
        }
      }

      expect(workforceProjectType).to.be.greaterThan(0);
    });
  });

  it("Project::Get Benchmark Data Types", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      form: true,
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/details/" + workforceProjectType + "/benchmark-data-types",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.be.greaterThan(1);
    });
  });

  it("Project::Add new project", () => {
    const token = Cypress.env("token");
    const date = new Date("2021-03-25");
    const benchmarkDataTypes = [
      {
        id: 82,
        name: "Actual Annual Incentive",
        agingFactor: 0,
        defaultDataType: null,
        orderDataType: 70,
        benchmarkDataTypeKey: 82,
        overrideAgingFactor: 0.5,
        overrideNote: "test add",
        checked: true,
        valid: true,
      },
      {
        id: 79,
        name: "Annualized Pay Range Minimum",
        agingFactor: 2,
        defaultDataType: true,
        orderDataType: 67,
        benchmarkDataTypeKey: 79,
        overrideAgingFactor: null,
        overrideNote: "",
        checked: true,
        valid: true,
      },
      {
        id: 44,
        name: "Pay Range Maximum",
        agingFactor: 1.2345,
        defaultDataType: true,
        orderDataType: 44,
        benchmarkDataTypeKey: 44,
        overrideAgingFactor: null,
        overrideNote: "",
        checked: true,
        valid: true,
      },
      {
        id: 84,
        name: "Target Annual Incentive",
        agingFactor: 0,
        defaultDataType: true,
        orderDataType: 72,
        benchmarkDataTypeKey: 84,
        overrideAgingFactor: null,
        overrideNote: "",
        checked: true,
        valid: true,
      },
    ];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/details",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        organizationID: orgID,
        versionDate: date,
        projectStatus: "1",
        name: projectData.Project.projectName,
        versionLabel: "1",
        workforceProjectType: workforceProjectType,
        version: "1",
        aggregationMethodologyKey: 1,
        sourceDataInfo: {
          sourceDataType: 0,
          sourceData: "",
          effectiveDate: null,
          fileLogKey: 0,
        },
        benchmarkDataTypes: benchmarkDataTypes,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body.organizationName).to.be.eq(projectData.orgName + "-" + projectData.orgID);

      projID = response.body.id;
      projVersion = response.body.version;
    });
  });

  it("Project::GET Project and Version Lookup (used on dropdown), make sure newly added project is here", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project?orgId=" + orgID,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);

      let recordFound = false;
      for (let i = 0; i < response.body.length; i++) {
        if (response.body[i].name == projectData.Project.projectName) {
          recordFound = true;
        }
      }

      expect(recordFound).to.be.eq(true);
    });
  });

  it("Project::Edit project", () => {
    const token = Cypress.env("token");
    const sourceDataInfo = {
      sourceDataType: 0,
      sourceData: "",
      effectiveDate: null,
      fileLogKey: 0,
    };
    const benchmarkDataTypes = [
      {
        id: 82,
        name: "Actual Annual Incentive",
        agingFactor: 0,
        defaultDataType: null,
        orderDataType: 70,
        benchmarkDataTypeKey: 82,
        overrideAgingFactor: "0.2",
        overrideNote: "modified",
        checked: true,
        valid: true,
      },
    ];

    cy.request({
      method: "PUT",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/details?projectId=" + projID + "&projectVersionId=" + projVersion,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        organizationID: orgID,
        versionDate: new Date("03/02/2023"),
        projectStatus: "1",
        name: projectData.Project.projectName,
        versionLabel: "1",
        workforceProjectType: workforceProjectType,
        version: projVersion,
        aggregationMethodologyKey: 1,
        sourceDataInfo: sourceDataInfo,
        benchmarkDataTypes: benchmarkDataTypes,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body.organizationName).to.be.eq(projectData.orgName + "-" + projectData.orgID);

      projID = response.body.id;
      projVersion = response.body.version;
    });
  });

  it("Project::Edit project with file", () => {
    const token = Cypress.env("token");
    const sourceDataInfo = {
      sourceDataType: 2,
      sourceData: "Job",
      effectiveDate: new Date("2021-03-25"),
      fileLogKey: 1,
    };
    const benchmarkDataTypes = [
      {
        id: 82,
        name: "Actual Annual Incentive",
        agingFactor: 0,
        defaultDataType: null,
        orderDataType: 70,
        benchmarkDataTypeKey: 82,
        overrideAgingFactor: "0.2",
        overrideNote: "modified",
        checked: true,
        valid: true,
      },
    ];

    cy.request({
      method: "PUT",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/details?projectId=" + projID + "&projectVersionId=" + projVersion,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        organizationID: orgID,
        versionDate: new Date("03/02/2023"),
        projectStatus: "1",
        name: projectData.Project.projectName,
        versionLabel: "1",
        workforceProjectType: workforceProjectType,
        version: projVersion,
        aggregationMethodologyKey: 1,
        sourceDataInfo: sourceDataInfo,
        benchmarkDataTypes: benchmarkDataTypes,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body.organizationName).to.be.eq(projectData.orgName + "-" + projectData.orgID);

      projID = response.body.id;
      projVersion = response.body.version;

      cy.request({
        method: "GET",
        url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-segment-mapping/" + projVersion + "/jobs",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      }).then(function (response) {
        expect(response.status).to.eq(200);
        expect(response.body.length).to.be.greaterThan(0);
        // Checking all the market pricing sheet rows has the status 'Not Started' after the file is attached.
        response.body.forEach(element => {
          expect(element.jobMatchStatusName).to.eq("Not Started");
        });
      });
    });
  });

  it("Project::Search project", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/search",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        take: 15,
        skip: 0,
        page: 1,
        pageSize: 15,
        sort: [{ field: "projectVersion", dir: "desc" }],
        orgId: orgID,
        projectId: projID,
        projectVersionId: projVersion,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      cy.log(response.body);
      expect(response.body.total).to.be.eq(1);
    });
  });

  it("Project::Delete project", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/" + projID + "/delete",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: { projectId: projID, projectVersionId: projVersion, notes: "test" },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.eq("Project Version " + projID + " has been deleted.");
    });
  });
});
