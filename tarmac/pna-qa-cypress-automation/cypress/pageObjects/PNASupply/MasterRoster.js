/// <reference types="Cypress" />
class MasterRoster {

    get breadcrumb() {
        return cy.get('#breadcrumb')
    }

    get masterRosterTab() {
        return cy.get('.masterRosterTab')
    }
    
    get engagementRolloverBtn() {
        return cy.get('#Rollover')
    }

    get advancedFilterSearch() {
        return cy.get('#searchFilter > .dynamicSearch > .dynamicSearchFilter')
    }

    get showDynamicFilter() {
        return cy.get('#divDynamicFilter')
    }

    get searchBtn() {
        return cy.get('#search-button')
    }

    get clearBtn() {
        return cy.get('#clear-button')
    }

    get saveAsDefaultBtn() {
        return cy.get('#savedefault-button')
    }

    get addProviderBtn() {
        return cy.get('#add-button')
    }

    get providerDetailPopup() {
        return cy.get('#CustomModelMainLogicHolder_wnd_title')
    }

    get providerDetailCloseBtn() {
        return cy.get('#btnClose')
    }

    get saveBtn() {
        return cy.get('#save-button')
    }

    get cancelBtn() {
        return cy.get('#cancel-button')
    }

    get exportBtn() {
        return cy.get('#export-button')
    }

    get columnsBtn() {
        return cy.get('.k-header-column-menu')
    }

    get columnsShowColumns() {
        return  cy.get('.k-menu-link-text > b')
    }


    get columnsResetColumns() {
        return cy.get('#reset-columns > .k-link > .k-menu-link-text')
    }
    
    get massActionBtn() {
        return cy.get('#btnMassActionDropdown')
    }

    get selectProvider() {
        return cy.get('input[class="selectms"]')
    }

    get massActionDropDownMenu() {
        return cy.get('#massactionbuttons')
    }


    get massActionDeleteLocation() {
        return cy.get('#msdelloc')
    }

    get massActionEditAddress() {
        return cy.get('#masseditaddress')
    }

    get serviceAreaDropDownOptions() {
        return cy.get(':nth-child(3) > :nth-child(2) > .MultiCheckBoxDetail > .MultiCheckBoxDetailBody')
    }

    get queryFilterDropdownList() {
        return cy.get('#SearchQueryName_listbox')
    }


    get selectQueryDropdownArrow() {
        return cy.get('.dynamicSearchFilter > :nth-child(2) > .k-picker > .k-input-button')
    }

    get masterRosterGridLinks() {
       return cy.get('#supplyGrid')
    }

    get auditLogScreen() {
        return cy.get('#msauditHolder_wnd_title')
    }

    get auditLogClose() {
        return cy.get('.k-display-inline-flex > .k-window-titlebar > .k-window-actions > .k-button')
    }

    get deleteProviderConfirmPopupTitle() {
        return cy.get('.k-display-inline-flex > .k-window-titlebar > .k-window-title')
    }

    get confirmationMessageText() {
        return  cy.get('p')
    }

    get confirmYesBtn() {
        return cy.get('.confirm-yes')
    }

    get cancelDeleteFromGrid() {
        return cy.get('#supplyGrid_active_cell > .grid-cancel-delete')
    }

    get showOrHideQueryFilter() {
        return  cy.get('#expColLnk3')
    }

    get queryNameField() {
        return cy.get('#searchQueryMSArea')
    }

    get dynamicFilterHeader() {
        return cy.get('#divDynamicFilterHeaderTable')
    }

    get dynamicFilterAddRowsBtn() {
        return cy.get('.addRowButton')
    }

    get listOfQueries() {
        return cy.get('#SearchQueryName_listbox > .k-list-item')
    }

    get providerNameSearchField() {
        return cy.get('#SearchProviderNameNPI')
    }

    get tableFirstRow() {
        return cy.get('tr[class="k-master-row"] td')
    }

    get firstNameColumnReq() {
        return cy.get('th[data-field="First_Name"]')
    }

    get lastNameColumnReq() {
        return cy.get('th[data-field="Last_Name"]')
    }

    get medCredentialColumnReq() {
        return cy.get('th[data-field="Medical_Credential"]')
    }

    get mainSpecialtyColumnReq() {
        return cy.get('th[data-field="Main_Specialty_Name"]')
    }

    get subSpeciatyColumnReq() {
        return cy.get('th[data-field="Sub_Specialty_Name"]')
    }

    get address1ColumnReq() {
        return cy.get('th[data-field="Address_1"]')
    }

    get zipColumnReq() {
        return cy.get('th[data-field="Zip_Code"]')
    }

    get providerIdSearchField() {
        return cy.get('#SearchProviderID')
    }









    





}
const masterRoster = new MasterRoster()
export default masterRoster