BASE_DIR := .

.PHONY: help clean build
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1\3/p'

clean: ## "Remove all generated deployment files"
	if [ -f "package.zip" ]; then rm package.zip; else echo "Compress file doesnt exists. Nothing to remove."; fi
	if [ -d "dependency" ]; then rm -rf dependency/; else echo "Dependencies folder doesnt exists. Nothing to remove."; fi

dependency: clean ## "Create dependency zip package needed by the Python script"
	bash -C "dependency.sh"

build: dependency ## "Create zip package by building the Go Slack bot"
	zip -r package.zip main.py

aws-upload: ## Upload dependencies package into AWS S3 bucket
	aws s3 cp dependency/lambda-dependencies.zip s3://alarm-lambda-dependencies/
