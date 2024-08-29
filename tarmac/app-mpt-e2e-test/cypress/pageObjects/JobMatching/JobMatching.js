class JobMatching {
    // JobMapping Tab
    jobMatchingTab(){
        return cy.get("[data-cy='tabs'] [data-cy='jobMatching']")
    }
    methodologyInput(){
        return cy.get('#jobMatchingTab input')
    }
    methodology(){
        return cy.get('#jobMatchingTab label')
    }
    // Buttons
    jobMatch(){
        return cy.get('#jobMatchingTab button[data-cy="jobmatchbtn"]')
    }
    statusChange(){
        return cy.get("#jobMatchingTab button#statusChangeLink")
    }
    exportBtn(){
        return cy.get("#jobMatchingTab button[data-cy='export']")
    }
    settingsIcon(){
        return cy.get('#jobMatchingTab button#popoverColumns i')
    }
    settingsOptions(){
        return cy.get('.popover .popover-body')
    }
    fullScreen(){
        return cy.get("#jobMatchingTab button[data-cy='fullscreen']")
    }
    grid(){
        return cy.get("#jobMatchingTab [data-role='grid']")
    }

    gridTableheader(){
        return cy.get('#jobMatchingTab table thead')
    }
    gridTablebody(){
        return cy.get('#jobMatchingTab table tbody')
    }
    tableHeaders(){
        return cy.get('#jobMatchingTab table thead tr th.k-header')
    }
    itemsCount(){
        return cy.get('#jobMatchingTab p.items-count-indicator')
    }

    checkRow(){
        return cy.get("input[type='checkbox']")
    }

    enterfilter(){
        return cy.get('.k-grid-filter-menu .k-svg-i-filter')
    }
    // filters
    filterButton(){
        return cy.get(".k-animation-container-shown button[title='Filter']")
    }

    enterfiltertext(){
        return cy.get(".k-animation-container-shown .k-popup input[title='Value']")
    }

    clearFilterButton(){
        return cy.get(".k-animation-container-shown button[title='Clear']")
    }
    // Popup
    jobMatchPopup(){
        return cy.get("#jobMatchingTab [aria-modal='true'][role='dialog']")
    }

    jobMatchPopupClose(){
        return cy.get("#jobMatchingTab button#popup-close")
    }
    // Filters
    organizationFilter(){
        return cy.get("#jobMatchingTab a[title='Organization filter column settings']")
    }
    clientJobCodeFilter(){
        return cy.get("#jobMatchingTab a[title='Client Job Code filter column settings']")
    }
    clientPositionCodeFileter(){
        return cy.get("#jobMatchingTab a[title='Client Position Code filter column settings']")
    }
    clientJobTitleFileter(){
        return cy.get("#jobMatchingTab a[title='Client Job Title filter column settings']")
    }
    clientJobGroupFilter(){
        return cy.get("#jobMatchingTab a[title='Client Job Group filter column settings']")
    }
    marketSegmentFilter(){
        return cy.get("#jobMatchingTab a[title='Market Segment filter column settings']")
    }
    standardJobCodeFilter(){
        return cy.get("#jobMatchingTab a[title='Standard Job Code filter column settings']")
    }
    standardJobTitleFilter(){
        return cy.get("#jobMatchingTab a[title='Standard Job Title filter column settings']")
    }
    standardJobDescriptionFilter(){
        return cy.get("#jobMatchingTab a[title='Standard Job description filter column settings']")
    }
    matchStatusFilter(){
        return cy.get("#jobMatchingTab a[title='Match Status filter column settings']")
    }
    jobmatchNotesFilter(){
        return cy.get("#jobMatchingTab a[title='Job Match Notes filter column settings']")
    }

    alret(){
        return cy.get('#jobMatchingTab .alert')
    }

    //Job Match Popup
    selectedJobs(){
        return cy.get('.window .border-right .align-items-center .align-items-center')
    }

    reset(){
        return cy.get("button[data-cy='resetBtn']")
    }

    saveAndClose(){
        return cy.get("button[data-cy='saveBtn']")
    }

    searchStandard(){
        return cy.get('input.searchStandardsInput')
    }

    autocompleteItems(){
        return cy.get('#autocomplete-items-list li')
    }

    standardGrid(){
        return cy.get('.window table.standard-table')
    }

    auditTable(){
        return cy.get('table.audit-table')
    }

    publisher(){
        return cy.get("select[data-cy='publisherName']")
    }

    jobCode(){
        return cy.get('input#jobCode')
    }

    jobTitle(){
        return cy.get('input#jobTitle')
    }

    jobDescription(){
        return cy.get('textarea#jobDescription')
    }

    jobMatchStatus(){
        return cy.get('select#jobMatchStatusKey')
    }

    jobMatchNotes(){
        return cy.get('textarea#jobMatchNotes')
    }

    resetDialog(){
        return cy.get('#jobMatching-reset-dialog')
    }

    textAlert(){
        return cy.get('span.text-danger')
    }

    blendNotes(){
        return cy.get("input[placeholder='Enter Blend Note']")
    }

    blendPercentage(){
        return cy.get("input[placeholder='Blend Percentage']")
    }

    deleteStandards(){
        return cy.get(".bi-trash")
    }

    warningAlert(){
        return cy.get('.alert.alert-warning')
    }

    confirmation(){
        return cy.get('#dialog').first()
    }

}
const jobMatching = new JobMatching();
export default jobMatching;