#!/bin/bash

#GET Instance's Identity
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep instanceId | awk -F\" '{print $4}')
EC2_INSTANCE_PRVIP=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep privateIp | awk -F\" '{print $4}')
EC2_INSTANCE_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

#GET Instance's Tags
EC2_INSTANCE_TAG_ECOSYSTEM=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=EcoSystem" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')
EC2_INSTANCE_TAG_WEBAPPLICATION=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=WebApplication" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')
EC2_INSTANCE_TAG_INTERFACE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=Interface" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')
EC2_INSTANCE_TAG_ENVIRONMENT=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=Environment" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')
##EC2_INSTANCE_TAG_ELB=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=connectToELB" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')
##EC2_INSTANCE_TAG_PUBNETWORK=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=hasPublicNetwork" --region=$EC2_INSTANCE_REGION | grep Value | awk -F\" '{print $4}')


#EXPORT Instance's Informations
echo "instanceID: $EC2_INSTANCE_ID" > /aws.services/.ec2Instance
echo "instancePrivateIP: $EC2_INSTANCE_PRVIP" >> /aws.services/.ec2Instance
echo "instanceRegion: $EC2_INSTANCE_REGION" >> /aws.services/.ec2Instance
echo "EcoSystem: $EC2_INSTANCE_TAG_ECOSYSTEM" >> /aws.services/.ec2Instance
echo "WebApplication: $EC2_INSTANCE_TAG_WEBAPPLICATION" >> /aws.services/.ec2Instance
echo "Interface: $EC2_INSTANCE_TAG_INTERFACE" >> /aws.services/.ec2Instance
echo "Environment: $EC2_INSTANCE_TAG_ENVIRONMENT" >> /aws.services/.ec2Instance
##echo "connectToELB: $EC2_INSTANCE_TAG_ELB" >> /aws.services/.ec2Instance
##echo "hasPublicNetwork: $EC2_INSTANCE_TAG_PUBNETWORK" >> /aws.services/.ec2Instance

cat /aws.services/.ec2Instance

#SET runasuser variable based on the Project
#runuser -l $prj_user -c ' ... '
APPUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (EXIT Status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "START EXECUTING Validation-Service LifeCycle Commands.." >> /aws.services/codedeploy/latestDeployment.logs

##sh /aws.services/codedeploy/AWS.CodeDeploy.Scripts/validate.service.cmds/499-register.to.elb.sh || die "Registering EC2 Instance to ELB FAILED.."

echo "Altering EC2 Instace ServiceStatus Tag FROM [inDEPLOYMENT-VALIDATON.Service] TO [ACTIVE]"
    aws ec2 delete-tags --resources $EC2_INSTANCE_ID --tags Key=ServiceStatus,Value=inDEPLOYMENT-VALIDATION.Service
    aws ec2 create-tags --resources $EC2_INSTANCE_ID --tags Key=ServiceStatus,Value=ACTIVE

echo "FINISH EXECUTING Validation-Service LifeCycle Commands.." >> /aws.services/codedeploy/latestDeployment.logs
