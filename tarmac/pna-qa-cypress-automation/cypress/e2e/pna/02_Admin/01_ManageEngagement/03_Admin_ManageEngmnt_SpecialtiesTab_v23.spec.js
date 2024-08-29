/// <reference types="Cypress" />
import manageEngmnt from '../../../../pageObjects/Admin_ManageEngagement/ManageEngmnt';
import specialtiestTab from '../../../../pageObjects/Admin_ManageEngagement/SpecialtiesTab';
import select_ClientAndEngagement from '../../../../pageObjects/PNASupply/Select_ClientAndEngagement'

describe('Manage Engagement - Specialties tab, v23', { testIsolation: false }, function () {

    before(function () {
        cy.visit('/')
        //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToAdmin()
    });
    beforeEach(function () {
        cy.fixture('02_admin_manageEngagement/admin.data').as('data')
        cy.fixture('02_admin_manageEngagement/specialties.data').as('specialties_data')
        
    });
    // after(function () {
    //     //cy.logoutClientPortal();
    // });

    it('03: Navigate to Admin - Manage Engagement - Specialties tab', function () {
        manageEngmnt.manageEngagement().click({force: true})
        cy.listenToClickEventForDownload()
        specialtiestTab.specialtiesTabBtn().contains(this.data.listOfTabs[1]).click({force: true})
        specialtiestTab.breadcrumbSpecialties().should('contain', 'Specialties')
        select_ClientAndEngagement.engagementField().should('be.visible')
    })

    it('03: Select a Client and Engagement - Version', function () {
        select_ClientAndEngagement.selectClientParent()
        select_ClientAndEngagement.selectEngagement_Version_V23()
    })

    it('03: Verify the list of specialty groups', function () {
        specialtiestTab.listOfSpecialtyGroups().each(($li, index) => {
            cy.wrap($li).should('contain', this.specialties_data.specialtyGroupv23[index])
        })
    })

    it('03: Verify all Primary Care specialties are displayed', function () {
        specialtiestTab.primaryCareGroup().each(($li, index) => {
            cy.wrap($li).should('contain', this.specialties_data.primaryCareSpecialties[index])
        })
    })

    it('03: Verify all Medical Specialties are displayed', function () {
        specialtiestTab.medSpecialtiesGroup().should('have.length', 22)
        specialtiestTab.medSpecialtiesGroup().each(($li, index) => {
            cy.wrap($li).should('contain', this.specialties_data.medicalSpecialties[index])
        })
    })

    it('03: Verify Surgical Specialties are displayed', function () {
        specialtiestTab.surgicalSpecialtiesGroup().should('have.length', 10)
        specialtiestTab.surgicalSpecialtiesGroup().each(($li, index) => {
            cy.wrap($li).should('contain', this.specialties_data.surgicalSpecialties[index])
        })
    })

    it('03: Verify Surgical Specialties are displayed', function () {
        specialtiestTab.hospitalBasedSpecialtiesGroup().should('have.length', 6)
        specialtiestTab.hospitalBasedSpecialtiesGroup().each(($li, index) => {
            cy.wrap($li).should('contain', this.specialties_data.hospitalBasedSpecialties[index])
        })
    })

    it('03: Verify Pediatric Subspecialties are displayed', function () {
        specialtiestTab.pediatricSubspecialtiesGroup().should('have.length', 1)
        specialtiestTab.pediatricSubspecialtiesGroup().should('contain', this.specialties_data.pediatricSubspecialties[0])
    })

    it('03: Verify Ancillary Specialties are displayed if version yesr is v23', function () {
        select_ClientAndEngagement.searchEngagementList().then((field) => {
            if(field.text().includes('v23')) {
                specialtiestTab.ancillarySpecialtiesGroup().each(($li, index) => {
                    cy.wrap($li).should('contain', this.specialties_data.ancillarySpecialties[index])
                })
            } else {
                cy.log('2019 and 2020 do not have Ancillary Specialties')
            }
        })
    })

    it('03: Verify Edit, Save and Cancel buttons present in Specialties tab', function () {
        specialtiestTab.specialtiesEditBtn().should('be.visible').should('contain', 'Edit')
        specialtiestTab.specialtiesSaveBtn().should('be.visible').should('contain', 'Save')
        specialtiestTab.specialtiesCancelBtn().should('be.visible').should('contain', 'Cancel')
    })

    it('03: Verify Select All can unselect all specialties', function () {
        specialtiestTab.selectAllField().should('contain', 'Select All')
        specialtiestTab.specialtiesEditBtn().click()
        specialtiestTab.selectAllCheckbox().uncheck()
        specialtiestTab.allCheckboxes().should('have.attr', 'aria-checked','false')
        specialtiestTab.specialtiesCancelBtn().click()
    })


    




    











})