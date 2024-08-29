/// <reference types="Cypress" />
import pnaHomePage from '../../../pageObjects/PNASupply/PnaHomePage';

describe('Navigate to Provider Needs Assessment application', { testIsolation: false }, function () {
    before(function () {
       cy.visit('/')
       cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
    });
    beforeEach(function () {
         cy.fixture('01_pnaSupply/pna_home_data').as('data')
    });
    
    after(function () {
     //cy.logoutClientPortal();
    });


    it("01: Navigate to Provider Needs Assessment application", function () {
        pnaHomePage.physicianNeedsAssessment.should('contain', 'Provider Needs Assessment').click()
        pnaHomePage.appName.contains('Provider Needs Assessment')
    })

    it('01: Verify the navigation bar buttons displayed', function () {
        pnaHomePage.navBarHomeBtn.should('have.text', this.data.navigationBar[0])
        pnaHomePage.navBarPnaSupplyBtn.should('have.text', this.data.navigationBar[1])
        pnaHomePage.navBarReporting.should('have.text', this.data.navigationBar[2])
        pnaHomePage.navBarAdmin.should('have.text', this.data.navigationBar[3])
        pnaHomePage.navBarMyProfile.should('have.text', this.data.navigationBar[4])
    })

    it('01: Verify the PNA Home page displayed' , function () {
        pnaHomePage.breadcrumbHome.should('have.text', ' Home')
        pnaHomePage.announcement.should('exist')
        pnaHomePage.announcementMessage.should('be.visible')
        pnaHomePage.signOut.should('be.visible')
    })

    it('01: Verify the Master Roster Edit app exists', function () {
        cy.get('[data-url="/PNA/Supply/MasterRosterList"]').contains(this.data.homePageApps[0]).should('exist')
        cy.get('[data-url="/PNA/Report/Index?reportId=2"]').contains(this.data.homePageApps[1]).should('exist')
    })

})