#!/bin/sh

EXPECTED_SIGNATURE="b66f9b53db72c5117408defe8a1e00515fe749e97ce1b0ae8bdaa6a5a43dd542"
php -r "copy('https://getcomposer.org/download/1.8.6/composer.phar', '/usr/bin/composer');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha256', '/usr/bin/composer');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm /usr/bin/composer
    exit 1
fi

chmod +x /usr/bin/composer
