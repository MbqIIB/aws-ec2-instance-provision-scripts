#!/bin/bash

echo "Installing PHP and related modules.."

yum install -y php56* --skip-broken

echo "Setting Basic Configurations for PHP"
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/error_reporting = E_ALL \& ~E_NOTICE/g' /etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = \"Europe\/London\"/g' /etc/php.ini

echo "Installing Fcgiwrap too get CGI support in NGinx.."

yum -y install fcgi-devel

cd /usr/local/src/
git clone git://github.com/gnosek/fcgiwrap.git
cd fcgiwrap
autoreconf -i
./configure
make
make install

cd /home/centos/

echo "Installing spawn-fcgi package so fcgiwrap can run as a daemon.."
yum -y install spawn-fcgi

cat <<EOT >> /etc/sysconfig/spawn-fcgi
FCGI_SOCKET=/var/run/fcgiwrap.socket
FCGI_PROGRAM=/usr/local/sbin/fcgiwrap
FCGI_USER=apache
FCGI_GROUP=apache
FCGI_EXTRA_OPTIONS="-M 0770"
OPTIONS="-u \$FCGI_USER -g \$FCGI_GROUP -s \$FCGI_SOCKET -S \$FCGI_EXTRA_OPTIONS -F 1 -P /var/run/spawn-fcgi.pid -- \$FCGI_PROGRAM"
EOT

usermod -a -G apache nginx

pecl install inotify-0.1.6
echo "extension=inotify.so" >> /etc/php.d/inotify.ini