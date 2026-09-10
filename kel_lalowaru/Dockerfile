FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    libgmp-dev \
    libtidy-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mysqli \
        gd \
        mbstring \
        xml \
        zip \
        intl \
        gmp \
        bcmath \
        opcache \
        exif \
        tidy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers expires

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy htaccess
RUN cp htaccess.apache.txt .htaccess

# Create required directories
RUN mkdir -p desa/config \
    && mkdir -p desa/upload \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/framework/views \
    && mkdir -p storage/framework/sessions \
    && mkdir -p storage/logs \
    && mkdir -p backup_inkremental

# Set Apache DocumentRoot
RUN sed -i 's|/var/www/html|/var/www/html|g' /etc/apache2/sites-available/000-default.conf

# Apache configuration for .htaccess
RUN echo '<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/opensid.conf \
    && a2enconf opensid

# PHP configuration
RUN echo "upload_max_filesize = 50M" > /usr/local/etc/php/conf.d/opensid.ini \
    && echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/opensid.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/opensid.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/opensid.ini \
    && echo "max_input_time = 300" >> /usr/local/etc/php/conf.d/opensid.ini \
    && echo "date.timezone = Asia/Jakarta" >> /usr/local/etc/php/conf.d/opensid.ini

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 desa/ storage/ backup_inkremental/

EXPOSE 80

CMD ["apache2-foreground"]
