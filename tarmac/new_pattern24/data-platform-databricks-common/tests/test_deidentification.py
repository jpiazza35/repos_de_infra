from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from src import DeidentificationRequestParameters, DeidentificationType, deidentify


class TestDeidentification:
    @classmethod
    def setup_class(cls):
        cls.spark = SparkSession.builder.getOrCreate()
        cls.data_ok = [
            ("John Smith", 30, "john@example.com"),
            ("Jane Doe", 25, "jane@example.com"),
            ("Mike Johnson", 35, "mike@example.com"),
        ]
        cls.df_ok = cls.spark.createDataFrame(cls.data_ok, ["Name", "Age", "Email"])

        cls.data_with_null = [
            ("John Smith", 30, ""),
            ("Jane Doe", 25, None),
            ("Mike Johnson", 35, '""'),
        ]
        cls.df_with_null = cls.spark.createDataFrame(
            cls.data_with_null, ["Name", "Age", "Email"]
        )

        cls.salt = "somesaltvalue"

    def test_deidentify_hash_ok(self):
        params = DeidentificationRequestParameters(
            column_name_list=["Email"], deidentification_type=DeidentificationType.HASH
        )
        deidentified_df = deidentify(self.df_ok, params, self.salt)

        # Check if email column is hashed
        hashed_emails = [
            row["Email"] for row in deidentified_df.select(col("Email")).collect()
        ]
        expected_hashed_emails = [
            "1e525e06bb473f5deb66d02bd54086adc2ac0fc6877cc65bdcbd2ed7e6477b43",
            "106963b34c849a5b4e71a0a9ddaea4ede555e558df09a62c19d3c6df33f16740",
            "6732106ef3c8119a209492c13f4dc3a3281a90517b6845b36e4bd95f59ec8823",
        ]

        assert hashed_emails == expected_hashed_emails

    def test_deidentify_hash_null(self):
        params = DeidentificationRequestParameters(
            column_name_list=["Email"], deidentification_type=DeidentificationType.HASH
        )
        deidentified_df = deidentify(self.df_with_null, params, self.salt)

        # Check if email column is hashed
        hashed_emails = [
            row["Email"] for row in deidentified_df.select(col("Email")).collect()
        ]
        expected_hashed_emails = [
            "4e4ef634544e6b9e6674c9f2b8cf085ed571eb621fc91dedff0fe0850e9e20b6",
            None,
            "2053d05681fddd3e5a9fe8404f74ce70d11a3a72080cf716f8616bf7fa8d314f",
        ]

        assert hashed_emails == expected_hashed_emails

    def test_deidentify_remove_ok(self):
        params = DeidentificationRequestParameters(
            column_name_list=["Email"],
            deidentification_type=DeidentificationType.REMOVE,
        )
        deidentified_df = deidentify(self.df_ok, params)

        # Check if email column is removed
        removed_columns = deidentified_df.columns
        expected_columns = ["Name", "Age"]

        assert removed_columns == expected_columns

    def test_deidentify_remove_null(self):
        params = DeidentificationRequestParameters(
            column_name_list=["Email"],
            deidentification_type=DeidentificationType.REMOVE,
        )
        deidentified_df = deidentify(self.df_with_null, params)

        # Check if email column is removed
        removed_columns = deidentified_df.columns
        expected_columns = ["Name", "Age"]

        assert removed_columns == expected_columns
