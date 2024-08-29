/// <reference types="Cypress" />
import masterRoster from "../../../pageObjects/PNASupply/MasterRoster"
import select_ClientAndEngagement from "../../../pageObjects/PNASupply/Select_ClientAndEngagement"


describe('Mater Roster tab', { testIsolation: false }, function () {
    before(function () {
        cy.visit('/')
        //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToPnaSupply()
    })

    beforeEach(function () {
        cy.fixture('01_pnaSupply/pna_data').as('data')
    });

    // after(function () {
    //     cy.logoutClientPortal();
    // });

    it('02: Select Client and Engagement - Version', function () {
        select_ClientAndEngagement.selectClientParent()
        select_ClientAndEngagement.selectEngagement_Version_V23()
    })

    it('02: Verify the Master Roster tab', function () {
        masterRoster.breadcrumb.children().should('have.text', 'Master Roster')
        masterRoster.masterRosterTab.should('have.text','Master Roster')
    })

    it('02: Verify (+)Show Advanced Filter Search fields are displayed', function () {
        cy.get('#expColLnk').then(($link) =>{
            if($link.hasClass('expCol closed')) {
                cy.get('#expColLnk').contains('(+) Show Advanced Filter Search').click()
            } else {
                masterRoster.advancedFilterSearch.each((el, index, list) => {
                    cy.wrap(el).should('contain.text', this.data.advFilter[index])
                })   
            }
        })    
    })

    it('02: Verify (+)Show Advanced Filter Search buttons are displayed', function () {
        cy.get('#expColLnk').then(($link) =>{
            if($link.hasClass('expCol closed')) {
                cy.get('#expColLnk').contains('(+) Show Advanced Filter Search').click({force: true})
            } else {
                masterRoster.searchBtn.should('not.be.disabled')
                masterRoster.clearBtn.should('not.be.disabled')
                masterRoster.saveAsDefaultBtn.should('not.be.disabled')
            }
        })    
    })

    
    it('02: Verify the required columns are displayed in grid', function () {
        masterRoster.firstNameColumnReq.should('be.visible').should('have.text', 'First Name*')
        masterRoster.lastNameColumnReq.should('be.visible').should('have.text', 'Last Name*')
        masterRoster.medCredentialColumnReq.should('be.visible').should('have.text', 'Medical Credential*')
        masterRoster.mainSpecialtyColumnReq.should('be.visible').should('have.text', 'Main Specialty*')
        masterRoster.subSpeciatyColumnReq.should('be.visible').should('have.text', 'Sub-specialty*')
        masterRoster.address1ColumnReq.should('be.visible').should('have.text', 'Address 1*')
        masterRoster.zipColumnReq.should('be.visible').should('have.text', 'Zip*')
    })

    it('02: Open the Dynamic Filter', function () {
        cy.get('#expColLnk2').then(($link) => {
            if($link.text().includes('(+) Show Dynamic Filter')) {
                cy.get('#expColLnk2').click({force: true})
            }
        })
        masterRoster.dynamicFilterAddRowsBtn.should('have.text', '+ Add Rows').click()
    })

    it('02: Verify the Dynamic Filter header values', function () {
        masterRoster.dynamicFilterHeader.should('contain', 'Field')
        masterRoster.dynamicFilterHeader.should('contain', 'Operator')
        masterRoster.dynamicFilterHeader.should('contain', 'Value')
        masterRoster.showOrHideQueryFilter.click()
    })


    it('02: Verify (+)Show Query Filter', function () {
        masterRoster.showOrHideQueryFilter.then(($link) => {
            if($link.text().includes('(+) Show Query Filter')) {
                masterRoster.showOrHideQueryFilter.click()
            }
        })
    })

    it('02: Verify list of the Query Filter reports', function () {
        masterRoster.queryNameField.should('contain', 'Query Name')
        masterRoster.selectQueryDropdownArrow.click()
        masterRoster.listOfQueries.each(($li, index) => {
            cy.wrap($li).should('contain.text', this.data.listOfQueryFilterReports[index])
        })
    })

    it('02: Hide Query Filter', function () {
        masterRoster.showOrHideQueryFilter.then(($link) => {
            if($link.text().includes('(-) Hide Query Filter')) {
                masterRoster.showOrHideQueryFilter.click()
            }
         })
    })

    it('02: Verify "Add Provider" button present', function () {
        masterRoster.addProviderBtn.should('be.visible')
        masterRoster.addProviderBtn.contains('Add Provider').click()
        masterRoster.providerDetailPopup.should('have.text', 'Provider Detail')
        masterRoster.providerDetailCloseBtn.should('not.be.disabled').click()
    })

    it('02: Verify the Master Roster grid buttons', function () {
        masterRoster.saveBtn.should('be.visible').should('be.enabled')
        masterRoster.cancelBtn.should('be.visible').should('be.enabled')
        masterRoster.exportBtn.should('be.visible').should('be.enabled')
        masterRoster.columnsBtn.should('exist').should('have.text', 'Columns ')
        masterRoster.massActionBtn.should('be.visible').should('not.be.enabled')
    })

    it('02: Verify the Columns dropdown options', function () {
        masterRoster.columnsBtn.click()
        masterRoster.columnsShowColumns.should('contain.text', 'Show Columns')
        masterRoster.columnsResetColumns.should('contain.text', 'Reset Columns')
    })

    it('02: Verify Master Roster grid has data', function () {
        masterRoster.masterRosterGridLinks.within(() => {
            cy.contains('a', 'Detail')
            cy.contains('a', 'Log')
            cy.contains('a', 'Delete Provider Location')
         })
    })

    it('02: Verify the "Detail" link', function () {
        masterRoster.masterRosterGridLinks.contains('Detail').click()
        masterRoster.providerDetailPopup.should('contain', 'Provider Detail')
        masterRoster.providerDetailCloseBtn.click()
    }) 

    it('02: Verify the "Log" link', function () {
        masterRoster.masterRosterGridLinks.contains('Log').click()
        masterRoster.auditLogScreen.should('contain.text', 'Audit Log')
        masterRoster.auditLogClose.click()
    }) 

    it('02: Verify the "Delete Provider Location" link', function () {
        masterRoster.masterRosterGridLinks.contains('Delete Provider Location').click()
        masterRoster.deleteProviderConfirmPopupTitle.should('have.text', 'Confirmation Required')
        masterRoster.confirmationMessageText.should('have.text', this.data.deleteProviderLinkConfirmMessage[0])
        masterRoster.confirmYesBtn.click()
        masterRoster.cancelDeleteFromGrid.contains('Cancel Delete').click()
    }) 

    it('02: Activate the "Mass Action" button' , function () {
        //cy.fixture('pna_data').as('data')
        masterRoster.selectProvider.first().check()
        masterRoster.massActionBtn.should('be.enabled')
    })

    it('02: Verify the Mass Action dropdown options', function () {
        masterRoster.massActionBtn.click({force: true})
        masterRoster.massActionDeleteLocation.contains('Delete Location').should('exist')
        masterRoster.massActionEditAddress.contains('Edit Address').should('exist')
    })



    // Verify the Search button is working
    // Verify the Clear button is working
    // Verify the Save as Default button is working

})

            




    



