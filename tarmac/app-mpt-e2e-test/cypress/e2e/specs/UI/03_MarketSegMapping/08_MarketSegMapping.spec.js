/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment'
import marketSegMapping from '../../../../pageObjects/MarketSegMapping/MarketSegMapping'

describe("MSM - Market Segment Mapping tab", { testIsolation: false }, function () {
    before(function () {
        // cy.visit('/')
        cy.logintoMPT();
        projectPage.mktSegmentMappingTab().should('be.visible').click();
    });

    beforeEach(function () {
        cy.fixture('MarketSegmentMapping/market_segment_mapping_data').as('mktSegmentMappingData')
        cy.fixture('MarketSegment/market_segment_data').as('mktSegmentData')
        cy.fixture('Project/project_data').as('projectData')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('08: verify top level filters', function () {
        //org        
        projectPage.orgLabel().should('contain', 'Organization (Name or ID)')
        projectPage.orgField().should('be.visible')
        projectPage.orgField().should('have.attr', 'placeholder', 'Select an Organization')
        //project ID
        projectPage.projectLabel().should('contain', 'Project (Name or ID)')
        projectPage.projectField().should('be.visible')
        projectPage.projectField().should('contain', 'Select a Project')
        //project version
        projectPage.projectVersionLabel().should('contain', 'Project Version (Label or ID)')
        projectPage.projectVersionField().should('be.visible')
        projectPage.projectVersionField().should('contain', 'Select a Project Version')
    });

    it('08: verify the message when org, project ID and project version are not selected', function () {
        let orgerrorMessage;
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentMappingData.orgErrorMessage)

    });

    it('08: verify the message when only org is selected', function () {
        projectPage.orgField().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentMappingData.projectIdErrorMessage)

    });

    it('08: verify the message when only org and project ID are selected', function () {
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectField().select(optionValue).wait(500);
        });
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentMappingData.projectVersionErrorMessage)

    });

    it('08: verify spreadsheet is displayed when we select incumbent project and version', function () {
        cy.intercept('get', '**/api/projects/versions/*/status').as('status')
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        cy.wait('@status').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
            //if project status=Draft it should return 1 for status
            expect(xhr.response.body).to.equal(1);
        })
        marketSegMapping.spreadSheet().should('exist')
    });

    it('08: verify the buttons and fields under Market Segment Mapping Tab', function () {
        marketSegMapping.saveBtn().should('be.visible').should('be.enabled')
        marketSegMapping.exportBtn().should('be.visible').should('be.enabled')
        marketSegMapping.methodology().should('contain', this.mktSegmentMappingData.label)
        marketSegMapping.methodologyInput().should('be.not.enabled')
        marketSegMapping.alert().should('contain', this.mktSegmentMappingData.alert)
    });

    it('08: verify full screen functionality', function () {
        marketSegMapping.fullscrBtn().click()
        marketSegMapping.fullscrBtn().should('contain', 'Exit Full Screen')
        //except for buttons other sections should be hidden in full screen mode
        homePage.logo().should('not.be.visible')
        homePage.sidebarToggle().should('not.be.visible')
        projectPage.pageTitle().should('not.be.visible')
        //exit full screen mode
        marketSegMapping.fullscrBtn().click()
        marketSegMapping.fullscrBtn().should('contain', 'Full Screen')
        homePage.appWindow().scrollTo('top')
        homePage.logo().should('be.visible')
        projectPage.pageTitle().should('be.visible')
    });

    it('08: Verify the error message when user Maps invalid Market Segement', function () {
        marketSegMapping.marketsegmentcell().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type(this.mktSegmentData.marketSegmentEdit + 'Invalid', { force: true }).type('{enter}')
        marketSegMapping.errorPopup().should('be.visible')
        marketSegMapping.errorPopupMessage().should('contain', this.mktSegmentMappingData.errorPopupMessage)
        marketSegMapping.errorRetry().click()
        marketSegMapping.marketsegmentcell().find('div').should('exist')
        marketSegMapping.marketsegmentcell().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type(this.mktSegmentData.marketSegmentEdit + 'Invalid', { force: true }).type('{enter}')
        marketSegMapping.errorPopup().should('be.visible')
        marketSegMapping.errorCancel().click()
        marketSegMapping.marketsegmentcell().find('div').should('exist')
    })

    it('08: Verify Map valid Market Segement', function () {
        marketSegMapping.marketsegmentcell().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type(this.mktSegmentData.marketSegmentEdit, { force: true }).type('{enter}')
        marketSegMapping.marketsegmentcell().find('div').should('contain', this.mktSegmentData.marketSegmentEdit)
    })

    it('08: Verify undo and redo functionality', function () {
        marketSegMapping.marketsegmentcell().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type('{enter}')
        marketSegMapping.undo().click()
        marketSegMapping.marketsegmentcell().find('div').should('contain', this.mktSegmentData.marketSegmentEdit)
        marketSegMapping.redo().click()
        marketSegMapping.marketsegmentcell().find('div').should('not.exist')
        marketSegMapping.undo().click()
        marketSegMapping.marketsegmentcell().find('div').should('contain', this.mktSegmentData.marketSegmentEdit)
    })

    it('08: Verify Market Segment Save functionality', function () {
        marketSegMapping.saveBtn().click()
        cy.contains('The records were saved').should('be.visible')
    })

    it('08: Verify Market Segment mapping export functionality', function () {
        cy.exportPageLoadEvents();
        marketSegMapping.exportBtn().first().click()
        cy.wait(1000)
        //verify the file is downloaded
        cy.verifyDownload('Market-Mapping-Jobs.xlsx', { timeout: 5000 });
        //data to validate
        cy.parseXlsx("cypress/downloads/Market-Mapping-Jobs.xlsx").then(jsonData => {
            //Verify Table header matches
            expect(jsonData[0].data[0]).to.eqls(this.mktSegmentMappingData.marketSegmentMappingExport);
            // Veridy mapped market segment is exported 
            expect(jsonData[0].data[1][4]).to.eqls(this.mktSegmentData.marketSegmentEdit);
            //verify the excel file has data
            expect(jsonData[0].data.length).to.be.eql(parseInt(this.mktSegmentMappingData.marketMappingJobsRowCount, 10));
        })
    });

    Cypress.Commands.add('clearFilters', () => {
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.filter_popup().should('be.visible')
        marketSegMapping.clearFilter().click()
    });

    it('08: Verify filter by value', function () {
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.filter_popup().should('be.visible')
        marketSegMapping.checkbox().contains('(Blanks)').parent().parent().find('.k-checkbox').uncheck()
        marketSegMapping.applyFilter().click()
        marketSegMapping.rows().should('have.length', 2)
        cy.clearFilters();
        marketSegMapping.rows().should('have.length.gt', 2)
    })

    it('08: Verify filter by Search', function () {
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.filter_popup().should('be.visible')
        marketSegMapping.filterSearch().click().type(this.mktSegmentData.marketSegmentEdit)
        marketSegMapping.applyFilter().click()
        marketSegMapping.rows().should('have.length', 2)
        cy.clearFilters();
        marketSegMapping.rows().should('have.length.gt', 2)
    })

    it('08: Verify Sort filters', function () {
        marketSegMapping.marketsegmentcell2().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type(this.mktSegmentData.marketSegmentDelete, { force: true }).type('{enter}')
        marketSegMapping.marketsegmentcell2().find('div').should('contain', this.mktSegmentData.marketSegmentDelete)
        marketSegMapping.saveBtn().click()
        cy.contains('The records were saved').should('be.visible')
        //Sorting
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.filter_popup().should('be.visible')
        marketSegMapping.checkbox().contains('(Blanks)').parent().parent().find('.k-checkbox').uncheck()
        marketSegMapping.applyFilter().click()
        marketSegMapping.rows().should('have.length', 3)
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.sortasc().click()
        marketSegMapping.marketsegmentcell().find('div').should('contain', this.mktSegmentData.marketSegmentDelete)
        marketSegMapping.marketsegmentcell2().find('div').should('contain', this.mktSegmentData.marketSegmentEdit)
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.sortdesc().click()
        marketSegMapping.marketsegmentcell2().find('div').should('contain', this.mktSegmentData.marketSegmentDelete)
        marketSegMapping.marketsegmentcell().find('div').should('contain', this.mktSegmentData.marketSegmentEdit)
        cy.clearFilters();
        marketSegMapping.marketsegmentcell2().dblclick({ force: true })
        marketSegMapping.editcell().clear({ force: true }).type('{enter}')
        marketSegMapping.saveBtn().click()
        cy.contains('The records were saved').should('be.visible')
    })

    it('08: Verify filter by condition', function () {
        marketSegMapping.merketSegmentFilter().click({ force: true }).wait(2000)
        marketSegMapping.filter_popup().should('be.visible')
        marketSegMapping.filterByCondition().click()
        marketSegMapping.filterByConditionInput().click()
        marketSegMapping.filterByConditionOption().contains('Text contains').click()
        marketSegMapping.enterInputFilterCondition().click().type(this.mktSegmentData.marketSegmentEdit)
        marketSegMapping.applyFilter().click()
        marketSegMapping.rows().should('have.length', 2)
        cy.clearFilters();
    })

    // Delete Market Segment Functionality 
    it('09:  Market Segment Tab: Verify Delete button with out selecting market segment ', function () {
        cy.intercept('get', '**/api/projects/*/status').as('status')
        cy.intercept('get', '**/api/projects/versions/*/market-segments').as('marketsegments')
        projectPage.mktSegmentTab().contains('Market Segment').scrollIntoView().should('be.visible').click({ force: true });
        cy.wait('@status').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
            //if project status=Draft it should return 1 for status
            expect(xhr.response.body).to.equal(1);
        })
        cy.wait('@marketsegments').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.deleteBtn().should('be.disabled')
    })

    it('09:  Market Segment Tab : Verify market segment field:Should Display 2 Dropdown Options ', function () {
        marketSegment.marketSegmentField().click().wait(1000);
        //The below test step might fail because the option are not displaying for first click
        marketSegment.marketSegmentOptions().should('have.attr', 'aria-hidden', 'false');
        // Verify the option are displaying 2 
        marketSegment.marketSegmentOptions().find('li').should('have.length', 2)
    })

    it('09:  Market Segment Mapping Tab :Select the option that is mapped and verify delete ', function () {
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentEdit, { matchCase: false }).click();
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentEdit, { matchCase: false }).parent().should('have.attr', 'aria-selected', 'true')
        marketSegment.deleteBtn().should('be.enabled').click()
        marketSegment.deleteDialog().should('be.visible').should('contain', this.mktSegmentData.deleteDialogMessage)
        marketSegment.deleteYes().click()
        cy.contains(this.mktSegmentData.marketSegementDeleteMapped).should('be.visible')
    })

    it('09: Market Segment Mapping Tab : Verify Delete Popup message ', function () {
        marketSegment.marketSegmentField().click().clear().wait(1000);
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentDelete, { matchCase: false }).click();
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentDelete, { matchCase: false }).parent().should('have.attr', 'aria-selected', 'true')
        marketSegment.deleteBtn().should('be.enabled').click()
        marketSegment.deleteDialog().should('be.visible').should('contain', this.mktSegmentData.deleteDialogMessage)
        marketSegment.deleteNo().last().click()
        marketSegment.deleteDialog().should('not.be.visible')
    })

    it('09:  Market Segment Mapping Tab : Select the option that is not mapped and verify delete ', function () {
        marketSegment.deleteBtn().should('be.enabled').click()
        marketSegment.deleteDialog().should('be.visible').should('contain', this.mktSegmentData.deleteDialogMessage)
        marketSegment.deleteYes().last().click()
        cy.contains(this.mktSegmentData.marketSegementDelete).should('be.visible')
        marketSegment.marketSegmentField().click().wait(1000);
        // Verify the option are displaying 2 
        marketSegment.marketSegmentOptions().find('li').should('have.length', 1)
    })
})

