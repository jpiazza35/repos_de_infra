import datetime
import json
import logging
import os
import re

from slack_sdk.webhook import WebhookClient

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def alarm_notifications_handler(event, context):
    logger.info(f"SNS Notification Response: {event['Records']}")

    url = os.environ.get('LAMBDA_SLACK_WEBHOOK')
    project = os.environ.get('LAMBDA_SLACK_PROJECT')

    webhook = WebhookClient(url)

    for content in event['Records']:
        sns_message = json.loads(content['Sns']['Message'])
        logger.info(f"Cloudwatch Event Message: {sns_message}")

        attachment_message = f"AWS Cloudwatch Notification System for {project} - {sns_message['AlarmName']}"

        region = get_alarm_region(sns_message)
        alarm_color = set_message_color(sns_message)

        response = webhook.send(
            attachments=[
                {
                    "mrkdwn_in": ["text"],
                    "color": alarm_color,
                    "pretext": f"{attachment_message}",
                    "fields": [
                        {
                            "title": "Alarm Name",
                            "value": f"{sns_message['AlarmName']}",
                            "short": False

                        },
                        {
                            "title": "Alarm Description",
                            "value": f"{sns_message['AlarmDescription']}",
                            "short": False

                        },
                        {
                            "title": "Alarm Reason",
                            "value": f"{sns_message['NewStateReason']}",
                            "short": False

                        },
                        {
                            "title": "Old State",
                            "value": f"{sns_message['OldStateValue']}",
                            "short": True

                        },
                        {
                            "title": "Current State",
                            "value": f"{sns_message['NewStateValue']}",
                            "short": True
                        },
                        {
                            "title": "Link to Alarm",
                            "value": f"https://console.aws.amazon.com/cloudwatch/home?region={region}#alarm"
                                     f":alarmFilter=ANY;name={sns_message['AlarmName']}",
                            "short": False
                        }
                    ],
                    "thumb_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn"
                                 ":ANd9GcQoAibUmGxrInP4SqZJHOWZHKD1v4b0tzguTw&usqp=CAU",
                    "footer": "slack api - aws lambda",
                    "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png",
                    "ts": datetime.datetime.now().timestamp()
                }
            ]
        )

        if response.status_code == 200:
            logger.info('Message delivered successfully to slack channel')
        else:
            logger.error(f"Response from Slack server API: {response.status_code} ---> {response.body}")


def get_alarm_region(sns_message):
    regex = '.+:((?:\\w+-)+\\w+):.+'
    alarm_arn = sns_message['AlarmArn']
    logger.info(f"Getting alarm region from {alarm_arn}")

    try:
        region = re.search(regex, alarm_arn).group(1)
    except AttributeError:
        logger.error(f"Cannot get region from {alarm_arn}")
        region = ""

    return region


def set_message_color(sns_message):
    alarm_color = "#47c718"  # green color
    if sns_message['NewStateValue'] == "ALARM":
        alarm_color = "#f54242"  # red color

    logger.info(f"Setting message color to {alarm_color}")
    return alarm_color
