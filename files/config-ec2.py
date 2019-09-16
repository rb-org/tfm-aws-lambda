import boto3
import os
# import json
import datetime
from datetime import datetime, timezone, timedelta
from dateutil.parser import parse
from botocore.exceptions import ClientError

client = boto3.client('config')
cfg = boto3.resource('config')

region = os.environ['REGION']


def lambda_handler(event, context):

    detail = event['detail']

    if not detail['responseElements']:
        print('No responseElements found')
        if detail['errorCode']:
            print('errorCode: ' + detail['errorCode'])
        if detail['errorMessage']:
            print('errorMessage: ' + detail['errorMessage'])
        return False

    try:
        print(event)
    except Exception as e:
        print('Error - reason "%s"' % str(e))
