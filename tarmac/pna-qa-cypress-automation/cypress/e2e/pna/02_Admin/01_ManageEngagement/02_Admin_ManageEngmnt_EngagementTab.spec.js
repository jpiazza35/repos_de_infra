/// <reference types="Cypress" />
import manageEngmnt from '../../../../pageObjects/Admin_ManageEngagement/ManageEngmnt';
import engagementTab from '../../../../pageObjects/Admin_ManageEngagement/EngagementTab';
describe('Manage Engagement - Engagement tab', { testIsolation: false }, function () {
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

    it('02: Navigate to Manage Engagement and verify Engagement tab is displayed by default', function () {
        manageEngmnt.manageEngagement().click({force: true})
        engagementTab.defaultEngmntTab().should('contain','Engagement')
    })

    it('02: Verify the Engagement tab buttons', function () {
        engagementTab.engmntAddBtn().should('be.visible').and('not.be.disabled').and('contain', 'Add')
        engagementTab.engmntExportBtn().should('be.visible').and('not.be.disabled').and('contain', 'Export')
        engagementTab.engmntSearchBtn().should('be.visible').and('not.be.disabled').and('contain', 'Search')
        engagementTab.engmntClearBtn().should('be.visible').and('not.be.disabled').and('contain', 'Clear')
    })

    it('02: Verify the CES Org field is present', function () {
        engagementTab.cesOrg().should('be.visible').and('not.be.disabled').and('contain', 'CES Org')
    })

    it('02: Verify the CES Org search field is autocomplete', function () {
        engagementTab.cesOrgSearchField().type('Sullivan')
        engagementTab.cesOrgDropDownList().should('be.visible').and('not.be.empty')
    })

    it('02: Verify the Engagement Date field', function () {
        engagementTab.engmntDate().should('be.visible').and('not.be.disabled').and('contain', 'Engagement Date')
        engagementTab.datePicker().click({force: true})
        engagementTab.calendar().should('be.visible')
    })

    it('02: Verify the Engagement Status field', function () {
        
        engagementTab.engmntStatus().should('be.visible').and('not.be.disabled').and('contain', 'Engagement Status')
        engagementTab.engmntStatusDropDownArrow().click({force: true})
        engagementTab.engmntStatusDropDownList().each((el,index) => {
            cy.wrap(el).should('contain.text', this.eng_data.engmntStatus[index])
        })
    })

    it('02: Verify the Version Year field', function () {
        engagementTab.versionYr().should('be.visible').and('not.be.disabled').and('contain', 'Version Year')
        engagementTab.versionYrDropDownArrow().click({force: true})
        engagementTab.versionYrDropDownList().each((el,index) => {
            cy.wrap(el).should('contain.text', this.eng_data.versionYr[index])
        })
    })

    it('02: Verify the grid headers', function () {
        engagementTab.gridHeader().should('have.length', 10)
        engagementTab.gridHeader().each((el,index) => {
            cy.wrap(el).should('contain.text', this.eng_data.gridHeadersList[index])
        })
    })



  


})