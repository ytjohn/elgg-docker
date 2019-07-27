FROM php:7.3.7-fpm
ARG VERSION=3.1.0

COPY ./php/zz-log.conf /usr/local/etc/php-fpm.d/zz-log.conf
# COPY ./php/install-composer.sh /tmp/install-composer.sh
RUN apt-get update && apt-get install -y \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        wget \
        unzip

# Elgg PHP requirements
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-install pdo pdo_mysql 

# fetch elgg and unzip
# note: while the version gets a zip file like 3.1.0, the unzipped directory is shorter, 3.1
RUN wget -q -O elgg.zip  "https://elgg.org/about/getelgg?forward=elgg-${VERSION}.zip"
RUN unzip -q elgg.zip &&\
    rm elgg.zip && \
    mv elgg-* /elgg && \
    mkdir /elggdata && \
    chown -R www-data:www-data /elgg /elggdata

VOLUME /elgg
VOLUME /elggdata
WORKDIR /elgg
