#!/usr/bin/env python3.8

# This script can be used by scheduled lambda based eventbridge rule that periodically checks IAM users from certain AWS account
# and looks for access keys older than ALERT_DAYS days. If such a keys are detected, an email will be send to that user and to
# devops team too. SES should be configured properly in order this to be worked. In our case email address of the user is used
# as an IAM user name, but if email address is placed in a tag small changes to this code are needed to be made. This example
# works only for "human" IAM users, since we don't use emails for "machine" users.

from datetime import datetime, timedelta
import boto3
from botocore.exceptions import ClientError


def lambda_handler(event, context):

    # Sender email
    SES_SENDER = 'mail@example.com'     # Change it according to your needs
    SES_REGION = 'eu-west-1'            # Change it according to your needs
    # Rotate keys every ALERT_DAYS days
    ALERT_DAYS = 30                     # Change it according to your needs

    iam_client = boto3.client('iam')
    ses_client = boto3.client('ses', region_name=SES_REGION)


    def send_notification(email, user_old_keys, account_name):
        email_text = f'''
            This is an automatic reminder for IAM user {email} about rotation of AWS Access Keys at least every {ALERT_DAYS} days.

            At the moment, you have {len(user_old_keys)} key(s) in the {account_name} account that have been created more than {ALERT_DAYS} days ago: \n
            '''
        for user_old_key in user_old_keys:
            email_text += f"- {user_old_key}\n"

        email_text += f'''
            To learn how to rotate your AWS Access Key, please read the official guide at https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_RotateAccessKey If you have any question, feel free to contact us.\n

            Regards,
            DevOps Team
            '''

        try:
            ses_response = ses_client.send_email(
                Destination={'ToAddresses': [email, "devops@example.com"]},
                Message={
                    'Body': {'Text': {'Charset': 'UTF-8', 'Data': email_text}},
                    'Subject': {'Charset': 'UTF-8',
                                'Data': f'Please rotate your AWS Key(s) on {account_name} account!'}
                },
                Source=SES_SENDER
            )
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print(f'Notification email sent successfully to {email}!')

    # Get the list of all IAM users from the current AWS account
    all_users = iam_client.list_users(
    )

    if len(all_users['Users']) > 0:
        # Set the oldest allowed access key creation time
        past = datetime.now() - timedelta(days=ALERT_DAYS)
        # Set AWS account name for email text
        aws_account_id = all_users['Users'][0]['Arn'].split(':')[4]
        if str(aws_account_id).startswith("X"):     # Change it according to your needs or you can use tags or env vars for this too
            ACC_NAME = "QA"
        else:
            ACC_NAME = "PROD"

        for one_user in all_users['Users']:
            # Get list of tags for the user
            user_tags = iam_client.list_user_tags(
                UserName=one_user['UserName']
            )
            # Proceed only if user is "human"
            # In our case we have IAM user tag "user_type" with "human" or "machine" possible values
            if user_tags['Tags']:
                for tag in user_tags['Tags']:
                    if tag['Key'] == 'user_type' and tag['Value'] == 'human':
                        print(one_user['UserName'])
                        # Get the list of access keys for the user
                        user_keys = iam_client.list_access_keys(
                            UserName=one_user['UserName']
                        )
                        # Check if there are any active keys older than ALERT_DAYS days
                        if len(user_keys['AccessKeyMetadata']) > 0:
                            user_old_keys = []
                            for access_key in user_keys['AccessKeyMetadata']:
                                if access_key['Status'] == "Active" and past > access_key['CreateDate'].replace(tzinfo=None):
                                    user_old_keys.append("Access key created at: " + str(access_key['CreateDate']))
                            # Send mail notification only if there are old active keys
                            if len(user_old_keys) > 0:
                                print(user_old_keys)
                                send_notification(one_user['UserName'], user_old_keys, ACC_NAME)
                            else:
                                print("User has no old active keys.")
                        else:
                            print("User has no keys.")
    else:
        print('There are no IAM users created.')