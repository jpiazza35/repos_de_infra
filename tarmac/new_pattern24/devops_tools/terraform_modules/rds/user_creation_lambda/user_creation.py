import sys
import json
import os
import logging
import psycopg2

rds_host = os.getenv('DB_HOSTNAME')
username = os.getenv('DB_USERNAME')
password = os.getenv('DB_PASSWORD')
db_name = os.getenv('DB_NAME')
db_iam_auth_username = os.getenv('DB_IAM_AUTH_USERNAME')
schema_name = os.getenv('DB_SCHEMA_NAME')
da_crs_sequence = os.getenv('DB_DA_CRS_SEQUENCE')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = psycopg2.connect(host=rds_host, user=username, password=password, database=db_name)
    conn.autocommit = True
except psycopg2.DatabaseError as e:
    logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS PostgreSQL instance succeeded.")

def lambda_handler(event, context):

    with conn.cursor() as cursor:
        cursor.execute("CREATE USER %s" % db_iam_auth_username)
        cursor.execute("GRANT rds_iam TO %s" % db_iam_auth_username)
        cursor.execute("GRANT ALL PRIVILEGES ON DATABASE %s TO %s" % (db_name, db_iam_auth_username))
        cursor.execute("GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA %s TO %s" % (schema_name, db_iam_auth_username))
        cursor.execute("GRANT USAGE ON SCHEMA %s TO %s" % (schema_name, db_iam_auth_username))
        cursor.execute("ALTER SCHEMA %s OWNER TO %s" % (schema_name, db_iam_auth_username))
        if da_crs_sequence != "":
            cursor.execute("CREATE SEQUENCE IF NOT EXISTS %s" % da_crs_sequence)
            cursor.execute("ALTER SEQUENCE %s OWNER TO %s" % (da_crs_sequence, db_iam_auth_username))

    logger.info("SUCCESS: RDS IAM auth user created and privileges assigned.")
        
    conn.commit()