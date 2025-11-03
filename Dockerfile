# -------------------------------
# Fynco Back (Laravel) - PHP 8.3
# -------------------------------
FROM php:8.3-fpm

# Dependências e extensões PHP
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpq-dev libxml2-dev libzip-dev \
 && docker-php-ext-install pdo pdo_pgsql zip

# Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# App em /var/www/html
WORKDIR /var/www/html

# Copia apenas definições primeiro (cache de deps)
COPY src/composer.json src/composer.lock* ./
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress || true

# Copia o restante da app
COPY src/ .

# Permissões mínimas
RUN mkdir -p storage bootstrap/cache && chmod -R 777 storage bootstrap/cache

# Cache/clear tolerantes
RUN php artisan config:clear || true && php artisan route:clear || true

# Porta do Render
ENV PORT=8080
EXPOSE 8080

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
