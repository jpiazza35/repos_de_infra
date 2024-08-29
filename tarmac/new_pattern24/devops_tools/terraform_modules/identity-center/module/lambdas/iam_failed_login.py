import boto3
from boto3.dynamodb.conditions import Key, Attr
import os
import json
from datetime import datetime, timedelta
from dateutil import parser

# Variables
dyndb_table_name = os.getenv('DYNAMODB_TABLE')
topic_arn = os.getenv('SNS_TOPIC_ARN')
failed_logins = 5
time_list=[]

# boto3
sns = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    username = event['detail']['userIdentity']['userName']
    ##username = event['userIdentity']['userName'] ##-- line for testing purposes.
    cur_date_time = datetime.today()
    past_10minutes = cur_date_time - timedelta(minutes = 10)
    table = dynamodb.Table(dyndb_table_name)
    record_bad_login = table.put_item(
    Item = { 
         'Datetime': cur_date_time.isoformat(),
         'Username': username
          }
    )
    ## Fetch all failed logins of the current username.
    user_failed_logins = table.scan(FilterExpression=Attr('Username').eq(username),TableName=dyndb_table_name,ConsistentRead=True)    
    user_failed_logins_count = table.scan(Select='COUNT',FilterExpression=Attr('Username').eq(username),TableName=dyndb_table_name,ConsistentRead=True)
    time_list = []
    for i in user_failed_logins['Items']:
        date_time = i['Datetime']
        time_list.append(date_time)
        date_first_bad_login = sorted(time_list)
    clean_list = list(dict.fromkeys(date_first_bad_login))

    if failed_logins < user_failed_logins_count['Count']:
        date_first_bad_login_FMTD = parser.parse(date_first_bad_login[0])

        if date_first_bad_login_FMTD > past_10minutes :
            message="Detected failed login on the root account. username:{} timestamp: {}".format(username,cur_date_time)
            print(message)
            sns_message = sns.publish(
                TopicArn=topic_arn,
                Message=message
                )
            print('Message sent to SNS topic: %s' % sns_message)
            delete_first_item = table.delete_item(
            Key = { 
                'Datetime': date_first_bad_login[0],
                'Username': username
                 },
                 )
            print("Row with username {} and datetime {} deleted.".format(username,date_first_bad_login[0]))
        else:
            with table.batch_writer() as batch:
                 for each in user_failed_logins['Items']:
                    batch.delete_item(
                         Key={
                               'Datetime': each['Datetime'],
                               'Username': each['Username']
                           }
                    )
