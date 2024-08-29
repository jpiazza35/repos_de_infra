from __future__ import print_function
import json

def lambda_handler(event, context):
    print(json.dumps(event))
