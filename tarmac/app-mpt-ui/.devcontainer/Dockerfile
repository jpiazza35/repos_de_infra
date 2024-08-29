# this image is built and updated weekly
# https://github.com/cse-labs/codespaces-images
FROM ghcr.io/cse-labs/k3d:latest

# some images require specific values
ARG USERNAME=vscode
ENV PATH $PATH:/home/${USERNAME}/.dapr/bin

# dotnet sdk
RUN apt install dotnet-sdk-7.0 -y
RUN dotnet --info

# nodejs & npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install nodejs -y
RUN node -v
RUN npm -v