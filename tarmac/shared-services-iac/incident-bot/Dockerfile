FROM vault:1.13.1 as vault

## Get the Vault Token and Address from the build args
ARG VAULT_ADDR
ARG VAULT_TOKEN

ENV VAULT_ADDR=$VAULT_ADDR
ENV VAULT_TOKEN=$VAULT_TOKEN

## Copy the script to generate the .env file
COPY incident-bot/scripts/generate_env.sh .

## Make the script executable
RUN chmod +x generate_env.sh

## Generate the .env file
RUN ./generate_env.sh

## Pull the incident-bot image
FROM eb129/incident-bot:v1.4.19 as final 

## Set the work directory to the app folder.
WORKDIR /incident-bot

## Copy Config File
COPY incident-bot/scripts/config.yaml config.yaml

## Copy the .env file from the vault container
COPY --from=vault .env .env

## Expose the port
EXPOSE 3000
