import JobMatching from "../../../support/pageObjects/jobMatching/jobMatching";
import ProjectHeader from "../../../support/pageObjects/marketPricingSheet/pricingHeaderSearch";
import MarketSummary from "../../../support/pageObjects/marketSummary/marketSummary";

let orgSearchStart;

describe("Job Matching", () => {
  before(function () {
    cy.NavigateToMPTHomeAuthenticate("client");
    cy.fixture("jobMatching").then(function (marketSegment) {
      orgSearchStart = marketSegment.topLevelFilters.orgName;
      const jobMatching = new JobMatching();

      cy.visit("/projects");

      cy.wait(1000).then(() => {
        jobMatching.getJobMatchingTab().click();
      });

      cy.wait(1000).then(() => {
        jobMatching.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgSearchStart, { force: true });

        cy.wait(2000).then(() => {
          cy.get("select[data-cy=projectId]").selectNth(3);
          cy.get("select[data-cy=projectId]").trigger("change", {
            force: true,
          });
          cy.get("select[data-cy=projectVersion]").selectNth(1);
          cy.get("select[data-cy=projectVersion]").trigger("change", {
            force: true,
          });
        });
      });
    });
  });

  after(function () {
    cy.logoutClientPortal();
  });

  it("01: check Set to No Benchmark Button is visible", () => {
    const jobMatching = new JobMatching();
    jobMatching.getSetToNoBenchmarkButton().should("be.visible");
  });

  it("02: set selected job to No Benchmark", () => {
    const jobMatching = new JobMatching();
    cy.get("div.k-grid-content-locked").find("table").find("tr").eq(0).find("td").eq(0).find(".k-select-checkbox").click();
    jobMatching.getSetToNoBenchmarkButton().click();
    cy.wait(1000);
  });

  it("03: verify columns in grid", () => {
    cy.get("div.k-grid-content").find("tr").eq(0).find("td").eq(4).should("have.text", "No Benchmark Match");
    cy.get("div.k-grid-content").find("tr").eq(0).find("td").eq(5).should("have.text", "No Benchmark Match");
  });

  it("04: verify changes in Market Pricing Sheet", () => {
    const projectHeader = new ProjectHeader();
    projectHeader.getPricingTab().click();
    cy.wait(1000);
    cy.get("[data-cy=div-jobmatchdetail]").find("[title='Survey Job Match Title']").siblings().should("have.text", "No Benchmark Match");
    cy.get("div.nodata").should("have.text", "No market data for the standard job matched");
  });

  it("05: verify changes in Market Summary", () => {
    const marketSummary = new MarketSummary();
    marketSummary.getMarketSummaryTab().click();
    cy.wait(1000);
    cy.get("tbody.k-table-tbody").find("tr").eq(0).find("td").eq(7).should("have.text", "No Benchmark Match");
    cy.get("tbody.k-table-tbody").find("tr").eq(0).find("td").eq(8).should("have.text", "No Benchmark Match");
  });
});
