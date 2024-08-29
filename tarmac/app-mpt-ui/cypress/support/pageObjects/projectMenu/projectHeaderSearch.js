class ProjectHeader {
  getProjectTab() {
    return cy.get("li[data-cy=project]");
  }

  getOrgInputControl() {
    return cy.get("input#organization-input");
  }

  getProjectSelect() {
    return cy.get("select[data-cy=projectId]");
  }

  getProjectVersion() {
    return cy.get("select[data-cy=projectVersion]");
  }
}

export default ProjectHeader;
