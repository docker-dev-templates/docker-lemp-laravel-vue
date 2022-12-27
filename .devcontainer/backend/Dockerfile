FROM php:fpm-alpine
LABEL maintainer="J. Rai <jraicr@github>"

# Arguments defined in docker-compose.yml or build command
ARG user
ARG uid

# Labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="php-xdebug-composer"
LABEL org.label-schema.description="Image from php:fpm-alpine with Xdebug, Composer and PHP Extensions requeriments for default Laravel project."

RUN apk --no-cache update && apk --no-cache upgrade

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        linux-headers \
        tar 

RUN apk --no-cache add \
    gmp-dev \
    oniguruma-dev \
    icu-dev \
    zip \
    unzip \
    git \
    curl
    
RUN rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# PHP Ext   
RUN docker-php-ext-install pdo_mysql \
        bcmath exif pcntl intl gmp opcache && \
        pecl install xdebug-3.2.0 swoole && \
    docker-php-ext-enable xdebug swoole && \
    apk del --no-cache .build-deps

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN adduser -D -G www-data -u $uid -h /home/$user $user
RUN addgroup $user root
RUN addgroup $user
RUN addgroup $user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN mkdir /app
USER $user