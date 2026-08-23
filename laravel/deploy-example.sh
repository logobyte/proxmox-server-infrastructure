#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/var/www/laravel-app}"

if [[ ! -d "$APP_DIR" ]]; then
  echo "Application directory not found: $APP_DIR"
  exit 1
fi

cd "$APP_DIR"

if [[ ! -f artisan ]]; then
  echo "This directory does not appear to be a Laravel application."
  exit 1
fi

echo "Putting Laravel into maintenance mode..."
php artisan down || true

echo "Installing Composer dependencies..."
composer install   --no-dev   --optimize-autoloader   --no-interaction

echo "Running database migrations..."
php artisan migrate --force

echo "Refreshing caches..."
php artisan optimize:clear
php artisan optimize

echo "Restarting queue workers..."
php artisan queue:restart || true

echo "Returning application online..."
php artisan up

echo "Deployment completed."
