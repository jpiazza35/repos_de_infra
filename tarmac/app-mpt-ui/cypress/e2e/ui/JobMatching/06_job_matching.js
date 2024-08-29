import JobMatching from "../../../support/pageObjects/jobMatching/jobMatching";

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

  it("01: check job matching tab exists", () => {
    const jobMatching = new JobMatching();
    jobMatching.getJobMatchingTab().should("be.visible");
  });

  it("02: check job matching buttons are visible", () => {
    const jobMatching = new JobMatching();
    jobMatching.getJobMatchButton().should("be.visible");
    jobMatching.getStatusChangeButton().should("be.visible");
    jobMatching.getExportButton().should("be.visible");
    jobMatching.getFullscreenButton().should("be.visible");
  });

  it("03: check for columns in grid", () => {
    const columns = [
      "organizationName",
      "clientJobCode",
      "clientPositionCode",
      "clientJobTitle",
      "clientJobGroup",
      "marketSegmentName",
      "standardJobCode",
      "standardJobTitle",
      "standardJobDescription",
      "matchStatus",
      "jobMatchNote",
    ];
    columns.forEach(column => {
      cy.get(`th[data-cy=${column}]`).should("be.visible");
    });
  });

  it("04: check notification if job match btn is clicked without row checked", () => {
    const jobMatching = new JobMatching();
    jobMatching.getJobMatchButton().click();
    cy.get("div.k-notification-content").should("be.visible");
  });

  it("05: check for clicking the checkbox in grid", () => {
    cy.wait(2000).then(() => {
      cy.get("div.k-grid-content-locked").find("table").find("tr").eq(0).find("td").eq(0).find(".k-select-checkbox").click();
      const jobMatching = new JobMatching();
      jobMatching.getJobMatchButton().click();
      cy.get("div.k-notification-content").should("not.exist");
    });
  });

  it("06: check for opening job match modal and verifying sections", () => {
    cy.get("h5[data-cy=modelTitle]").should("be.visible");
    cy.get("h6[data-cy=searchStandards]").should("be.visible");
    cy.get("h6[data-cy=selectedStandards]").should("be.visible");
    cy.get("h6[data-cy=audit]").should("be.visible");
    cy.get("h6[data-cy=jobdescription-notes-status]").should("be.visible");
  });

  it("07: check for search input length warning in standard section", () => {
    const jobMatching = new JobMatching();
    jobMatching.getStandardsInput().click({ force: true }).clear({ force: true }).type("pa", { force: true });
    jobMatching.getSearchInputLengthWarningText().should("be.visible");
    jobMatching.getSearchInputLengthWarningText().contains("Must type at least 3 characters to search");
  });

  it("08: check for search standard headers", () => {
    const jobMatching = new JobMatching();
    jobMatching.getStandardsInput().click({ force: true }).clear({ force: true }).type("pal", { force: true });
    jobMatching.getSearchBtnInStandardSection().click({ force: true });
    cy.wait(2000).then(() => {
      // eslint-disable-next-line cypress/no-assigning-return-values
      const headerElement = cy.get("li.autocomplete-items").eq(0).find("a");
      headerElement.get("div[data-cy=headerCode]").should("be.visible");
      headerElement.get("div[data-cy=headerTitle]").should("be.visible");
      headerElement.get("div[data-cy=headerDescription]").should("be.visible");
    });
  });

  it("09: check for search standard input", () => {
    const jobMatching = new JobMatching();
    jobMatching.getStandardsInput().click({ force: true }).clear({ force: true }).type("pal", { force: true });
    jobMatching.getSearchBtnInStandardSection().click({ force: true });
    cy.wait(2000).then(() => {
      cy.get("li.autocomplete-items").eq(1).find("a").click();
      jobMatching.getJobDescriptionControl().click({ force: true }).clear({ force: true }).type("test", { force: true });
    });
  });

  it("10: check for blend percentage", () => {
    const errors = [
      "A blend note is required to save this job match",
      "A blend percent total must be equal to 100",
      "Each blend percent must be greater than 0",
    ];
    cy.get("span.text-danger").each((error, i) => {
      cy.wrap(error).should("be.visible");
      cy.wrap(error).contains(errors[i]);
    });
    cy.get("input[placeholder='Blend Percentage']").each(blend => {
      cy.wrap(blend).type("50", { force: true });
    });
    cy.get("input[placeholder='Enter Blend Note']").type("test", { force: true });
    cy.get("span.text-danger").should("not.exist");
  });

  it("11: check for audit table", () => {
    cy.get("th").contains("National Base Pay - Survey Values").should("be.visible");
    cy.get("th").contains("10th %ile").should("be.visible");
    cy.get("th").contains("50th %ile").should("be.visible");
    cy.get("th").contains("90th %ile").should("be.visible");
    cy.get("th").contains("Client Base Pay").should("be.visible");
    cy.get("th").contains("Average").should("be.visible");
    cy.get("th").contains("Compa-Ratio to 50th %ile").should("be.visible");
  });

  it("12: check for audit calculations", () => {
    const auditCalc = ["---", "---", "---", "$66.22", "$77.38", "$87.67", "---", "$3.80", "---", "0.05"];
    let i = 0;
    cy.get("table.audit-table").each(table => {
      cy.wrap(table).within(() => {
        cy.get("td").each(td => {
          cy.get(td).contains(auditCalc[i]);
          cy.get(td).should("be.visible");
          i++;
        });
      });
    });
  });

  it("13: check for save functionality", () => {
    cy.get("button[data-cy=saveBtn]").click({ force: true });
    cy.wait(200).then(() => {
      cy.get("div.k-notification-content").should("be.exist");
    });
    cy.get("button[data-cy=popup-close]").click({ force: true });
  });

  it("14: Toggles to Bulk Edit mode", () => {
    // Initially, #bulk-edit should not exist
    cy.get("#bulk-edit").should("not.exist");

    // Click the Bulk Edit button
    cy.get("[data-cy=bulkEditBtn]").click();

    // Click the Bulk Edit Option
    cy.get("[data-cy=editOptionBtnBulkEdit]").click();

    // After clicking the Bulk Edit Option, #bulk-edit should be visible
    cy.get("#bulk-edit").should("be.visible");
  });

  it("15: Show loading spinner when clicking save button", () => {
    // Click the Save button
    cy.get("[data-cy=saveBulkEdit]").click();
    // The loading spinner should be visible
    cy.get(".overlay").should("be.visible");
  });

  it("16: should prevent save job codes larger than 100 characters", () => {
    cy.get("#kendo-spreadsheet").should("be.exist");

    cy.get("#kendo-spreadsheet")
      .find(".k-spreadsheet-data .k-spreadsheet-cell")
      .eq(21) // This targets the cell G2 (7th cell in the 2nd row)
      .click()
      .type("102 chars Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempori incididutes");

    cy.get("[data-cy=saveBulkEdit]").click();

    // The loading spinner should not be visible
    cy.get(".overlay").should("not.exist");

    // an error message should be visible
    cy.contains("The following job codes are invalid").should("exist");
  });

  it("17: should allow save job codes shorter than 100 characters", () => {
    cy.get("#kendo-spreadsheet").should("be.exist");

    cy.get("#kendo-spreadsheet")
      .find(".k-spreadsheet-data .k-spreadsheet-cell")
      .eq(21) // This targets the cell G2 (7th cell in the 2nd row)
      .click()
      .type("98 chars Lorem ipsum dolor sit amet, consectetur adipiscing elit, eiusmod tempori incididutes");

    cy.get("[data-cy=saveBulkEdit]").click();

    // The loading spinner should be visible
    cy.get(".overlay").should("be.visible");
  });

  it("18: should prevent save Job Match notes than 200 characters", () => {
    cy.get("#kendo-spreadsheet").should("be.exist");

    cy.get("#kendo-spreadsheet")
      .find(".k-spreadsheet-data .k-spreadsheet-cell")
      .eq(25) // This targets the cell K2 (11th cell in the 2nd row)
      .click()
      .type(
        "202 chars Lorem ipsum dolor sit ame, consectetur adipiscing elit, sed do eiusmod tempori incididute Lorem ipsum chars Lorem ipsum dolor sit amet, consectetur adipiscing elit, eiusmod tempori incididutet",
      );

    cy.get("[data-cy=saveBulkEdit]").click();

    // The loading spinner should not be visible
    cy.get(".overlay").should("not.exist");

    // an error message should be visible
    cy.contains("Job Match notes are invalid.").should("exist");
  });

  it("19: should allow save Job Match notes shorter than 200 characters", () => {
    cy.get("#kendo-spreadsheet").should("be.exist");

    cy.get("#kendo-spreadsheet")
      .find(".k-spreadsheet-data .k-spreadsheet-cell")
      .eq(25) // This targets the cell K2 (11th cell in the 2nd row)
      .click()
      .type(
        "198 chars Lorem ipsum dolor sit ame, consectetur adipiscing elit, sed do eiusmod tempori incididute Lorem ipsum Lorem ipsum dolor sit amet, consectetur adipiscing elit, eiusmod tempori incididutet",
      );

    cy.get("[data-cy=saveBulkEdit]").click();

    // The loading spinner should be visible
    cy.get(".overlay").should("be.visible");
  });
});
