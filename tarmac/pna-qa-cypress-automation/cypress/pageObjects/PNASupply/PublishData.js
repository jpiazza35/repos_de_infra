class PublishData  {

    publishDataTab () {
        return cy.get('.publishDataTab')
    }

    breadcrumbPublishData() {
        return cy.get('#breadcrumb')
    }

    publishDataBtn() {
        return cy.get('#PublishDataButton')
    }

    confirmPopup() {
        return cy.get('.k-display-inline-flex')
    }

    confirmPopupNoBtn() {
        return cy.get('button[class="confirm-no k-button"]')
    }

    confirmPopupYesBtn() {
        return cy.get('button[class="confirm-yes k-button"]')
    }

    tableFirstRow() {
        return cy.get('tbody tr').first()
    }

}
const publishData = new PublishData()
export default publishData