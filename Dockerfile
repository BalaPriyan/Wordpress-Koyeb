FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV WORDPRESS_VERSION=6.5.3

# Install required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    unzip \
    less \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    php-zip \
    php-soap \
    php-intl \
    libapache2-mod-php \
    mariadb-client \
    pwgen \
    && rm -rf /var/lib/apt/lists/*

# Install WordPress
RUN curl -o /tmp/wordpress.zip https://wordpress.org/wordpress-${WORDPRESS_VERSION}.zip && \
    unzip /tmp/wordpress.zip -d /tmp && \
    mv /tmp/wordpress/* /var/www/html && \
    rm -rf /tmp/*

# Copy setup script
COPY setup-wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-wordpress.sh

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Apache configuration
RUN a2enmod rewrite
RUN echo '<Directory /var/www/html/>\n\
    AllowOverride All\n\
</Directory>' >> /etc/apache2/apache2.conf

EXPOSE 80

# Use the setup script as entrypoint
ENTRYPOINT ["setup-wordpress.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]
