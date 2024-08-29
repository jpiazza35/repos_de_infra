class ProjectDetails {
    modalTitle() {
        return cy.get('[data-cy="modelTitle"]')
    }
    projInfoCardHeader() {
        return cy.get('[data-cy="projectInfoTitle"]')
    }
    sourceDataInfoCardHeader() {
        return cy.xpath('(//h6[normalize-space()="Source Data Info"])[1]')
    }
    benchmarkDataTypeInfoCardHeader() {
        return cy.get('[data-cy="benchMarkDataTypeInfoTitle"]')
    }

    //field labels
    orgLabel() {
        return cy.get('[data-cy="orgLabel"]')
    }
    versionDateLabel() {
        return cy.get('[data-cy="versionDateLabel"]')
    }
    projectStatusLabel() {
        return cy.get('[data-cy="statusLabel"]')
    }
    projectNameLabel() {
        return cy.get('[data-cy="nameLabel"]')
    }
    versionLabel() {
        return cy.get('[data-cy="versionLabel"]')
    }
    projectVersionLabel() {
        return cy.get('[data-cy="projectVersionLabel"]')
    }
    aggMethodologyLabel() {
        return cy.get('[data-cy="aggregationLabel"]')
    }
    workforceProjectTypeLabel() {
        return cy.get('[data-cy="workforceLabel"]')
    }
    sourceDataLabel() {
        return cy.get('[data-cy="sourceDataLabel"]')
    }
    effectiveDateLabel() {
        return cy.get('[data-cy="effectiveDateLabel"]')
    }
    uploadDataLabel() {
        return cy.get('[data-cy="uploadDataLabel"]')
    }

    //fields
    orgField() {
        return cy.get('[data-cy="organization"]')
    }
    versionDateField() {
        return cy.get('[data-cy="versionDateValue"]')
    }
    projectStatusDropdown() {
        return cy.get('[data-cy="statusValue"]')
    }
    projectNameField() {
        return cy.get('[data-cy="name-input"]')
    }
    projectVersionField() {
        return cy.get('[data-cy="version-input"]')
    }
    projectVersionLabelField() {
        return cy.get('[data-cy="versionLabel-input"]')
    }
    aggMethodologyField() {
        return cy.get('[data-cy="aggregationValue"]')
    }
    workforceProjectTypeField() {
        return cy.get('[data-cy="workforceValue"]')
    }
    autoCompleteList() {
        return cy.get('ul[id=autocomplete-items-list]')
    }

    //radio buttons
    noDataLabel() {
        return cy.get('[data-cy="noDataLabel"]')
    }
    noDataRadioBtn() {
        return cy.get('[data-cy="noDataValue"]')
    }
    useExistingLabel() {
        return cy.get('[data-cy="useExistingLabel"]')
    }
    useExistingRadioBtn() {
        return cy.get('[data-cy="useExistingValue"]')
    }
    uploadNewLabel() {
        return cy.get('[data-cy="uploadNewLabel"]')
    }
    uploadNewRadioBtn() {
        return cy.get('[data-cy="uploadNewValue"]')
    }

    //radio values
    uploadDataValue() {
        return cy.get('[data-cy="uploadDataValue"]')
    }
    sourceDataValue() {
        return cy.get('[data-cy="sourceDataValue"]')
    }
    effectiveDateValue() {
        return cy.get('[data-cy="effectiveDateValue2"]')
    }

    //benchmark data info type table column headers
    includeColumn() {
        return cy.get('[data-cy="include"]')
    }
    includeCheckbox() {
        return cy.get('input[type="checkbox"]')
    }
    benchmarkDataTypeColumn() {
        return cy.get('[data-cy="benchmarkDataType"]')
    }
    agingFactorColumn() {
        return cy.get('[data-cy="agingFactor"]')
    }
    agingFactorValue() {
        return cy.xpath('td[3]')
    }
    agingFactorOverrideColumn() {
        return cy.get('[data-cy="agingFactorOverride"]')
    }
    agingFactorOverrideInput() {
        return cy.get('input[data-cy="overrideAgingFactor-input"]')
    }
    overrideNoteColumn() {
        return cy.get('[data-cy="overrideNote"]')
    }
    overrideNoteInput() {
        return cy.get('input[data-cy="overrideNote-input"]')
    }

    //benchmark data info type table column values
    benchmarkDataTypeTable() {
        return cy.get('[class="table table-bordered s-m_AlPb-rowuc"]')
    }
    benchmarkDataTypeTableHeader() {
        return cy.get('th[class="s-m_AlPb-rowuc"]')
    }
    benchmarkDataTypeTableBody() {
        return cy.get('tbody[class="s-m_AlPb-rowuc"]')
    }
    benchmarkDataTypeTableRow() {
        return cy.get('tr[class="s-m_AlPb-rowuc"]')
    }
    benchmarkDataTypeTableCell() {
        return cy.get('td[class="s-m_AlPb-rowuc"]')
    }

    // default benchmark data types
    actualAnnualIncentive() {
        return cy.get('[data-cy="Actual Annual Incentive"]')
    }
    annualIncentiveMaximumOpportunity() {
        return cy.get('[data-cy="Annual Incentive Maximum Opportunity"]')
    }
    annualIncentiveReceiving() {
        return cy.get('[data-cy="Annual Incentive Receiving"]')
    }
    annualIncentiveThresholdOpportunity() {
        return cy.get('[data-cy="Annual Incentive Threshold Opportunity"]')
    }
    annualizedPayRangeMaximum() {
        return cy.get('[data-cy="Annualized Pay Range Maximum"]')
    }
    annualizedPayRangeMidpoint() {
        return cy.get('[data-cy="Annualized Pay Range Midpoint"]')
    }
    annualizedPayRangeMinimum() {
        return cy.get('[data-cy="Annualized Pay Range Minimum"]')
    }
    basePayHourlyRate() {
        return cy.get('[data-cy="Base Pay Hourly Rate"]')
    }
    payRangeMaximum() {
        return cy.get('[data-cy="Pay Range Maximum"]')
    }
    payRangeMidpoint() {
        return cy.get('[data-cy="Pay Range Midpoint"]')
    }
    payRangeMinimum() {
        return cy.get('[data-cy="Pay Range Minimum"]')
    }
    targetAnnualIncentive() {
        return cy.get('[data-cy="Target Annual Incentive"]')
    }
    thresholdIncentivePercent() {
        return cy.get('[data-cy="Threshold Incentive Percent"]')
    }

    //buttons
    saveBtn() {
        return cy.get('[data-cy="save"]')
    }
    clearBtn() {
        return cy.get('[data-cy="cancel"]')
    }
    closeBtn() {
        return cy.get('[data-cy="close"]')
    }
    popUpClose() {
        return cy.get('[data-cy="popup-close"]')
    }

    //confirmation pop up
    confirmationPopUp() {
        return cy.get('div.k-window.k-dialog')
    }
    confirmationPopUpTitle() {
        return cy.get('.k-window-title.k-dialog-title')
    }
    confirmationPopUpMessage() {
        return cy.get('#dialog')
    }
    confirmationPopUpYesBtn() {
        return cy.get('[data-cy="yesConfirmation"]')
    }
    confirmationPopUpNoBtn() {
        return cy.get('[data-cy="noConfirmation"]')
    }
    confirmationNotification() {
        return cy.get('.k-notification-content')
    }
    errorNotification() {
        return cy.get('.k-notification-error')
    }
    deleteProjectModal() {
        return cy.get('[data-cy="deleteProjectModal"]')
    }

    //sourceData
    existingFileDataEffectiveDate() {
        return cy.get('[data-cy="fileLogKey"]')
    }

    projectDetailsCardHeader() {
        return cy.get('.card > .card-header')
    }

}
const projectDetails = new ProjectDetails();
export default projectDetails;
