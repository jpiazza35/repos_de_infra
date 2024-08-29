class MarketSegment {

    //error messages
    errorMessage() {
        return cy.get('.alert')
    }
    orgErrorMessage() {
        return cy.get('[data-cy="organizationErrorMessage"]')
    }
    projectIdErrorMessage() {
        return cy.get('[data-cy="projectIdErrorMessage"]')
    }
    projectVersionErrorMessage() {
        return cy.get('[data-cy="projectVersionErrorMessage"]')
    }
    orgidField() {
        return cy.get('[data-cy="organization"]')
    }
    orgidFieldAutoCom() {
        return cy.get('.autocomplete-items')
    }

    //market segment 

    marketSegmentLabel() {
        return cy.get('[data-cy="marketSegmentNameLabel"]')
    }

    marketSegmentField() {
        return cy.get('[data-cy="marketSegmentNameControl"]')
    }

    marketSegmentOptions() {
        return cy.get("#marketSegmentNameControl-list .k-list-content ul")
    }

    // buttons
    addBtn() {
        return cy.get('[data-cy="addMarketSegmentBtn"]')
    }

    editBtn() {
        return cy.get('[data-cy="editMarketSegmentBtn"]')
    }
    deleteBtn() {
        return cy.get('[data-cy="deleteMarketSegmentBtn"]')
    }
    saveAsBtn() {
        return cy.get('[data-cy="saveAsMarketSegmentBtn"]')
    }
    clearBtn() {
        return cy.get('[data-cy="clear"]')
    }
    fullscrBtn() {
        return cy.get('[data-cy="export"]')
    }

    // accordian sections
    filtersSection() {
        return cy.get('[data-cy="accordianFiltersBtn"]')
    }
    selectedCutsSection() {
        return cy.get('[data-cy="accordianSelectedCutsBtn"]')
    }
    ERISection() {
        return cy.get('[data-cy="accordianERIBtn"]')
    }
    BlendSection() {
        return cy.get('[data-cy="accordianBlendBtn"]')
    }
    combinedAvgSection() {
        return cy.get('[data-cy="accordianCombinedAveragedBtn"]')
    }
    noDataSection() {
        return cy.get('[data-cy="deleteDialog"]')
    }
    deleteDialog() {
        return cy.get('#marketsegment-delete-dialog')
    }
    deleteYes(){
        return cy.get(".k-dialog [data-cy='yesConfirmation']")
    }
    deleteNo(){
        return cy.get(".k-dialog [data-cy='noConfirmation']")
    }

    //filters section

    publisherLabel() {
        return cy.get('[data-cy="publisher-filterMultipleSelect"] > .align-items-center > .form-label');
    }
    selectedPublisherLabel() {
        return cy.get('[data-cy="publisher-multiselect-autocomplete"]')
    }
    searchPublisherField() {
        return cy.get('[data-cy="publisher-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner');
    }
    yearLabel() {
        return cy.get('[data-cy="year-filterMultipleSelect"] > .align-items-center')
    }
    selectedYearLabel() {
        return cy.get('[data-cy="year-multiselect-autocomplete"]')
    }
    searchYearField() {
        return cy.get('[data-cy="year-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }

    surveyLabel() {
        return cy.get('[data-cy="survey-filterMultipleSelect"] > .align-items-center')
    }
    selectedSurveyLabel() {
        return cy.get('[data-cy="survey-multiselect-autocomplete"]')
    }
    searchSurveyField() {
        return cy.get('[data-cy="survey-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }
    industrySectorLabel() {
        return cy.get('[data-cy="industrySector-filterMultipleSelect"] > .align-items-center')
    }
    selectedIndustrySectorLabel() {
        return cy.get('[data-cy="industrySector-multiselect-autocomplete"]')
    }
    searchIndustrySectorField() {
        return cy.get('[data-cy="industrySector-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }
    orgTypeLabel() {
        return cy.get('[data-cy="organizationType-filterMultipleSelect"] > .align-items-center')
    }
    selectedOrgTypeLabel() {
        return cy.get('[data-cy="organizationType-multiselect-autocomplete"]')
    }
    searchOrgTypeField() {
        return cy.get('[data-cy="organizationType-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }
    cutGroupLabel() {
        return cy.get('[data-cy="cutGroup-filterMultipleSelect"] > .align-items-center')
    }
    selectedCutGroupLabel() {
        return cy.get('[data-cy="cutGroup-multiselect-autocomplete"]')
    }
    searchCutGroupField() {
        return cy.get('[data-cy="cutGroup-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }
    cutSubGroupLabel() {
        return cy.get('[data-cy="cutSubGroup-filterMultipleSelect"] > .align-items-center')
    }
    selectedCutSubGroupLabel() {
        return cy.get('[data-cy="cutSubGroup-multiselect-autocomplete"]')
    }
    searchCutSubGroupField() {
        return cy.get('[data-cy="cutSubGroup-filterMultipleSelect"] > .k-multiselect > .k-input-values > .k-input-inner')
    }
    listOptions() {
        return cy.get('ul#multiselect-autocomplete_listbox')
    }
    clearOptions() {
        return cy.get('[class="k-clear-value"]')
    }
    filtersSectionNextBtn() {
        return cy.get('[data-cy="nextBtnMSFilters"]')
    }
    viewDetailsBtn() {
        return cy.get('[data-cy="viewDetailBtn"]')
    }

    /// Servey Level Details Grid
    sldWindow() {
        return cy.get('[data-cy="survey-level-details"]', { timeout: 10000, interval: 1000 })
    }
    sldTitle() {
        return cy.get('[data-cy="modalTitle"]')
    }
    gridHeader() {
        return cy.get('.k-grid-header')
    }
    gridData() {
        return cy.get('.k-grid-container')
    }
    gridCloseBtn() {
        return cy.get('[data-cy="closeBtn"]')
    }


    spCol() {
        return cy.get('[data-cy="survey-publisher"] > .k-cell-inner > .k-link > .k-column-title')
    }
    syCol() {
        return cy.get('[data-cy="survey-year"] > .k-cell-inner > .k-link > .k-column-title')
    }
    snCol() {
        return cy.get('[data-cy="survey-name"] > .k-cell-inner > .k-link')
    }
    isCol() {
        return cy.get('[data-cy="industry-sector"] > .k-cell-inner > .k-link')
    }
    otCol() {
        return cy.get('[data-cy="org-type"] > .k-cell-inner > .k-link')
    }
    cgCol() {
        return cy.get('[data-cy="cut-group"] > .k-cell-inner > .k-link > .k-column-title')
    }
    csgCol() {
        return cy.get('[data-cy="cut-sub-group"] > .k-cell-inner > .k-link > .k-column-title')
    }
    cCol() {
        return cy.get('[data-cy="cut"] > .k-cell-inner > .k-link')
    }
    // MarketSegmentTab(){
    //     return cy.get('[data-cy="marketSegment"]')
    // }
    // MarketSegmentResultGrid(){
    //     return cy.get('.center-text')
    // }

    // projectIdField(){
    //     return cy.get('[data-cy="projectId"]')
    // }
    // margetSegmentResultGrid(){
    //     return cy.get('.center-text')
    // }
    // projectVersionField(){
    //     return cy.get('[data-cy="projectVersion"]')
    // }
    // projectVersionField(){
    //     return cy.get('.card-body')
    // }
    // Selected Cuts
    statusLabel() {
        return cy.get('.accordion-body > :nth-child(1) > .col-sm-12 > .form-group > .col-5')
    }
    statusField() {
        return cy.get('[data-cy="marketSegment-status"]')
    }
    masterRow() {
        return cy.get('k-alt k-table-row k-table-alt-row k-master-row')
    }
    orgType() {
        return cy.get('tbody tr td:nth-child(3)')
    }
    cutGroup() {
        return cy.get('tbody tr td:nth-child(4)')
    }
    marketPCField() {
        return cy.get('tbody tr td:nth-child(6)')
    }
    // marketPCField() {
    //     return cy.get(':nth-child(6) > .svelte-input-container > #cutName')
    // }

    //Buttons
    gridContentScroll() {
        return cy.get('#app')
    }
    previousBtn() {
        return cy.get('[data-cy="msSelectionCutSection-previousBtn"]')
    }
    saveBtn() {
        return cy.get('[data-cy="msSelectionCutSection-saveBtn"]')
    }
    selectedCutsSaveNextBtn() {
        return cy.get('[data-cy="msSelectionCutSection-saveNextBtn"]')
    }
    selectedCutsNextBtn() {
        return cy.get('[data-cy="msSelectionCutSection-nextBtn"]')
    }
    editDetailsBtn() {
        return cy.get('[data-cy="selectedCutsSection"] > .accordion-body > .flex-wrap > :nth-child(1) > [data-cy="viewDetailBtn"]')
    }
    checkMarkBtnEditDetails() {
        return cy.get('.k-text-center > .k-select-checkbox')
    }


    //Icons
    trashIcon() {
        return cy.get(':nth-child(1) >td > div > div > .fa-trash')
    }
    ConfirmYesNo() {
        return cy.get('[style*="display: flex"]')
    }
    ConfirmYes() {
        return cy.get('[style*="display: flex"] button').contains('Yes')
    }
    ConfirmNo() {
        return cy.get('[style*="display: flex"] button').contains('No')
    }
    gridSaveBtn() {
        return cy.get('[data-cy="saveBtn"]')
    }
    saveConf() {
        return cy.get('k-notification-content')
    }

    hamburgerIcon() {
        return cy.get(':nth-child(1) > .svelte-action-container > .d-flex > .fa-bars')
    }
    toTopIcon() {
        return cy.get(':nth-child(1) > .svelte-action-container > .d-flex > .fa-angle-double-up')
    }
    oneUpIcon() {
        return cy.get(':nth-child(1) > .svelte-action-container > .d-flex > .fa-angle-up')
    }
    oneDownIcon() {
        return cy.get(':nth-child(1) > .svelte-action-container > .d-flex > .fa-angle-down')
    }
    toBottomIcon() {
        return cy.get(':nth-child(1) > .svelte-action-container > .d-flex > .fa-angle-double-down')
    }

    cutSubGroupLink() {
        return cy.get('a[href*="#"]')
    }
    confirmationPopUp() {
        return cy.get('.k-window.k-dialog')
    }
    //ERI section
    ERISectionPreviousBtn() {
        return cy.get('.s-bMEL8R8ton_r > [data-cy="previousBtn"]')
    }
    ERISectionNextBtn() {
        return cy.get('.s-bMEL8R8ton_r > [data-cy="nextBtn"]')
    }
    ERISectionSaveBtn() {
        return cy.get('[data-cy="saveBtnEri"]')
    }
    ERISectionSaveNextBtn() {
        return cy.get('.s-bMEL8R8ton_r > [data-cy="saveNextBtn"]')
    }
    ERIGrid() {
        return cy.get('.s-bMEL8R8ton_r > tr:nth-child(1)')
    }

    ERIAdjFactor() {
        return cy.get('[data-cy="eriAdjustmentFactorInput"]')
    }
    ERICutName() {
        return cy.get('[data-cy="eriItem.eriCutName-input"]')
    }
    ERICutCity() {
        return cy.get('[data-cy="eriItem.eriCity-input"]')
    }

    //Blend section

    blendNameLabel() {
        return cy.get('[data-cy="blendNameLabel"]')
    }
    blendNameField() {
        return cy.get('.typeahead')
    }
    blendNameOptions() {
        return cy.get('.form-group .dropdown-item')
    }
    blendCutGroupLabel() {
        return cy.get('[data-cy="cutGroupLabel"]')
    }
    blendCutGroupOptions() {
        return cy.get('#cutGroup option')
    }
    blendCutGroupDropdown() {
        return cy.get('#cutGroup')
    }
    blendCutGroupDisabled() {
        return cy.get('#cutGroupDisabled')
    }
    blendTotalsLabel() {
        return cy.get('[data-cy="totalsLabel"]')
    }
    blendTotalsInputField() {
        return cy.get('[data-cy="totalsControl-input"]')
    }
    blendGrid() {
        return cy.get('[data-cy="blendSection"] > div > div:nth-child(1) > div:nth-child(2) > table > thead > tr')
    }
    blendsMsg() {
        return cy.get('.text-center.s-dXly0-m3kae8')
    }
    addBlendBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="addBlendBtn"]')
    }
    blendPreviousBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="previousBtn"]')
    }
    blendNextBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="nextBtn"]')
    }
    blendSaveBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="saveBtn"]')
    }
    blendSaveNextBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="saveNextBtn"]')
    }
    blendViewDetailsBtn() {
        return cy.get('.s-dXly0-m3kae8 > [data-cy="viewDetailBtn"]')
    }
    blendCutSubGroupCheckBox1() {
        return cy.get(':nth-child(1) > :nth-child(1) > [data-cy="blendDataCheckbox"]')
    }
    blendCutSubGroupCheckBox2() {
        return cy.get(':nth-child(2) > :nth-child(1) > [data-cy="blendDataCheckbox"]')
    }
    blendWeightField1() {
        return cy.get(':nth-child(1) > :nth-child(6) > div > div > [data-cy="blendWeight-input"]')
    }
    blendWeightField2() {
        return cy.get(':nth-child(2) > :nth-child(6) > div > div > [data-cy="blendWeight-input"]')
    }

    //combined Avg

    addCombinedAvgBtn() {
        return cy.get('[data-cy="addCombinedAverageBtn"]')
    }
    combinedAvgPreviousBtn() {
        return cy.get('[data-cy="msCombinedAverageSection-previousBtn"]')
    }
    combinedAvgNextBtn() {
        return cy.get('[data-cy="msCombinedAverageSection-nextBtn"]')
    }
    combinedAvgSaveBtn() {
        return cy.get('[data-cy="msCombinedAverageSection-saveBtn"]')
    }
    combinedAvgSaveNextBtn() {
        return cy.get('[data-cy="msCombinedAverageSection-saveNextBtn"]')
    }
    combinedAvgGrid() {
        return cy.get('#combined-average-grid')
    }
    combinedAvgNameLabel() {
        return cy.get("label[for='combinedAverageName']")
    }
    combinedAvgNameField() {
        return cy.get('#combinedAverageName')
    }
    combinedAvgModalGridHeader() {
        return cy.get('#combined-average-modal-grid > .k-grid-header')
    }
    combinedAvgModalGridData() {
        return cy.get('#combined-average-modal-grid > div > .k-grid-content >.k-grid-table')
    }
    combinedAvgModalSaveBtn() {
        return cy.get('[data-cy="saveBtn"]')
    }
    combinedAvgModalCloseBtn() {
        return cy.get('[data-cy="closeBtn"]')
    }
    combinedAvgModalGridCheckbox() {
        return cy.get('input[type="checkbox"]')
    }
    combinedAvgModalChkBx1() {
        return cy.get(':nth-child(1) > :nth-child(1) > .svelte-checkbox-container > .form-check-input')
    }
    combinedAvgModalChkBx2() {
        return cy.get(':nth-child(2) > :nth-child(1) > .svelte-checkbox-container > .form-check-input')
    }
    combinedAvgModalChkBx3() {
        return cy.get(':nth-child(3) > :nth-child(1) > .svelte-checkbox-container > .form-check-input')
    }
    combinedAvgLink() {
        return cy.get(':nth-child(2) > .svelte-link-container > p.s-7l7gZ0XWQGNi > a')
    }
    combinedAvgModalTitle() {
        return cy.get('[data-cy="modalTitle"]')
    }
}

const marketSegment = new MarketSegment();
export default marketSegment;
