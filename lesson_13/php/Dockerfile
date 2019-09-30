FROM php:7.3-fpm-alpine

RUN apk update && apk --no-cache add curl-dev

RUN  docker-php-ext-install mbstring \
     && docker-php-ext-install mysqli \
     && docker-php-ext-install curl

WORKDIR /usr/share/nginx/html

EXPOSE 9000

CMD ["php-fpm"]
