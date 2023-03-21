FROM ubuntu:22.04
MAINTAINER karlhenh@stud.ntnu.no
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php-pgsql php-mysql \
php-memcache libmemcached11 libmemcached-dev net-tools curl unzip wget2 \
php-cli php-mbstring glusterfs-client prometheus-apache-exporter supervisor \
memcached


# Webserver: apache2 libapache2-mod-php php-pgsql php-mysql
# memcached: php-memcache libmemcached11 libmemcached-dev
# Andre: net-tools curl unzip wget2
# Fra kyrres repo: php-cli php-mbstring glusterfs-client prometheus-apache-exporter supervisor
# Memcache: memcached

RUN rm /var/www/html/index.html
RUN mkdir /var/www/html/images
ADD code/* /var/www/html/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD init.sh /
ADD config.php.docker /var/www/html/config.php

EXPOSE 80
EXPOSE 9117

ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]

