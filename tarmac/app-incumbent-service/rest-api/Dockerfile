# Build and deploy Dotnet container
#
# Build arguments:
# ASP_VER: Version of ASP to use. (Default: 7.0)
#
# Pass build arguments with the --build-arg switch. i.e. --build-arg ASP_VER=7.0
#
# This package has a dependency on `app-shared-protobuffs` repo. It should be present as a submodule located in the `submodules` directory of this repo.

# Accept ASP version or default to 7.0
ARG ASP_VER=7.0

FROM mcr.microsoft.com/dotnet/sdk:${ASP_VER} AS build

# Build a self-signed cert
RUN dotnet dev-certs https --clean
RUN dotnet dev-certs https -ep /usr/local/share/ca-certificates/aspnet/https.crt --format PEM --password 123password

# Stage source
WORKDIR /src
COPY . .
WORKDIR /src/rest-api

# Restore and build
RUN dotnet restore "CN.Incumbent.RestApi.csproj"

# Publish
RUN dotnet publish "CN.Incumbent.RestApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Generate final image
FROM mcr.microsoft.com/dotnet/aspnet:${ASP_VER} AS final

WORKDIR /app
RUN update-ca-certificates
COPY --from=build /app/publish .
COPY --from=build /usr/local/share/ca-certificates/aspnet/https.* /usr/local/share/ca-certificates/aspnet/


ENTRYPOINT ["dotnet", "CN.Incumbent.RestApi.dll"]