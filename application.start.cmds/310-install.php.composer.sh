#!/bin/bash

cd ~
curl -sS https://getcomposer.org/installer | php
mv ~/composer.phar /usr/bin/composer
