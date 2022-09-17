FROM alpine:3.16

RUN apk add --no-cache --update php8-apache2 curl tar \
      php8-mysqli php8-pdo_mysql php8-session php8-gd php8-json php8-tokenizer && \
    sed -e "s~#LoadModule rewrite_module modules/mod_rewrite.so~LoadModule rewrite_module modules/mod_rewrite.so~g" -i /etc/apache2/httpd.conf && \
    mkdir -p /var/www/wordpress

VOLUME /var/www/wordpress

ADD wordpress.conf /etc/apache2/conf.d/wordpress.conf
ADD php-options.ini /etc/php7/conf.d/99_php-options.ini
ADD run.sh /run.sh


CMD ["/run.sh"]
