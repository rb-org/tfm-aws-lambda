import boto3
import os
import datetime
from datetime import datetime, timezone, timedelta
from dateutil.parser import parse
from botocore.exceptions import ClientError

client = boto3.client('iam')

# Calculate age
x_days = 60
older_than_x_days = datetime.now(timezone.utc)-timedelta(days=x_days)


def lambda_handler(event, context):

    try:
        print(event)

        iam_users = client.list_users()
        # num_users = len(iam_users['Users'])

        for user in iam_users['Users']:
            access_key = client.list_access_keys(
                UserName=user['UserName']
            )
            for key in access_key['AccessKeyMetadata']:
                key_id = key['AccessKeyId']
                key_date = key['CreateDate']
                if key_date <= older_than_x_days:
                    print(
                        "Access key will be disabled - too old: {0} {1}".format(key_id, key_date))
                    # response = client.delete_access_key(
                    #     UserName=user['UserName'],
                    #     AccessKeyId=key_id
                    # )
                    response = client.update_access_key(
                        DryRun=True,
                        UserName=user['UserName'],
                        AccessKeyId=key_id,
                        Status='Inactive'
                    )
                    print(response)
                else:
                    print("Key age ok: {0} {1}".format(key_id, key_date))

    except Exception as e:
        print('Error - reason "%s"' % str(e))
