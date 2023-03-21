FROM ubuntu:22.04
MAINTAINER karlhenh@stud.ntnu.no
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php-pgsql php-mysql \
php-memcache libmemcached11 libmemcached-dev net-tools curl unzip wget2

# Webserver: apache2 libapache2-mod-php php-pgsql php-mysql 
# memcached: php-memcache libmemcached11 libmemcached-dev
# Andre: net-tools curl unzip wget2

EXPOSE 80

# /usr/sbin/apache2ctl -D "FOREGROUND" -k start
ENTRYPOINT ["/usr/sbin/apache2ctl","-D","FOREGROUND", "-k", "start"]
