class ProjectDetail
{

getModelTitle()
{
    return cy.get('h5[data-cy=modelTitle]')
}

getOrganization()
{
    return cy.get('div.window input[data-cy=organization]')
}

getAutoCompleteItem()
{
    return 'li.autocomplete-items';
}

getProjectInput()
{
    return cy.get('div.window input[data-cy=name-input]')
}

getSaveButton()
{
    return cy.get('div.window button[data-cy=save]')
}

getCloseButton()
{
    return cy.get('div.window button[data-cy=close]')
}

getDetailLink()
{
    return cy.get("button.k-grid-Details > span.k-button-text")
}

getProjectTitle()
{
    return cy.get('h5[data-cy=modelTitle]')
}

getIncludeCheck(row)
{
    return cy.get("div.accordion-body table>tbody>tr:nth-child(" + row + ") td:nth-child(1) input[type=checkbox]")
}

getAgeFactorOverride(row)
{
    return cy.get("div.accordion-body table>tbody>tr:nth-child(" + row + ") td:nth-child(4) input[data-cy=overrideAgingFactor-input]")
}

getOverrideNotes(row)
{
    return cy.get("div.accordion-body table>tbody>tr:nth-child(" + row + ") td:nth-child(5) input[data-cy=overrideNote-input]")
}

getSaveButton()
{
    return cy.get('div.window button[data-cy=save]')
}

getCloseButton()
{
    return cy.get('div.window button[data-cy=close]')
}

}
export default ProjectDetail;
