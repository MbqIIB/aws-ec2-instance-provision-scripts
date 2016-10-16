#!/bin/bash

## GET Instance's Identity ##
ec2InstaceID=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep instanceId | awk -F\" '{print $4}')
ec2InstanceRegion=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
ec2InstancePrivateIP=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep privateIp | awk -F\" '{print $4}')

## GET Instance's Tags ##
ec2TagEcoSystem=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=EcoSystem" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagWebApplication=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=WebApplication" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagInterface=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=Interface" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagEnvironment=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=Environment" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagServiceStatus=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=ServiceStatus" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')

## EXPORT Instance's Informations ##
echo "EC2 Instance Identity:" > /aws.services/.ec2Instance
echo "instanceID: $ec2InstaceID" >> /aws.services/.ec2Instance
echo "instanceRegion: $ec2InstanceRegion" >> /aws.services/.ec2Instance
echo "instancePrivateIP: $ec2InstancePrivateIP" >> /aws.services/.ec2Instance
echo "EC2 Instance Tags:" >> /aws.services/.ec2Instance
echo "EcoSystem: $ec2TagEcoSystem" >> /aws.services/.ec2Instance
echo "WebApplication: $ec2TagWebApplication" >> /aws.services/.ec2Instance
echo "Interface: $ec2TagInterface" >> /aws.services/.ec2Instance
echo "Environment: $ec2TagEnvironment" >> /aws.services/.ec2Instance
echo "ServiceStatus: $ec2TagServiceStatus" >> /aws.services/.ec2Instance

## VIEW Instance's Informations ##
cat /aws.services/.ec2Instance


## SET runasuser variable based on the Project ##
# runuser -l $appUser -c ' ... '
sshUser=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')


## ERROR Handing Function ##
die() {
    echo "FATAL ERROR: $* (EXIT Status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}


## ALTER EN2 Instance Tag: ServiceStatus ##
echo "Altering EC2 Instace ServiceStatus Tag FROM [inDeployment-beforeInstall] TO [inDeployment-afterInstall]"
aws ec2 delete-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-beforeInstall
aws ec2 create-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-afterInstall


## EXECUTING Commands ##
echo "START EXECUTING [After-Install] LifeCycle Commands.."
#echo "Executing BashScript: 101-prepare.deployment.enviroment.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/101-prepare.deployment.enviroment.sh || die "Unable to execute BashScript: 101-prepare.deployment.enviroment.sh"
echo "Executing BashScript: 102-configure.ec2admin-awscrds.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/102-configure.ec2admin-awscrds.sh || die "Unable to execute BashScript: 102-configure.ec2admin-awscrds.sh"
echo "Executing BashScript: 103-gitclone-aws.ssm-scripts.library.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/103-gitclone-aws.ssm-scripts.library.sh || die "Unable to execute BashScript: 103-gitclone-aws.ssm-scripts.library.sh"
#echo "Executing BashScript: 104-configure.aws.cloudwatch.custom.metrics.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/104-configure.aws.cloudwatch.custom.metrics.sh || die "Unable to execute BashScript: 104-configure.aws.cloudwatch.custom.metrics.sh"
#echo "Executing BashScript: 105-configure.aws.cloudwatch.alarms.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/105-configure.aws.cloudwatch.alarms.sh || die "Unable to execute BashScript: 105-configure.aws.cloudwatch.alarms.sh"
echo "Executing BashScript: 106-stop.disable.all.web.services.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/106-stop.disable.preinstalled.services.sh || die "Unable to execute BashScript: 106-stop.disable.preinstalled.services.sh"
##echo "Executing BashScript: 199-configure.aws.ec2InstanceNanny.sh"
##bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/199-configure.aws.ec2InstanceNanny.sh || die "Unable to execute BashScript: 199-configure.aws.ec2InstanceNanny.sh"

echo "Executing BashScript: 201-enable.additional.repos.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/201-enable.additional.repos.sh || die "Unable to execute BashScript: 201-enable.additional.repos.sh"
echo "Executing BashScript: 202-set.instance.timezone.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/202-set.instance.timezone.sh || die "Unable to execute BashScript: 202-set.instance.timezone.sh"
echo "Executing BashScript: 203-enable.swapfile.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/203-enable.swapfile.sh || die "Unable to execute BashScript: 203-enable.swapfile.sh"
echo "Executing BashScript: 204-disable.selinux.firewall.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/204-disable.selinux.firewall.sh || die "Unable to execute BashScript: 204-disable.selinux.firewall.sh"
#echo "Executing BashScript: 205-install.extra.security.software.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/205-install.extra.security.software.sh || die "Unable to execute BashScript: 205-install.extra.security.software.sh"
#echo "Executing BashScript: 206-install.mariadb.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/206-install.mariadb.sh || die "Unable to execute BashScript: 206-install.mariadb.sh"
echo "Executing BashScript: 207-install.nginx.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/207-install.nginx.sh || die "Unable to execute BashScript: 207-install.nginx.sh"
echo "Executing BashScript: 208-install.php.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/208-install.php.sh || die "Unable to execute BashScript: 208-install.php.sh"
echo "Executing BashScript: 209-install.nfs.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/209-install.nfs.sh || die "Unable to execute BashScript: 209-install.nfs.sh"
#echo "Executing BashScript: 210-install.s3fs.sh"
#bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/210-install.s3fs.sh || die "Unable to execute BashScript: 210-install.s3fs.sh"
echo "Executing BashScript: 211-install.newrelic.sh"
bash /aws.services/codedeploy/AWS.CodeDeploy.Scripts/after.install.cmds/211-install.newrelic.sh || die "Unable to execute BashScript: 211-install.newrelic.sh"

    
echo "FINISH EXECUTING After-Install LifeCycle Commands.."
