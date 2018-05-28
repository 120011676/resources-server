FROM php:apache

MAINTAINER Say.li <120011676@qq.com>

LABEL maintainer="Say.li <120011676@qq.com>"

USER root

ENV TZ Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY ./src/ /var/www/html/
RUN chown www-data:www-data -R /var/www/html/

EXPOSE 80