FROM nginx

COPY vhost.conf /etc/nginx/conf.d/default.conf

ENV APP_HOST=app

CMD sed -i "s/app/${APP_HOST}/" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'