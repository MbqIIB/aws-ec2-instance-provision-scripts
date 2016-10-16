#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
    echo "##################################################"
    echo "##################################################"
    cat /aws.services/.ec2Instance
    echo "##################################################"
    echo "##################################################"

## SET runasuser variable based on the Project ##
# runuser -l $appUser -c ' ... '
    sshUser=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')


## ERROR Handing Function ##
die() {
    echo "FATAL ERROR: $* (EXIT Status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}


## ALTER EC2 Instance Tag: ServiceStatus ##
    echo "Altering EC2 Instace ServiceStatus Tag FROM [inDeployment-beforeInstall] TO [inDeployment-afterInstall]"
    aws ec2 delete-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-beforeInstall
    aws ec2 create-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-afterInstall


## EXECUTING Commands ##
echo "## START CodeDeploy LifeCycle: \"After-Install\""
#echo "##-- 101-prepare.deployment.enviroment.sh"
#bash $DIR/after.install.cmds/101-prepare.deployment.enviroment.sh || die "Unable to execute BashScript: 101-prepare.deployment.enviroment.sh"
echo "##-- 102-configure.ec2admin-awscrds.sh"
bash $DIR/after.install.cmds/102-configure.ec2admin-awscrds.sh || die "Unable to execute BashScript: 102-configure.ec2admin-awscrds.sh"
echo "##-- 103-gitclone-aws.ssm-scripts.library.sh"
bash $DIR/after.install.cmds/103-gitclone-aws.ssm-scripts.library.sh || die "Unable to execute BashScript: 103-gitclone-aws.ssm-scripts.library.sh"
#echo "##-- 104-configure.aws.cloudwatch.custom.metrics.sh"
#bash $DIR/after.install.cmds/104-configure.aws.cloudwatch.custom.metrics.sh || die "Unable to execute BashScript: 104-configure.aws.cloudwatch.custom.metrics.sh"
#echo "##-- 105-configure.aws.cloudwatch.alarms.sh"
#bash $DIR/after.install.cmds/105-configure.aws.cloudwatch.alarms.sh || die "Unable to execute BashScript: 105-configure.aws.cloudwatch.alarms.sh"
echo "##-- 106-stop.disable.all.web.services.sh"
bash $DIR/after.install.cmds/106-stop.disable.preinstalled.services.sh || die "Unable to execute BashScript: 106-stop.disable.preinstalled.services.sh"
##echo "##-- 199-configure.aws.ec2InstanceNanny.sh"
##bash $DIR/after.install.cmds/199-configure.aws.ec2InstanceNanny.sh || die "Unable to execute BashScript: 199-configure.aws.ec2InstanceNanny.sh"
echo "##-- 201-enable.additional.repos.sh"
bash $DIR/after.install.cmds/201-enable.additional.repos.sh || die "Unable to execute BashScript: 201-enable.additional.repos.sh"
echo "##-- 202-set.instance.timezone.sh"
bash $DIR/after.install.cmds/202-set.instance.timezone.sh || die "Unable to execute BashScript: 202-set.instance.timezone.sh"
echo "##-- 203-enable.swapfile.sh"
bash $DIR/after.install.cmds/203-enable.swapfile.sh || die "Unable to execute BashScript: 203-enable.swapfile.sh"
echo "##-- 204-disable.selinux.firewall.sh"
bash $DIR/after.install.cmds/204-disable.selinux.firewall.sh || die "Unable to execute BashScript: 204-disable.selinux.firewall.sh"
#echo "##-- 205-install.extra.security.software.sh"
#bash $DIR/after.install.cmds/205-install.extra.security.software.sh || die "Unable to execute BashScript: 205-install.extra.security.software.sh"
#echo "##-- 206-install.mariadb.sh"
#bash $DIR/after.install.cmds/206-install.mariadb.sh || die "Unable to execute BashScript: 206-install.mariadb.sh"
echo "##-- 207-install.nginx.sh"
bash $DIR/after.install.cmds/207-install.nginx.sh || die "Unable to execute BashScript: 207-install.nginx.sh"
echo "##-- 208-install.php.sh"
bash $DIR/after.install.cmds/208-install.php.sh || die "Unable to execute BashScript: 208-install.php.sh"
echo "##-- 209-install.nfs.sh"
bash $DIR/after.install.cmds/209-install.nfs.sh || die "Unable to execute BashScript: 209-install.nfs.sh"
#echo "##-- 210-install.s3fs.sh"
#bash $DIR/after.install.cmds/210-install.s3fs.sh || die "Unable to execute BashScript: 210-install.s3fs.sh"
echo "##-- 211-install.newrelic.sh"
bash $DIR/after.install.cmds/211-install.newrelic.sh || die "Unable to execute BashScript: 211-install.newrelic.sh"
    
echo "## END CodeDeploy LifeCycle: \"After Install\""
