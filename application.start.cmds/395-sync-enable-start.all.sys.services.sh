#!/bin/bash

#GET Project's Name and EcoSystem
APPGROUP=$(cat /aws.services/.ec2Instance| grep EcoSystem | awk '{print $2}')
APPUSER=$(cat /aws.services/.ec2Instance| grep WebApplication | awk '{print $2}')
APPENV=$(cat /aws.services/.ec2Instance| grep Environment | awk '{print $2}')
APPINTERFACE=$(cat /aws.services/.ec2Instance| grep Interface | awk '{print $2}')


#ERROR Handing Function
die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo $APPGROUP
echo $APPUSER
echo $APPINTERFACE
echo $APPENV

cd /home/$PRJUSER/

echo "Enable & Start NewRelic Services.."
#yes|cp -rf /mnt/S3.Buckets/$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/newrelic.ini /etc/php.d/newrelic.ini
aws s3 cp s3://$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/newrelic.ini /etc/php.d/newrelic.ini

chmod 755 /etc/php.d/newrelic.ini
systemctl enable newrelic-sysmond.service
systemctl enable newrelic-daemon.service
service newrelic-sysmond start
service newrelic-daemon start
service newrelic-sysmond status -l
service newrelic-daemon status -l

echo "Enable & Start FCGi Daemon.."
chkconfig spawn-fcgi on
systemctl start spawn-fcgi

echo "Enable & Start PHP-FPM Service.."
#yes|cp -rf /mnt/S3.Buckets/$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/phpfpm.conf /var/www/$APPUSER.$APPGROUP.vhost.confs/phpfpm.conf
aws s3 cp s3://$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/phpfpm.conf /var/www/$APPGROUP.$APPUSER.vhost.confs/phpfpm.conf

chmod 755 /var/www/$APPGROUP.$APPUSER.vhost.confs/phpfpm.conf
systemctl enable php-fpm.service
service php-fpm start
service php-fpm status -l

echo "Enable & Start NGinx Web Server (nginx.service).."
#yes|cp -rf /mnt/S3.Buckets/$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/nginx.conf /var/www/$APPUSER.$APPGROUP.vhost.confs/nginx.conf
aws s3 cp s3://$APPGROUP.$APPUSER/vHost.Config.Files/$APPINTERFACE/$APPENV.env/nginx.conf /var/www/$APPGROUP.$APPUSER.vhost.confs/nginx.conf

chmod 755 /var/www/$APPGROUP.$APPUSER.vhost.confs/nginx.conf
systemctl enable nginx.service
service nginx start
service nginx status -l

echo "Project's AWS Logs Configuration Service.."
#yes|cp -rf /mnt/S3.Buckets/$APPGROUP.$APPUSER/AWS.Services.Config.Files/CloudWatch.Logs/$APPINTERFACE/*.logs.conf /var/awslogs/etc/config/
aws s3 cp s3://$APPGROUP.$APPUSER/AWS.Services.Config.Files/CloudWatch.Logs/$APPINTERFACE/*.logs.conf /var/awslogs/etc/config/

chmod -R 755 /var/awslogs/etc/config/
service awslogs restart

service newrelic-sysmond restart
service newrelic-daemon restart
service php-fpm restart
service nginx restart
