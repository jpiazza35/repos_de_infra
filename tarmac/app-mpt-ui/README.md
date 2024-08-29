# Market Pricing UI

MPT Front end running on codespace.


## How to start 

Create a codespace from the main branch on [app-mpt-ui branch](https://github.com/clinician-nexus/app-mpt-ui/) or clicking [here](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=588774518) 

Wait it to create a new codespace and choose where you are going to use that: Browser, VSCode, VSInsiders, w/e.
After choose your plataform and enter on it, open a terminal and run the command `code /workspaces`, so you wil be able to see all the repos on your VSCode.

Open a new terminal in the `app-mpt-ui` folder and type the following commands: 

  * `npm run build-db` #if you want to build
  * `npm run start-db`
  * `npm run start-backend`

Wait it to start the backend and check if there is no error on it.
open a new terminal and run 
`npm run dev`

You are good to go.

In the `package.json` file, there are other commands that will help you to update your files with the latest changes or rebuild the databases.

## Prod docker image build (temporary)
As of the moment of writing this (May 16th 23') we are building our production UI docker images locally as the pipeline for that is still not in place. The process for this is:
1. Update `.env.production` Azure B2C env vars values according the production B2C configuration - more specifically the `VITE_AB2C_TENANT_ID` and `VITE_AB2C_CLIENT_ID`.
2. Run a local `docker build` and push the image to the SS_TOOLS ECR.
3. Make sure to clean up the prod B2C values in the `.env.production` file so you don't push them into the repo.
