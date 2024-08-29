# Introduction 

Postgres(Latest Version) Database container with databases:
- Incumbent_Staging_DB

Username and password is `postgres` and `postgres`

Use 127.0.0.1 to connect to the running container on your local machine or cloud dev environment. pgAdmin and other tools can connect to the running instance.

Example to build: `podman build -t pgsql .`

Example to run: `podman run -d -p 5432:5432 -t localhost/pgsql`