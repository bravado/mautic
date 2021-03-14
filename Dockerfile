FROM bravado/php:7.3

USER root

# Install PHP extensions
RUN apt-get update && apt-get install --no-install-recommends -y \
    cron \
    unzip \
    zip \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/cron.*/*

# Define Mautic version and expected SHA1 signature
ENV MAUTIC_VERSION 3.3.1
ENV MAUTIC_SHA1 eeb751abe0cd17de90a61b48ee8c306b50bd2226

# Download package and extract to web volume
RUN curl -o /usr/src/mautic.zip -SL https://github.com/mautic/mautic/releases/download/${MAUTIC_VERSION}/${MAUTIC_VERSION}.zip \
    && echo "$MAUTIC_SHA1 /usr/src/mautic.zip" | sha1sum -c - \
    && cd /var/www/html \
    && unzip /usr/src/mautic.zip \
    && rm -f /usr/src/mautic.zip

# By default enable cron jobs
ENV CRON_ENABLE true

# All MAUTIC_* env vars are written to the local config file
ENV MAUTIC_DB_HOST mysql
ENV MAUTIC_DB_TABLE_PREFIX ""
ENV MAUTIC_DB_PORT 3306
ENV MAUTIC_DB_NAME mautic
ENV MAUTIC_DB_USER root
ENV MAUTIC_DB_PASSWORD root
ENV MAUTIC_DB_BACKUP_TABLES 0
ENV MAUTIC_DB_BACKUP_PREFIX bak_
ENV MAUTIC_TRUSTED_PROXIES '[]'

ENV APACHE_RUN_USER app
ENV PHP_MEMORY_LIMIT 512M

RUN mv /var/www/html/media/images /var/www/html/_images \
	&& rm -rf /var/www/html/media/files \
	&& rm -rf /var/www/html/var \
	&& rm -rf /var/www/html/translations \
	&& mkdir /var/www/local /var/www/local/images /var/www/local/translations /var/www/local/files /var/www/local/var \
	&& ln -s /var/www/local/config.php /var/www/html/app/config/local.php \
	&& ln -s /var/www/local/images /var/www/html/media/images \
	&& ln -s /var/www/local/files /var/www/html/media/files \
	&& ln -s /var/www/local/var /var/www/html/var \
	&& ln -s /var/www/local/translations /var/www/html/translations \
	&& chown app:app /var/www/local -R

ADD etc /etc

RUN for i in $(find /var/www/html/_images -maxdepth 1 -mindepth 1 ! -name '.*'); \
	do echo "Alias /media/images/$(basename $i) $i"; \
	done >> /etc/apache2/conf-enabled/mautic.conf
USER app
