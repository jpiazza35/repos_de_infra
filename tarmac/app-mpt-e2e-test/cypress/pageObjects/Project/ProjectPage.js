class ProjectPage {

    //page title
    pageTitle() {
        return cy.get('.ibox-title')
    }

    // top level filters
    orgLabel() {
        return cy.get(':nth-child(1) > .form-group > [data-cy="orgLabel"]')
    }
    orgField() {
        return cy.get('[data-cy="organization"]')
    }
    projectLabel() {
        return cy.get(':nth-child(2) > .form-group > [data-cy="orgLabel"]')
    }
    projectField() {
        return cy.get('[data-cy="projectId"]')
    }
    projectVersionLabel() {
        return cy.get('[data-cy="projVerLabel"]')
    }
    projectVersionField() {
        return cy.get('[data-cy="projectVersion"]')
    }

    //tabs
    projectTab() {
        return cy.get('[data-cy="project"]')
    }
    mktSegmentTab() {
        return cy.get("[data-cy='tabs'] [data-cy='marketSegment'] a", { timeout: 10000, interval: 1000 })
    }
    mktSegmentMappingTab() {
        return cy.get('[data-cy="marketSegmentMapping"]')
    }
    jobMatchingTab() {
        return cy.get('[data-cy="jobMatching"]')
    }
    marketPricingSheetTab() {
        return cy.get('[data-cy="marketpricingsheet"]')
    }
    jobSummaryTab() {
        return cy.get('[data-cy="jobSummary"]')
    }

    // buttons
    addBtn() {
        return cy.get('[data-cy="addProject"]')
    }
    downloadTemplateBtn() {
        return cy.get('[data-cy="downloadTemplate"]')
    }
    downloadIncumbentTemplateBtn() {
        return cy.get('[data-cy="downloadIncumbentTemplate"]')
    }
    downloadJobTemplateBtn() {
        return cy.get('[data-cy="downloadJobTemplate"]')
    }
    exportBtn() {
        return cy.get('[data-cy="export"]')
    }
    clearBtn() {
        return cy.get('[data-cy="clear"]')
    }
    closeBtn() {
        return cy.get('[data-cy="popup-close"]')
    }
    fullScreenBtn() {
        return cy.get('[style="margin-left: auto;"]')
    }

    // grid
    projectGridHeader() {
        return cy.get('.k-grid-header-wrap')
    }
    projectGrid() {
        return cy.get('.k-grid-content')
    }
    paginationBar() {
        return cy.get('.k-pager-info')
    }

    // popup
    popupTitle() {
        return cy.get('[data-cy=modelTitle]')
    }
    deleteProjectNote() {
        return cy.get('[data-cy="noteDeleteModal"]')
    }
    //left Side bar
    projectSidebar() {
        return cy.get('[data-cy="project-sidebar"]')
    }

    //action buttons
    projectDetailsBtn() {
        return cy.get(".k-grid-Details")
    }
    projectDeleteBtn() {
        return cy.get(".k-grid-Delete")
    }
    projectSaveAsBtn() {
        return cy.get(".k-grid-SaveAs")
    }

    //project grid alert message
    alertMessage() {
        return cy.get('.alert')
    }
    noProjectsMsg() {
        return cy.get('.mt-2')
    }
    //details link
    detailsLink() {
        return cy.get('.k-grid-Details')
    }
    //save as link
    saveAsLink() {
        return cy.get('.k-grid-SaveAs')
    }
    //delete link
    deleteLink() {
        return cy.get('.k-grid-Delete')
    }
    gridScrollbar() {
        return cy.get('.k-grid-content.k-auto-scrollable')
    }
    gridData() {
        return cy.get("tbody")
    }
    gridSourceData() {
        return cy.get('.k-grid-sourceData')
    }
    fileStatusLink() {
        return cy.get('.k-grid-fileStatusName')
    }
}

const projectPage = new ProjectPage();
export default projectPage;
