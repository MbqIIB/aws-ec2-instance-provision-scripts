#!/bin/bash

#GET Project's Name and EcoSystem
appEco=$(cat /aws.services/.ec2Instance     | grep EcoSystem        | awk '{print $2}')
appName=$(cat /aws.services/.ec2Instance    | grep WebApplication   | awk '{print $2}')
appEnv=$(cat /aws.services/.ec2Instance     | grep Environment      | awk '{print $2}')
appIFace=$(cat /aws.services/.ec2Instance   | grep Interface        | awk '{print $2}')

#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}


cd /home/$appName/

echo "Apply Configurations for NewRelic Services"
echo "Copying Configuration Files From S3 To Instance"
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/vhost-newrelic_conf /etc/php.d/newrelic.ini
    chmod 755 /etc/php.d/newrelic.ini
    
echo "Enable & Start NewRelic Services" 
    systemctl enable newrelic-sysmond.service
    systemctl enable newrelic-daemon.service
    systemctl start newrelic-sysmond.service
    systemctl start newrelic-daemon.service
    systemctl status newrelic-sysmond.service -l
    systemctl status newrelic-daemon.service -l

echo "Enable & Start FCGi Daemon"
    chkconfig spawn-fcgi on
    systemctl start spawn-fcgi


echo "Apply Configurations for PHP-FPM Service"
echo "Copying Configuration Files From S3 To Instance"
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/vhost-phpfpm_conf /var/www/$appEco.$appName.vhost.confs/phpfpm.conf
    chmod 755 /var/www/$appEco.$appName.vhost.confs/phpfpm.conf
    
echo "Enable & Start PHP-FPM Service (php-fpm.service)"
    systemctl enable php-fpm.service
    systemctl start php-fpm.service
    systemctl status php-fpm.service -l

echo "Apply Configurations for NGinx Web Server"
echo "Copying Configuration Files From S3 To Instance"
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/vhost-nginx_conf /var/www/$appEco.$appName.vhost.confs/nginx.conf
    chmod 755 /var/www/$appEco.$appName.vhost.confs/nginx.conf
    
echo "Enable & Start NGinx Web Server (nginx.service)"
    systemctl enable nginx.service
    systemctl start nginx.service
    systemctl status nginx.service -l

echo "Apply Configurations for AWS Cloudwatch Logs Monitoring Service"
echo "Copying Configuration Files From S3 To Instance"
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/cloudwatch-allInstances_app_logs_conf /var/awslogs/etc/config/cloudwatch-allInstances_app.logs.conf
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/cloudwatch-allInstances_vhost_logs_conf /var/awslogs/etc/config/cloudwatch-allInstances_vhost.logs.conf
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/cloudwatch-allInstances_services_logs_conf /var/awslogs/etc/config/cloudwatch-allInstances_services.logs.conf
    aws s3 cp s3://$appEnv-$appEco-$appName-app-cnf/cloudwatch-allInstances_gqm_qc_daemons_logs_conf /var/awslogs/etc/config/cloudwatch-allInstances_gqm_qc_daemons.logs.conf
    chmod -R 755 /var/awslogs/etc/config/
echo "Restaring AWS Cloudwatch Logs Monitoring Service (awslogs)"    
    service awslogs restart


service newrelic-sysmond restart
service newrelic-daemon restart
service php-fpm restart
service nginx restart
