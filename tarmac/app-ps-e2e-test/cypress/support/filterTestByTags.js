/**
 * This script is used to filter tests in spec by specific tags. Tags are coming from environment file or passed arguments.
 * This script is being run in e2e.js file (cypress script which runs before each spec in test run)
 * 
 *  @example 
 *  We have 2 tests with different tags.
 *  it("1st test @smoke") and  it ("2nd test  "@regression")
 *      To run only first test we should pass TAG: npx cypress run --env tags='@smoke'. OR it should be in cypress.config.js
 */
"use strict";
(function () {
    var _a, _b;
    if (!Cypress.env('tags') && !Cypress.env('exclTags')) {
        console.log('No any tags are used. Running all tests.');
        return;
    }
    var envTags = (_a = Cypress.env('tags')) !== null && _a !== void 0 ? _a : '';
    var envExclTags = (_b = Cypress.env('exclTags')) !== null && _b !== void 0 ? _b : '';
    var hasTags = envTags !== '';
    var hasExclTags = envExclTags !== '';
    // Don't filter if both is defined. We do not know what is right
    if (hasTags && hasExclTags) {
        console.log('Both tags and excluding tags has been defined. Not filtering');
        return;
    }
    var tags = hasTags ? envTags.split(' ') : [];
    var exclTags = hasExclTags ? envExclTags.split(' ') : [];
    var orgIt = it;
    var filterFunction = hasTags ? onlyWithTags : onlyWithoutTags;
    var filteredIt = filterFunction;
    filteredIt.skip = orgIt.skip;
    filteredIt.only = orgIt.only;
    filteredIt.retries = orgIt.retries;
    it = filteredIt;
    function onlyWithTags(title, fn) {
        if (tags.find(function (t) { return title.indexOf(t) === -1; })) {
            fn = null;
        }
        orgIt(title, fn);
    }
    function onlyWithoutTags(title, fn) {
        if (exclTags.find(function (t) { return title.indexOf(t) !== -1; })) {
            fn = null;
        }
        orgIt(title, fn);
    }
})();