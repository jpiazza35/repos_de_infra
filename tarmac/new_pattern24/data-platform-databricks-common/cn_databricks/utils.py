import os
from dataclasses import dataclass

import IPython

dbutils = IPython.get_ipython().user_ns["dbutils"]

# be very careful with type hints and stubs in this file
# this file's purpose is to extract what we need from the Databricks runtime,
# which is very notepbook & ipython oriented. When writing tests, we want to be able to mock


@dataclass
class SecretManager:
    scope: str

    def get_secret(self, key: str) -> str:
        return dbutils.secrets.get(scope=self.scope, key=key)


def get_spark():
    return IPython.get_ipython().user_ns["spark"]

def convert_to_unity_catalog_naming_coventions(name: str) -> str:
    """
    Converts a name to a valid Unity Catalog name
    https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/
    """
    return (
        name.replace("/", "_")
            .replace(" ", "_")
            .replace(".", "_")
            .lower()[0:254]
    )
