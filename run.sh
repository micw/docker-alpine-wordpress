#!/bin/sh
set -e

if [ -z "${MYSQL_HOST}" ]; then
	echo "Please set MYSQL_HOST"
	exit 1
fi
if [ -z "${MYSQL_DATABASE}" ]; then
	echo "Please set MYSQL_DATABASE"
	exit 1
fi
if [ -z "${MYSQL_USER}" ]; then
	echo "Please set MYSQL_USER"
	exit 1
fi
if [ -z "${MYSQL_PASSWORD}" ]; then
	echo "Please set MYSQL_PASSWORD"
	exit 1
fi

if [ -f /var/www/wordpress/index.php ]; then
	echo "Existing wordpress installation found"
else
	echo "Installing latest wordpress version"
	curl -s https://wordpress.org/latest.tar.gz | tar xfvz - -C /var/www/wordpress --strip-components 1
fi

echo "Creating wp-config.php"
cat << EOF >/var/www/wordpress/wp-config.php
<?php

define('DB_HOST', '${MYSQL_HOST}');
define('DB_NAME', '${MYSQL_DATABASE}');
define('DB_USER', '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('WP_AUTO_UPDATE_CORE', true);
define('AUTOMATIC_UPDATER_DISABLED', false);
define('DISABLE_WP_CRON', false);

\$_SERVER['HTTPS']='on';
define('FORCE_SSL_ADMIN', true);

\$table_prefix  = 'wp_';

EOF

if [ ! -z "${COOKIE_DOMAIN}" ]; then
	cat << EOF >>/var/www/wordpress/wp-config.php
# Set cookie domain and let all paths point to / to allow multisite log-ins
define('COOKIE_DOMAIN', '${COOKIE_DOMAIN}');
define('ADMIN_COOKIE_PATH', '/');
define('COOKIEPATH', '');
define('SITECOOKIEPATH', '');
@ini_set('session.cookie_secure', false);
EOF
fi

cat << EOF >>/var/www/wordpress/wp-config.php
if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');

EOF

echo "Setting file owners"
chown apache.apache /var/www/wordpress -R

rm -f /usr/local/apache2/logs/httpd.pid
mkdir -p /run/apache2
exec httpd -DFOREGROUND
