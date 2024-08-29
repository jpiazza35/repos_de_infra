describe("job matching spec", () => {
  let projectVersionId = 0;
  let sourceDataAgregationKey = 0;

  before(function () {
    cy.GenerateAPIToken();

    cy.fixture("jobMatching").then(function (data) {
      projectVersionId = data.projectVersionId;
      sourceDataAgregationKey = data.sourceDataAgregationKey;
    });
  });

  it("Job Matching::Get standard jobs", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-segment-mapping/" + projectVersionId + "/jobs",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      cy.log(response.body.length);

      const clientJob = response.body.filter(item => item.sourceDataAgregationKey == sourceDataAgregationKey)[0];
      expect(clientJob.marketSegmentName).to.eq("market segment test");
      expect(clientJob.standardJobCode).to.eq("2.61");
      expect(clientJob.standardJobTitle).to.eq("Software Developer 1 - standard");
      expect(clientJob.standardJobDescription).to.eq("");
      expect(clientJob.jobMatchStatusName).to.eq("Not Started");
    });
  });

  it("Job Matching::Get audit calculations", () => {
    const token = Cypress.env("token");
    const versionId = 3;
    const clientJobCodes = ["2.52"];
    const standardJobCodes = ["3030"];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-matching/" + versionId + "/audit-calculations",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        clientJobCodes,
        standardJobCodes,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.not.be.null;

      const hourlyCalc = response.body.hourly;
      expect(hourlyCalc).to.not.be.null;
      expect(hourlyCalc.average).to.not.be.null;
      expect(hourlyCalc.compaRatio).to.not.be.null;
      expect(hourlyCalc.tenthPercentile).to.not.be.null;
      expect(hourlyCalc.fiftiethPercentile).to.not.be.null;
      expect(hourlyCalc.ninetiethPercentile).to.not.be.null;
    });
  });

  it("Job Matching::Check if multiple client jobs can be edited", () => {
    const token = Cypress.env("token");
    const aggregationMethodKey = 1;
    const organizationId = 90;
    const positionCode = "";
    const jobCodes = ["client-job-1", "client-job-2"];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-matching/" + projectVersionId + "/matching/check-edition",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        selectedJobs: [
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[0],
          },
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[1],
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.not.be.null;
      expect(response.body.valid).to.be.eq(true);
    });
  });

  it("Job Matching::Match jobs", () => {
    const token = Cypress.env("token");
    const aggregationMethodKey = 1;
    const organizationId = 90;
    const positionCode = "";
    const jobCodes = ["client-job-1", "client-job-2"];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-matching/" + projectVersionId + "/matching/client-jobs",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        selectedJobs: [
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[0],
          },
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[1],
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Job Matching::Match jobs with no benchmark error request", () => {
    const token = Cypress.env("token");
    const aggregationMethodKey = 1;
    const organizationId = 90;
    const positionCode = "";
    const jobCodes = ["client-job-1", "client-job-2"];

    cy.request({
      method: "POST",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/job-matching/" +
        projectVersionId +
        "/matching/client-jobs/no-benchmark-match",
      failOnStatusCode: false,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        selectedJobs: [
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[0],
            noBenchmarkMatch: false,
          },
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[1],
            noBenchmarkMatch: false,
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(400);
      expect(response.body).to.not.be.null;
      expect(response.body).to.not.be.null;
      expect(response.body).to.not.be.empty;
      expect(response.body).to.eq(`Selected Jobs not set as No Benchmark Match: ${jobCodes.join(", ")}`);
    });
  });

  it("Job Matching::Match jobs with no benchmark", () => {
    const token = Cypress.env("token");
    const aggregationMethodKey = 1;
    const organizationId = 90;
    const positionCode = "";
    const jobCodes = ["client-job-1", "client-job-2"];

    cy.request({
      method: "POST",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/job-matching/" +
        projectVersionId +
        "/matching/client-jobs/no-benchmark-match",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        selectedJobs: [
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[0],
            noBenchmarkMatch: true,
          },
          {
            aggregationMethodKey,
            fileOrgKey: organizationId,
            positionCode,
            jobCode: jobCodes[1],
            noBenchmarkMatch: true,
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Job Matching::Search Standards - Sort Returned Results List by Job Code", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/cuts-data/standard-jobs",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        standardJobSearch: "111",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      // Extract and sort the data based on the standard job code
      const responseBody = response.body;
      const sortedData = responseBody.sort((a, b) => a.standardJobCode.localeCompare(b.standardJobCode));
      // Perform assertions on the sorted data
      expect(sortedData).to.deep.equal(response.body);
    });
  });
});
