#!/usr/bin/env python3.8

# This script can be used for detection of old IAM user passwords. It uses IAM credential report for fetching info about password age.
# User will start receiving mails ALERT_DAYS before password expiration date.

from datetime import datetime, timedelta
import boto3
from botocore.exceptions import ClientError
from time import sleep
import csv

SES_SENDER = 'mail@example.com'     # Change it according to your needs
SES_REGION = 'eu-west-1'            # Change it according to your needs
ALERT_DAYS = 5                      # Change it according to your needs
current_time = datetime.now()
start_reminder_time = datetime.now() + timedelta(days=ALERT_DAYS)

def lambda_handler(event, context):
    
    # Set account name
    account_id = context.invoked_function_arn.split(":")[4]
    if str(account_id).startswith("X"):
        account_name = "NONPROD"
    else:
        account_name = "PROD"

    # Set Boto3 clients
    iam_client = boto3.client('iam')
    ses_client = boto3.client('ses', region_name=SES_REGION)

    # Function that generates and gets IAM credential report and creates sub-report that contains password enabled users
    # which password has expired or will expire in ALERT_DAYS days
    def get_credential_report_expired(iam_client):
        print('Getting IAM credential report ...')
        try:
            response_generate = iam_client.generate_credential_report()
        except ClientError as e:
            print("Unknown error getting Report: " + e.message)
        print(response_generate['State'])
        if response_generate['State'] == 'COMPLETE':
            try:
                response = iam_client.get_credential_report()
                credential_report_csv = response['Content'].decode("utf-8")
                reader = csv.DictReader(credential_report_csv.splitlines())
                # print(reader.fieldnames)
                credential_report_expired = []
                for row in reader:
                    if row['password_enabled'] == "true" and start_reminder_time > datetime.fromisoformat(row['password_next_rotation']).replace(tzinfo=None):
                        credential_report_expired.append(row)
                        print(row['user'], row['password_next_rotation'])
                return credential_report_expired
            except ClientError as e:
                print("Unknown error getting Report: " + e.message)
        else:
            sleep(5)
            return get_credential_report_expired(iam_client)

    # Function for extraction of email address from IAM user tags
    def get_email(user_name):
        user_tags = iam_client.list_user_tags(
            UserName=user_name
        )
        if user_tags['Tags']:
            for tag in user_tags['Tags']:
                if tag['Key'] == 'email':
                    return tag['Value']

    # Function for send an email notification to certain user
    def send_notification(email, pass_exp_time, acc_name, text_fragment):
        email_text = f'''
            This is an automatic reminder for IAM user {email} about AWS password rotation at least every 90 days.

            Your AWS password in {acc_name} account {text_fragment} at {pass_exp_time}.
            
            Please rotate it as soon as possible. If you need any help, feel free to contact us.\n

            Regards,
            DevOps Team
            '''

        try:
            ses_response = ses_client.send_email(
                Destination={'ToAddresses': [email, "devops@example.com"]},
                Message={
                    'Body': {'Text': {'Charset': 'UTF-8', 'Data': email_text}},
                    'Subject': {'Charset': 'UTF-8',
                                'Data': f'Please rotate your AWS password on {acc_name} account!'}
                },
                Source=SES_SENDER
            )
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print(f'Notification email sent successfully to {email}!')


    # Get current sub-report
    current_exp_credential_report = get_credential_report_expired(iam_client)
    # Send mail notification to all users from sub-report
    if len(current_exp_credential_report) > 0:
        print("not good ", len(current_exp_credential_report))
        for cred_report_row in current_exp_credential_report:
            row_exp_time = datetime.fromisoformat(cred_report_row['password_next_rotation']).replace(tzinfo=None)
            if current_time > row_exp_time:
                mail_message = "has expired"
            else:
                mail_message = "will expire"
            try:
                email_address = get_email(cred_report_row['user'])
            except ClientError as e:
                print("Unknown error getting Report: " + e.message)
            send_notification(email_address, row_exp_time, account_name, mail_message)
    else:
        print("No user needs IAM password rotation!")