import MarketSegmentMapping from "../../../support/pageObjects/marketSegmentMapping/marketSegmentMapping.js";

let marketSegmentMapping;
const orgName = "Hospital of the University of Pennsylvania";

const visitMarketSegmentMappingTab = (orgName = "Hospital of the University of Pennsylvania", projectId = 2, projectVersion = 1) => {
  cy.visit("/projects");

  cy.wait(3000).then(() => {
    marketSegmentMapping = new MarketSegmentMapping();
    marketSegmentMapping.getMarketSegmentMappingTab().click();
  });

  cy.wait(2000).then(() => {
    marketSegmentMapping.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });

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
  visitMarketSegmentMappingTab(orgName);
});

describe("Market Segment Mapping", () => {
  it("01: check Market Segment Mapping tab exists", () => {
    marketSegmentMapping.getMarketSegmentMappingTab().should("be.visible");
    marketSegmentMapping.getMarketSegmentMappingTab().click();
  });
});

it("02: select a market segment", () => {
  marketSegmentMapping.marketSegmentCell().dblclick({ force: true });
  marketSegmentMapping.editCell().clear({ force: true }).type("market segment test", { force: true }).type("{enter}");
  marketSegmentMapping.marketSegmentCell().find("div").should("contain", "market segment test");
});

it("03: save market segment mapping ", () => {
  marketSegmentMapping.marketSegmentCell().dblclick({ force: true });
  marketSegmentMapping.editCell().clear({ force: true }).type("market segment test", { force: true }).type("{enter}");
  marketSegmentMapping.marketSegmentCell().find("div").should("contain", "market segment test");
});

it("04: export to excel", () => {
  // Click on the "msp-export" dropdown button
  cy.get("[data-cy=export]").click();

  // Wait for the file to be downloaded
  cy.wait(2000); // Adjust this time according to your file download speed

  // Assert that the file was downloaded
  cy.task("listDownloads").then(downloads => {
    const excelDownload = downloads.find(download => download.endsWith(".xlsx"));
    expect(excelDownload).to.exist;
  });
});
