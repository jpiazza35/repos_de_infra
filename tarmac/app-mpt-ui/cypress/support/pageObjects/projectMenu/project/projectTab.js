class ProjectTab {
  getGridContent() {
    return cy.get(".k-grid-content");
  }

  getOrg() {
    return cy.get(".k-grid-content");
  }

  getAddButton() {
    return cy.get("button[data-cy=addProject]");
  }

  getSaveAs() {
    return cy.get("button.k-grid-SaveAs > span.k-button-text");
  }

  getDeleteLink() {
    return "button.k-grid-Delete span";
  }

  getDeleteModelTitle() {
    return cy.get("h5[data-cy=deleteModalTitle]");
  }

  getDeleteNotesTextarea() {
    return cy.get("textarea[data-cy=noteDeleteModal]");
  }

  getConfirmYesButton() {
    return cy.get("div.window button[data-cy=yesDeleteModal]");
  }

  getDownloadTemplateButton() {
    return cy.get("button[data-cy=downloadTemplate]");
  }

  getExportButton() {
    return cy.get("button[data-cy=export]");
  }

  getFullScreenButton() {
    return cy.get("button[data-cy=fullscreenProjectMain]");
  }
}

export default ProjectTab;
