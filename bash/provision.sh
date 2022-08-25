#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

username=$USER

# Update Package List
apt-get update

# Update System Packages
apt-get upgrade -y

# Take into account the French language
apt-get install language-pack-fr

# Force Locale
echo "LC_ALL=fr_FR.UTF-8" >> /etc/default/locale
locale-gen fr_FR.UTF-8

# software-properties-common: Provides an abstraction of the used apt repositories. 
# It allows you to easily manage your distribution and independent software vendor software sources.
# Without it, you would need to add and remove repositories (such as PPAs) manually 
# by editing /etc/apt/sources.list and/or any subsidiary files in /etc/apt/sources.list.d

apt-get install -y software-properties-common curl sudo

# Install Some PPAs
apt-add-repository ppa:ondrej/php -y
add-apt-repository ppa:chris-lea/redis-server -y

# NodeJS
curl -sL https://deb.nodesource.com/setup_16.x | bash
sudo apt-get install -y nodejs
/usr/bin/npm install -g npm
/usr/bin/npm install -g yarn

# NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install node

# Install Some Basic Packages
apt-get install -y build-essential dos2unix wget gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony unzip make \
re2c unattended-upgrades whois vim libnotify-bin pv mcrypt bash-completion net-tools procps jq

# Install SQLite
apt-get install -y sqlite3 libsqlite3-dev

# Install Python
apt-get install -y python3-pip libssl-dev libffi-dev python3-dev python3-venv python-is-python3

# Set My Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install Generic PHP packages
apt-get install -y --allow-change-held-packages \
php-imagick php-memcached php-redis php-xdebug php-dev

# PHP 8.1
apt-get install -y --allow-change-held-packages \
php8.1 php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev \
php8.1-enchant php8.1-fpm php8.1-gd php8.1-gmp php8.1-imap php8.1-interbase php8.1-intl php8.1-ldap \
php8.1-mbstring php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pgsql php8.1-phpdbg php8.1-pspell php8.1-readline \
php8.1-snmp php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xml php8.1-xmlrpc php8.1-xsl php8.1-zip

update-alternatives --set php /usr/bin/php8.1
update-alternatives --set php-config /usr/bin/php-config8.1
update-alternatives --set phpize /usr/bin/phpize8.1

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Set Some PHP CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

# Install Nginx
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# Setup Some PHP-FPM Options
echo "xdebug.remote_enable = 1" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.1/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.1/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini

# Disable XDebug On The CLI
sudo phpdismod -s cli xdebug

# Set The Nginx & PHP-FPM User
sed -i "s/user www-data;/user $username;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/user = www-data/user = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = $username/" /etc/php/8.1/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf

service nginx restart
service php8.1-fpm restart

usermod -a -G www-data $username
id $username
groups $username


# Install MySQL
echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
apt-get install -y mysql-server

# Configure MySQL 8 Remote Access and Native Pluggable Authentication
cat > /etc/mysql/conf.d/mysqld.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
default_authentication_plugin = mysql_native_password
EOF

# Configure MySQL Password Lifetime
echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access
sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

export MYSQL_PWD=secret

mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql --user="root" -e "CREATE USER '$username'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "CREATE USER '$username'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO '$username'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO '$username'@'%' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"
mysql --user="root" -e "CREATE DATABASE $username character set UTF8mb4 collate utf8mb4_bin;"

sudo tee /home/$username/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL

# Add Timezone Support To MySQL
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql
service mysql restart

# Install Redis, Memcached
apt-get install -y redis-server memcached
systemctl enable redis-server
service redis-server start

# Add Composer Global Bin To Path
printf "\nPATH=\"$(sudo su - $username -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/$username/.profile

# Add symfony cli
echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
apt update
apt install -y symfony-cli

# Useful to install local Certificate Authority certificate
# Generating a default certificate for HTTPS support
apt install libnss3-tools

# Install Sshpass For Ansible To Support Ssh Passwords
apt get install sshpass