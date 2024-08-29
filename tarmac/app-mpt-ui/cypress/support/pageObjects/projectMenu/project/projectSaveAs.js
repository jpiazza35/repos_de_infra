class ProjectSaveAs
{

getModelTitle()
{
    return cy.get('h5[data-cy=modelTitle]')
}

getProjectInput()
{
    return cy.get('div.window input[data-cy=name-input]')
}

getProjectSaveButton()
{
    return cy.get('div.window button[data-cy=save]')
}

getModelClose()
{
    return cy.get('div.window button[data-cy=popup-close]')
}

}
export default ProjectSaveAs;
