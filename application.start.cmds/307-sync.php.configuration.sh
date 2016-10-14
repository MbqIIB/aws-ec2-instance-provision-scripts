#!/bin/bash

rm -rf /etc/php.ini
#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/PHP.Config.Files/T2.Micros/php.ini /etc/php.ini
aws s3 cp s3://global.gem.apps/PHP.Config.Files/T2.Micros/php.ini /etc/php.ini

rm -rf /etc/php.d/15-xdebug.ini
#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/
aws s3 cp s3://global.gem.apps/PHP.Config.Files/T2.Micros/xdebug.ini /etc/php.d/xdebug.ini

rm -rf /etc/php-fpm.conf
#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/PHP.Config.Files/T2.Micros/php-fpm.conf /etc/php-fpm.conf
aws s3 cp s3://global.gem.apps/PHP.Config.Files/T2.Micros/php-fpm.conf /etc/php-fpm.conf

rm -rf /etc/php-fpm.d/www.conf
#yes|cp -rf /mnt/S3.Buckets/Global.GEM.Apps/PHP.Config.Files/T2.Micros/www.conf /etc/php-fpm.d/www.conf
aws s3 cp s3://global.gem.apps/PHP.Config.Files/T2.Micros/www.conf /etc/php-fpm.d/www.conf

chmod -R 755 /etc/php.d/
chmod -R 755 /etc/php-fpm.d/
