# Use the base Ubuntu 22.04 image
FROM ubuntu:22.04

# Set environment variables for non-interactive mode and GitHub Runner version
ENV DEBIAN_FRONTEND=non-interactive
# https://github.com/actions/runner
ENV RUNNER_VERSION="v2.309.0" 

ENV RUNNER_ALLOW_RUNASROOT=true

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub Runner's dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    liblttng-ust1 \
    libkrb5-3 \
    zlib1g \
    libssl-dev \
&& rm -rf /var/lib/apt/lists/*

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
    rm actions-runner-linux-x64-${RUNNER_VERSION#v}.tar.gz

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

RUN ls -l

# Switch to the runner user
USER github-runner

CMD ["./start.sh"]
