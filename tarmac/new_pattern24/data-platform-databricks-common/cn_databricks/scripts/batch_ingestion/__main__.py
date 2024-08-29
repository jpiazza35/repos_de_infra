from argparse import ArgumentParser

from cn_databricks.ingestion import ExternalDatabaseIngestion


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


def main():
    argparse = ArgumentParser()
    kwargs = [
        "secret_scope",
        "username_secret",
        "password_secret",
        "database_product",
        "host_name_secret",
        "port_number",
        "database_name",
        "target_schema",
        "target_table_list",
        "target_catalog",
        "num_partitions",
    ]
    for kwarg in kwargs:
        argparse.add_argument(f"--{kwarg}", required=True)
    args = argparse.parse_args()
    batch_ingest_database(**vars(args))


if __name__ == "__main__":
    main()
