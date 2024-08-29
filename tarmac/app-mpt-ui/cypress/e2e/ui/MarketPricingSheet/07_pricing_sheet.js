// @ts-ignore
/* eslint-disable-next-line no-unsafe-optional-chaining */
import PricingTab from "../../../support/pageObjects/marketPricingSheet/pricingHeaderSearch";

let projectData = null;
let orgNameID = "";

// TODO Mostly of the test just check labels and fields that are set by default on the tab.
// Create tests that change filter and watch for the changes on the tab.

describe("market pricing sheet spec", () => {
  const pricingTab = new PricingTab();
  const orgName = "Hospital of the University of Pennsylvania",
    projectId = 3,
    projectVersion = 1;

  before(function () {
    cy.NavigateToMPTHomeAuthenticate("client");

    cy.fixture("marketPricing").then(function (projectDatas) {
      projectData = projectDatas;
      orgNameID = projectData.orgName + " - " + projectData.orgID;
    });
  });
  it("1 - Check if market pricing sheet tab is visible on Tab list", () => {
    pricingTab.getPricingTab().should("be.visible");
  });

  it("2 - Enter Market Pricing sheet tab and see if it is visible", () => {
    cy.SelectOrganization(pricingTab, orgName, projectId, projectVersion);
    pricingTab.getPricingTab().click();

    cy.wait(1000);
    pricingTab.getPricingTab().should("be.visible");

    cy.wait(1000);
    cy.get("#marketpricingsheetTab").should("be.visible");
  });

  it("3 - Age to date - Date Picker change should change average - check", () => {
    cy.wait(4000);
    const averageValue = "$295,311.45";
    cy.get("#mpDataDetailFooter").find("#datacell_6_4").as("averageValueToCompare");
    cy.get("@averageValueToCompare").scrollIntoView().should("have.text", averageValue);
    cy.wait(500);
    cy.get("[data-cy=ageToDateSection]").as("ageToDateSection");
    cy.get("[data-cy=ageToDatePicker]").as("ageToDatePicker");
    cy.get("@ageToDateSection").scrollIntoView().children().eq(2).children().eq(0).children().closest("button").as("datePickerButton");
    cy.wait(500);

    cy.get("@ageToDateSection").should("be.visible");
    cy.get("@ageToDatePicker").should("be.visible");
    cy.get("@datePickerButton").should("be.visible");

    cy.get("@datePickerButton").click({ force: true });
    cy.get("#iAgeToDate_dateview").as("dateCalendar");

    cy.get("@dateCalendar").should("exist");
    cy.wait(2000);
    cy.get("@dateCalendar").click({ force: true });
    cy.get("@dateCalendar").find(".k-calendar-td:not(.k-selected)").first().click({ force: true });
    cy.wait(1000);
    cy.get("@averageValueToCompare").scrollIntoView().should("not.have.text", averageValue);
  });

  // // TODO: improve this test assert, it doesn't test nothing diferrent than the before.
  it("4 - Select Org, Project, and Version", () => {
    cy.wait(1000).then(() => {
      cy.AutoCompleteFirstChild(pricingTab.getOrgInputControl(), "90", orgNameID);

      cy.wait(2000).then(() => {
        cy.get(pricingTab.getProjectSelect()).as("projectSelectDropdown");

        cy.get("@projectSelectDropdown").select("3");
        cy.get("@projectSelectDropdown").invoke("val").should("eq", "3");
        cy.get("@projectSelectDropdown").trigger("change", {
          force: true,
        });
      });

      cy.wait(1000).then(() => {
        cy.get(pricingTab.getProjectVersion()).as("projectVersionSelectDropdown");
        cy.get("@projectVersionSelectDropdown").select("3");
        cy.get("@projectVersionSelectDropdown").invoke("val").should("eq", "3");
        cy.get("@projectVersionSelectDropdown").trigger("change", {
          force: true,
        });
      });

      cy.wait(100).then(() => {
        cy.get(pricingTab.getPricingTabDefaultData()).should("exist");
      });
    });
  });

  // TODO Create a test like that but that changes the filter by clicking on any job on the list.
  it("5 - Find job code and title", () => {
    cy.wait(2000).then(() => {
      cy.get("#list-jobCode a").should("have.length.greaterThan", 1);
    });
  });

  it("6 - Check Org Name", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowOrgName").uncheck();
    cy.get("div.card-body div[title='Hospital of the University of Pennsylvania-90']").parent().should("not.be.visible");

    cy.get("#chkShowOrgName").check({ waitForAnimations: false });
    cy.get("div.card-body div[title='Hospital of the University of Pennsylvania-90']").parent().should("be.visible");
  });

  it("7 - Check Report Date", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowReportDate").uncheck();
    cy.get("div.card-body div[title='Report Date']").parent().should("not.be.visible");

    cy.get("#chkShowReportDate").check({ waitForAnimations: false });
    cy.get("div.card-body div[title='Report Date']").parent().should("be.visible");
  });

  it("8 - Check Client Position Detail", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowClientPosDetail").uncheck();
    cy.get("div[data-cy='div-clientposdetail']").should("not.be.visible");

    cy.get("#chkShowClientPosDetail").check({ waitForAnimations: false });
    cy.get("div[data-cy='div-clientposdetail']").should("be.visible");
  });

  it("9 - Check Client Pay Detail", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowClientPayDetail").uncheck();
    cy.get("div[data-cy='div-clientpaydetail']").should("not.be.visible");

    cy.get("#chkShowClientPayDetail").check({ waitForAnimations: false });
    cy.get("div[data-cy='div-clientpaydetail']").should("be.visible");
  });

  it("10 - Check Job Match Detail", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowJobMatchDetail").uncheck();
    cy.get("div[data-cy='div-jobmatchdetail']").should("not.be.visible");

    cy.get("#chkShowJobMatchDetail").check({ waitForAnimations: false });
    cy.get("div[data-cy='div-jobmatchdetail']").should("be.visible");
  });

  it("11 - Check Market Segment Name", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("#chkShowMarketSegmentName").uncheck();
    cy.get("div[data-cy='div-marketSegmentNameSection']").should("not.be.visible");

    cy.get("#chkShowMarketSegmentName").check({ waitForAnimations: false });
    cy.get("div[data-cy='div-marketSegmentNameSection']").should("be.visible");
  });

  it("12 - Validate Survey Cut Columns Dropdown", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(1) h6.pricing-header:nth-child(1) i.fa-angle-down").click();
      }
    });

    cy.get("select[id='selColumns']").next().click();
    cy.get("ul.multiselect-container li.active").should("have.length.greaterThan", 1);
    cy.get("body").trigger("keydown", { keyCode: 27 });
  });

  it("13 - Validate Percentile Section", () => {
    cy.get("body").then($body => {
      if ($body.find("#leftMenu div:nth-child(2) h6.pricing-header:nth-child(1) i.fa-angle-down").length) {
        cy.get("#leftMenu div:nth-child(2) h6.pricing-header:nth-child(1) i.fa-angle-down").click({ force: true });
      }
    });

    cy.get("div.benchmarkFilterContainer").should("have.length.greaterThan", 1);
  });

  it("14 - Has Market Data", () => {
    cy.get("#mpDataDetail .k-grid-content tr").should("have.length.greaterThan", 1);
  });

  it("15 - Three dashes displayed when cuts have no data", () => {
    // check cell in table
    cy.get("#mpDataDetail .k-grid-content tr").find("#datacell_1_41").should("have.text", "---");
    // check cell in footer
    cy.get("#mpDataDetailFooter").find("#datacell_0_26").should("have.text", "---");
  });

  it("16 - Update Job Match Adjustment Note with empty string", () => {
    cy.get("input#jobMatchNotes").click({ force: true }).clear({ force: true });
    cy.get("div[data-cy=jobMatchNotesLabel]").click({ force: true });

    cy.wait(1000).then(() => {
      cy.CheckNotification("Job Match Adjustment Notes updated successfully.");
    });
  });

  it("17 - Update Job Match Adjustment Note", () => {
    cy.get("input#jobMatchNotes").click({ force: true }).clear({ force: true }).type("test", { force: true });
    cy.get("div[data-cy=jobMatchNotesLabel]").click({ force: true });

    cy.wait(1000).then(() => {
      cy.CheckNotification("Job Match Adjustment Notes updated successfully.");
    });
  });

  it("18 - download excel file after clicking on export-excel-current link", () => {
    cy.SelectOrganization(pricingTab, orgName, projectId, projectVersion);
    pricingTab.getPricingTab().click();

    cy.wait(1000);
    // Click on the "msp-export" dropdown button
    cy.get("[data-cy=mps-export]").click();

    cy.wait(1000);
    // Click on the "export-excel-current" option
    cy.get("[data-cy=export-excel-current]").click();

    // Wait for the file to be downloaded
    cy.wait(2000);
    const fileName = `mpt_MarketPricingSheet_${orgName}_${projectId}_`;

    // Assert that the file was downloaded
    cy.task("listDownloads").then(downloads => {
      const excelDownload = downloads.find(download => download.startsWith(fileName));
      expect(excelDownload).to.exist;
    });
  });

  it("19 - download excel file after clicking on export-excel-all link", () => {
    cy.SelectOrganization(pricingTab, orgName, projectId, projectVersion);
    pricingTab.getPricingTab().click();

    cy.wait(1000);
    // Click on the "msp-export" dropdown button
    cy.get("[data-cy=mps-export]").click();

    cy.wait(1000);
    // Click on the "export-excel-all" option
    cy.get("[data-cy=export-excel-all]").click();

    // Wait for the file to be downloadedß
    cy.wait(2000);
    const fileName = `mpt_MarketPricingReport_${orgName}_${projectId}_`;

    // Assert that the file was downloaded
    cy.task("listDownloads").then(downloads => {
      const excelDownload = downloads.find(download => download.startsWith(fileName) && download.endsWith(".xlsx"));
      expect(excelDownload).to.exist;
    });
  });

  it("add external data popup shows up after clicking on Add Survey data button", () => {
    cy.get("[data-cy=addSurveyData]").click();
    cy.get("[data-cy=addexternaldata-current]").click();
    cy.get("[data-cy=addSurveyDataPopup]").should("be.visible");
    cy.get("[data-cy=mpsAddExternalData]").click();
    cy.get("[data-cy=addExternalDataPopup]").should("be.visible");
  });
});
