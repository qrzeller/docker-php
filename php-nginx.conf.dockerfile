export DEBIAN_FRONTEND=noninteractive
export RUNLEVEL=1
echo "#!/bin/sh
exit 0
" > /usr/sbin/policy-rc.d
apt-get update && apt-get install -y nginx php-fpm php-mysql
echo "
  server {
            listen       80;
            server_name  localhost;

            location / {
                root /var/www/html/;
                index index.html index.php info.php;
            }

            location ~ \.php$ {

               fastcgi_index info.php;
               include fastcgi_params;
               fastcgi_pass unix:/run/php/php7.0-fpm.sock;
               fastcgi_param SCRIPT_FILENAME /var/www/html/\$fastcgi_script_name;
            }
       }


" > /etc/nginx/sites-available/default
nginx -t
service nginx restart
echo "<?php
phpinfo(); ?>" > /var/www/html/info.php
chmod -R +x /var/www/html/
chown -R www-data:www-data /var/www/html/
while true; do echo test; sleep 1000; done
