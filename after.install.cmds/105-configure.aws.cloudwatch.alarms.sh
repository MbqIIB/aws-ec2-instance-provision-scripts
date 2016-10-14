#!/bin/bash

#GET EC2 Instance's Identity
ec2InstanceID=$(cat /aws.services/.ec2Instance| grep instanceID | awk '{print $2}')
ec2InstanceRegion=$(cat /aws.services/.ec2Instance| grep instanceRegion | awk '{print $2}')
ec2InstancePrivateIP=$(cat /aws.services/.ec2Instance| grep instancePrivateIP | awk '{print $2}')


aws cloudwatch put-metric-alarm --alarm-name EC2.Instance-lowCPUCredits[$ec2InstanceID] --alarm-description "Instance (ID: $ec2InstanceID | Private IP: $ec2InstancePrivateIP | Region: $ec2InstanceRegion) | CPU Credits Status [LOW] (less or equal than 5)" --metric-name CPUCreditBalance --namespace AWS/EC2 --dimensions "Name=InstanceId,Value=$ec2InstanceID" --period 300 --evaluation-periods 1 --comparison-operator LessThanOrEqualToThreshold --threshold 5 --unit Count --statistic Minimum --alarm-actions arn:aws:sns:eu-west-1:547013329349:EC2_Instances-ALARMS
aws cloudwatch put-metric-alarm --alarm-name EC2.Instance-highCPUCredits[$ec2InstanceID] --alarm-description "Instance (ID: $ec2InstanceID | Private IP: $ec2InstancePrivateIP | Region: $ec2InstanceRegion) | CPU Credits Status [HIGH] (more or equal than 72)" --metric-name CPUCreditBalance --namespace AWS/EC2 --dimensions "Name=InstanceId,Value=$ec2InstanceID" --period 300 --evaluation-periods 1 --comparison-operator GreaterThanOrEqualToThreshold --threshold 72 --unit Count --statistic Maximum --alarm-actions arn:aws:sns:eu-west-1:547013329349:EC2_Instances-ALARMS
