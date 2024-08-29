import MarketSummary from "../../../support/pageObjects/marketSummary/marketSummary";

let marketSummary;
const orgName = "Hospital of the University of Pennsylvania";

const mockedBenchmarks = [
  {
    shortAlias: "Base",
    longAlias: "Hourly Base Pay",
    orderDataType: 1,
    title: "Base Pay Hourly Rate",
    id: 29,
    percentiles: [25, 50, 75, 90],
    selectedPercentiles: [25, 50, 75, 90],
    checked: true,
    comparisons: [{ id: 29, title: "Base Pay Hourly Rate", selectedPercentiles: [50] }],
  },
  {
    shortAlias: "Max",
    longAlias: "Hourly Pay Range Maximum",
    orderDataType: 5,
    title: "Pay Range Maximum",
    id: 44,
    percentiles: [50],
    selectedPercentiles: [50],
    checked: true,
    comparisons: [{ id: 44, title: "Pay Range Maximum", selectedPercentiles: [50] }],
  },
  {
    shortAlias: "Min",
    longAlias: "Annual Pay Range Minimum",
    orderDataType: 6,
    title: "Annualized Pay Range Minimum",
    id: 79,
    percentiles: [50],
    selectedPercentiles: [50],
    checked: true,
    comparisons: [{ id: 79, title: "Annualized Pay Range Minimum", selectedPercentiles: [50] }],
  },
  {
    shortAlias: "Target IP ($)",
    longAlias: "Annual Incentive Pay Target ($)",
    orderDataType: 11,
    title: "Target Annual Incentive",
    id: 84,
    percentiles: [25, 50, 75, 90],
    selectedPercentiles: [25, 50, 75, 90],
    checked: true,
    comparisons: [{ id: 84, title: "Target Annual Incentive", selectedPercentiles: [50] }],
  },
];

const dataScopes = [
  { title: "BLEND TEST", checked: true },
  { title: "cut test", checked: true },
  { title: "ERI TEST (3%)", checked: true },
  { title: "one", checked: true },
  { title: "ott", checked: true },
  { title: "three", checked: true },
  { title: "two", checked: true },
];
const visitMarketSummaryTab = (orgName = "Hospital of the University of Pennsylvania", projectId = 3, projectVersion = 1) => {
  cy.visit("/projects");

  cy.wait(3000).then(() => {
    marketSummary = new MarketSummary();
    marketSummary.getMarketSummaryTab().click();
  });

  cy.wait(2000).then(() => {
    marketSummary.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });

    cy.wait(2000).then(() => {
      cy.get("select[data-cy=projectId]").selectNth(projectId);
      cy.get("select[data-cy=projectId]").trigger("change", {
        force: true,
      });
      cy.get("select[data-cy=projectVersion]").selectNth(projectVersion);
      cy.get("select[data-cy=projectVersion]").trigger("change", {
        force: true,
      });
    });
  });
};

before(() => {
  cy.NavigateToMPTHomeAuthenticate("client");
  cy.fixture("marketSummaryTab").then(marketSummary => {
    visitMarketSummaryTab(marketSummary.topLevelFilters.orgName);
  });
});

describe("Market Summary Tables", () => {
  it("01: check Market Summary Table tab exists", () => {
    cy.get("li[data-cy=marketSummary]").should("be.visible");
    cy.get("li[data-cy=marketSummary]").click();
  });

  it("02: click on Market Summary Tables tab without selecting an organization", () => {
    marketSummary.getMarketSummaryTab().click();
    cy.get('button[data-cy="clear"]').click({ force: true });
    marketSummary.getOrganizationInput().click({ force: true }).clear({ force: true });
    cy.get('[data-cy="filterSelectCy"]')
      .should("have.class", "alert alert-primary")
      .and("contain", "To visualize Market Summary Tables, please select");
  });

  it("03: click on Market Summary Tables tab without selecting a project ID", () => {
    marketSummary.getMarketSummaryTab().click();

    cy.wait(500).then(() => {
      marketSummary.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
      cy.get('[data-cy="filterSelectCy"]')
        .should("have.class", "alert alert-primary")
        .and("contain", "To visualize Market Summary Tables, please select");
    });
  });

  it("04: click on Market Summary Tables tab without selecting a project version", () => {
    marketSummary.getMarketSummaryTab().click();
    cy.wait(2000).then(() => {
      cy.get("select[data-cy=projectId]").selectNth(3);
      cy.get("select[data-cy=projectId]").trigger("change", { force: true });
    });

    marketSummary.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
    cy.get('[data-cy="filterSelectCy"]')
      .should("have.class", "alert alert-primary")
      .and("contain", "To visualize Market Summary Tables, please select");
  });

  it("05: Check DataScope report summary filter", () => {
    visitMarketSummaryTab();

    cy.wait(2000).then(() => {
      marketSummary.getDataScopeFormGroup().should("be.visible");
    });
  });

  it("06: Get report summary filter btns", () => {
    visitMarketSummaryTab();

    marketSummary.getApplyFilterBtn().should("be.visible").and("contains.text", "Apply");
    marketSummary.getResetFilterBtn().should("be.visible").and("contains.text", "Reset");
  });

  it("07: Change Report summary data scope Unchecking + no filter", () => {
    visitMarketSummaryTab();
    cy.wait(1000).then(() => {
      dataScopes.forEach((ds, index) => {
        marketSummary.getSwitchInput(ds.title).should("be.visible");
        marketSummary.getSwitchInput(ds.title).uncheck();
        if (index === dataScopes.length - 1) {
          marketSummary.getSwitchInput(ds.title).check();
          marketSummary.getSwitchInput(ds.title).should("be.checked");
          marketSummary.getFilterWarningSpan("datascopes").should("be.visible").and("contain", "You must have at least one Data Scope checked.");
        } else {
          marketSummary.getSwitchInput(ds.title).should("not.be.checked");
        }
      });
    });
  });

  it("08: Change Report summary Benchmarks Unchecking + Warning", () => {
    visitMarketSummaryTab();
    marketSummary.getFilterAccordion("Benchmark").should("be.visible");
    marketSummary.getFilterAccordion("Benchmark").click({ force: true });

    cy.wait(1000).then(() => {
      mockedBenchmarks.forEach((benchmark, index) => {
        marketSummary.getBenchmarkSwitchInput(benchmark.id).should("be.visible");
        marketSummary.getBenchmarkSwitchInput(benchmark.id).uncheck();
        if (index === mockedBenchmarks.length - 1) {
          marketSummary.getBenchmarkSwitchInput(benchmark.id).check();
          cy.wait(1000).then(() => {
            marketSummary.getBenchmarkSwitchInput(benchmark.id).should("be.checked");
            marketSummary.getFilterWarningSpan("benchmarks").should("be.visible").and("contain", "You must have at least one Benchmark checked.");
          });
        } else {
          marketSummary.getBenchmarkSwitchInput(benchmark.id).should("not.be.checked");
        }
      });
    });
  });

  it("09: Datascope filter by eri", () => {
    visitMarketSummaryTab();
    cy.wait(1000).then(() => {
      const eriDatascope = dataScopes[2];
      marketSummary.getSwitchInput(eriDatascope.title).should("be.visible");
      marketSummary.getSwitchInput(eriDatascope.title).uncheck();
      marketSummary.getApplyFilterBtn().click();
      marketSummary.getSummaryGrid().as("marketSummaryGrid");
      cy.wait(3000).then(() => {
        cy.get("@marketSummaryGrid").find("table tbody").children("tr").should("have.length", 6);
        marketSummary.getSwitchInput(eriDatascope.title).should("be.visible");
        marketSummary.getSwitchInput(eriDatascope.title).should("not.be.checked");
      });
      marketSummary.getSwitchInput(eriDatascope.title).check();
      marketSummary.getApplyFilterBtn().click();
      cy.wait(3000).then(() => {
        cy.get("@marketSummaryGrid").find("table tbody").children("tr").should("have.length", 7);
      });
    });
  });
});
