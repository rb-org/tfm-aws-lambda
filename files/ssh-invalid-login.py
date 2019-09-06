import boto3
import os
import json
# from datetime import datetime
from botocore.exceptions import ClientError

region = os.environ['REGION']

client = boto3.client('ec2', region_name=region)
# ec2 = boto3.resource('ec2', region_name=region)

# event only contains the Instance ID if hard coded into the alarm description.


def lambda_handler(event, context):
    try:
        sns_msg = event['Records'][0]['Sns']
        json_msg = json.loads(sns_msg['Message'])
        instance_id = json_msg('AlarmDescription')
        client.stop_instances(
            InstanceIds=[
                instance_id,
            ],
        )
        print('Stopped instance: ', instance_id)
    except Exception as e:
        print('Error - reason "%s"' % str(e))
