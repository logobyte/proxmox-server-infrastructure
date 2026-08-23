#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script with sudo:"
  echo "sudo ./laravel/install-stack.sh"
  exit 1
fi

echo "Installing web server and Laravel dependencies..."

apt update

apt install -y   nginx   mysql-server   php-fpm   php-cli   php-mysql   php-curl   php-mbstring   php-xml   php-bcmath   php-zip   php-gd   php-intl   git   curl   unzip

echo
echo "Installed versions:"
nginx -v || true
php -v | head -n 1 || true
mysql --version || true

echo
echo "Composer is intentionally not installed automatically."
echo "Use the official Composer installer so you can verify its current installer/checksum."
