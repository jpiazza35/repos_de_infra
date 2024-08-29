
# Benchmark 2.0 
 

## Description
Benchmarks 2.0 is a rewrite of the original Benchmarks360 system, but focused initially on the Physician and APP workforces. The goal is to display survey data to the user in a variety of ways and let users compare their organization data to the market.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [How to Start](#how-to-start)
  - [How to Commit](#how-to-commit)
- [Scripts](#scripts)
  - [Cypress Tests](#cypress-tests)
- [Project Stack](#project-stack)
- [Dependencies](#dependencies)
  - [Development Dependencies](#development-dependencies)
  - [Production Dependencies](#production-dependencies)


## Getting Started

  

### Prerequisites

- Git Hub Codespaces https://github.com/codespaces  

### Installation
 

1. Create a Codespace with options: [New Codespace with Options](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=725151355&skip_quickstart=true)
2. Select the eight (8) RAM Machine and proceed
3. Connect to it with your Visual Studio Code
4. Open and select the folder ``/workspaces/``
```In the workspaces folder we have our UI folder which we run our commands on the terminal ```

## How to Start

Follow these step-by-step instructions to set up and run the BM2.0 project

1. **Create a Codespace:**
   - Create a [New Codespace with Options](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=your-username/app-bm2-ui&skip_quickstart=true). Selecting the eight (8) RAM Machine.

2. **Connect to Codespace with Visual Studio Code:**
   - Open and connect to the Codespace using Visual Studio Code.

3.  **Open workspace folder:**
   - In Visual Studio Code, open the ```/workspaces/``` folder in the folder explorer.
  
5. **Open Terminal and Navigate to the UI Folder:**
   - In Visual Studio Code, open the terminal.
   - Run the following commands:
     ```bash
     cd /workspaces/app-bm2-ui
     ```

6. **Install Dependencies:**
   - Run to install project dependencies:
     ```bash
     npm install
     ```

8. **Run the Front-end App:**
   - Start the development server:
     ```bash
     npm run dev
     ```

9. **Open a New Terminal for the Database:**
   - Open a new terminal in Visual Studio Code.
   - Verify if the folder is the ui, other wise run:
     ```bash
     cd /workspaces/app-bm2-ui
     ```

10. **Start the Database:**
   - Run the following command to start the database using Docker Compose:
     ```bash
     npm run start-db
     ```

11. **Start Backend Processes:**
   - While the database is starting, open another terminal in the UI folder.
   - Run the following command to start the backend:
     ```bash
     npm run start-backend
     ```

13. **Access the Application:**
    - Open your web browser and navigate to `http://localhost:5173` to access the running Svelte application.

Now, the benchmark 2.0 is set up and running in the Codespace. For more scripts and other related running process, check [Scripts section](#scripts).

## How to Commit

Follow these steps to commit your changes to the project repository.

1. **Stage Changes:**
   - Use the `git add` command to stage the changes you want to commit. You can either stage specific files or all changes. For example, to stage all changes, run:
     ```bash
     git add .
     ```

2. **Commit Changes:**
   - After staging your changes, run ```npm run commit```. Provide a meaningful commit message that describes the purpose of your changes on the open file, save and close.
 - Or use the following command:
     ```bash
     git commit -m "commit message here"
     ```

4. **Husky Hooks (Pre-Commit):**
   - Before the commit is finalized, Husky will run pre-commit hooks to enforce linting and formatting standards. If there are any issues, resolve them before proceeding.

5. **Push to Remote Repository:**
   - If you're working in a branch and want to push your changes to the remote repository (GitHub), use the `git push` command. Replace `main` with the branch name if you're working in a different branch:
     ```bash
     git push origin main
     ```

6. **Pull Changes (Optional):**
   - If you encounter a message indicating that your branch is behind the remote repository, it's recommended to pull the latest changes before pushing your commits. Use the following command:
     ```bash
     git pull origin main
     ```

7. **Resolve Conflicts (If Any):**
   - If there are conflicts during the pull, resolve them in your local working copy.

8. **Push Again (If Needed):**
   - After resolving conflicts (if any), push your changes to the remote repository again using the `git push` command.

9. **Verify Changes on GitHub:**
   - Visit [pull requests](https://github.com/clinician-nexus/app-bm2-ui/pulls) and verify that your commits are reflected on GitHub.

## Scripts

These scripts are shortcuts for used tasks during development, testing, building, start and comitting process. They make it easier to perform various actions without having to remember or type long command-line instructions. =)

```npm run```:	
-   **dev**: Runs the development server using Vite    
 
-   **build**: Builds the project for production, generating optimized and minified assets ready for deployment.
 
-   **preview**: Previews the production build locally, enabling you to test the production-ready version of your application before deploying it.

-   **cy:run**: Executes Cypress tests    
 
-   **lint**: Lints the code using ESLint, identifying and fixing common code style and formatting issues in both JavaScript and Svelte files.
 
-   **format**: Formats the code using Prettier  
  
-   **prepare**: Installs Husky hooks, setting up pre-commit hooks to enforce linting and formatting standards before each commit.
    
-   **cypress**: Opens the Cypress test runner, providing a graphical interface for managing and running your Cypress tests.
    
-   **checkout:ui**: Checks out the main branch and pulls changes for the current repository
    
-   **checkout:bm2-service**: Checks out the main branch and pulls changes for the `app-bm2-service` repository, synchronizing changes from the backend service.
    
-   **checkout-main**: Runs parallel Git checkout commands for both repositories, streamlining the process of updating both the UI and service code.
    
-   **start:bm2-service-api**: Starts the BM2 service API using Go, enabling you to run the backend service locally during development.
    
-   **start-db**: Starts the database using Docker Compose, initializing the database environment.
    
-   **stop-db**: Stops the database using Docker Compose, terminating the database environment.
    
-   **reset-db-volumes**: Stops the database and removes volumes using Docker Compose.
    
-   **start-backend**: Starts the database and other backend-related processes in parallel using npm-run-all.

### Cypress Tests

#### How to run Cypress tests from codespace
- **Prerequisite: Start the Application:**
  - Ensure that the Svelte application is running by executing `npm run dev`. 
  This should start your application on `http://localhost:5173`.

- **Headless:**
  - Run `npm run cy:run` to execute Cypress tests in headless mode without the Cypress Test Runner UI.

- **In Browser:**
  - Ensure the application and the required services are running. Check the VS Code Port Window to confirm that the ports are open. (Usually 2 ports will be already set up, we are using the 6080)
  - Open `http://localhost:6080` in your browser and log in with the default password `vscode`.
  - In VS Code, run `npm run cy:open` to open the Cypress Test Runner interface.
  - Voilà, your environment is set up and ready for testing.

#### Folder Structure
- `cypress/`: Contains all Cypress tests and related files.
  - `component/`: Component tests for isolated Svelte components.
  - `e2e/`: End-to-end tests that simulate real user scenarios.
    - `api/`: Tests for API endpoints and integration.
    - `ui/`: Tests for user interface interactions and workflows.
  - `fixtures/`: Static data for tests, used to mock responses or provide consistent test data.
  - `pageObjects/`: Encapsulates data selectors and actions for pages, promoting code reuse and reducing maintenance.
  - `support/`: Custom commands and configurations that extend Cypress's capabilities.

#### Troubleshooting
- If you encounter issues with ports not being available, check to ensure that no other services are running on the required ports. We are Exposing the `6080` for the test environment.
- For failed tests, check the screenshots captured by Cypress in the `screenshots/` directory for clues on what went wrong.
- If custom commands in the `support/` directory are not recognized, ensure that they are correctly imported in your test files.

## Project Stack

- **Frontend Framework:** [Svelte](https://svelte.dev/)
- **Bundling and Development Server:**  [Vite](https://vitejs.dev/)

- **Styling:**  [Tailwind CSS](https://tailwindcss.com/),                        [Sass](https://sass-lang.com/)

- **State Management:** [@tanstack/svelte-query](https://svelte-query.tanstack.com/)

- **Routing:**  [Svelte Routing](https://github.com/EmilTholin/svelte-routing)

- **Icons:** [Flowbite Icons](https://flowbite.com/docs/svelte/icons/)

- **Date Manipulation:** [Day.js](https://day.js.org/)

- **Charts:** [AmCharts 5](https://www.amcharts.com/)

- **Authentication:**  [Auth0 SPA SDK](https://auth0.com/docs/quickstart/spa/vanillajs/01-login)

- **Testing:** [Cypress](https://www.cypress.io/)

- **Linting and Formatting:** [ESLint](https://eslint.org/), [Prettier](https://prettier.io/)

- **Git Hooks:** [Husky](https://typicode.github.io/husky/): A tool to easily set up Git hooks.

- **Git Workflow Automation:** [npm-run-all](https://www.npmjs.com/package/npm-run-all): A CLI tool to run multiple npm scripts in parallel or sequential.

- **Database and Backend:** [Docker Compose](https://docs.docker.com/compose/), [Go](https://golang.org/)

## Dependencies

### Development Dependencies

- **[@commitlint/cli](https://www.npmjs.com/package/@commitlint/cli):** Lint commit messages against conventional commits.
- **[@commitlint/config-conventional](https://www.npmjs.com/package/@commitlint/config-conventional):** Shareable commitlint config for conventional commits.
- **[@sveltejs/vite-plugin-svelte](https://www.npmjs.com/package/@sveltejs/vite-plugin-svelte):** Svelte plugin for Vite.
- **[autoprefixer](https://www.npmjs.com/package/autoprefixer):** Parse CSS and add vendor prefixes.
- **[cypress](https://www.npmjs.com/package/cypress):** JavaScript End to End Testing Framework.
- **[eslint](https://www.npmjs.com/package/eslint):** Linter for JavaScript and JSX.
- **[eslint-config-prettier](https://www.npmjs.com/package/eslint-config-prettier):** Turns off all rules that are unnecessary or might conflict with Prettier.
- **[eslint-plugin-cypress](https://www.npmjs.com/package/eslint-plugin-cypress):** ESLint plugin for Cypress.
- **[eslint-plugin-prettier](https://www.npmjs.com/package/eslint-plugin-prettier):** ESLint plugin for Prettier formatting.
- **[eslint-plugin-svelte](https://www.npmjs.com/package/eslint-plugin-svelte):** ESLint plugin for Svelte.
- **[flowbite-svelte-icons](https://www.npmjs.com/package/flowbite-svelte-icons):** Flowbite Svelte icons.
- **[husky](https://www.npmjs.com/package/husky):** Git hooks made easy.
- **[lint-staged](https://www.npmjs.com/package/lint-staged):** Run linters on pre-committed files.
- **[npm-run-all](https://www.npmjs.com/package/npm-run-all):** A CLI tool to run multiple npm scripts in parallel or sequential.
- **[postcss](https://www.npmjs.com/package/postcss):** A tool for transforming CSS with JavaScript plugins.
- **[postcss-load-config](https://www.npmjs.com/package/postcss-load-config):** Loads PostCSS configuration.
- **[prettier](https://www.npmjs.com/package/prettier):** Opinionated code formatter.
- **[prettier-plugin-svelte](https://www.npmjs.com/package/prettier-plugin-svelte):** Prettier plugin for Svelte.
- **[sass](https://www.npmjs.com/package/sass):** Syntactically Awesome Stylesheets.
- **[svelte](https://www.npmjs.com/package/svelte):** Cybernetically enhanced web apps.
- **[svelte-preprocess](https://www.npmjs.com/package/svelte-preprocess):** Preprocess Svelte components with other preprocessors.
- **[tailwindcss](https://www.npmjs.com/package/tailwindcss):** A utility-first CSS framework.
- **[vite](https://www.npmjs.com/package/vite):** A fast build tool that serves your code via native ES Module imports during development.

### Production Dependencies

- **[@amcharts/amcharts5](https://www.npmjs.com/package/@amcharts/amcharts5):** A versatile JavaScript charting library.
- **[@auth0/auth0-spa-js](https://www.npmjs.com/package/@auth0/auth0-spa-js):** Auth0 SDK for Single Page Applications.
- **[@fortawesome/pro-solid-svg-icons](https://www.npmjs.com/package/@fortawesome/pro-solid-svg-icons):** Font Awesome Pro Solid SVG icons.
- **[@popperjs/core](https://www.npmjs.com/package/@popperjs/core):** Positioning engine to align poppers to their reference elements.
- **[@tanstack/svelte-query](https://www.npmjs.com/package/@tanstack/svelte-query):** Svelte-friendly version of React Query for managing state.
- **[calendarize](https://www.npmjs.com/package/calendarize):** A small JavaScript library to handle calendar events.
- **[dayjs](https://www.npmjs.com/package/dayjs):** A minimalist JavaScript library for modern date utilities.
- **[flowbite](https://www.npmjs.com/package/flowbite):** A component library for Tailwind CSS.
- **[flowbite-svelte](https://www.npmjs.com/package/flowbite-svelte):** Flowbite components for Svelte.
- **[svelte-fa](https://www.npmjs.com/package/svelte-fa):** Font Awesome 5 components for Svelte.
- **[svelte-routing](https://www.npmjs.com/package/svelte-routing):** Svelte router.
- **[tailwind-merge](https://www.npmjs.com/package/tailwind-merge):** Tailwind CSS plugin for merging utility classes.