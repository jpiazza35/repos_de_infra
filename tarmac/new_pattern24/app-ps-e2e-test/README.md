To update all dependencies : `npm install` 

# cypress

To run the tests (headless electron) : `npx cypress run`

To run the tests (chrome) : `npm run cy:chrome`

To open cypress UI : `npx cypress open`

# tags
You can use tags to run specific set of tests , `default = '@smoke'`

`npm run cy:chrome -- --env tags='@tag1 @tag2'` to **INCLUDE** these tests in test run

or `npm run cy:chrome -- --env exclTags='@tag1 @tag2'`  to **EXCLUDE** tests with these tags

