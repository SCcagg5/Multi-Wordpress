# Run multiple WordPress Docker containers with NGINX Proxy, LetsEncrypt and PHP Composer

Each WordPress site runs its own container and is proxied by an NGINX Proxy that handles SSL thanks to LetsEncrypt.
This setup relies on https://github.com/jwilder/nginx-proxy and https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion

## Requirements

* Docker
* Docker Compose

## NGINX Proxy and LetsEncrypt

Run `docker-compose up -d` in the `nginx` directory to start the NGINX Proxy and LetsEncrypt Proxy
Companion containers. These containers will handle https.  

## WordPress Setup

* Copy the `wordpress_01` directory for each WordPress site you want to host. I created a copy called `wordpress_02` as an example. If you only want to host one site you can delete `wordpress_02` and modify `wordpress_01` to your liking.

* In each site directory is a `sample.env` - copy that file, edit the environment variables and
rename it to `.env`. Each site directory must contain this environment file.
* Make sure that the container names  are unique for each site. (`DB_CONTAINER, WP_CONTAINER and COMPOSER_CONTAINER`).
* I recommend highly choosing different database credentials for each site.
* Make optional changes to `wp-config.php`
* The `wp-content` folder is mounted locally to `/srv/www/${VIRTUAL_HOST}/html/wp-content` for
persistency. This folder contains themes, plugins and uploads.
* Database files are mounted here: `/srv/www/${VIRTUAL_HOST}/db_data`

## Build and run containers.

For each site navigate to its directory and:

``docker-compose up --build``
