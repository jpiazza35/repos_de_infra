## Lambda function that uses psycopg2 (it is a dependency that needs to be in the uploaded .zip file) to connect and execute sql commands in an RDS PostgreSQL server.
## It also uses RDS DB IAM authentication instead of a regular user/password combination to login to Postgres.
## It needs a specific file name (SQL_FILE variable) in an s3 bucket (S3_BUCKET). Of course, this can be changed so it is triggered by any .sql file uploaded, not a specific one.
## The function has been tested with a file with one and 2 commands, worked, please feel free to report or change any possible issues that you might have while using/testing it.

import sys
import json
import os
import logging
import psycopg2
import boto3

rds_host = os.getenv('DB_HOSTNAME')
username = os.getenv('DB_USERNAME')
db_name = os.getenv('DB_NAME')
port = os.getenv('DB_PORT')
region = os.getenv('REGION')
bucket = os.getenv('S3_BUCKET')
sql_file = os.getenv('SQL_FILE')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

## This function uses IAM authentication for RDS

client = boto3.client('rds')
token = client.generate_db_auth_token(DBHostname=rds_host, Port=port, DBUsername=username, Region=region)


def lambda_handler(event, context):
    
    try:
        conn = psycopg2.connect(host=rds_host, user=username, password=token, database=db_name, sslmode='verify-ca', sslrootcert="rds-combined-ca-bundle.pem")
    
        conn.autocommit = True

        logger.info("SUCCESS: Connection to RDS PostgreSQL instance succeeded.")
    
        s3 = boto3.client('s3')
        sql = s3.get_object(Bucket=bucket, Key=sql_file)
        contents = sql['Body'].read().decode('utf-8')
        print(contents)

        cur = conn.cursor()
        cur.execute(contents)
        query_results = cur.fetchall()
        print(query_results)
        
        cur.close()
    except psycopg2.DatabaseError as e:
        logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
        logger.error(e)
        sys.exit()
    finally:
        try:
            conn.close()
        except:
            pass