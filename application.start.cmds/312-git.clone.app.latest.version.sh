#!/bin/bash

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

#GET Project's Name and EcoSystem
appEco=$(cat /aws.services/.ec2Instance     | grep EcoSystem        | awk '{print $2}')
appName=$(cat /aws.services/.ec2Instance    | grep WebApplication   | awk '{print $2}')
appEnv=$(cat /aws.services/.ec2Instance     | grep Environment      | awk '{print $2}')

# Retrieve GitHub Repo Configuration Files from S3 Bucket
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/github-repository_info /tmp/.app-github-repository_info
    chmod 600 /tmp/.app-github*

# Parse GitHub Repo Information
    appGitRepoUsername=$(cat /tmp/.app-github-repository_info | grep Username      | awk '{print $2}')
    appGitRepoPassword=$(cat /tmp/.app-github-repository_info | grep Password      | awk '{print $2}')
    appGitRepoURL=$(cat /tmp/.app-github-repository_info      | grep RepoURL       | awk '{print $2}')
    appGitRepoBranch=$(cat /tmp/.app-github-repository_info   | grep RepoBranch    | awk '{print $2}')    

# Remove GitRepo Information File from Temp Folder
    rm -rf /tmp/.app-github*


# Update appGitRepoURL Variable with Git Account Information (username & password)
appGitRepoURL="$(sed s/github\.com/$appGitRepoUsername\:$appGitRepoPassword\@github\.com/g <<<$appGitRepoURL)"


git clone -b $appGitRepoBranch $appGitRepoURL /var/www/$appEco.$appName/Initial.Deployment/
