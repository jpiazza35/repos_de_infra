import MarketAssessment from "../../../support/pageObjects/marketAssessment/marketAssessment";
import ProjectHeader from "../../../support/pageObjects/projectMenu/projectHeaderSearch";

let marketAssessment;
let projectHeader;
const orgName = "Hospital of the University of Pennsylvania";

// project id 3 => data to shown
const visitMarketAssessmentTab = (orgName, projectId = 3, projectVersion = 1) => {
  cy.visit("/projects");

  cy.wait(2000).then(() => {
    marketAssessment = new MarketAssessment();
    cy.get("li[data-cy=marketAssessment]").click({ force: true });
    marketAssessment.getMarketAssessmentTab().click();
  });

  cy.get("button[data-cy=clear]").click();

  cy.wait(1000).then(() => {
    projectHeader = new ProjectHeader();
    projectHeader.getOrgInputControl().click({ force: true }).clear({ force: true }).type(orgName, { force: true });

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

beforeEach(() => {
  cy.NavigateToMPTHomeAuthenticate("client");
  cy.fixture("marketAssessmentTab").then(marketAssessment => {
    visitMarketAssessmentTab(marketAssessment.topLevelFilters.orgName);
  });
});

describe("Market Assessment Tab", () => {
  marketAssessment = new MarketAssessment();
  it("01 - should display the market assessment tab", () => {
    marketAssessment.getMarketAssessmentTab().should("be.visible").and("contains.text", "Market Assessment");
  });

  it("02: click on Market Assessment tab without selecting an organization", () => {
    marketAssessment.getMarketAssessmentTab().click();
    cy.get('button[data-cy="clear"]').click({ force: true });
    projectHeader.getOrgInputControl().click({ force: true }).clear({ force: true });
    cy.get('[data-cy="filterSelectCy"]').should("have.class", "alert alert-primary").and("contain", "To visualize Market Assessment, please select");
  });

  it("03: click on Market Assessment tab without selecting a project ID", () => {
    marketAssessment.getMarketAssessmentTab().click();
    cy.get("button[data-cy=clear]").click();

    cy.wait(1000).then(() => {
      projectHeader.getOrgInputControl().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
      cy.get('[data-cy="filterSelectCy"]')
        .should("have.class", "alert alert-primary")
        .and("contain", "To visualize Market Assessment, please select");
    });
  });

  it("04: click on Market Assessment tab without selecting a project version", () => {
    marketAssessment.getMarketAssessmentTab().click();

    cy.get("button[data-cy=clear]").click();

    projectHeader.getOrgInputControl().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
    cy.wait(2000).then(() => {
      cy.get("select[data-cy=projectId]").selectNth(3);
      cy.get("select[data-cy=projectId]").trigger("change", { force: true });
    });

    cy.get('[data-cy="filterSelectCy"]').should("have.class", "alert alert-primary").and("contain", "To visualize Market Assessment, please select");
  });

  it("05: Check for visibility of Base Pay Market Comparison Graph", () => {
    visitMarketAssessmentTab(orgName);

    cy.wait(1000).then(() => {
      cy.get("div[data-cy=basePayCompetitivenessGraph]").should("be.visible");
    });
  });

  it("06: Check for visibility of Distribution of Incumbent Base Pay Competitiveness Graph", () => {
    visitMarketAssessmentTab(orgName);

    cy.wait(1000).then(() => {
      // get the second element of radio group and click on it
      cy.get("#r2").click({ force: true });
      cy.get("div[data-cy=distributionOfBasePayChart]").should("be.visible");
    });
  });
});
