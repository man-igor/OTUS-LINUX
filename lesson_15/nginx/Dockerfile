FROM  nginx:1.17.4-alpine

RUN apk update

COPY index.html /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
