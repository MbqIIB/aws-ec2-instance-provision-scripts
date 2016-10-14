#!/bin/bash

echo "Creating Folder to store all Bash Scripts needed for CodeDeploy Agent to execute.."

dir_path=/aws.services/codedeploy/scripts/asg.deployment
mkdir -p $dir_path

echo "Checking if Folder has been successfully created.. "

if [ -d "$dir_path" ]
	then
	        echo "Success! $dir_path Folder has been successfully created! Continuing Deployment.."
	else
	        echo "ERROR! $dir_path Folder is NOT found! Aborting Deployment."
	        exit 1
fi
