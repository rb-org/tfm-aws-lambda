import boto3
import os
# import json
# from datetime import datetime
from botocore.exceptions import ClientError

client = boto3.client('s3')
s3 = boto3.resource('s3')

region = os.environ['REGION']


def lambda_handler(event, context):
    try:
        print(event)
        s3event = event['detail']['requestParameters']
        s3acl = s3event['accessControlList']
        print(s3acl)

    except Exception as e:
        print('Error - reason "%s"' % str(e))
