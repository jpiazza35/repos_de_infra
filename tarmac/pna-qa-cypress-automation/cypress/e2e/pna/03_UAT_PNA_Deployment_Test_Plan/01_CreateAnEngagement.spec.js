/// <reference types="Cypress" />
import manageEngmnt from '../../../pageObjects/Admin_ManageEngagement/ManageEngmnt';
import engagementTab from '../../../pageObjects/Admin_ManageEngagement/EngagementTab';

describe('Create Engagement', { testIsolation: false }, function () {
    before(function () {
        cy.visit('/')
        //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToAdmin()
    });
    beforeEach(function () {
        cy.fixture('02_admin_manageEngagement/engmntTab.data').as('eng_data')
    });
    // after(function () {
    //     //cy.logoutClientPortal();
    // });

    it('01: Navigate to Engagement tab', function (){
        manageEngmnt.manageEngagement().click({force: true})
        engagementTab.defaultEngmntTab().contains('Engagement')
        cy.wait(3000)
    })

    it('01: Click Add to create a new engagement', function (){
        engagementTab.engmntAddBtn().should('be.visible').and('not.be.disabled').and('contain', 'Add').click({force: true})
        // verify the first line is showing empty fields and user sees Save and Cancel buttons:
        engagementTab.addNewEngmntLine().first().should('contain', 'Save')
        engagementTab.addNewEngmntLine().first().should('contain', 'Cancel')
    })

    it('01: Add CES Org name', function () {
        engagementTab.addNewCESField().should('be.empty')
        engagementTab.addNewCESField().type('SullivanCotter Demo_Parent - 10423')
    })

    it('01: Add Engagement Name', function () {
        engagementTab.addNewEngmntNameField().clear()
        cy.newEngagementName()
    })

    it('01: Add Version Year', function () {
        engagementTab.addNewVersionYearField().clear()
        engagementTab.addNewVersionYearField().click().type('2020',  {force: true} )
        
    })

    it('01: Verify Engagement Date field contains data', function () {
       engagementTab.addNewEngmntDate().should('not.be.null')
    })

    it('01: Add Patient Management Factor %', function () {
        engagementTab.addPatientMngmntFactor().click( {force: true} )
        engagementTab.newEngmntPatientMngmntValue().contains('0%')
    })

    it('01: Add Report Year 1', function () {
        engagementTab.addNewReportYear1().click()
        engagementTab.addNewReportYear1().clear().type('2023')
    })

    it('01: Add Report Year 2', function () {
        engagementTab.addNewReportYear2().click()
        engagementTab.addNewReportYear2().clear().type('2028')
    })

    it('01: Click on Save button to save a new created engagement', function () {
        engagementTab.saveBtn().click()
   
    })

 
    // click Save and verify new engagement has been created
    
    // click CES Org search field to find a new created engmnt
    


})



