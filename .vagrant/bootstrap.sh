#!/usr/bin/env bash

# Helper function for making passwords
make_password () {
    PASS=`< /dev/urandom tr -dc A-Za-z0-9 | head -c28;`
}

# Use sudo if not root user
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

# Lets start in a known location
cd ~

# See: https://packages.sury.org/php/README.txt
echo "-- Install PPA's --"
${SUDO} apt-get update
${SUDO} apt-get -y install apt-transport-https lsb-release ca-certificates
${SUDO} wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
${SUDO} sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
${SUDO} apt-get update

echo "-- Install Packages --"
sudo apt-get install -y --force-yes curl git git-core nginx redis-server
sudo apt-get install -y --force-yes php7.0-common php7.0-dev php7.0-json php7.0-opcache php7.0-cli php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-bcmath php7.0-zip php7.0-xml

echo "-- Install Composer --"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- Configuring Redis --"
${SUDO} sed -i "s/supervised no/supervised systemd/" /etc/redis/redis.conf
${SUDO} systemctl restart redis

echo "-- Creating Laravel User/Group --"
${SUDO} groupadd laravel
${SUDO} useradd -g laravel laravel

