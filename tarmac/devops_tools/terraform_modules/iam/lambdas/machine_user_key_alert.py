import boto3, json, time, datetime, sys, os
from botocore.exceptions import ClientError

client = boto3.client('iam')
sns = boto3.client('sns')
days_old = int(os.getenv('DAYS_OLD'))
topic_arn = os.getenv('SNS_TOPIC_ARN')
account_name = os.getenv('ACCOUNT_NAME')

usernames = []
mylist = []

def lambda_handler(event, context):

    users = client.list_users()
    for key in users['Users']:
        a = str(key['UserName'])
        usernames.append(a)

    for username in usernames:

        try:
            res = client.list_access_keys(UserName=username)  
            accesskeydate = res['AccessKeyMetadata'][0]['CreateDate'] 
            accesskeydate = accesskeydate.strftime("%Y-%m-%d %H:%M:%S")
            currentdate = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime())
            accesskeyd = time.mktime(datetime.datetime.strptime(accesskeydate, "%Y-%m-%d %H:%M:%S").timetuple())
            currentd = time.mktime(datetime.datetime.strptime(currentdate, "%Y-%m-%d %H:%M:%S").timetuple())
            active_days = (currentd - accesskeyd)/60/60/24 ### We get the data in seconds. converting it to days

            if days_old < active_days:
                response_old = 'The {} IAM access key in the {} account is {} days old.'.format(username,account_name,int(round(active_days)))
                print(response_old)
                response = sns.publish(TopicArn=topic_arn, Message = response_old)
                
            else:
                response_ok = 'The {} IAM access key in the {} account is {} days old.'.format(username,account_name,int(round(active_days)))
                response = print(response_ok)
                
        except ClientError as e:
            print(e.response['Error']['Message'])

    

