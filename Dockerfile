FROM alpine:3.22.1

RUN apk add --no-cache --update php84-apache2 curl tar \
      php84-mysqli php84-pdo_mysql php84-session php84-gd php84-json php84-tokenizer && \
    sed -e "s~#LoadModule rewrite_module modules/mod_rewrite.so~LoadModule rewrite_module modules/mod_rewrite.so~g" -i /etc/apache2/httpd.conf && \
    mkdir -p /var/www/wordpress

VOLUME /var/www/wordpress

ADD wordpress.conf /etc/apache2/conf.d/wordpress.conf
ADD php-options.ini /etc/php7/conf.d/99_php-options.ini
ADD run.sh /run.sh


CMD ["/run.sh"]
