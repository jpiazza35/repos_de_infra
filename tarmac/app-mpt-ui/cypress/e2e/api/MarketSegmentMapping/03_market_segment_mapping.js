describe("market segment mapping spec", () => {
  let projectVersionId = 0;
  let sourceDataAgregationKey = 0;
  let marketSegmentId = 0;

  before(function () {
    cy.GenerateAPIToken();

    cy.fixture("marketSegmentMapping").then(function (data) {
      projectVersionId = data.projectVersionId;
      sourceDataAgregationKey = data.sourceDataAgregationKey;
      marketSegmentId = data.marketSegmentId;
    });
  });

  it("Market Segment Mapping::Get client jobs", () => {
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

      expect(clientJob.aggregationMethodKey).to.eq(1);
      expect(clientJob.organizationName).to.eq("Hospital of the University of Pennsylvania");
      expect(clientJob.jobCode).to.eq("2.52");
      expect(clientJob.jobTitle).to.eq("Software Developer 2");
      expect(clientJob.benchmarkDataTypes["Annual Pay Range Minimum"]).to.eq(1.45);
      expect(clientJob.benchmarkDataTypes["Hourly Base Pay"]).to.eq(3.8);
      expect(clientJob.formattedBenchmarkDataTypes["Annual Pay Range Minimum"]).to.eq("$1");
      expect(clientJob.formattedBenchmarkDataTypes["Hourly Base Pay"]).to.eq("$3.80");
    });
  });

  it("Market Segment Mapping::Get filtered client jobs", () => {
    const token = Cypress.env("token");
    const filterInput = "Hospital";
    const filterColumn = "organizationName";

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-segment-mapping/" +
        projectVersionId +
        "/jobs?filterInput=" +
        filterInput +
        "&filterColumn=" +
        filterColumn,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.not.eq(0);

      response.body.forEach(job => {
        expect(job.organizationName).to.contains(filterInput);
      });
    });
  });

  it("Market Segment Mapping::Get market segments", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-segment-mapping/" + projectVersionId + "/market-segments",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      const marketSegment = response.body.filter(item => item.id == marketSegmentId)[0];
      expect(marketSegment.name).to.eq("market segment test");
    });
  });
});
