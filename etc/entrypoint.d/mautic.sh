[ -d /var/www/local ] || mkdir /var/www/local
[ -f /var/www/local/config.php ] || /usr/bin/php /etc/mautic/makeconfig.php
[ -d /var/www/local/images ] || mkdir /var/www/local/images
[ -d /var/www/local/files ] || mkdir /var/www/local/files
[ -d /var/www/local/var ] || mkdir /var/www/local/var

chown app:app /var/www/local
chown app:app /var/www/local/images
chown app:app /var/www/local/files
chown -R app:app /var/www/local/var
chown app:app /var/www/local/config.php
