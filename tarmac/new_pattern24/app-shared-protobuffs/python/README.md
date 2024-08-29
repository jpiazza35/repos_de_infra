# Clinician Nexus Shared Proto Library for Python
## Install
To install a local version with the necessary databricks helpers.
```zsh
curl -sSL https://install.python-poetry.org | python3 -
poetry config virtualenvs.in-project true
poetry install --all-extras
```


## Development
Mark the following folders as sources root:

        python/src


Build wheel

        poetry build


Publish package to internal PyPi. `poetry publish` does not seem to support our PyPi endpoint.

```shell
export TWINE_USERNAME=$WORK_USER  # AD id, not email
export TWINE_PASSWORD=$WORK_PASSWORD
export TWINE_REPOSITORY_URL=https://sonatype.cliniciannexus.com/repository/cn_pypi/
export TWINE_NON_INTERACTIVE=1

pip install twine
twine upload dist/*
```


## Helper functions for Proto, Python and Spark
This package includes helper functions to support protobuf development with Python and PySpark.
