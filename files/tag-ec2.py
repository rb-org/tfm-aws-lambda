import boto3
import os
# import json
# from datetime import datetime
from botocore.exceptions import ClientError

client = boto3.client('ec2')
ec2 = boto3.resource('ec2')

region = os.environ['REGION']

resource_ids = []


def lambda_handler(event, context):
    try:
        # print(event)
        # Create EC2
        if event['detail']['eventName'] == 'RunInstances':
            items = event['detail']['responseElements']['instancesSet']['items']
            for item in items:
                resource_ids.append(item['instanceId'])
                volumes = client.describe_volumes(
                    Filters=[
                        {
                            'Name': 'attachment.instance-id',
                            'Values': [
                                item['instanceId'],
                            ]
                        },
                    ]
                )
                vol_list = volumes['Volumes']
                for vol in vol_list:
                    vol_id = vol['VolumeId']
                    resource_ids.append(vol_id)
        # Create EBS
        elif event['detail']['eventName'] == 'CreateVolume':
            resource_ids.append(
                event['detail']['responseElements']['volumeId'])

        # Create Snapshot
        elif event['detail']['eventName'] == 'CreateSnapshot':
            resource_ids.append(
                event['detail']['responseElements']['snapshotId'])

        else:
            print('Not supported: {0}'.format(event['detail']['eventName']))

        # Create Tags
        client.create_tags(
            Resources=resource_ids,
            Tags=[
                {
                    'Key': 'SecureTag',
                    'Value': 'true'
                },
                {
                    'Key': 'Name',
                    'Value': 'testing123'
                }
            ]
        )

    except Exception as e:
        print('Error - reason "%s"' % str(e))
