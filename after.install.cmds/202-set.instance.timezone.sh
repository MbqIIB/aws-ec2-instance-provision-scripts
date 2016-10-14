#!/bin/bash

echo "Updating System's Timezone.."

touch /etc/sysconfig/clock
echo "ZONE=\"Europe/London\"" >> /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime


echo "Installing NTP Service.."

yum -y install ntp
systemctl enable ntpd.service
systemctl start ntpd.service


echo "Updating NTP Service's configuration.."

yes | cp -f /etc/ntp.conf /etc/ntp.conf.original
sed -i -e 's/0.centos.pool.ntp.org/time1.google.com/g' /etc/ntp.conf
sed -i -e 's/1.centos.pool.ntp.org/time2.google.com/g' /etc/ntp.conf
sed -i -e 's/2.centos.pool.ntp.org/time3.google.com/g' /etc/ntp.conf
sed -i -e 's/3.centos.pool.ntp.org/time4.google.com/g' /etc/ntp.conf
systemctl restart ntpd.service
