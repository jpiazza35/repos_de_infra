### Github Runners
This application deploys a Github Runner to your cluster. It is based on the [official Github Runner Helm Chart](https://github.com/actions/actions-runner-controller).

#### Prerequisites
- A Github Application with the `repo` and `organization` scope
  - Repo scope permissions:
    - Administration (Read and Write)
    - Deployments (Read and Write)
    - Metadata (Read Only)
  - Organization scope permissions:
    - Self-hosted runners (Read and Write)

#### Installation
1. Create a Github Application with the above permissions
2. Create a Github Personal Access Token with the `repo` and `admin:org` scopes
3. Create a Kubernetes Secret with the following values:
   - `GITHUB_APP_ID`: The Github Application ID
   - `GITHUB_APP_INSTALLATION_ID`: The Github Application Installation ID
   - `GITHUB_APP_PRIVATE_KEY`: The Github Application Private Key
4. Install the Helm Chart:
   `kustomize build --enable-helm | kubectl apply -f -`

#### Configuration
The runners are deployed as a RunnerSet which is a Kubernetes statefulset. The RunnerSet is configured with the following values:
- `replicas`: The number of runners to deploy. You leave this commented out when using an autoscaling is enabled
- `runner.name`: The name of the runner
- `runner.image`: The image to use for the runner. This is configured in the runner controller.
- `runner.labels`: The labels to apply to the runner, this is what will be used to select the runners in a workflow

The runners are autoscaled using the [Horizontal Runner Autoscaler Custom Resource](https://github.com/actions/actions-runner-controller/blob/master/docs/automatically-scaling-runners.md#automatically-scaling-runners) and [Github Webhook Driven Scaling](https://github.com/actions/actions-runner-controller/blob/master/docs/automatically-scaling-runners.md#webhook-driven-scaling)
This means that the runners scale based on events from Github. The autoscaler is configured with the following values:

- `scaleUpTriggers`: The events that will trigger a scale up
- `duration`: The number of minutes to wait before scaling up/down to avoid flapping.

```yaml
scaleUpTriggers:
  - githubEvent:
      workflowJob: {}
    duration: "30m"
```
There are two types of runners configured, one to be used for `e2e` and the other is the shared runner withing the organization. The main difference between the two is that the `e2e` runner does not require containers during workflow runs and has pre-installed software to aid in the speed of `e2e Pipeline` runs.
The shared runner is configured as a `docker-in-docker` runner and requires users to specify the container to use during workflow runs.

On the `e2e` runner, the following software is installed:
- `nvm`
- `curl`
- `awscli`
- `minikube`
- `cypress`
- `kubectl`
- `helm`
- `npx`
- `node`
- `git`

The software installation script is mounted as a configmap volume on the container and is installed by a lifecycle hook on the runner.
```yaml
lifecycle:
  postStart:
    exec:
      command:
        - /bin/bash
        - -c
        - /runner/scripts/reqs.sh
``` 

#### Usage
The runners are configured with the following labels:
- `e2e`: The e2e runner
- `k8s`: The shared runner
```yaml
jobs:
  example-workflow:
    name: 'This is how we do it'
    runs-on:
      - k8s
    container:
      image: ubuntu
```
The `e2e` runner is configured as a `docker` runner and does not require users to specify the container to use during workflow runs.
```yaml
jobs:
  example-workflow:
    name: 'This is how we do it'
    runs-on:
      - e2e
```
