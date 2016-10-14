#!/bin/bash

mkdir -p /aws.services/.aws/

echo "Configuring AWS Credentials For AWS.Admin.EC2 IAM User"
AWSAccessKeyID=$(sed -n 's/^aws_access_key_id=//p' /root/.aws/credentials)
AWSAccessKeySecret=$(sed -n 's/^aws_secret_access_key=//p' /root/.aws/credentials)

echo $AWSAccessKeyID:$AWSAccessKeySecret > /aws.services/.aws/.ec2admin.credentials
chmod 600 /aws.services/.aws/.ec2admin.credentials
