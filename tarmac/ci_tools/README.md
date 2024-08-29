# ci-tools

Repository for reusable CI components, and examples. 

## Usage 
To use, call the main branch of this repo into your CI pipeline as a job, like:

```
    jobs:
      call-ci-tools-workflow-from-another-repo:
        uses: clinician-nexus/ci_tools/.github/workflows/<workflow_name.yml>@main
```

or include a checkout of this repo into your CI pipeline steps for a given job, like

```
    - name: Checkout and authenticate
      uses: actions/checkout@v3
      with:
        repository: clinician-nexus/ci_tools
        path: .github/workflows/
```

To pass inputs to the reusable workflow:
```
    jobs:
      call-ci-tools-workflow-from-another-repo:
        uses: clinician-nexus/ci_tools/.github/workflows/`<workflow_name.yml>`@main
        with:
          <input_name>: <input_value>
```


To pass secrets to the reusable workflow:
```
    jobs:
      call-ci-tools-workflow-from-another-repo:
        uses: clinician-nexus/ci_tools/.github/workflows/`<workflow_name.yml>`@main
        with:
          <input_name>: <input_value>
        secrets:
          <secret_name>: <secret_value>
```
## Generally Recommended Initial CI flow (for services)

1. Create Artifact - single job
  1. Setup - Configure access to private repos and registries, or other setup tasks.
  1. Build - building is a most basic test for runnability, and the artifact generated should be used in subsequent tests; even services built using dynamic languages that don't require a build should have at least a container image built that includes a fully configured environment.
  1. Register - Push a container to the shared container registry
1. Test Artifacts - multiple parallel jobs
  1. Setup - Configure access to private repos and registries, or other setup tasks.
  1. Test - using the built container perform linting, static analysis, unit tests, integration tests, etc.
1. Finish - single job
  1. Retag - Give an artifact a version (optional)
  1. Cleanup - Remove artifacts with failed tests (optional)
  1. Publish - Commit local file with the vetted image name as the current image to use. 
  1. Deploy - If all tests pass create a set of manifests required to deploy the service, and push those artifacts to the repository that ArgoCD watches to apply the changes in a target environment
  1. Notify - Regardless of the status of any previous stages, notifications should be sent to the team about the results.


## Generally Recomended CI flow for Staging/Production environments

1. Deploy - 
  1. If setting a version, retag image with a specific version(optional)
  1. If setting a version, publish the new version instead of the original commit SHA (optional)
  1. get the image id from the `ci-image-id.txt` file
  1. Deploy that image
1. `E2E` - End-to-end testing of the environment
1. Notify

## Example how to build and push a docker image:
...