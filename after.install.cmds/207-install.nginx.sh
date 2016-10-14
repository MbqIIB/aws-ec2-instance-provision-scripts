#!/bin/bash

echo "Installing NGinx WebServer.."

cat <<EOT >> /etc/yum.repos.d/NGinx.repo
[nginx]
name=NGinx
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
priority=1
EOT

yum install -y nginx nginx-module-geoip nginx-module-image-filter nginx-module-njs nginx-module-perl nginx-module-xslt nginx-nr-agent
