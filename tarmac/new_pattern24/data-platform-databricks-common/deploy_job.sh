#!/usr/bin/env bash

# todo: convert to GHA
# build wheel
rm -rf dist/
poetry version patch
poetry build
FILE_PATH=$(ls dist/*.whl)

bucket="sdlc-artifacts-230176594509"


# copy to s3
s3_path="s3://$bucket/wheels/$FILE_PATH"
aws s3 cp $FILE_PATH $s3_path --profile ss_databricks


# tf init
tf_directory="terraform/batch_jobs"
ch_dir="-chdir=$tf_directory"
workspace="sdlc"

echo "terraform $ch_dir init"
terraform $ch_dir init

# tf apply
terraform $ch_dir apply -var-file=${workspace}.tfvars -var="wheel_path=$s3_path" -auto-approve
