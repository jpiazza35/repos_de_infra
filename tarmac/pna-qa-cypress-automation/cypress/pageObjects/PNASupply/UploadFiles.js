class UploadFiles {

    uploadFilesTab() {
        return cy.get('.uploadfiles')
    }

    breadcrumbUploadFiles() {
        return cy.get('#breadcrumb')
    }

    fileTypeField() {
        return  cy.get('.dynamicSearch > :nth-child(1)')
    }

    fileTypeDropdown() {
        return cy.get('.dynamicSearch > :nth-child(1)')
    }

    fileTypeSearchField() {
        return cy.get('.dynamicSearch > :nth-child(1) .k-input-value-text')
    }

    fileTypeDropdownClick() {
        return cy.get('.dynamicSearch > :nth-child(1) > :nth-child(2) > .k-picker > .k-input-button')
    }

    fileTypeDropdownList() {
        return cy.get('#SearchFileType-list ul li .k-list-item-text')
    }

    dataSourceSearchField() {
        return cy.get('.dynamicSearch > :nth-child(2)')
    }

    dataSourceDropdown() {
        return cy.get('.dynamicSearch > :nth-child(2) > :nth-child(2) > span')
    }

    dataSourceDropdownClick() {
        return cy.get('.dynamicSearch > :nth-child(2) > :nth-child(2) > .k-picker > .k-input-button')
    }

    dataSourceFieldValue() {
        return cy.get('.dynamicSearch > :nth-child(2) .k-input-value-text')
    }

    dataSourceDropdownList() {
        return cy.get('#SearchDataSource_listbox')
    }

    downloadTemplateBtn() {
        return cy.get('#btnDownload')
    }

    browseBtn() {
        return cy.get('div[class="file-upload btn btn-primary"] :first-child')
    }

    uploadBtn() {
        return cy.get('#btnUpload')
    }

    uploadFileForm() {
        return cy.get('#formUpload')
    }

    refreshBtn() {
        return cy.get('#refreshButton')
    }

    exportBtn() {
        return cy.get('#exportButton')
    }

    // uploadSourceBtn() {
    //     return cy.get('#uploadSourceBtn')
    // }

    chooseFile() {
        return cy.get('#uploadSourceFile')
    }

    mostRecentUploadsRadioBtn() {
        return cy.get('#recentFilesRadioButton')
    }

    allUploadsRadioBtn() {
        return cy.get('#allFilesRadioButton')
    }

    gridHeader() {
        return cy.get('thead tr .k-header')
    }
    





}
const uploadFiles = new UploadFiles()
export default uploadFiles