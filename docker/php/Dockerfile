# Use PHP 8.2 with FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Set the working directory for the application
WORKDIR /var/www

# Install system dependencies and PHP extensions
# - zip/unzip: For handling compressed files
# - git: For version control
# - curl: For making HTTP requests
# - default-mysql-client: For database operations
# - procps: For process management
# Also install PDO extensions for MySQL connectivity
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    curl \
    default-mysql-client \
    procps \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/* # Clean up to reduce image size

# Configure PHP-FPM
RUN mkdir -p /var/log \
    # Create and set permissions for log file
    && touch /var/log/php-fpm.log \
    && chmod 666 /var/log/php-fpm.log \
    # Configure PHP-FPM to listen on all interfaces
    && sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.d/www.conf \
    # Remove default error log settings
    && sed -i '/error_log/d' /usr/local/etc/php-fpm.conf \
    && sed -i '/log_level/d' /usr/local/etc/php-fpm.conf \
    # Configure PHP-FPM logging
    && echo "php_admin_value[error_log] = /var/log/php-fpm.log" >> /usr/local/etc/php-fpm.d/www.conf \
    && echo "php_admin_value[log_level] = notice" >> /usr/local/etc/php-fpm.d/www.conf \
    # Configure PHP-FPM process management
    && echo "pm.max_children = 50" >> /usr/local/etc/php-fpm.d/www.conf \
    && echo "pm.max_requests = 500" >> /usr/local/etc/php-fpm.d/www.conf \
    # Enable PHP error reporting for debugging
    && echo "php_admin_value[display_errors] = On" >> /usr/local/etc/php-fpm.d/www.conf \
    && echo "php_admin_value[error_reporting] = E_ALL" >> /usr/local/etc/php-fpm.d/www.conf

# Copy application code into container
COPY . .

# Configure container health check
# Tests if PHP-FPM is responding to FastCGI requests
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

# Start PHP-FPM process
CMD ["php-fpm"]