import { toCamelCase } from '../../../../src/utils/strings'

describe('Tile Component testing', () => {
  let tilesData
  beforeEach(() => {
    cy.fixture('tile')
      .as('dataFixture')
      .then(data => {
        tilesData = data
      })
    cy.visit('/')
  })

  const createDataCyTile = (title, type) => {
    const modifiedTitle = toCamelCase(title)
    const tileCy = `tile-${type}-${modifiedTitle}`
    return tileCy
  }

  it('01 - Should render Tiles titles', () => {
    tilesData.PHYSICIAN_TILES.forEach(tile => {
      const dataCyy = createDataCyTile(tile.title, tile.type)
      cy.get(`[data-cy=${dataCyy}]`).should('be.visible')
      cy.get(`[data-cy=${dataCyy}]`).should('include.text', tile.title)
    })
  })

  it('02 - Should click and enter on a market report dashboard', () => {
    const dataCyy = createDataCyTile('Market Report', 'physician')
    cy.get(`[data-cy=${dataCyy}]`).should('be.visible')
    cy.get(`[data-cy=${dataCyy}]`).click()

    cy.url().should('include', '/physician/marketReport')

    cy.get('[data-cy="logo-sulivan"]').as('homeBtn')
    cy.get('@homeBtn').should('be.visible')
    cy.get('@homeBtn').click()
  })

  it('03 - Should Click, enter and get home on each tile from physician', () => {
    cy.get('[data-cy="logo-sulivan"]').as('homeBtn')

    tilesData.PHYSICIAN_TILES.forEach(tile => {
      const dataCyy = createDataCyTile(tile.title, tile.type)
      cy.get(`[data-cy=${dataCyy}]`).should('be.visible')
      cy.get(`[data-cy=${dataCyy}]`).should('include.text', tile.title)
      cy.get(`[data-cy=${dataCyy}]`).click()

      cy.url().should('include', tile.url)

      cy.get('@homeBtn').click()
    })
  })
  it('04 - Should Click, enter and get home on each tile from Advanced Practice Provider', () => {
    cy.get('[data-cy="logo-sulivan"]').as('homeBtn')

    tilesData.ADVANCED_PRACTICE_PROVIDER_TILES.forEach(tile => {
      const dataCyy = createDataCyTile(tile.title, tile.type)
      cy.get(`[data-cy=${dataCyy}]`).should('be.visible')
      cy.get(`[data-cy=${dataCyy}]`).should('include.text', tile.title)
      cy.get(`[data-cy=${dataCyy}]`).click()

      cy.url().should('include', tile.url)

      cy.get('@homeBtn').click()
    })
  })
  it('05 - Should Click, enter and get home on each tile from Other Studies', () => {
    cy.get('[data-cy="logo-sulivan"]').as('homeBtn')

    tilesData.OTHER_STUDIES_TILES.forEach(tile => {
      const dataCyy = createDataCyTile(tile.title, tile.type)
      cy.get(`[data-cy=${dataCyy}]`).should('be.visible')
      cy.get(`[data-cy=${dataCyy}]`).should('include.text', tile.title)
      cy.get(`[data-cy=${dataCyy}]`).should('have.attr', 'target', '_blank')
      cy.get(`[data-cy=${dataCyy}]`).should('have.attr', 'href', tile.url)
      cy.get('@homeBtn').click()
    })
  })
  it('06 - Tile should have Text and Icon cy defined', () => {
    tilesData.PHYSICIAN_TILES.forEach(tile => {
      cy.get(`[data-cy=tile-${tile.type}-${toCamelCase(tile.title)}]`).should('be.visible')
      cy.get(`[data-cy=${toCamelCase(tile.title)}-text-cy]`).should('be.visible')
      cy.get(`[data-cy=icon-${tile.icon}-cy]`).should('be.visible')
    })
    tilesData.ADVANCED_PRACTICE_PROVIDER_TILES.forEach(tile => {
      cy.get(`[data-cy=tile-${tile.type}-${toCamelCase(tile.title)}]`).should('be.visible')
      cy.get(`[data-cy=${toCamelCase(tile.title)}-text-cy]`).should('be.visible')
      cy.get(`[data-cy=icon-${tile.icon}-cy]`).should('be.visible')
    })
    tilesData.OTHER_STUDIES_TILES.forEach(tile => {
      cy.get(`[data-cy=tile-${tile.type}-${toCamelCase(tile.title)}]`).should('be.visible')
      cy.get(`[data-cy=${toCamelCase(tile.title)}-text-cy]`).should('be.visible')
      cy.get(`[data-cy=icon-${tile.icon}-cy]`).should('be.visible')
    })
  })
})
