# Define PostgresDB container that restores a database and provides pgadmin access.
#

# Start with a base postgres image
FROM docker.io/library/postgres:latest

# Accept database restore info arguments or use defaults
ENV POSTGRES_DB=Incumbent_Staging_DB
ENV POSTGRES_USERNAME=postgres
ENV POSTGRES_PASSWORD=postgres

# Stage files
COPY ./seed /seed
COPY ./init /docker-entrypoint-initdb.d

EXPOSE 5432
