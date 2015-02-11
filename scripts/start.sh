#!/bin/bash
set -e

chown -R www-data:www-data /opt/appserver/webapps
chown -R www-data:www-data /opt/appserver/var
chmod -R 775 /opt/appserver/webapps

/opt/appserver/bin/php -dappserver.php_sapi=appserver /opt/appserver/server.php &
/opt/appserver/sbin/php-fpm --fpm-config /opt/appserver/etc/php-fpm.conf &
/opt/appserver/bin/php -dappserver.php_sapi=appserver /opt/appserver/server.php -w
