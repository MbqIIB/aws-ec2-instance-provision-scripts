#!/bin/bash

cd ~

rm -rf /etc/nginx/nginx.conf
rm -rf /etc/nginx/conf.d/default.conf
rm -rf /etc/nginx/conf.d/php-fpm.conf

#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/NGinx.Config.Files/T2.Micros/nginx.conf /etc/nginx/nginx.conf
aws s3 cp s3://global.gem.apps/NGinx.Config.Files/T2.Micros/nginx.conf /etc/nginx/nginx.conf
#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/NGinx.Config.Files/T2.Micros/www.conf /etc/nginx/conf.d/www.conf
aws s3 cp s3://global.gem.apps/NGinx.Config.Files/T2.Micros/www.conf /etc/nginx/conf.d/www.conf

chmod -R 755 /etc/nginx/
