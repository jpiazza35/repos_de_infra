import json
import re
from dataclasses import dataclass
from typing import List

from cn_databricks.utils import SecretManager, get_spark, convert_to_unity_catalog_naming_coventions


def batch_ingest_database(
        secret_scope: str,
        username_secret: str,
        password_secret: str,
        database_product: str,
        host_name_secret: str,
        port_number: int,
        database_name: str,
        target_schema: str,
        target_table_list: str,
        target_catalog: str,
        num_partitions: int = 8,
):
    ingestion = ExternalDatabaseIngestion(
        secret_scope=secret_scope,
        username_secret=username_secret,
        password_secret=password_secret,
        database_product=database_product,
        host_name_secret=host_name_secret,
        port_number=port_number,
        database_name=database_name,
        target_schema=target_schema,
        target_table_list=target_table_list,
        target_catalog=target_catalog,
        num_partitions=num_partitions,
    )
    ingestion.replicate_tables()




class ExternalDatabaseIngestion:
    def __init__(
            self,
            secret_scope,
            username_secret,
            password_secret,
            database_product,
            host_name_secret,
            port_number,
            database_name,
            target_schema,
            target_table_list,
            target_catalog,
            num_partitions=8,
    ):
        sm = SecretManager(scope=secret_scope)
        self.username = sm.get_secret(key=username_secret)
        self.password = sm.get_secret(key=password_secret)
        self.host_name = sm.get_secret(key=host_name_secret)
        self.database_product = database_product
        self.target_catalog = self._get_valid_name(target_catalog)
        self.target_schema = self._get_valid_name(target_schema)
        self.target_table_list = json.loads(target_table_list)
        self.num_partitions = num_partitions
        self.port_number = port_number
        self.database_name = database_name

        self.spark = get_spark()
        self.spark.conf.set(
            "spark.databricks.delta.properties.defaults.columnMapping.mode", "name"
        )
        self.spark.conf.set(
            "spark.databricks.delta.properties.defaults.minReaderVersion", "2"
        )
        self.spark.conf.set(
            "spark.databricks.delta.properties.defaults.minWriterVersion", "5"
        )

        if self.database_product not in ["sqlserver", "postgresql"]:
            raise NotImplementedError("Only SQL Server and PostgreSQL are supported.")

        # self.df_reader = (
        #     self.spark.read
        #     .format(self.database_product)
        #     .option("user", self.username)
        #     .option("password", self.password)
        #     .option("host", self.host_name)
        #     .option("port", self.port_number)
        #     .option("database", self.database_name)
        #     .option("numPartitions", self.num_partitions)
        # )

    def df_reader(self, table: str):
        if self.database_product == "sqlserver":
            table = f"[{table}]"
            url = f"jdbc:sqlserver://{self.host_name}:{self.port_number};database={self.database_name};user={self.username};password={self.password};encrypt=true;trustServerCertificate=true;"
            df_reader = (
                self.spark.read
                .format("jdbc")
                .option("url", url)
                .option("dbtable", table)
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
                .option("numPartitions", self.num_partitions)

            )
        elif self.database_product == "postgresql":
            table = f"{table}"
            df_reader = (
                self.spark.read
                .format("postgresql")
                .option("user", self.username)
                .option("password", self.password)
                .option("host", self.host_name)
                .option("port", self.port_number)
                .option("database", self.database_name)
                .option("numPartitions", self.num_partitions)
                .option("dbtable", table)
            )
        return df_reader


    def _get_valid_name(self, name):
        return re.sub("[^0-9a-zA-Z_]", "_", name)

    def replicate_tables(self):
        table_count = len(self.target_table_list)
        count = 0

        for table in self.target_table_list:
            count = count + 1
            failed = []
            progress = "({}/{})".format(count, table_count)
            print("{} INFO: Starting batch load of {}...".format(progress, table))

            try:
                df = self.df_reader(table).load()

                print(f"Number of partitions of read df: {df.rdd.getNumPartitions()}")

                print(
                    "{} INFO: Successfully read table data into dataframe via JDBC".format(
                        progress
                    )
                )

                print(
                    "{} INFO: Creating table {}.{}.{} in Unity Catalog".format(
                        progress, self.target_catalog, self.target_schema, convert_to_unity_catalog_naming_coventions(table)
                    )
                )
                self.spark.sql(
                    "CREATE SCHEMA IF NOT EXISTS {}.{}".format(
                        self.target_catalog, self.target_schema
                    )
                )

                df.write.mode("overwrite").saveAsTable(
                    "{}.{}.{}".format(self.target_catalog, self.target_schema, convert_to_unity_catalog_naming_coventions(table))
                )
                print(
                    "{} SUCCESS: Batch refresh of {} completed successfully.".format(
                        progress, convert_to_unity_catalog_naming_coventions(table)
                    )
                )

            except Exception as e:
                print(e)
                failed.append(table)
                print(
                    "{} ERROR: Failed to load table {} into s3.".format(progress, table)
                )

            print(" ")

        if len(failed) > 0:
            raise Exception(f"Batch load process failed for tables: {failed}")

        print("INFO: Batch load process completed.")
