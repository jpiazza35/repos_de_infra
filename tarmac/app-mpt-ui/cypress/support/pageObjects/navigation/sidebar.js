class SideBar {
  getActiveMenu() {
    return cy.get("#sidebar-wrapper div a.active");
  }

  getSideBar() {
    return cy.get("#sidebar-wrapper");
  }

  getProjectMenu() {
    return cy.get("a[data-cy=project-sidebar]");
  }
}

export default SideBar;
