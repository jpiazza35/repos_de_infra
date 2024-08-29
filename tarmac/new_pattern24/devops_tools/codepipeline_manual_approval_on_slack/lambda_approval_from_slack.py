from urllib.parse import parse_qs
import json
import os
import boto3

SLACK_VERIFICATION_TOKEN = os.environ.get('SLACK_VERIFICATION_TOKEN')
STAGE_NAME = os.environ.get('CodepipelineStageName')
ACTION_NAME = os.environ.get('CodepipelineActionName')

print(SLACK_VERIFICATION_TOKEN)
print(STAGE_NAME)
print(ACTION_NAME)

def lambda_handler(event, context):
 #print("Received event: " + json.dumps(event, indent=2))
 body = parse_qs(event['body'])
 payload = json.loads(body['payload'][0])

 if SLACK_VERIFICATION_TOKEN == payload['token']:
  send_slack_message(json.loads(payload['actions'][0]['value']))

  return  {
    "isBase64Encoded": "false",
    "statusCode": 200,
    "body": "{\"text\": \"The approval has been processed\"}"
  }
 else:
  return  {
    "isBase64Encoded": "false",
    "statusCode": 403,
    "body": "{\"error\": \"This request does not include a vailid verification token.\"}"
  }

def send_slack_message(action_details):
 codepipeline_status = "Approved" if action_details["approve"] else "Rejected"
 token = action_details["codePipelineToken"]

 client = boto3.client('codepipeline')
 response = client.put_approval_result(
    pipelineName=action_details['codePipelineName'],
    stageName=STAGE_NAME,
    actionName=ACTION_NAME,
    result={
        'summary': '',
        'status': codepipeline_status
    },
    token=token
 )
 print(response)
