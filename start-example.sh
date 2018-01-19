#!/bin/bash
docker run php-nginx bash -c "service php7.0-fpm start; nginx -g 'daemon off;'"
