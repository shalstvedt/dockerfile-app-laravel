# Base Docker File
# Extends base/nginx
# https://github.com/outrunthewolf/dockerfile-base-nginx
FROM app/laravel54

# Miantainer
MAINTAINER outrunthewolf

# ENVIRONMENTAL variables
ENV USERNAME laravel
ENV SITEPATH "/home/$USERNAME/public_html"

# create a user
RUN useradd -d /home/$USERNAME -m $USERNAME
RUN chsh -s /bin/bash $USERNAME

# Add base nginx conf
ADD ./config/default_nginx_conf /usr/local/nginx/conf/nginx.conf

# Add a default vhost, activate host file
ADD ./config/default_vhost /usr/local/nginx/conf/sites-available/default.conf
RUN ln -s /usr/local/nginx/conf/sites-available/default.conf /usr/local/nginx/conf/sites-enabled/default.conf

# Add base FreeTDS config
ADD ./config/default_freetds /etc/freetds/freetds.conf

# Set up php fpm, restart php
ADD ./config/default_php_pool /etc/php5/fpm/pool.d/default.conf
RUN touch /var/log/php-slowlog.log

# Expose some ports
EXPOSE 80

RUN apt-get install -y php5-sybase php5-odbc freetds-bin

# CMD
CMD php5-fpm && \
	/usr/local/nginx/sbin/nginx