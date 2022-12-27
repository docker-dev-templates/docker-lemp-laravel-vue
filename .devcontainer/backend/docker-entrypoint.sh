#!/bin/sh

# PHP FPM Serves the Laravel APP (Recommended to be used in production environment)
#php-fpm 

# Artisan serves Laravel APP by default (Recommended to be used in development environment)
#php artisan serve --host=0.0.0.0 --port=${BACKEND_LISTENING_PORT}

# This command allows you to run php-fpm and artisan dev server at same time (Only for testing purposes from dev environment)
php-fpm &
php artisan serve --host=0.0.0.0 --port=${BACKEND_LISTENING_PORT}

# Artisan serves Laravel APP using Octane with Swoole. (Recommended to be used in production & development environment)
#composer require laravel/octane
#php artisan octane:start --host=0.0.0.0 --port=${BACKEND_LISTENING_PORT}