# Laravel Deployment on Ubuntu

This guide demonstrates a traditional Laravel deployment using:

- Ubuntu Server
- Nginx
- PHP-FPM
- MySQL
- Composer
- Git
- Laravel

It is appropriate for a lab, staging environment, or portfolio.

## Architecture

```text
Browser
   |
   v
Nginx
   |
   v
PHP-FPM
   |
   v
Laravel
   |
   +---- MySQL
```

## Step 1 - Install Nginx

```bash
sudo apt update
sudo apt install -y nginx
```

Check:

```bash
sudo systemctl status nginx
```

## Step 2 - Install PHP

Ubuntu package versions depend on your Ubuntu release.

Install the currently supported PHP version available for your environment, together with common Laravel extensions:

```bash
sudo apt install -y \
  php-fpm \
  php-cli \
  php-mysql \
  php-curl \
  php-mbstring \
  php-xml \
  php-bcmath \
  php-zip \
  php-gd \
  php-intl
```

Check:

```bash
php -v
```

## Step 3 - Install Composer

Use the official Composer installation instructions for the current release.

After installation:

```bash
composer --version
```

## Step 4 - Install MySQL

```bash
sudo apt install -y mysql-server
```

Run:

```bash
sudo mysql_secure_installation
```

Create an application database and dedicated user.

Example:

```sql
CREATE DATABASE laravel_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'laravel_user'@'localhost'
IDENTIFIED BY 'USE_A_STRONG_UNIQUE_PASSWORD';

GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'localhost';

FLUSH PRIVILEGES;
```

Never commit the database password to Git.

## Step 5 - Clone the Repository

Recommended path:

```bash
sudo mkdir -p /var/www
sudo chown "$USER":"$USER" /var/www
cd /var/www
```

Clone:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git laravel-app
cd laravel-app
```

For private repositories, use SSH or another secure Git authentication method.

## Step 6 - Install Dependencies

For production-style installs:

```bash
composer install \
  --no-dev \
  --optimize-autoloader \
  --no-interaction
```

For a development VM:

```bash
composer install
```

If the project uses frontend assets:

```bash
npm ci
npm run build
```

## Step 7 - Configure Laravel Environment

```bash
cp .env.example .env
php artisan key:generate
```

Edit:

```bash
nano .env
```

Example:

```text
APP_ENV=production
APP_DEBUG=false
APP_URL=http://SERVER_IP

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_app
DB_USERNAME=laravel_user
DB_PASSWORD=YOUR_STRONG_PASSWORD
```

Never commit `.env`.

## Step 8 - Storage Permissions

Example:

```bash
sudo chown -R www-data:www-data /var/www/laravel-app/storage
sudo chown -R www-data:www-data /var/www/laravel-app/bootstrap/cache

sudo chmod -R 775 /var/www/laravel-app/storage
sudo chmod -R 775 /var/www/laravel-app/bootstrap/cache
```

Avoid using `chmod -R 777`.

## Step 9 - Run Migrations

Review migrations first.

Then:

```bash
php artisan migrate --force
```

## Step 10 - Optimize Laravel

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Only use route caching if your routes are compatible with it.

## Step 11 - Configure Nginx

Create:

```bash
sudo nano /etc/nginx/sites-available/laravel-app
```

Example:

```nginx
server {
    listen 80;
    server_name _;

    root /var/www/laravel-app/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

The exact PHP-FPM socket can vary by Ubuntu/PHP version.

Find yours:

```bash
ls /run/php/
```

Then update `fastcgi_pass` accordingly.

Enable:

```bash
sudo ln -s /etc/nginx/sites-available/laravel-app /etc/nginx/sites-enabled/laravel-app
```

Optionally remove the default site:

```bash
sudo rm -f /etc/nginx/sites-enabled/default
```

Validate:

```bash
sudo nginx -t
```

Reload:

```bash
sudo systemctl reload nginx
```

## Step 12 - Laravel Scheduler

Edit root cron:

```bash
sudo crontab -e
```

Add:

```text
* * * * * cd /var/www/laravel-app && php artisan schedule:run >> /dev/null 2>&1
```

## Step 13 - Queue Worker with systemd

Example service:

```bash
sudo nano /etc/systemd/system/laravel-queue.service
```

Example:

```ini
[Unit]
Description=Laravel Queue Worker
After=network.target

[Service]
User=www-data
Group=www-data
Restart=always
WorkingDirectory=/var/www/laravel-app
ExecStart=/usr/bin/php artisan queue:work --sleep=3 --tries=3 --timeout=90

[Install]
WantedBy=multi-user.target
```

Enable:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now laravel-queue
```

Check:

```bash
sudo systemctl status laravel-queue
```

## Step 14 - Deploy Updates

Typical manual flow:

```bash
cd /var/www/laravel-app
git pull
composer install --no-dev --optimize-autoloader --no-interaction
php artisan migrate --force
php artisan optimize
sudo systemctl reload nginx
```

For real production, use controlled CI/CD, release directories, backups, and rollback procedures.
