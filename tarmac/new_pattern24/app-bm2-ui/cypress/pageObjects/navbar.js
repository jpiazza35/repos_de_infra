class Navbar {
  getLandingNavbar() {
    return cy.get('[data-cy="landing-navbar"]')
  }

  getBtnOpenSidebar() {
    return cy.get('[data-cy="button-open-sidebar"]')
  }
  getLogoSulivan() {
    return cy.get('[data-cy="logo-sulivan"]')
  }
  getClientPortalContainer() {
    return cy.get('[data-cy="client-portal-container"]')
  }
  getClientPortalLink() {
    return cy.get('[data-cy="client-portal-link"]')
  }

  getLogoSidebar() {
    return cy.get('#logo-sidebar')
  }

  getBtnDropdownUser() {
    return cy.get('[data-cy="button-dropdown-user"]')
  }

  getDropdownUser() {
    return cy.get('#dropdown-user')
  }

  getEmulateButton() {
    return cy.get('[data-cy="button-emulate"]')
  }

  getProfileUsername() {
    return cy.get('[data-cy="profile-username"]')
  }

  getProfilePicture() {
    return cy.get('[data-cy="profile-picture"]')
  }

  getUserProfile() {
    return cy.get('[data-cy="profile-userinfo"]')
  }

  getUserProfileName() {
    return cy.get('[data-cy="profile-name"]')
  }

  getUserProfileEmail() {
    return cy.get('[data-cy="profile-email"]')
  }

  getProfileSettings() {
    return cy.get('[data-cy="profile-account-settings"]')
  }
  getProfileEditSettings() {
    return cy.get('[data-cy="profile-account-edit"]')
  }
  getNotificationSettings() {
    return cy.get('[data-cy="profile-notification-settings"]')
  }
  getProfileLogout() {
    return cy.get('[data-cy="profile-logout"]')
  }
}

const navbar = new Navbar()
export default navbar
