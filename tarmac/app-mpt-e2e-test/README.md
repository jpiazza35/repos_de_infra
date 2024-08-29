To update all dependencies : `npm install` 

# cypress

To run the tests (headless electron) : `npx cypress run`

To run the tests (chrome) : `npm run cy:chrome`

To open cypress UI : `npx cypress open`

To run tests in dev env: `npm run cy:run-dev`
To run tests in test env: `npm run cy:run-test`
To run tests in stage env: `npm run cy:run-stage`
To run tests in prod env: `npm run cy:run-prod`

# tags
You can use tags to run specific set of tests , `default = '@smoke'`

`npm run cy:chrome -- --env tags='@tag1 @tag2'` to **INCLUDE** these tests in test run

or `npm run cy:chrome -- --env exclTags='@tag1 @tag2'`  to **EXCLUDE** tests with these tags

# mochareports
Output will be in cypress/reports/index.html

Note: before running another set of test you should make sure cypress/reports folder is empty.
Use this script: `npm run mocha-clean-reports`