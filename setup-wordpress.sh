#!/bin/bash

# Exit on error
set -e

WP_CONFIG=/var/www/html/wp-config.php

# If wp-config.php doesn't exist, create it
if [ ! -f "$WP_CONFIG" ]; then
    echo "Generating wp-config.php file..."
    cp /var/www/html/wp-config-sample.php "$WP_CONFIG"

    # Set database settings
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" "$WP_CONFIG"
    sed -i "s/username_here/$WORDPRESS_DB_USER/" "$WP_CONFIG"
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" "$WP_CONFIG"
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" "$WP_CONFIG"

    # Set authentication keys and salts
    sed -i "/AUTH_KEY/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/SECURE_AUTH_KEY/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/LOGGED_IN_KEY/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/NONCE_KEY/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/AUTH_SALT/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/SECURE_AUTH_SALT/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/LOGGED_IN_SALT/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"
    sed -i "/NONCE_SALT/s/put your unique phrase here/$(pwgen -1 -s 64)/" "$WP_CONFIG"

    # Set WordPress debugging mode
    sed -i "/WP_DEBUG/s/false/${WP_DEBUG:-false}/" "$WP_CONFIG"

    # Set WP_HOME and WP_SITEURL if specified
    if [ -n "$WP_HOME" ]; then
        echo "define('WP_HOME', '$WP_HOME');" >> "$WP_CONFIG"
        echo "define('WP_SITEURL', '$WP_HOME');" >> "$WP_CONFIG"
    fi

    # Set file permissions
    chown www-data:www-data "$WP_CONFIG"
    chmod 644 "$WP_CONFIG"
fi

# Execute the original command
exec "$@"
