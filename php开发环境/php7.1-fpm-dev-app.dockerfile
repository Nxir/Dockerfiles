# docker build -t 0ne1rue/php7.1-fpm-dev -f dev.prod.dockerfile --build-arg HTTP_PROXY=http://10.0.0.102:6152 .

FROM php:7.1-fpm

# 切换至阿里源 首行插入地址
RUN sed -i "1i\deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib\ndeb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib\ndeb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib\ndeb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib" /etc/apt/sources.list

RUN buildDeps="libicu-dev libpq-dev libzip-dev libjpeg62-turbo-dev libfreetype6-dev libmcrypt-dev libpng-dev libmagickwand-dev zip unzip net-tools openssh-server git" \
&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
&& docker-php-ext-install intl mcrypt iconv pdo pgsql pdo_pgsql pdo_mysql sockets zip opcache\
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# 安装composer并使用国内镜像
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com
#    && php composer.phar install --no-dev --no-scripts \
#    && rm composer.phar

WORKDIR /var/www

COPY init-laravel-project.sh /usr/bin