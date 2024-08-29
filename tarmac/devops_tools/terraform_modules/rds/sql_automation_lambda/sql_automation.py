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

try:
    conn = psycopg2.connect(host=rds_host, user=username, password=token, database=db_name, sslmode='verify-ca', sslrootcert="rds-combined-ca-bundle.pem")
    conn.autocommit = True
except psycopg2.DatabaseError as e:
    logger.error("ERROR: Unexpected error: Could not connect to PostgreSQL instance.")
    logger.error(e)
    sys.exit()

def lambda_handler(event, context):
    
    s3 = boto3.client('s3')
    sql = s3.get_object(Bucket=bucket, Key=sql_file)
    contents = sql['Body'].read().decode('utf-8')
    print(contents)

    cur = conn.cursor()
    cur.execute(contents)