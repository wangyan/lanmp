#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

if [ $(id -u) != "0" ]; then
	printf "Error: You must be root to run this script!"
	exit 1
fi

LANMP_PATH=`pwd`
if [ `echo $LANMP_PATH | awk -F/ '{print $NF}'` != "lanmp" ]; then
	clear && echo "Please enter lanmp script path:"
	read -p "(Default path: ${LANMP_PATH}/lanmp):" LANMP_PATH
	[ -z "$LANMP_PATH" ] && LANMP_PATH=$(pwd)/lanmp
	cd $LANMP_PATH/
fi

clear
echo "#############################################################"
echo "# LANMP Auto Update Script"
echo "# Env: Redhat/CentOS"
echo "# Intro: https://wangyan.org/blog/lanmp.html"
echo "# Version: $(awk '/version/{print $2}' $LANMP_PATH/Changelog)"
echo "#"
echo "# Copyright (c) 2012, WangYan <WangYan@188.com>"
echo "# All rights reserved."
echo "# Distributed under the GNU General Public License, version 3.0."
echo "#"
echo "#############################################################"
echo ""

echo "Please enter the webroot dir:"
read -p "(Default webroot dir: /var/www):" WEBROOT
if [ -z $WEBROOT ]; then
	WEBROOT="/var/www"
fi
echo "---------------------------"
echo "Webroot dir=$WEBROOT"
echo "---------------------------"
echo ""

echo "Please choose webserver software! (1:nginx,2:apache,3:nginx+apache) (1/2/3)"
read -p "(Default: 3):" SOFTWARE
if [ -z $SOFTWARE ]; then
	SOFTWARE="3"
fi
echo "---------------------------"
echo "You choose = $SOFTWARE"
echo "---------------------------"
echo ""

######################### PHP5 #########################

LATEST_PHP=$(curl -s http://www.php.net/downloads.php | awk '/Current stable/{print $3}')
INSTALLED_PHP=$(php -r 'echo PHP_VERSION;' 2>/dev/null);

echo -e "Latest version of PHP: \033[41;37m $LATEST_PHP \033[0m"
echo -e "Installed version of PHP: \033[41;37m $INSTALLED_PHP \033[0m"
echo ""

if [ "$INSTALLED_PHP" != "5.2.17p1" ];then
	echo "Do you want to upgrade PHP ? (y/n)"
	read -p "(Default: n):" UPGRADE_PHP
	if [ -z $UPGRADE_PHP ]; then
		UPGRADE_PHP="n"
	fi
	echo "---------------------------"
	echo "You choose = $UPGRADE_PHP"
	echo "---------------------------"
	echo ""
fi

######################### Nginx #########################

if [ "$SOFTWARE" != 2 ];then
	INSTALLED_NGINX=$(echo `nginx -v 2>&1` | cut -d '/' -f 2)
	LATEST_NGINX=$(curl -s http://nginx.org/| awk -F- '/nginx-/{print $6}' | head -1|cut -d '<' -f 1)

	echo -e "Latest version of Nginx: \033[41;37m $LATEST_NGINX \033[0m"
	echo -e "Installed version of Nginx: \033[41;37m $INSTALLED_NGINX \033[0m"
	echo ""	

	echo "Do you want to upgrade Nginx ? (y/n)"
	read -p "(Default: n):" UPGRADE_NGINX
	if [ -z $UPGRADE_NGINX ]; then
		UPGRADE_NGINX="n"
	fi
	echo "---------------------------"
	echo "You choose = $UPGRADE_NGINX"
	echo "---------------------------"
	echo ""
fi

######################### phpMyAdmin #########################

if [ ! -s "$LANMP_PATH/version.txt" ]; then
	echo -e "phpmyadmin\t0" > $LANMP_PATH/version.txt
fi

INSTALLED_PMA=$(awk '/phpmyadmin/{print $2}' $LANMP_PATH/version.txt)
LATEST_PMA=$(elinks http://nchc.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/ | awk -F/ '{print $7F}' | sort -n | grep -iv '-' | tail -1)

echo -e "Latest version of phpmyadmin: \033[41;37m $LATEST_PMA \033[0m"
echo -e "Installed version of phpmyadmin: \033[41;37m $INSTALLED_PMA \033[0m"
echo ""

echo "Do you want to upgrade phpmyadmin ? (y/n)"
read -p "(Default: n):" UPGRADE_PMA
if [ -z $UPGRADE_PMA ]; then
	UPGRADE_PMA="n"
fi
echo "---------------------------"
echo "You choose = $UPGRADE_PMA"
echo "---------------------------"
echo ""


get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}
echo "Press any key to start Upgrade..."
echo "Or Ctrl+C cancel and exit ?"
echo ""
char=`get_char`

######################### Extract Function #########################

Extract(){
	local TARBALL_TYPE
	if [ -n $1 ]; then
		SOFTWARE_NAME=`echo $1 | awk -F/ '{print $NF}'`
		TARBALL_TYPE=`echo $1 | awk -F. '{print $NF}'`
		wget -c -t3 -T3 $1 -P $LANMP_PATH/
		if [ $? != "0" ];then
			rm -rf $LANMP_PATH/$SOFTWARE_NAME
			wget -c -t3 -T60 $2 -P $LANMP_PATH/
			SOFTWARE_NAME=`echo $2 | awk -F/ '{print $NF}'`
			TARBALL_TYPE=`echo $2 | awk -F. '{print $NF}'`
		fi
	else
		SOFTWARE_NAME=`echo $2 | awk -F/ '{print $NF}'`
		TARBALL_TYPE=`echo $2 | awk -F. '{print $NF}'`
		wget -c -t3 -T3 $2 -P $LANMP_PATH/ || exit
	fi
	EXTRACTED_DIR=`tar tf $LANMP_PATH/$SOFTWARE_NAME | tail -n 1 | awk -F/ '{print $1}'`
	case $TARBALL_TYPE in
		gz|tgz)
			tar zxf $LANMP_PATH/$SOFTWARE_NAME -C $LANMP_PATH/ && cd $LANMP_PATH/$EXTRACTED_DIR || return 1
		;;
		bz2|tbz)
			tar jxf $LANMP_PATH/$SOFTWARE_NAME -C $LANMP_PATH/ && cd $LANMP_PATH/$EXTRACTED_DIR || return 1
		;;
		tar|Z)
			tar xf $LANMP_PATH/$SOFTWARE_NAME -C $LANMP_PATH/ && cd $LANMP_PATH/$EXTRACTED_DIR || return 1
		;;
		*)
		echo "$SOFTWARE_NAME is wrong tarball type ! "
	esac
}

echo "===================== PHP5 Upgrade ===================="

if [[ "$UPGRADE_PHP" = "y" || "$UPGRADE_PHP" = "Y" ]];then

	if [[ -d "/usr/local/php.bak" && -d "/usr/local/php" ]];then
		rm -rf /usr/local/php.bak/
	fi
	\mv /usr/local/php /usr/local/php.bak

	cd $LANMP_PATH

	if [ ! -s php-5.4.*.tar.gz ]; then
		LATEST_PHP_LINK="http://us.php.net/distributions/php-${LATEST_PHP}.tar.gz"
		BACKUP_PHP_LINK="http://wangyan.org/download/lanmp/php-latest.tar.gz"
		Extract ${LATEST_PHP_LINK} ${BACKUP_PHP_LINK}
	else
		tar -zxf php-5.4.*.tar.gz
		cd php-5.4.*/
	fi

	if [ "$SOFTWARE" != "1" ]; then
		./configure \
		--prefix=/usr/local/php \
		--with-apxs2=/usr/local/apache/bin/apxs \
		--with-curl \
		--with-curlwrappers \
		--with-freetype-dir \
		--with-gettext \
		--with-gd \
		--with-iconv-dir \
		--with-jpeg-dir \
		--with-libxml-dir \
		--with-mcrypt \
		--with-mhash \
		--with-mysql=/usr/local/mysql \
		--with-mysqli=/usr/local/mysql/bin/mysql_config \
		--with-openssl \
		--with-pear \
		--with-png-dir \
		--with-xmlrpc \
		--with-zlib \
		--enable-bcmath \
		--enable-calendar \
		--enable-exif \
		--enable-ftp \
		--enable-gd-native-ttf \
		--enable-inline-optimization \
		--enable-mbregex \
		--enable-mbstring \
		--enable-shmop \
		--enable-soap \
		--enable-sockets \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-xml \
		--enable-zip
	else
		./configure \
		--prefix=/usr/local/php \
		--with-curl \
		--with-curlwrappers \
		--with-freetype-dir \
		--with-gettext \
		--with-gd \
		--with-iconv-dir \
		--with-jpeg-dir \
		--with-libxml-dir \
		--with-mcrypt \
		--with-mhash \
		--with-mysql=/usr/local/mysql \
		--with-mysqli=/usr/local/mysql/bin/mysql_config \
		--with-openssl \
		--with-pear \
		--with-png-dir \
		--with-xmlrpc \
		--with-zlib \
		--enable-bcmath \
		--enable-calendar \
		--enable-exif \
		--enable-fpm \
		--enable-ftp \
		--enable-gd-native-ttf \
		--enable-inline-optimization \
		--enable-mbregex \
		--enable-mbstring \
		--enable-pcntl \
		--enable-shmop \
		--enable-soap \
		--enable-sockets \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-xml \
		--enable-zip
	fi

	make ZEND_EXTRA_LIBS='-liconv'
	make install

	echo "---------- PHP Extension ----------"
	
	mkdir -p /usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/
	cp /usr/local/php.bak/lib/php/extensions/no-debug-non-zts-20100525/* /usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/

	echo "---------- PHP Config ----------"

	cp /usr/local/php.bak/lib/php.ini /usr/local/php/lib/php.ini

	if [ "$SOFTWARE" != "1" ]; then
		pkill httpd
		/etc/init.d/httpd start
	else
		cp /usr/local/php.bak/etc/php-fpm.conf /usr/local/php/etc/php-fpm.conf
		pkill php-fpm
		/etc/init.d/php-fpm start
	fi

	rm -rf $LANMP_PATH/src/{php-*,memcache-*,xcache-*}
fi

echo "===================== Nginx Upgrade ===================="

if [[ "$UPGRADE_NGINX" = "y" || "$UPGRADE_NGINX" = "Y" ]];then

	cd $LANMP_PATH
	
	if [ ! -s nginx-${LATEST_NGINX}.tar.gz ]; then
		LATEST_NGINX_LINK="http://nginx.org/download/nginx-$LATEST_NGINX.tar.gz"
		BACKUP_NGINX_LINK="http://wangyan.org/download/lanmp/nginx-latest.tar.gz"
		Extract ${LATEST_NGINX_LINK} ${BACKUP_NGINX_LINK}
	else
		tar -zxf nginx-${LATEST_NGINX}.tar.gz
		cd nginx-${LATEST_NGINX}/
	fi

	./configure \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/lock/nginx.lock \
	--user=www \
	--group=www \
	--with-http_ssl_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_realip_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-pcre \
	--with-debug \
	--with-ipv6 \
	--http-client-body-temp-path=/var/tmp/nginx/client \
	--http-proxy-temp-path=/var/tmp/nginx/proxy \
	--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
	--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
	--http-scgi-temp-path=/var/tmp/nginx/scgi
	make

	\mv /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.old
	cp objs/nginx /usr/local/nginx/sbin/nginx
	/usr/local/nginx/sbin/nginx -t
	make upgrade
	echo "Upgrade completed!"
	/usr/local/nginx/sbin/nginx -v
	echo ""
	/etc/init.d/nginx restart

	rm -rf $LANMP_PATH/src/nginx-*
fi


echo "===================== phpMyAdmin Upgrade ===================="

if [[ "$UPGRADE_PMA" = "y" || "$UPGRADE_PMA" = "Y" ]];then

	PMA_LINK="http://nchc.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin"

	mv $WEBROOT/phpmyadmin/config.inc.php $WEBROOT/config.inc.php
	rm -rf $WEBROOT/phpmyadmin/

	if [ ! -s phpMyAdmin-${LATEST_PMA}-all-languages.tar.gz ]; then
		LATEST_PMA_LINK="${PMA_LINK}/${LATEST_PMA}/phpMyAdmin-${LATEST_PMA}-all-languages.tar.gz"
		BACKUP_PMA_LINK="http://wangyan.org/download/lanmp/phpMyAdmin-latest-all-languages.tar.gz"
		Extract ${LATEST_PMA_LINK} ${BACKUP_PMA_LINK}
		mkdir -p $WEBROOT/phpmyadmin
		mv * $WEBROOT/phpmyadmin
	else
		tar -zxf phpMyAdmin-${LATEST_PMA}-all-languages.tar.gz -C $WEBROOT
		mv $WEBROOT/phpMyAdmin-${LATEST_PMA}-all-languages $WEBROOT/phpmyadmin
	fi

	mv $WEBROOT/config.inc.php $WEBROOT/phpmyadmin/
	
	sed -i '/phpmyadmin/d' $LANMP_PATH/version.txt
	echo -e "phpmyadmin\t${LATEST_PMA}" >> $LANMP_PATH/version.txt 2>&1
	rm -rf $LANMP_PATH/src/phpMyAdmin-*

fi

if [ ! -d "$LANMP_PATH/src" ];then
	mkdir -p $LANMP_PATH/src/
fi
\mv $LANMP_PATH/{*gz,*-*/,ioncube,package.xml} $LANMP_PATH/src >/dev/null 2>&1
