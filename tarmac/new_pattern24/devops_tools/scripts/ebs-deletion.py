import boto3
from botocore.exceptions import ClientError
from datetime import datetime,timedelta
import os

# Connect to region
ec2 = boto3.client('ec2', region_name='__AWS_REGION___')
sts = boto3.client('sts', region_name='__AWS_REGION___')

# AWS Account ID
account_id = sts.get_caller_identity()['Account']

retention_days = os.getenv("RETENTION_DAYS") # Delete EBS snapshots older than this number - fetch from Lambda env vars
old_snapshots_list = []
line = "================================"

snapshots_list = ec2.describe_snapshots(
    OwnerIds=[account_id]
)

# Get current timestamp in UTC
now = datetime.now()

def delete_snapshot(snapshot_id):
    print(line)
    print("Deleting snapshot {}".format(snapshot_id))
    try:
        ec2resource = boto3.resource('ec2', region_name='__AWS_REGION___')
        snapshot = ec2resource.Snapshot(snapshot_id)
        snapshot.delete()
    except ClientError as e:
        print("Caught exception: {}".format(e))

    return

def lambda_handler(event, context):
    for snapshot in snapshots_list['Snapshots']:
        
        print("Checking snapshot {} which was created on {}".format(snapshot['SnapshotId'],snapshot['StartTime']))

        # Remove timezone info from snapshot in order for comparison to work below
        snapshot_time = snapshot['StartTime'].replace(tzinfo=None)
        snapshot_id = snapshot['SnapshotId']

        # Subtract snapshot time from now returns a timedelta
        # Check if the timedelta is greater than retention days
        if (now - snapshot_time) > timedelta(retention_days):
            old_snapshots_list.append(snapshot)
            print("Snapshot {} is older than {} days so it will be deleted.".format(snapshot_id, retention_days))
            print(line)
            delete_snapshot(snapshot['SnapshotId'])
    print(line)
    print("{} snapshots have been deleted.".format(len(old_snapshots_list)))