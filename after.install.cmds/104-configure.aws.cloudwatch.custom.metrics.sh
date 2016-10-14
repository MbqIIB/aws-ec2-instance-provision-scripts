#!/bin/bash

yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA
yum install -y zip unzip

echo "Cloning bridgemanart/AWS.Cloudwatch-CustomMetrics-Scripts.git Repo"
cd /aws.services/cloudwatch/
rm -rf AWS.Cloudwatch-CustomMetrics-Scripts/
git clone git@github.com:bridgemanart/AWS.Cloudwatch-CustomMetrics-Scripts.git || die "Unable to Clone bridgemanart/AWS.Cloudwatch-CustomMetrics-Scripts.git"
chmod -R 777 AWS.Cloudwatch-CustomMetrics-Scripts/


##echo "* * * * * root /aws.services/cloudwatch/AWS.Cloudwatch-CustomMetrics-Scripts/mon-put-instance-data.pl --loadave --mem-util --mem-used --mem-avail --swap-util --swap-used --memory-units=megabytes --auto-scaling --from-cron" > /etc/cron.d/awscloudwatch_put_custom_metrics
