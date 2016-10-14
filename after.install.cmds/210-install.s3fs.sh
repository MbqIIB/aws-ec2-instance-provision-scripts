#!/bin/bash

yum -y remove fuse fuse-s3fs
yum -y install gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel openssl-devel mailcap 

cd /tmp/
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse/
autoreconf --install
./configure --prefix=/usr
make
make install

cd /home/centos/
rm -rf /tmp/s3fs-fuse/
