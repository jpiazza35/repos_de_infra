describe("job summary spec", () => {
  let projectVersionId = 0;

  before(function () {
    cy.GenerateAPIToken();

    cy.fixture("marketSummary").then(function (data) {
      projectVersionId = data.projectVersionId;
    });
  });

  it("Job Summary::Get summary table", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-summary-table/" + projectVersionId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.be.greaterThan(0);

      response.body.forEach(element => {
        expect(element.benchmarks).to.not.be.null;
        expect(element.benchmarks).to.be.a("array");
        expect(element.dataScope).to.not.be.empty;
        expect(element.benchmarks).to.not.be.empty;
        expect(element.benchmarks.length).to.be.greaterThan(0);

        element.benchmarks.forEach(benchmark => {
          expect(benchmark).to.not.be.null;
          expect(benchmark.id).to.not.be.null;
          expect(benchmark.title).to.not.be.empty;
          expect(benchmark.comparisons).to.not.be.null;
          expect(benchmark.comparisons.length).to.eq(1);
          expect(benchmark.percentiles).to.not.be.null;
          expect(benchmark.percentiles.length).to.be.greaterThan(0);
        });
      });
    });
  });

  it("Job Summary::Get summary table with Benchmark Comparisons", () => {
    const token = Cypress.env("token");
    const benchmarkIdToBeCompared = 44;
    const benchmarkIdComparison = 29;

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-summary-table/" + projectVersionId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        benchmarks: [
          {
            id: benchmarkIdToBeCompared,
            comparisons: [
              {
                id: benchmarkIdComparison,
                title: "Base Pay Hourly Rate",
              },
            ],
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.be.greaterThan(0);

      response.body.forEach(element => {
        expect(element.benchmarks).to.not.be.null;
        expect(element.benchmarks).to.be.a("array");
        expect(element.benchmarks.length).to.be.greaterThan(0);

        element.benchmarks.forEach(benchmark => {
          expect(benchmark).to.not.be.null;
          expect(benchmark.id).to.not.be.null;

          if (benchmark.id == benchmarkIdToBeCompared) {
            expect(benchmark.comparisons).to.not.be.null;
            expect(benchmark.comparisons).to.not.be.empty;
            expect(benchmark.comparisons.length).to.eq(2);

            let benchmarkComparisonsIds = benchmark.comparisons.map(x => x.id);
            expect(benchmarkComparisonsIds).to.include(benchmarkIdToBeCompared);
            expect(benchmarkComparisonsIds).to.include(benchmarkIdComparison);
          }
        });
      });
    });
  });

  it("Job Summary::Get summary table with Benchmark Comparisons and Filter", () => {
    const token = Cypress.env("token");
    const benchmarkIdToBeCompared = 44;
    const benchmarkIdComparison = 29;

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/job-summary-table/" + projectVersionId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        benchmarks: [
          {
            id: benchmarkIdToBeCompared,
            comparisons: [
              {
                id: benchmarkIdComparison,
                title: "Base Pay Hourly Rate",
              },
            ],
          },
        ],
        filter: {
          marketSegmentList: [
            {
              id: 2,
            },
          ],
          clientJobGroupList: ["Group"],
        },
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.be.greaterThan(0);

      response.body.forEach(element => {
        expect(element.benchmarks).to.not.be.null;
        expect(element.benchmarks).to.be.a("array");
        expect(element.benchmarks.length).to.be.greaterThan(0);

        element.benchmarks.forEach(benchmark => {
          expect(benchmark).to.not.be.null;
          expect(benchmark.id).to.not.be.null;

          if (benchmark.id == benchmarkIdToBeCompared) {
            expect(benchmark.comparisons).to.not.be.null;
            expect(benchmark.comparisons).to.not.be.empty;
            expect(benchmark.comparisons.length).to.eq(2);

            let benchmarkComparisonsIds = benchmark.comparisons.map(x => x.id);
            expect(benchmarkComparisonsIds).to.include(benchmarkIdToBeCompared);
            expect(benchmarkComparisonsIds).to.include(benchmarkIdComparison);
          }
        });
      });
    });
  });
});
