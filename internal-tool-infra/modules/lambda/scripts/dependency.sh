#!/bin/bash

mkdir "$PATH_DEPENDENCY"/dependencies && cd "$PATH_DEPENDENCY"/dependencies &&\
python3 -m venv venv && source venv/bin/activate &&\
mkdir python && cd python &&\
pip install slack_sdk -t . && rm -rf *dist-info &&\
cd ../ && zip -r lambda-dependencies.zip python
