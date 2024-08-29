class MarketPricingSheet {
    marketPricingSheettab(){
        return cy.get('#marketpricingsheetTab')
    }

    fullscrBtn(){
        return cy.get('button').contains('Full Screen')
    }

    hidePane(){
        return cy.get('.bd-highlight button').contains('Hide Pane')
    }

    showPane(){
        return cy.get('.bd-highlight button').contains('Show Pane')
    }

    addExternalData(){
        return cy.get('.bd-highlight button').contains('Add External Data')
    }

    export(){
        return cy.get('.bd-highlight button').contains('Export')
    }

    statusChange(){
        return cy.get('.dropdown button#dropdownMenuLink')
    }
    
    card(){
        return cy.get('.card')
    }

    mainSettings(){
        return cy.get('.card .card-header').contains('Main Settings')
    }

    percentiles (){
        return cy.get('.card .card-header').contains('Percentiles')
    }

    filters(){
        return cy.get('.card .card-header').contains('Filters')
    }

    sortBy(){
        return cy.get('.card .card-header').contains('Sort By')
    }

    marketPricingSheet(){
        return cy.get('.card .card-header').contains('Market Pricing Sheet')
    }

    clientPositionDetail(){
        return cy.get('.card .card-header').contains('Client Position Detail')
    }

    clientPayDetail(){
        return cy.get('.card .card-header').contains('Client Pay Detail')
    }

    jobMatchDetail(){
        return cy.get('.card .card-header').contains('Job Match Detail')
    }

    marketDataDetail(){
        return cy.get('.card .card-header').contains('Market Data Detail')
    }

    notes(){
        return cy.get('.card .card-header').contains('Notes')
    }

    listJobCode(){
        return cy.get('#list-jobCode')
    }

    leftMenu(){
        return cy.get('#leftMenu')
    }

    marketPricingStatus(){
        return cy.get("[title='Market Pricing Status']")
    }

    uploadFile(){
        return cy.get('#fileid')
    }

    saveAndClose(){
        return cy.get("[data-cy='close']")
    }

    gridHolder(){
        return cy.get('#gridHolder')
    }

    method(){
        return cy.get('')
    }
    
    method(){
     
        return cy.get('')
    }
    method(){
        return cy.get('')
    }
}

const marketPricingSheet = new MarketPricingSheet();
export default marketPricingSheet;


// Survey Cut Columns
// Age to Date
// Pay Range Maximum
// Annual Pay Range Minimum
// Target Annual Incentive
// Client Job Code or Title
// Client Job Group
// Market Segment Name
// 1st
// 2nd
// 3rd
// 4th
