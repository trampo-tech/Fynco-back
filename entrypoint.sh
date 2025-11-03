#!/usr/bin/env bash
set -e
cd /var/www/html

# Gera APP_KEY se estiver vazio
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
  php artisan key:generate --force || true
fi

# Migra banco se quiser (defina RUN_MIGRATIONS=true)
if [ "$RUN_MIGRATIONS" = "true" ]; then
  php artisan migrate --force || true
fi

# Cache leve
php artisan config:cache || true
php artisan route:cache  || true
php artisan view:clear   || true

echo ">> Starting Laravel on 0.0.0.0:${PORT:-8080}"
php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
