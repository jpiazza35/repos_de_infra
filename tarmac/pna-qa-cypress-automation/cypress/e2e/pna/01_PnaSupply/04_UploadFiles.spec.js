/// <reference types="Cypress" />
import select_ClientAndEngagement from "../../../pageObjects/PNASupply/Select_ClientAndEngagement"
import uploadFiles from "../../../pageObjects/PNASupply/UploadFiles"

describe('Upload Files tab', { testIsolation: false }, function () {

    before(function () {
        cy.visit('/')
       // cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToPnaSupply()
    })

    beforeEach(function () {
        cy.fixture('01_pnaSupply/pna_uploadFiles_data').as('uploadFiles_data')
    });

    // after(function () {
    //     cy.logoutClientPortal();
    // });

    it('04: Select Client and Engagement - Version', function () {
        select_ClientAndEngagement.selectClientParent()
        select_ClientAndEngagement.selectEngagement_Version_V23()
    })

    it('04: Navigate to the Upload Files tab', function (){
        uploadFiles.uploadFilesTab().should('have.text','Upload Files').click()
        uploadFiles.breadcrumbUploadFiles().should('contain', 'Upload Files')
    })

    it('04: Verify that Upload Files search fields are displayed', function () {
        uploadFiles.fileTypeField().should('exist').should('contain', 'File Type')
        uploadFiles.dataSourceSearchField().should('exist').should('contain', 'Data Source')
        uploadFiles.uploadFileForm().should('exist').should('contain', 'Upload File (.csv)')
    })

    it('04: Verify Data Source dropdown and Upload File field are disabled by default', function () {
        uploadFiles.dataSourceDropdown().should('have.attr', 'aria-disabled', 'true')
        uploadFiles.chooseFile().should('have.attr', 'disabled', 'disabled')
    })

    it('04: Verify buttons present on the page', function () {
        uploadFiles.downloadTemplateBtn().should('be.visible').should('have.text', 'Download Template')
        uploadFiles.browseBtn().should('be.visible').should('contain', 'Browse')
        uploadFiles.uploadBtn().should('be.visible').should('have.text', 'Upload')
        uploadFiles.refreshBtn().should('be.visible').should('have.text', 'Refresh')
        uploadFiles.exportBtn().should('be.visible').should('have.text', 'Export')
    })

    it('04: Verify Dropdown Template, Browse and Upload buttons are disabled by default ', function () {
        uploadFiles.downloadTemplateBtn().should('have.attr', 'disabled', 'disabled')
        uploadFiles.browseBtn().should('not.be.enabled')
        uploadFiles.uploadBtn().should('have.attr', 'disabled', 'disabled')
    })
    
    it('04: Verify File Type field is displayed and not disabled', function (){
        uploadFiles.fileTypeDropdown().contains('File Type').should('not.be.disabled')
    })

    it('04: Verify the File Type dropdown list', function () {
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().each(($li, index) => {
            cy.wrap($li).should('contain', this.uploadFiles_data.fileTypeDropdownValues[index])
        })
    })

    it('04: Verify the recent files filtering radio buttons', function () {
        cy.get('h4.pull-left').should('be.visible').should('have.text', 'Recent Files')
        uploadFiles.mostRecentUploadsRadioBtn().should('be.checked')
        uploadFiles.allUploadsRadioBtn().should('not.be.checked')
    })

    it('04: Verify Data Source field becomes active when file type is selected', function () {
        uploadFiles.dataSourceDropdown().should('not.be.enabled')
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().contains('Service_Area').click({force: true})
        uploadFiles.dataSourceDropdown().should('not.be.disabled')
    })

    it('04: Verify buttons get enabled after selecting the data source from the dropdown', function () {
        uploadFiles.fileTypeSearchField().should('not.contain',this.uploadFiles_data[0])
        uploadFiles.browseBtn().should('not.be.enabled')
        uploadFiles.dataSourceDropdownClick().click()
        uploadFiles.dataSourceDropdownList().contains('Service Area').click({force: true})
        uploadFiles.downloadTemplateBtn().should('be.enabled')
        uploadFiles.browseBtn().should('not.be.disabled')
        uploadFiles.uploadBtn().should('be.enabled')
    })
    
    it('04: Verify the grid table headers', function () {
        uploadFiles.gridHeader().not('[style="display:none"]').should('have.length', 7)
        uploadFiles.gridHeader().not('[style="display:none"]').each(($li, index) => {
            cy.wrap($li).should('contain', this.uploadFiles_data.tableHeaders[index])
        })
    })
    
    it('04: Upload the Service Area data file', function () {
        uploadFiles.browseBtn().click({force: true})
        cy.fixture('Service Area').then(fileContent => {
            cy.get('input[type="file"]').attachFile({fileContent, fileName: 'Service Area.csv', mimeType: 'Service Area/csv', encoding: 'utf8'})
        })
        uploadFiles.uploadBtn().click()
        uploadFiles.allUploadsRadioBtn().click()
    })

    it('04: Verify that if the file type is Affiliation, the data source dropdown list contains Affiliation', function () {
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().contains('Affiliation').click({force: true})
        uploadFiles.dataSourceDropdownClick().click()
        uploadFiles.dataSourceDropdownList().should('contain', 'Affiliation')
    })

    it('04: Verify that if the file type is cFTE, the data source dropdown list contains cFTE', function () {
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().contains('cFTE').click({force: true})
        uploadFiles.dataSourceDropdownClick().click()
        uploadFiles.dataSourceDropdownList().contains('cFTE')
    })

    it('04: Verify that if the file type is Engagement, the data source dropdown list does not contain Engagement', function () {
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().contains('Engagement').click({force: true})
        uploadFiles.dataSourceDropdownClick().click()
        uploadFiles.dataSourceDropdownList().should('not.contain','Engagement')
    })

    it('04: Verify the Data Source dropdown options when the file type is Supply Roster', function () {
        uploadFiles.fileTypeDropdownClick().click()
        uploadFiles.fileTypeDropdownList().contains('Supply Roster').click({force: true})
        uploadFiles.dataSourceDropdownClick().click()
        uploadFiles.dataSourceDropdownList().should('contain', this.uploadFiles_data.dataSourceDropdownValues[0])
        uploadFiles.dataSourceDropdownList().should('contain', this.uploadFiles_data.dataSourceDropdownValues[1])
        uploadFiles.dataSourceDropdownList().should('contain', this.uploadFiles_data.dataSourceDropdownValues[2])
    })

    it('04: Export the table data and verify the file was downloaded successfully', function () {
        cy.window().document().then(function (doc) {
            doc.addEventListener('click', () => {
                setTimeout(function () { doc.location.reload() }, 2000)
            })
        })
        uploadFiles.exportBtn().contains('Export').click()
        cy.verifyDownload('Upload Files.xlsx', { timeout: 2000 })
    })

    it('04: Verify table contains an uploaded file', function () {
        uploadFiles.refreshBtn().click()
        cy.get('tbody tr').first().should('contain', 'Demand Pending')
    })
})