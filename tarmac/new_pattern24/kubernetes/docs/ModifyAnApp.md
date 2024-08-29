# Modifying Already Deployed Applications

## Overview

For modifying existing apps in a safe manner, a feature branch workflow is recommended. Below are the steps to modify an existing application and validate the changes using ArgoCD.

## Steps

### 1. Create a Feature Branch

- Create a new feature branch to isolate your changes.

### 2. Modify Configurations

- Make the required changes to the configurations, such as updating manifests or changing environment variables.

### 3. Test in ArgoCD

- Log into ArgoCD for the specific environment you want to test. Update the target revision to point to your feature branch.
- This allows you to validate your changes in a controlled environment before merging.

### 4. Pull Request and Review

- Once validated, create a pull request for code review.

### 5. Reset Target Revision in ArgoCD

- After the pull request is merged, log back into ArgoCD and reset the target revision back to `main`.

## Conclusion

By following this workflow, you can safely modify existing applications and validate the changes via ArgoCD before they're merged into the main branch.

## Note: We should find a way to automate this process. For example, we can create a GitHub Action that automatically creates a feature branch and updates the ArgoCD target revision. This way, developers can focus on the actual changes and not worry about the process
