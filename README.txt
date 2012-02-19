一、简介

LANMP 环境指的是 Linux + Apache + Nginx + MySQL + PHP。
LANMP 一键安装包使用的是Linux Shell语言编写，用于在Linux系统(Redhat/CentOS/Debian/Ubuntu)上一键安装LAMP环境。

二、特点与优势

1、3种Web环境自由组合

lnmp、lamp、lanmp（Nginx前端Apache后端）可自主选择，甚至安装完后还可以自由调整。

2、最新版本软件包

全部采用最新稳定版本的软件包，如PHP5.3系列，MySQL 5.5系列。

3、下载更智能更方便

自动从官方地址下载最新稳定版本源码安装，如果官网挂了或被和谐了，可自动从备选地址下载最新版。

4、完美多用户支持

配套了虚拟主机用户添加和删除脚本，因此可用来做虚拟主机销售。（主网站位于/var/www目录，用户网站位于/home/user1、/home/user2...）

5、完善的扩展支持

除小型依赖库外，都尽可能从源码编译安装。如PHP支持了gd,memcache,eaccelerator,pdo mysql等扩展。

6、多种php处理方式

Nginx以FastCGI方式解析PHP，Nginx+Apache以php模块方式解析PHP。

7、模块化安装流程

模块化、清晰的安装流程，脚本非常易于理解，因此您可以很容易修改脚本。

８、其他

如phpMyAdmin支持额外的链接表特性，支持添加二级子域名，自定义rewrite规则等等。

三、配置文件位置

php:	/usr/local/php/lib/php.ini
php-fpm:	/usr/local/php/etc/php-fpm.conf
pear:	/usr/local/php/etc/pear.conf
nginx:	/usr/local/nginx/conf/nginx.conf
httpd:	/usr/local/apache/conf/httpd.conf
mysql:	/etc/my.cnf

四、注意事项

1、LANMP一键安装包针对了512M内存的VPS进行了些优化。如果你的内存较低，建议您要修改php或apache的配置文件。
2、下载版安装包需要连接互联网，完整版安装包可以在局域安装，但需要配置好局域网的更新源。