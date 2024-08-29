FROM ubuntu:17.04
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER Pablo Caviglia <pablo.caviglia@gmail.com>

RUN apt-get update && \
    apt-get install -y --allow-unauthenticated curl vim unzip net-tools iputils-ping software-properties-common wget mysql-client-5.7

RUN apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

#this is necessary to assign correct permissions to docker volume of project
RUN usermod -u 1000 www-data

RUN mkdir /app/

ENTRYPOINT /app/script/startup.sh
