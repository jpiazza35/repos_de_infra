echo "on-create.sh starting"

# clone service repos next to this one
git clone https://github.com/clinician-nexus/app-user-service.git /workspaces/app-user-service
git clone https://github.com/clinician-nexus/app-mpt-project-service.git /workspaces/app-mpt-project-service
git clone https://github.com/clinician-nexus/app-organization-service.git /workspaces/app-organization-service
git clone https://github.com/clinician-nexus/app-survey-service.git /workspaces/app-survey-service
git clone https://github.com/clinician-nexus/app-shared-protobuffs.git /workspaces/app-shared-protobuffs
git clone https://github.com/clinician-nexus/app-mpt-sql-db.git /workspaces/app-mpt-sql-db
git clone https://github.com/clinician-nexus/app-mpt-postgres-db.git /workspaces/app-mpt-postgres-db
git clone https://github.com/clinician-nexus/app-incumbent-service.git /workspaces/app-incumbent-service
git clone https://github.com/clinician-nexus/app-incumbent-db.git /workspaces/app-incumbent-db
git clone https://github.com/clinician-nexus/app-incumbent-staging-db.git /workspaces/app-incumbent-staging-db

# initiating git submodules
git -C /workspaces/app-mpt-project-service submodule update --init 
git -C /workspaces/app-organization-service submodule update --init 
git -C /workspaces/app-survey-service submodule update --init  
git -C /workspaces/app-user-service submodule update --init 
git -C /workspaces/app-incumbent-service submodule update --init 

# npm install app-mpt-ui
npm i
npm run build-db

# restore each dotnet service's solution

echo "Restoring Project Service"
sudo dotnet restore ../app-mpt-project-service/app-mpt-project-service.sln
echo "Restoring Organization Service"
sudo dotnet restore ../app-organization-service/app-organization-service.sln
echo "Restoring Survey Service"
sudo dotnet restore ../app-survey-service/app-survey-service.sln
echo "Restoring User Service"
sudo dotnet restore ../app-user-service/app-user-service.sln
echo "Restoring Incumbent Service"
sudo dotnet restore ../app-incumbent-service/app-incumbent-service.sln

# configure dotnet certs for this machine
sudo dotnet dev-certs https --clean
sudo dotnet dev-certs https -ep /usr/local/share/ca-certificates/aspnet/https.crt --format PEM --password 123password
sudo update-ca-certificates
sudo chmod 777 -R /usr/local/share/ca-certificates/aspnet

echo "on-create.sh done"
