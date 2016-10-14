#!/bin/bash

mkdir -p /var/log/aws.services/cloudwatch/

cat <<EOT >> /etc/cron.d/aws_ec2Instance_Nanny
#!/bin/bash
MAILTO=""
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
* * * * * root /aws.services/ssm/AWS.EC2-SSM.Scripts/scripts.lib/aws.cloudwatch/ec2InstanceNanny.sh >> /var/log/aws.services/cloudwatch/ec2InstanceNanny.logs 2>&1
EOT

cat <<EOT >> /var/awslogs/etc/config/AWS.EC2-Instance-Nanny.logs.conf
[AWS.EC2-Instance-Nanny.logs]
datetime_format = %Y-%m-%d %H:%M:%S
file = /var/log/aws.services/cloudwatch/ec2InstanceNanny.logs
log_stream_name = {instance_id}
log_group_name = AWS.EC2-Instance-Nanny.logs
EOT

chmod -R 755 /var/awslogs/etc/config/
service awslogs restart
