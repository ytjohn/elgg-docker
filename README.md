Elgg in Docker
==============

This is [Elgg](https://elgg.org/), an open-source social neworking engine, packaged in a Docker container. Currently, it is built against Elgg 3.1.0 and [php-fpm](https://hub.docker.com/_/php). The ytjohn/elgg container is not enough to get an app going, you need to
combine it with something like Nginx or Apahe, and a database server. The [docker-compose](docker-compose.yml) uses Nginx. Each container is pinned to a specific version to ensure that it continues to work as desired, even if a breaking change is made upstream. While this setup is primarily for development, it could easily be ported to work in production.

## Development

To test this out, just clone this repo and use docker-compose to bring it up.

        git clone https://github.com.ytjohn/elgg-docker.git
        cd elgg-docker
        docker-compose up

Once it starts up, elgg will be listening on [http://localhost:8080]. You if you didn't change anything in docker-compose.yml,
your setup information is:

- database username: elgg
- database password: elggpassword
- databases name: elgg
- database host: db
- database port: 3306
- database table prefix: _elgg
- data directory: /elggdata
- site url: http://localhost:8080/

This has persistent volumes, so your data will persist across restarts and reboots. To stop, hit Ctrl-C.

## Web and Elgg containers

The elgg container exposes /elgg and /elggdata as volumes. PHP-FPM is running in this container on port 9000, and the nginx (web) container links to it. In order for nging to read static files, it shares the "volumes_from" the elgg container (/elgg and /elggdata). The nginx/web container does not have php installed and is just acting as a form of proxy to the php-fpm and serving any static files.

## Development

This repo is to be a base for your development. It is recommend that you fork the repo so you can add your own changes to docker-compose. Let's say you want to develop a theme. We'll assume that your theme is called "mytheme" and is up a directory from where docker-compose lives.

_Tip: I use [custom_index](https://github.com/Elgg/custom_index) as my starting theme._

Edit the defintion of the "elgg" container in docker-compose.yaml:

        elgg:
            image: ytjohn/elgg:3.1.0
            volumes:
                - ./extra/php/zz-log.conf:/usr/local/etc/php-fpm.d/zz-log.conf
                - elggdata:/elggdata 
                - ../mytheme:/elgg/mod/mytheme
            links:
            - db

Now, next time restart the contents of `../mytheme` will appear in `/elgg/mod/mytheme`. You can now edit files in that directory, activate the theme in Elgg's web interface, and view the results in real-time.
