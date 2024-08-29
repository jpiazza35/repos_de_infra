# app-incumbent-service

## REST API appsettings.json parameters

In addition to all the parameters that exist in the rest-api `appsettings.json` file used to build the api service, there is the `BuildNumber` one as well. This parameter is rather important since it introduces a process of using a jinja template `appsettings.json.j2` which is needed to update this number on every new build (pipeline run) with the latest git tag that has been published.

For this, reference:
- appsettings.json.j2 file
- update-env.py script
- step `Update appsettings.json` in the `test-and-deploy-dev.yml` GH actions workflow

The reason these files and process are important is because using this jinja templating we introduce a dependency we have to fulfill when we add a new parameter or change/rename an existing one in our original `appsettings.json`.
When this is needed, we also have to update the `appsettings.json.j2` file because how that python script works is that it fetches the j2 file, updates in place and writes it to the original json file. 

So if we add a new parameter in `appsettings.json` we need to reflect the same thing in the `appsettings.json.j2` file so it does not get removed/overwritten by this whole process.