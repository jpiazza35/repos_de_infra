import os
import json
import logging
import urllib.parse

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_WEBHOOK_URL = os.environ.get('SLACK_WEBHOOK_URL')
SLACK_CHANNEL = os.environ.get('SLACK_CHANNEL')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    message = event["Records"][0]["Sns"]["Message"]

    data = json.loads(message)
    token = data["approval"]["token"]
    codepipeline_name = data["approval"]["pipelineName"]

    slack_message = {
        "channel": SLACK_CHANNEL,
        "text": "Would you like to promote the build to production?",
        "attachments": [
            {
                "text": "Yes to deploy your build to production",
                "fallback": "You are unable to promote a build",
                "callback_id": "Put the callback_id for the action",
                "color": "#SomeColourHere",
                "attachment_type": "default",
                "actions": [
                    {
                        "name": "deployment",
                        "text": "Yes",
                        "style": "danger",
                        "type": "button",
                        "value": json.dumps({"approve": True, "codePipelineToken": token, "codePipelineName": codepipeline_name}),
                        "confirm": {
                            "title": "Are you sure?",
                            "text": "This will deploy the build to production",
                            "ok_text": "Yes",
                            "dismiss_text": "No"
                        }
                    },
                    {
                        "name": "deployment",
                        "text": "No",
                        "type": "button",
                        "value": json.dumps({"approve": False, "codePipelineToken": token, "codePipelineName": codepipeline_name})
                    }
                ]
            }
        ]
    }

    req = Request(SLACK_WEBHOOK_URL,
json.dumps(slack_message).encode('utf-8'))

    response = urlopen(req)
    response.read()

    return None
