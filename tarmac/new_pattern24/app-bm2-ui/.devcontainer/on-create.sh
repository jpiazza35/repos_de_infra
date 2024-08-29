echo "on-create.sh starting"

# clone service repos next to this one
git clone https://github.com/clinician-nexus/app-bm2-service.git /workspaces/app-bm2-service
git clone https://github.com/clinician-nexus/app-shared-protobuffs.git /workspaces/app-shared-protobuffs

# cn-ui
git clone https://github.com/clinician-nexus/cn-ui.git /workspaces/cn-ui
cd /workspaces/cn-ui
npm i
npm link
cd /workspaces/app-bm2-ui
npm link @cn/ui
npm i


npm run build-db



# initiating git submodules
git -C /workspaces/app-survey-data-workbench-service submodule update --init 
git -C /workspaces/app-es-legacy submodule update --init 

echo "on-create.sh done"