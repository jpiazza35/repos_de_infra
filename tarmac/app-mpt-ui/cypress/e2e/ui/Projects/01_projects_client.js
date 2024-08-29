import ProjectHeader from "../../../support/pageObjects/projectMenu/projectHeaderSearch";
import ProjectTab from "../../../support/pageObjects/projectMenu/project/projectTab";
import ProjectDetail from "../../../support/pageObjects/projectMenu/project/projectDetail";
import ProjectSaveAs from "../../../support/pageObjects/projectMenu/project/projectSaveAs";

let projectData = null;
let orgSearchStart = null;
let orgNameID = "";
let orgID = null;
let projectHeader;

const visitProjectTab = data => {
  cy.visit("/#");

  projectData = data;
  orgSearchStart = data.orgName.substring(0, 1);
  orgID = data.orgID;
  orgNameID = data.orgName + " - " + projectData.orgID;
  projectHeader = new ProjectHeader();

  cy.wait(2000).then(() => {
    projectHeader.getProjectTab().should("be.visible");
  });

  cy.wait(1000).then(() => {
    projectHeader.getOrgInputControl().click({ force: true }).clear({ force: true }).type(data.orgName, { force: true });

    cy.wait(2000).then(() => {
      const projectHeader = new ProjectHeader();
      projectHeader.getProjectSelect().selectNth(1);
      projectHeader.getProjectSelect().trigger("change", { force: true });

      projectHeader.getProjectVersion().selectNth(1);
      projectHeader.getProjectVersion().trigger("change", { force: true });
    });
  });
};

describe("project spec", () => {
  before(() => {
    cy.fixture("project").then(data => {
      visitProjectTab(data);
    });
  });

  after(function () {
    cy.logoutClientPortal();
  });

  it("01: check project tab exists", () => {
    const projectHeader = new ProjectHeader();
    projectHeader.getProjectTab().should("be.visible");
  });

  it("01: Search Project for Org", () => {
    const projectTab = new ProjectTab();

    cy.wait(1000).then(() => {
      projectTab.getGridContent().find("tr").should("have.length.greaterThan", -1);
    });
  });

  it("01: Check action buttons in project tab", () => {
    const projectTab = new ProjectTab();
    projectTab.getDownloadTemplateButton().should("be.visible");
    projectTab.getExportButton().should("be.visible");
    projectTab.getFullScreenButton().should("be.visible");
  });

  it("01: Add New Project", () => {
    const projectTab = new ProjectTab();
    const projectDetail = new ProjectDetail();

    cy.wait(2000).then(() => {
      projectTab.getAddButton().should("be.visible");
      projectTab.getAddButton().click();

      projectDetail.getModelTitle().should("have.text", "Project Details");

      projectDetail.getOrganization().click({ force: true }).clear({ force: true }).type(orgID, { force: true });
      cy.get(projectDetail.getAutoCompleteItem(), { timeout: 3000 }).should("be.visible");
      cy.get(projectDetail.getAutoCompleteItem()).first().click();

      projectDetail
        .getProjectInput()
        .click({ force: true })
        .clear({ force: true })
        .type(new Date().getTime() + projectData.Project.projectUIName, {
          force: true,
        });
      projectDetail.getSaveButton().click();

      cy.CheckNotification(projectData.Project.Success_Msg_1);
      projectDetail.getCloseButton().click({ force: true });
    });
  });

  it("01: Search Project", () => {
    const projectHeader = new ProjectHeader();
    const projectTab = new ProjectTab();

    cy.wait(1000).then(() => {
      // eslint-disable-next-line cypress/unsafe-to-chain-command
      cy.scrollTo("0%", "100%", { ensureScrollable: false }).then(() => {
        cy.AutoCompleteFirstChild("input#organization-input", orgSearchStart, orgNameID);
        cy.wait(2000).then(() => {
          projectHeader.getProjectSelect().selectNth(1);
          projectHeader.getProjectSelect().trigger("change", {
            force: true,
          });
        });

        cy.wait(1000).then(() => {
          projectHeader.getProjectVersion().selectNth(1);
          projectHeader.getProjectVersion().trigger("change", {
            force: true,
          });
        });

        cy.wait(2000).then(() => {
          projectTab.getGridContent().find("tr").should("have.length.greaterThan", -1);
        });
      });
    });
  });

  it("01: SaveAs Project", () => {
    const projectTab = new ProjectTab();
    const projectSaveAs = new ProjectSaveAs();

    cy.wait(1000).then(() => {
      projectTab.getSaveAs().click();

      projectSaveAs.getModelTitle().should("have.text", "Save As");

      projectSaveAs.getProjectInput().clear().type("Cypress Project x");
      projectSaveAs.getProjectSaveButton().click();

      cy.CheckNotification(projectData.Project.Success_Msg_1);

      projectSaveAs.getModelClose().click();
    });
  });

  it("01: Delete existing Project", () => {
    const projectTab = new ProjectTab();

    cy.get("body").then($body => {
      cy.wait(2000).then(() => {
        cy.log($body.find(projectTab.getDeleteLink()).length);

        if ($body.find(projectTab.getDeleteLink()).length > 0) {
          cy.get(projectTab.getDeleteLink()).eq(0).trigger("click");

          projectTab.getDeleteModelTitle().should("have.text", "Confirmation Required");

          projectTab.getDeleteNotesTextarea().type(projectData.Project.Delete_Comment);
          projectTab.getConfirmYesButton().click();
          cy.CheckNotification(projectData.Project.Delete_Success_Msg_1);
        }
      });
    });
  });
});
