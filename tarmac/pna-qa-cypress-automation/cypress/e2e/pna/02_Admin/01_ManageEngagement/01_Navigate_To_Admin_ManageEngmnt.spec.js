/// <reference types="Cypress" />
import manageEngmnt from '../../../../pageObjects/Admin_ManageEngagement/ManageEngmnt';

describe('Navigate to Admin - Manage Engagement', { testIsolation: false }, function () {
   before(function () {
      cy.visit('/')
      //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
   });
   beforeEach(function () {
      cy.fixture('02_admin_manageEngagement/admin.data').as('data')
   });
   // after(function () {
   //    //cy.logoutClientPortal();
   // });
     
   it('01: Navigate to Admin', function () {
      cy.navigateToAdmin()
   })

   it('01: Verify the Admin dropdown list', function () {
      manageEngmnt.adminDropDownList().should('have.length', 7)
      manageEngmnt.adminDropDownList().each((el, index) => {
         cy.wrap(el).should('contain.text', this.data.adminDropDownValues[index])
      })
   })
      
   it('01: Navigate to Manage Engagement', function () {
      manageEngmnt.manageEngagement().contains('Manage Engagement').click()
      manageEngmnt.breadcrumbManageEngmnt().should('contain', 'Manage Engagement')
   })

   it('01: Verify Manage Engagement tabs', function () {
      manageEngmnt.allTabs().should('be.visible').and('have.length', 7)
      manageEngmnt.allTabs().each((el, index) => {
         cy.wrap(el).should('contain.text', this.data.listOfTabs[index])
      })
   })













})