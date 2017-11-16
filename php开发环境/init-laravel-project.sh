#!/bin/bash
set -e

if [[ $# < 1 ]]; then
	echo "请传递git地址";
	exit;
fi

cd /var/www

echo "--- 克隆项目 $1 ---";
git init
git remote add origin $1
git fetch origin
git checkout master
#git branch --set-upstream-to origin/master
#git pull origin master
#git clone $1 .

# 如果有提供第二个参数, 则将参数对应的文件复制为.env文件
if [[ $2 ]]; then
	echo "--- 将$2复制为.env文件 ---"
	cp $2 .env
fi

echo "--- 开始修改目录权限 ---"

chown -R www-data:www-data \
		/var/www/storage \
		/var/www/bootstrap/cache

echo "--- 开始执行composer install ---"
command -v composer.phar >/dev/null 2>&1 && composer="composer.phar" || composer="composer"
$composer install


echo "--- 初始完成 ---"