import boto3
import os
import json
from datetime import datetime
from botocore.exceptions import ClientError

client = boto3.client('ec2')
ec2 = boto3.resource('ec2')
flow_logs_group = os.environ['FLOW_LOGS_GROUP']
iam_role_arn = os.environ['IAM_ROLE_ARN']


def lambda_handler(event, context):
    try:
        # Print some stuff to check we got the event correctly
        vpc_id = event
        print("New VPC Id: {0}".format(vpc_id))

        vpc = ec2.Vpc(vpc_id)
        print("VPC Cidr block: {0}".format(vpc.cidr_block))

        # # Create a log group

        # try:
        #     response = logs.create_log_group(
        #         logGroupName=flow_logs_group
        #     )
        # except ClientError:
        #     print(f"Log group '{flow_logs_group}' already exists.")

        # Enable VPC flow logs for the VPC
        response_describe = client.describe_flow_logs(
            DryRun=False,
            Filters=[
                {
                    'Name': 'resource-id',
                    'Values': [
                        vpc_id,
                    ]
                },
            ],
        )

        if len(response_describe['FlowLogs']) > 0:
            print("Flow logs already enabled")
        else:
            client.create_flow_logs(
                DryRun=False,
                DeliverLogsPermissionArn=iam_role_arn,
                LogGroupName=flow_logs_group,
                ResourceIds=[
                    vpc_id,
                ],
                ResourceType='VPC',
                TrafficType='ALL',
            )
            print("Flow logs created")

    except Exception as e:
        print('Error - reason "%s"' % str(e))
