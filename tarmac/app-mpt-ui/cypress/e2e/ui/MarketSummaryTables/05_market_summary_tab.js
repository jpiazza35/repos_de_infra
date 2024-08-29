import MarketSummary from "../../../support/pageObjects/marketSummary/marketSummary";
import PricingTab from "../../../support/pageObjects/marketPricingSheet/pricingHeaderSearch";
import { escapeString, unescapeString } from "../../../../src/utils/functions";

const getFormatedDateString = () => {
  const d = new Date();
  return `${String(d.getMonth() + 1).padStart(2, "0")}/${String(d.getDate()).padStart(2, "0")}/${d.getFullYear()}`;
};
let marketSummary;
const orgName = "Hospital of the University of Pennsylvania";
const today = getFormatedDateString();

const setTopLevelFilters = (orgName, projectId = 3, projectVersion = 1) => {
  cy.visit("/#");
  cy.get("button[data-cy=clear]").click();
  cy.wait(1000).then(() => {
    const marketSummary = new MarketSummary();
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
  navigateToSummaryTab();
};

const navigateToSummaryTab = () => {
  cy.wait(2000).then(() => {
    const marketSummary = new MarketSummary();
    cy.get("li[data-cy=marketSummary]").click({ force: true });
    marketSummary.getMarketSummaryTab().click();
  });
};

const changeProject = (projectId, projectVersion = 1) => {
  cy.get("select[data-cy=projectId]").selectNth(projectId);
  cy.get("select[data-cy=projectId]").trigger("change", {
    force: true,
  });
  cy.get("select[data-cy=projectVersion]").selectNth(projectVersion);
  cy.get("select[data-cy=projectVersion]").trigger("change", {
    force: true,
  });
};

beforeEach(() => {
  cy.fixture("marketSummaryTab").then(marketSegment => {
    marketSummary = new MarketSummary();
    setTopLevelFilters(marketSegment.topLevelFilters.orgName);
  });
});

const verifyTabHeader = (type = "Job") => {
  marketSummary.getOrganizationName().should("be.visible").and("contain.text", orgName);
  marketSummary.getReportDateLabel().should("be.visible").and("contain.text", "Report Date:");
  marketSummary.getOrganizationHeaderView().should("be.visible").and("contain.text", `${type} Summary`);
};

describe("Market Summary Tab", () => {
  it("01 - should display the market summary tab", () => {
    marketSummary.getMarketSummaryTab().should("be.visible").and("contains.text", "Market Summary Tables");
  });

  it("02 - should toggle fullscreen mode on clicking the fullscreen button", () => {
    marketSummary.toggleFullScreen();
    marketSummary.getFullScreenButton().should("contain.text", "Exit Full Screen");
    marketSummary.toggleFullScreen();
    marketSummary.getFullScreenButton().should("contain.text", "Full Screen");
  });

  it("03 - should export the market summary grid", () => {
    marketSummary.exportGrid();
  });

  it("04 - should hide/show the side menu", () => {
    marketSummary.hideSideMenu();
    marketSummary.getSideFilterPanel().should("not.be.visible");
    marketSummary.showSideMenu();
    marketSummary.getSideFilterPanel().should("be.visible");
  });

  it("05 - Should have set the Tab Header defined with organization name and report date and job view title", () => {
    verifyTabHeader();
    marketSummary.getOrganizationHeader().within(() => {
      marketSummary.getReportDateLabel().should("contain.text", "Report Date:");
    });
  });

  it("06 - Change Summary view should change header title", () => {
    verifyTabHeader();
    marketSummary.getSummaryViewBtn().should("be.visible").and("contain.text", "Summary View");
    marketSummary.getSummaryViewBtn().click({ force: true });
    marketSummary.getOrganizationHeaderView().should("be.visible").and("contain.text", "Job Summary");
    cy.contains("li.dropdown-item", "Incumbent View").click();
    marketSummary.getOrganizationHeaderView().should("be.visible").and("contain.text", "Incumbent Summary");
  });

  it("07 - Change Summary view Should call Incumbent data", () => {
    cy.intercept("GET", "/api/mpt-project/job-summary-table/3/employeeLevel").as("getEmployeeLevel");
    marketSummary.getSummaryViewBtn().click({ force: true });
    cy.contains("li.dropdown-item", "Job View").click();

    marketSummary.getOrganizationHeaderView().should("be.visible").and("contain.text", "Job Summary");

    marketSummary.getSummaryViewBtn().click({ force: true });
    cy.contains("li.dropdown-item", "Incumbent View").click({ force: true });

    cy.wait(2000).then(() => {
      marketSummary.getOrganizationHeaderView().should("be.visible").and("contain.text", "Incumbent Summary");
      cy.wait("@getEmployeeLevel").then(interception => {
        expect(interception.response.statusCode).to.equal(200);
        expect(interception.response.body.length).to.be.at.least(1);
      });
    });
  });

  it("08 - Should have set the Tab Header defined with organization name and report date", () => {
    verifyTabHeader("Incumbent");
    marketSummary.getReportDateValue().should("be.visible").and("have.text", today);
  });

  it("09 - Change Org to a no benchmark/Data scope filter available to check messages", () => {
    const projectId = 1;
    setTopLevelFilters(orgName, projectId);
    changeProject(projectId);

    cy.wait(1000).then(() => {
      marketSummary.getFilterAccordion("Data Scope").should("be.visible");
      marketSummary.getFilterAccordion("Benchmark").should("be.visible");
      marketSummary
        .getNoFilterAvailableShown("noDataScopFilterAlert")
        .should("be.visible")
        .and("contains.text", "There are no report filters associated with this project version.");

      marketSummary.getFilterAccordion("Benchmark").click({ force: true });
      marketSummary
        .getNoFilterAvailableShown("noBenchmarksFilterAlert")
        .should("be.visible")
        .and("contains.text", "There are no benchmarks associated to this project version.");
      marketSummary.getSummaryGrid().should("be.visible");
      marketSummary.getApplyFilterBtn().should("be.visible");
      marketSummary.getApplyFilterBtn().click({ force: true });
    });

    cy.wait(1000).then(() => {
      marketSummary.getSummaryGrid().should("be.visible").get("div").filter(".k-grid-norecords").and("contains.text", "No records available.");
    });
  });

  it("10 - Check Empty Apply filter - No Data to show on grid", () => {
    setTopLevelFilters(orgName, 1, 1);
    marketSummary
      .getNoFilterAvailableShown("noBenchmarksFilterAlert")
      .should("be.visible")
      .and("contains.text", "There are no benchmarks associated to this project version.");
    marketSummary.getSummaryGrid().should("be.visible");
    marketSummary.getApplyFilterBtn().should("be.visible");
    marketSummary.getApplyFilterBtn().click({ force: true });
    cy.wait(1000).then(() => {
      marketSummary.getSummaryGrid().should("be.visible").get("div").filter(".k-grid-norecords").and("contains.text", "No records available.");
    });
  });

  it("11 - Get report summary filter btns", () => {
    marketSummary.getApplyFilterBtn().should("be.visible").and("contains.text", "Apply");
    marketSummary.getResetFilterBtn().should("be.visible").and("contains.text", "Reset");
  });

  it("12 - Get Benchmark percentile value", () => {
    marketSummary
      .getBenchmarkPercentile()
      .should("be.visible")
      .invoke("text")
      .invoke("replace", /\s+/g, " ")
      .invoke("trim")
      .should("match", /^Market\s+25th$/);

    marketSummary
      .getBenchmarkPercentile()
      .get(".k-table-td")
      .each($element => {
        cy.wrap($element).invoke("text").should("not.be", "undefined");
      });
  });

  const invalidString = ">>>>>>>>";
  it("13 - Change market pricing note should reflect on summary note - Escape unscape", () => {
    const pricingSheet = new PricingTab();
    pricingSheet.getPricingTab().click();
    pricingSheet.getPricingTab().should("be.visible");

    cy.wait(1000);
    cy.get("#marketpricingsheetTab").should("be.visible");

    pricingSheet.getNotesSection().as("NotesArea");
    cy.get("@NotesArea").scrollIntoView().should("be.visible");
    pricingSheet.getNotesTextArea().as("TextArea");
    cy.get("@TextArea").clear({ force: true });
    cy.get("@TextArea").type(invalidString);
    cy.wait(1000);

    navigateToSummaryTab(orgName);

    cy.wait(1500);
    cy.contains("td.k-table-td", unescapeString(">>>>>>")).as("JobMatchColumn");
    cy.get("[data-cy=jobMatchAdjustmentNotesCy]").as("JobMatchColumn2");
    cy.get("@JobMatchColumn").should("exist");
    cy.get("@JobMatchColumn").should("be.visible");
    cy.get("@JobMatchColumn").should("be.visible").invoke("text").should("include", invalidString);
    cy.get("@JobMatchColumn").should("be.visible").invoke("text").should("not.be.equal", escapeString(invalidString));
    cy.get("@JobMatchColumn").should("be.visible").invoke("text").should("be.equal", unescapeString(invalidString));
  });
});
