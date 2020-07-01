FROM php:7.2-apache
RUN apt-get update && \
    apt-get install -y gcc make \
        libssh2-1-dev libssh2-1 \
        libldap2-dev \
        libonig-dev \
        colordiff

RUN curl http://pecl.php.net/get/ssh2-1.2.tgz -o ssh2.tgz && \
    pecl install ssh2 ssh2.tgz && \
    rm -rf ssh2.tgz

RUN docker-php-ext-install mbstring \
        pcntl \
        ldap \
        mysqli

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ 
RUN docker-php-ext-enable ssh2 && \
        a2enmod authnz_ldap

#RUN sed -i "s#^ErrorLog.*#ErrorLog /proc/self/fd/1#" /etc/apache2/apache2.conf

WORKDIR /ska
COPY . .
RUN chown  www-data:www-data -R /ska && \
    chmod +x prepare-docker-configs.sh

CMD ["apache2-foreground"]
# https://stackoverflow.com/questions/62596598/stopping-apache2-is-much-slower-when-overriding-entrypoint-in-docker
ENTRYPOINT ["./prepare-docker-configs.sh"]