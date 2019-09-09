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
        s3event = event['requestParameters']
        s3acl = s3event['accessControlList']
        s3_acl_read = s3acl['x-amz-grant-read']
        s3_acl_write = s3acl['x-amz-grant-write']
        bucket = s3event['bucketName']
        key = s3event['key']
        print(s3acl)
        public_access = 'uri=\"http://acs.amazonaws.com/groups/global/AllUsers\"'
        if public_access in s3_acl_read or s3_acl_write:
            print("Public ACL on {0} found in bucket {1}".format(key, bucket))
            try:
                print('Reset ACL to private')
                response = client.put_object_acl(
                    ACL='private',
                    Bucket=bucket,
                    Key=key
                )
                print(response)
            except Exception as e:
                print('Error - reason "%s"' % str(e))

    except Exception as e:
        print('Error - reason "%s"' % str(e))
