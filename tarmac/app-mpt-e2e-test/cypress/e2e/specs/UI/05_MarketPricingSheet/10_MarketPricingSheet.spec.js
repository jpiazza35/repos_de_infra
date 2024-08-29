/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment'
import marketPricingSheet from '../../../../pageObjects/MarketPricingSheet/MarketPricingSheet'

describe("MSM - Market Segment Mapping tab", { testIsolation: false }, function () {
    before(function () {
        // cy.visit('/')
        cy.logintoMPT();
        projectPage.marketPricingSheetTab().should('be.visible').click();
    });

    beforeEach(function () {
        cy.fixture('MarketPricingSheet/market_pricing_sheet_data').as('mktPricingSheetData')
        cy.fixture('MarketSegment/market_segment_data').as('mktSegmentData')
        cy.fixture('Project/project_data').as('projectData')
        cy.fixture('JobMatching/job_matching_data').as('jobmatchingdata')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('10: verify top level filters', function () {
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

    it('10: verify the message when org, project ID and project version are not selected', function () {
        projectPage.alertMessage().trimmedText().should('eq', this.mktPricingSheetData.orgErrorMessage)

    });

    it('10: verify the message when only org is selected', function () {
        projectPage.orgField().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.alertMessage().trimmedText().should('eq', this.mktPricingSheetData.projectIdErrorMessage)

    });

    it('10: verify the message when only org and project ID are selected', function () {
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectField().select(optionValue).wait(500);
        });
        projectPage.alertMessage().trimmedText().should('eq', this.mktPricingSheetData.projectVersionErrorMessage)

    });

    it('10: verify spreadsheet is displayed when we select incumbent project and version', function () {
        cy.intercept('get', '**/api/projects/versions/*/market-segments').as('marketSegments')
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        cy.wait('@marketSegments', { timeout: 15000, intervval: 1000 }).then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketPricingSheet.marketPricingSheettab().should('exist')
    });

    it('10: verify the buttons and fields under Market Pricing Sheet Tab', function () {
        marketPricingSheet.hidePane().should('be.visible').should('be.enabled')
        marketPricingSheet.addExternalData().should('be.visible').should('be.enabled')
        marketPricingSheet.export().should('be.visible').should('be.enabled')
        marketPricingSheet.statusChange().should('be.visible').should('be.enabled')
        marketPricingSheet.fullscrBtn().should('be.visible').should('be.enabled')
        marketPricingSheet.mainSettings().should('be.visible')
        marketPricingSheet.percentiles().should('be.visible')
        marketPricingSheet.filters().should('be.visible')
        marketPricingSheet.sortBy().should('be.visible')
        marketPricingSheet.marketPricingSheet().should('be.visible')
        marketPricingSheet.clientPositionDetail().should('be.visible')
        marketPricingSheet.clientPayDetail().should('be.visible')
        marketPricingSheet.jobMatchDetail().should('be.visible')
        marketPricingSheet.marketDataDetail().should('be.visible')
    });

    it('10: verify full screen functionality', function () {
        marketPricingSheet.fullscrBtn().click()
        marketPricingSheet.fullscrBtn().should('contain', 'Exit Full Screen')
        //except for buttons other sections should be hidden in full screen mode
        homePage.logo().should('not.be.visible')
        homePage.sidebarToggle().should('not.be.visible')
        //exit full screen mode
        marketPricingSheet.fullscrBtn().click()
        marketPricingSheet.fullscrBtn().should('contain', 'Full Screen')
        homePage.appWindow().scrollTo('top')
        homePage.logo().should('be.visible')
        projectPage.pageTitle().should('be.visible')
    });

    it('10: verify Hide Pane functionality', function () {
        marketPricingSheet.hidePane().click()
        marketPricingSheet.leftMenu().should('not.be.visible')
        marketPricingSheet.showPane().should('be.visible').click()
        marketPricingSheet.leftMenu().should('be.visible')
    })

    Cypress.Commands.add('validateFiltersBody', (headertext) => {
        cy.get('.card .card-header').contains(headertext).parent().find('.card-body').should('not.be.visible')
        cy.get('.card .card-header').contains(headertext).find('.fa-angle-down').click()
        cy.get('.card .card-header').contains(headertext).parent().find('.card-body').should('be.visible')
        cy.get('.card .card-header').contains(headertext).find('.fa-angle-up').click()
        cy.get('.card .card-header').contains(headertext).parent().find('.card-body').should('not.be.visible').wait(1000)
    });

    Cypress.Commands.add('expandCardBody', (headertext) => {
        cy.get('.card .card-header').contains(headertext).find('.fa-angle-down').click()
    })

    Cypress.Commands.add('scaledownCardBody', (headertext) => {
        cy.get('.card .card-header').contains(headertext).find('.fa-angle-up').click()
    })

    Cypress.Commands.add('checkFiltersOptions', (headertext, optiontext) => {
        cy.get('.card .card-header').contains(headertext).parent().find('.card-body').should('be.visible').within(() => {
            cy.get('.settingText').contains(optiontext).parent().find('.form-check .form-check-input').click()
        })
    });

    it('10: Validate fiters card body functionality', function () {
        cy.validateFiltersBody(this.mktPricingSheetData.filtersHeader[0])
        cy.validateFiltersBody(this.mktPricingSheetData.filtersHeader[1])
        cy.validateFiltersBody(this.mktPricingSheetData.filtersHeader[2])
        cy.validateFiltersBody(this.mktPricingSheetData.filtersHeader[3])
    })

    it('10: Validate Main fiters options functionality', function () {
        const mainSettings = this.mktPricingSheetData.filtersHeader[0]
        cy.expandCardBody(mainSettings)
        // Toogle Off
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[0])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[1])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[2])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[3])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[4])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[5])
        // Toogle Off
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[0])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[1])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[2])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[3])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[4])
        cy.checkFiltersOptions(mainSettings, this.mktPricingSheetData.mainSettingsOptions[5])
        cy.scaledownCardBody(mainSettings)
    })

    it('10: Validate Status Change functionality', function () {
        marketPricingSheet.statusChange().click()
        marketPricingSheet.statusChange().parent().contains('ul li', this.jobmatchingdata.statusChangeOptions[2]).click()
        marketPricingSheet.marketPricingStatus().parent().find('div').last().should('have.text', this.jobmatchingdata.statusChangeOptions[2])
        marketPricingSheet.statusChange().click()
        marketPricingSheet.statusChange().parent().contains('ul li', this.jobmatchingdata.statusChangeOptions[0]).click()
        marketPricingSheet.marketPricingStatus().parent().find('div').last().should('have.text', this.jobmatchingdata.statusChangeOptions[2])
    })

    it('10: Validate Export Current Pricing Sheet Excel functionality', function () {
        cy.exportPageLoadEvents();
        marketPricingSheet.export().click()
        marketPricingSheet.export().parent().find('ul li').last().click()
        cy.wait(1000)
        //verify the file is downloaded
        cy.verifyDownload('current-pricing-sheet.xlsx', { timeout: 5000 });
        //data to validate
        cy.parseXlsx("cypress/downloads/current-pricing-sheet.xlsx").then(jsonData => {
            expect(jsonData[0].data.length).to.be.gte(parseInt(this.mktPricingSheetData.currentPricingSheetRowCount, 10));
        })
    })

    it('10: Validate Export Current Pricing Sheet Pdf functionality', function () {
        cy.exportPageLoadEvents();
        marketPricingSheet.export().click()
        cy.intercept('get', '**/api/projects/market-pricing-sheet/*/export-pdf*').as('fileexport')
        marketPricingSheet.export().parent().find('ul li').eq(1).click()
        cy.wait('@fileexport').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.wait(2000)
        //verify the file is downloaded
        const partialFilename = 'mpt_MarketPricingSheet_MPT'
        cy.task('readDownloadsFolder', { partialFilename }).then((matchedFiles) => {
            expect(matchedFiles.length).to.be.greaterThan(0, `No file found with partial filename: ${partialFilename}`);
            const filename = matchedFiles[0]; // Assuming there's only one matching file
        })
    })

    it('10: Validate Add External data Current Pricing Sheet functionality', function () {
        marketPricingSheet.marketDataDetail().parent().should('contain', this.mktPricingSheetData.noMarketDataMesssage)
        marketPricingSheet.addExternalData().click()
        cy.intercept('get', '**/api/projects/market-pricing-sheet/*/global-settings').as('globalSettings')
        marketPricingSheet.addExternalData().parent().find('ul li').last().click()
        cy.wait('@globalSettings').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketPricingSheet.saveAndClose().should('be.disabled')
        marketPricingSheet.uploadFile().selectFile('cypress/fixtures/MarketPricingSheet/' + this.mktPricingSheetData.externalCurrentPricingSheet + ".xlsx", { force: true })
        cy.intercept('post', '**/api/projects/market-pricing-sheet/*/external-data').as('externalData')
        marketPricingSheet.saveAndClose().should('be.enabled').click({ force: true })
        cy.wait('@externalData').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains(this.mktPricingSheetData.externalDataSave)
    })

    it('10: Validate Add External data All Pricing Sheet functionality', function () {
        marketPricingSheet.addExternalData().click()
        cy.intercept('get', '**/api/projects/market-pricing-sheet/*/global-settings').as('globalSettings')
        marketPricingSheet.addExternalData().parent().find('ul li').first().click()
        cy.wait('@globalSettings').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketPricingSheet.saveAndClose().should('be.disabled')
        marketPricingSheet.uploadFile().selectFile('cypress/fixtures/MarketPricingSheet/' + this.mktPricingSheetData.externalCurrentPricingSheet + ".xlsx", { force: true })
        cy.intercept('post', '**/api/projects/market-pricing-sheet/*/external-data').as('externalData')
        marketPricingSheet.saveAndClose().should('be.enabled').click({ force: true })
        cy.wait('@externalData').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains(this.mktPricingSheetData.externalDataSave)
    })
})