#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## GET Instance's Identity ##
ec2InstaceID=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep instanceId | awk -F\" '{print $4}')
ec2InstanceRegion=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
ec2InstancePrivateIP=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep privateIp | awk -F\" '{print $4}')

## GET Instance's Tags ##
ec2TagNeme=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=Name" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagGitRepoURL=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=GitRepo_URL" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
ec2TagGitRepoBranch=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2InstaceID" "Name=key,Values=GitRepo_Branch" --region=$ec2InstanceRegion | grep Value | awk -F\" '{print $4}')
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
    echo "Name: $ec2TagName" >> /aws.services/.ec2Instance
    echo "GitRepoURL: $ec2TagGitRepoURL" >> /aws.services/.ec2Instance
    echo "GitRepoBranch: $ec2TagGitRepoBranch" >> /aws.services/.ec2Instance
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
    echo "Altering EC2 Instace ServiceStatus Tag FROM [inDeployment-afterInstall] TO [inDeployment-startApplication]"
    aws ec2 delete-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-afterInstall
    aws ec2 create-tags --resources $ec2InstaceID --tags Key=ServiceStatus,Value=inDeployment-startApplication

echo "START CodeDeploy LifeCycle: \"Application Start\"" >> /aws.services/codedeploy/latestDeployment.logs

bash $DIR/application.start.cmds/301-update.instance.hostname.sh || die "Update Instance Hostname Failed.."
#bash $DIR/application.start.cmds/302-mount.global.gem.apps.s3bucket.sh || die "Mounting Global.GEM.Apps S3.Bucket Failed.."
bash $DIR/application.start.cmds/303-configure.appuser.aws.crds.sh || die "Configuring Application User AWS Credentials Failed.."
bash $DIR/application.start.cmds/304-add.appuser.ssh.user.sh || die "Creating Application SSH User SSH User Failed.."
#bash $DIR/application.start.cmds/305-mount.app.s3bucket.sh || die "Mounting Application S3.Bucket Failed.."
bash $DIR/application.start.cmds/306-prepare.app.lnxfolders.structure.sh || die "Preparing Application Linux Folder Structure Failed.."
bash $DIR/application.start.cmds/307-sync.php.configuration.sh || die "Configure of PHP Service Failed.."
bash $DIR/application.start.cmds/308-sync.nginx.configuration.sh || die "Configure of NGinx Service Failed.."
bash $DIR/application.start.cmds/310-install.php.composer.sh || die "Installation of PHP Composer Failed.."
#runuser -l $sshUser -c 'sh $DIR/application.start.cmds/311-sync.appuser.sshd.configuration.sh || die "Configre of Applicatiob SSH User Failed.."'
runuser -p -u $sshUser -c 'bash $DIR/application.start.cmds/312-git.clone.app.latest.version.sh || die "Cloning of the Application latest GIT revision Failed.."'
runuser -p -u $sshUser -c 'bash $DIR/application.start.cmds/313-execute.composer.install.sh || die "Executing Composer Install Failed.."'
runuser -p -u $sshUser -c 'bash $DIR/application.start.cmds/314-create.all.appuser.symlinks.sh || die "Configure all symlinks to Application User Home Folder Failed.."'
bash $DIR/application.start.cmds/395-sync-enable-start.all.sys.services.sh || die "Syncing, Enabling and Starting All System Services Failed.."
runuser -p -u $sshUser -c 'bash $DIR/application.start.cmds/397-start.all.app.services.sh || die "Starting all Application Services Failed.."'
runuser -p -u $sshUser -c 'bash $DIR/application.start.cmds/399-start.gqm-qc-daemons.sh || die "Starting GQM:QueueClient Services Failed.."'

echo "## END CodeDeploy LifeCycle: \"Application Start\"" >> /aws.services/codedeploy/latestDeployment.logs
