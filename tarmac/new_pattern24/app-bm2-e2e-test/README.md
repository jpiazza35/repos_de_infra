# Introduction
Benchmark 2.0 Readme

## Prerequisite Setup Steps
Before running the application, ensure you follow these setup steps:

<details>
<summary>Steps to follow</summary>
<p>

- **Install [Node.js](https://nodejs.org/en/):** Choose the recommended version.
- **Install [Git](https://git-scm.com/):**
- **Install [Visual Studio Code](https://code.visualstudio.com/):**
- **Clone the repository:** Use the [Benchmark 2.0 Automation Repo Link](https://github.com/clinician-nexus/app-bm2-e2e-test/tree/main) to clone the `Benchmark 2.0 E2E` repository.
</p>
</details>

## How to Run
To run the application, follow these steps:

- **Navigate to the project directory.**
- **Install dependencies:** Run `npm install` (ensure you are not on a VPN).
- **Run tests with Cypress App Viewer:** Execute `npm run cy:open`.
- **Run tests through Cypress CLI:** Execute `npm run cy:run`.
- **Run tests through Cypress CLI with Video Recording:** Execute `npm run cy:run-video`.
- **Run tests through Cypress CLI with Cucumber tags:** Execute `npm run cy:run-tags`.

## Creating Tests
When creating tests, adhere to these guidelines:

- **UI tests:** Place them inside `cypress/e2e/ui`.
- **API tests:** Place them inside `cypress/e2e/api`.
- **File format:** Use the `name.cy.js` format for test files.
- **Page objects:** Create them inside the `cypress/pages` folder.
- **Naming convention:** Ensure meaningful names for both test files and page objects to align with the tested story.