# Use the base Ubuntu 23.04 image
FROM ubuntu:23.04

# Set environment variables for non-interactive mode and GitHub Runner version
ENV DEBIAN_FRONTEND=non-interactive
# https://github.com/actions/runner
ENV RUNNER_VERSION="v2.310.2"
ENV NODE_MAJOR=18

ENV RUNNER_ALLOW_RUNASROOT=true

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    sudo \
    ca-certificates \
    gnupg \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

## Install Docker Prerequisites
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN sudo apt-get update && \
    apt-cache policy docker-ce \
    && sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

## Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install ${NODE_MAJOR} && nvm install 20 && nvm use ${NODE_MAJOR}


# Install Minikube
RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    install minikube-linux-amd64 /usr/local/bin/minikube

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# Install GitHub Runner's dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    docker-ce \
    containerd.io \
    libicu-dev \
    liblttng-ust1 \
    libkrb5-3 \
    zlib1g \
    libssl-dev \
    libcurl4-openssl-dev \
    build-essential \
    gawk \ 
    bison \
&& rm -rf /var/lib/apt/lists/*

## Install glibc
RUN wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.38.tar.gz \
    && tar -xzf glibc-2.38.tar.gz \
    && cd glibc-2.38 \
    && mkdir build \
    && cd build \
    && ../configure --prefix=/opt/glibc \
    && make \
    && make install

## Install AWS CLI
RUN apt-get update \
    && apt-get install -y unzip

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Create the actions-runner directory and switch to it
WORKDIR /actions-runner

# Download and extract the GitHub runner in the /actions-runner directory
RUN curl -O -L https://github.com/actions/runner/releases/download/${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION#v}.tar.gz && \
    tar xzf actions-runner-linux-x64-${RUNNER_VERSION#v}.tar.gz && \
    rm actions-runner-linux-x64-${RUNNER_VERSION#v}.tar.gz && \
    ./bin/installdependencies.sh

# Install required dependences. Use provided script
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    /actions-runner/bin/installdependencies.sh  && \
    rm -rf /var/lib/apt/lists/*

## Install Git
RUN apt-get update && \
    apt-get install -y \
    git

# Command to run the GitHub Runner
COPY github-runner/scripts/ .

RUN chmod +x start.sh
RUN chmod +x jwt.sh

## Optionally, add custom tools or configurations here
## Example: RUN apt-get install -y your-required-tool
## Set up the runner user and permissions
## Add user to sudoers
RUN adduser --disabled-password --gid 0 --gecos "" --home /actions-runner github-runner
RUN chown -R github-runner /actions-runner
RUN usermod -aG sudo github-runner 
RUN echo "github-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Create docker group and add github-runner user to it
RUN usermod -aG docker github-runner

RUN ls -l

# Switch to the runner user
USER github-runner
#RUN newgrp docker

CMD ["./start.sh"]
