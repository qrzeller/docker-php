FROM ubuntu:xenial
RUN export DEBIAN_FRONTEND=noninteractive
RUN export RUNLEVEL=1
#ADD php-nginx.conf.dockerfile /tmp/
#RUN chmod +x php-nginx.conf.dockerfile
#RUN php-nginx.conf.dockerfile
RUN echo "#!/bin/sh \nexit 0" > /usr/sbin/policy-rc.d
RUN apt-get update && apt-get install -y nginx php-fpm php-mysql php-gd php-zip php-json php-curl php-mbstring php-intl php-mcrypt php-imagick php-xml php-redis php-memcached php-apcu php-gmp php-smbclient
RUN echo "\
  server {\
            listen       80;\
            server_name  _;\
\
            location / {\
                root /var/www/html/;\
                index index.html index.php info.php;\
            }\
\
            location ~ \.php$ {\
\
               fastcgi_index info.php;\
               include fastcgi_params;\
               fastcgi_pass unix:/run/php/php7.0-fpm.sock;\
               fastcgi_param SCRIPT_FILENAME /var/www/html/\$fastcgi_script_name;\
            }\
       }\
\
\
" > /etc/nginx/sites-available/default
RUN nginx -t
RUN service nginx restart
ADD https://download.nextcloud.com/server/releases/nextcloud-12.0.4.zip /tmp/nextcloud.zip
RUN apt-get install unzip
RUN unzip -a /tmp/nextcloud.zip -d /var/www/html/ && rm -f /tmp/nextcloud.zip
RUN cp -r /var/www/html/nextcloud/* /var/www/html/
RUN rm -R /var/www/html/nextcloud/
RUN chmod -R +x /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

