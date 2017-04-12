#!/bin/bash

cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sed -i 's/username_here/wordpressuser/' /var/www/html/wp-config.php
sed -i 's/password_here/password/' /var/www/html/wp-config.php
sed -i 's/localhost/db/' /var/www/html/wp-config.php


