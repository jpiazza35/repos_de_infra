# Build and deploy Dotnet container
#
# Build arguments:
# ASP_VER: Version of ASP to use. (Default: 7.0)
#
# Pass build arguments with the --build-arg switch. i.e. --build-arg ASP_VER=7.0
#
# This package has a dependency on `app-shared-protobuffs` repo. It should be present as a submodule located in the `submodules` directory of this repo.

# Accept ASP version or default to 7.0
ARG ASP_VER

FROM mcr.microsoft.com/dotnet/sdk:${ASP_VER} AS build   
ARG SIMBA_SPARK_ODBC_DRIVER_URL

# Build a self-signed cert
RUN dotnet dev-certs https --clean
RUN dotnet dev-certs https -ep /usr/local/share/ca-certificates/aspnet/https.crt --format PEM --password 123password

# Install curl & unzip
RUN apt-get update && apt-get install -y curl unzip

RUN mkdir -p /usr/local/share/odbc-driver/

# Copy odbcinst.ini file
COPY ./rest-api/odbcinst.ini /etc/

# Copy odbc.ini file
COPY ./rest-api/odbc.ini /etc/

# Download Simba Spark ODBC Driver
RUN curl ${SIMBA_SPARK_ODBC_DRIVER_URL} -o /usr/local/share/odbc-driver/simbasparkodbcdriver.zip

# Unzip the downloaded file
RUN unzip /usr/local/share/odbc-driver/simbasparkodbcdriver.zip -d /usr/local/share/odbc-driver && rm -rf /usr/local/share/odbc-driver/simbasparkodbcdriver.zip

# Rename the downloaded .deb file to use it later
RUN mv /usr/local/share/odbc-driver/simba* /usr/local/share/odbc-driver/simbasparkodbdriver.deb

# Stage source
WORKDIR /src
COPY . .
WORKDIR /src/rest-api

# Restore and build
RUN dotnet restore "CN.Survey.RestApi.csproj"

# Publish
RUN dotnet publish "CN.Survey.RestApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Generate final image
FROM mcr.microsoft.com/dotnet/aspnet:${ASP_VER} AS final

WORKDIR /app
RUN update-ca-certificates
RUN apt-get update && apt-get install -y unixodbc libsasl2-modules-gssapi-mit
COPY --from=build /app/publish .
COPY --from=build /usr/local/share/ca-certificates/aspnet/https.* /usr/local/share/ca-certificates/aspnet/
COPY --from=build /usr/local/share/odbc-driver/simbasparkodbdriver.deb /usr/local/share/odbc-driver/simbasparkodbdriver.deb

# Copy odbcinst.ini file from build image to the final one
COPY --from=build /etc/odbcinst.ini /etc/odbcinst.ini

# Copy odbc.ini file from build image to the final one
COPY --from=build /etc/odbc.ini /etc/odbc.ini



# Changing permission cerificates
RUN chmod 744 /app/*
RUN chmod -R 744 /usr/local/share/*
RUN chmod 744 /etc/odbcinst.ini
RUN chmod 744 /etc/odbc.ini

# Changing owner to user 1000 
RUN chown -R 1000:1000 /app/
RUN chown -R 1000:1000 /usr/local/share
RUN chown -R 1000:1000 /etc/odbcinst.ini
RUN chown -R 1000:1000 /etc/odbc.ini

# Install the .deb package
RUN dpkg -i /usr/local/share/odbc-driver/simbasparkodbdriver.deb

ENTRYPOINT ["dotnet", "CN.Survey.RestApi.dll"]