FROM alpine:3.12

RUN apk add --no-cache --update php7-apache2 curl tar \
      php7-mysqli php7-pdo_mysql php7-session php7-gd php7-json php7-tokenizer && \
    sed -e "s~#LoadModule rewrite_module modules/mod_rewrite.so~LoadModule rewrite_module modules/mod_rewrite.so~g" -i /etc/apache2/httpd.conf && \
    mkdir -p /var/www/wordpress

VOLUME /var/www/wordpress

ADD wordpress.conf /etc/apache2/conf.d/wordpress.conf
ADD run.sh /run.sh


CMD ["/run.sh"]
