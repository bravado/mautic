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
ENV MAUTIC_VERSION 3.0.2
ENV MAUTIC_SHA1 225dec8fbac05dfb77fdd7ed292a444797db215f

# Download package and extract to web volume
RUN curl -o /usr/src/mautic.zip -SL https://github.com/mautic/mautic/releases/download/${MAUTIC_VERSION}/${MAUTIC_VERSION}.zip \
    && echo "$MAUTIC_SHA1 /usr/src/mautic.zip" | sha1sum -c - \
    && cd /var/www/html \
    && unzip /usr/src/mautic.zip \
    && rm -f /usr/src/mautic.zip

# By default enable cron jobs
ENV MAUTIC_RUN_CRON_JOBS true

# Setting an root user for test
ENV MAUTIC_DB_HOST mysql
ENV MAUTIC_DB_TABLE_PREFIX ""
ENV MAUTIC_DB_PORT 3306
ENV MAUTIC_DB_NAME mautic
ENV MAUTIC_DB_USER root
ENV MAUTIC_DB_PASSWORD root
ENV TRUSTED_PROXIES ""


# Copy init scripts and custom .htaccess
# COPY docker-entrypoint.sh /entrypoint.sh
# COPY makeconfig.php /makeconfig.php
# COPY makedb.php /makedb.php
# COPY mautic.crontab /etc/cron.d/mautic
# RUN chmod 644 /etc/cron.d/mautic

# Enable Apache Rewrite Module
# RUN a2enmod rewrite

# Apply necessary permissions
# RUN ["chmod", "+x", "/entrypoint.sh"]
# ENTRYPOINT ["/entrypoint.sh"]
#
# CMD ["apache2-foreground"]

# ENV PUID=1000 \
# PGID=10000

ENV APACHE_RUN_USER app
ENV PHP_MEMORY_LIMIT 512M

RUN mv /var/www/html/media/images /var/www/html/_images \
	&& rm -rf /var/www/html/media/files \
	&& rm -rf /var/www/html/var \
	&& mkdir /var/www/local /var/www/local/images /var/www/local/files /var/www/local/var \
	&& ln -s /var/www/local/config.php /var/www/html/app/config/local.php \
	&& ln -s /var/www/local/images /var/www/html/media/images \
	&& ln -s /var/www/local/files /var/www/html/media/files \
	&& ln -s /var/www/local/var /var/www/html/var \
	&& chown app:app /var/www/local

ADD etc /etc

USER app
