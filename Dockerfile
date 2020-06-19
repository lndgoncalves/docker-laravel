FROM php:7.4-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# define timezone
RUN echo "America/Sao_Paulo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    libonig-dev \
    libzip-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libicu-dev \
    libmemcached-dev \
    memcached \
    default-mysql-client \
    libmagickwand-dev \
    curl


# memcached
RUN pecl install memcached-3.1.5
RUN docker-php-ext-enable memcached

# mcrypt
RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable mcrypt

# configure, install and enable all php packages
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-configure mysqli --with-mysqli=mysqlnd
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure zip


RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) exif
RUN docker-php-ext-install -j$(nproc) pcntl

# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# install imagick
RUN pecl install imagick-3.4.4
RUN docker-php-ext-enable imagick


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
#COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]