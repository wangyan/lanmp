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
echo "# LANMP Auto Uninstall Shell Scritp"
echo "# Env: Debian/Ubuntu/Redhat/CentOS"
echo "# Version: $(awk '/version/{print $2}' $LANMP_PATH/Changelog)"
echo ""
echo "# Copyright (c) 2011, WangYan <WangYan@188.com>"
echo "# All rights reserved."
echo "# Distributed under the GNU General Public License, version 3.0."
echo "#"
echo "#############################################################"
echo ""

echo "Are you sure uninstall LANMP? (y/n)"
read -p "(Default: n):" UNINSTALL
if [ -z $UNINSTALL ]; then
	UNINSTALL="n"
fi
if [ "$UNINSTALL" != "y" ]; then
	clear
	echo "==========================="
	echo "You canceled the uninstall!"
	echo "==========================="
	exit
else
	echo "---------------------------"
	echo "Yes, I decided to uninstall!"
	echo "---------------------------"
	echo ""
fi

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
echo "Press any key to start uninstall..."
echo "Or Ctrl+C cancel and exit ?"
char=`get_char`
echo ""

if [ "$UNINSTALL" = 'y' ]; then

	echo "---------- MySQL ----------"

	if cat /proc/version | grep -Eqi '(redhat|centos)';then
		chkconfig mysql off
	elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
		update-rc.d -f mysql remove
	fi

	/etc/init.d/mysql stop
	killall mysqld
	userdel mysql
	groupdel mysql
	rm -rf /etc/init.d/mysql
	rm -rf /usr/local/mysql
	rm -rf /etc/my.cnf
	rm -rf /usr/bin/mysql*
	sed -i 's/\/usr\/local\/mysql\/lib//g' /etc/ld.so.conf

	echo "---------- Apache ----------"

	if cat /proc/version | grep -Eqi '(redhat|centos)';then
		chkconfig httpd off
	elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
		update-rc.d -f httpd remove
	fi

	/etc/init.d/httpd stop
	killall httpd
	userdel www
	groupdel www
	rm -rf /etc/init.d/httpd
	rm -rf /usr/local/apache
	rm -rf /usr/local/apr
	rm -rf /usr/bin/apachectl
	rm -rf /usr/bin/httpd
	rm -rf /usr/bin/ab

	echo "---------- PHP ----------"

	cd $LANMP_PATH/src/libpng-*/
	make uninstall

	cd $LANMP_PATH/src/jpeg-*/
	make uninstall

	cd $LANMP_PATH/src/libiconv-*/
	make uninstall

	cd $LANMP_PATH/src/libmcrypt-*/
	make uninstall

	cd $LANMP_PATH/src/mhash-*/
	make uninstall

	cd $LANMP_PATH/src/mcrypt-*/
	make uninstall

	if [ -s /usr/local/php/sbin/php-fpm ]; then
		/usr/local/php/sbin/php-fpm stop
		killall php-fpm
		if cat /proc/version | grep -Eqi '(redhat|centos)';then
			chkconfig php-fpm off
		elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
			update-rc.d -f php-fpm remove
		fi
		rm -rf /etc/init.d/php-fpm
	fi

	rm -rf /usr/local/php
	rm -rf /usr/local/zend
	rm -rf /var/www/xcache
	rm -rf /tmp/{pcov,phpcore}
	rm -rf /usr/bin/php*

	echo "---------- nginx ----------"

	cd $LANMP_PATH/src/pcre-*/
	make uninstall

	if cat /proc/version | grep -Eqi '(redhat|centos)';then
		chkconfig nginx off
	elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
		update-rc.d -f nginx remove
	fi

	/etc/init.d/nginx stop
	killall nginx
	userdel nginx
	groupdel nginx

	rm -rf /etc/init.d/nginx
	rm -rf /usr/local/nginx
	rm -rf /var/tmp/nginx
	rm -rf /usr/sbin/nginx*

	echo "---------- phpmyadmin ----------"

	rm -rf /var/www/phpmyadmin

	echo "==========================="
	echo "Uninstall completed!"
	echo "==========================="
fi
