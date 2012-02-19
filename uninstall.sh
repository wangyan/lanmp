#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

if [ $(id -u) != "0" ]; then
	printf "Error: You must be root to run this script!"
	exit 1
fi

clear
echo "#############################################################"
echo "# LANMP Auto Uninstall Shell Scritp"
echo "# Env: Debian/Ubuntu/Redhat/CentOS"
echo "# Last modified: 2012.02.20"
echo ""
echo "# Copyright (c) 2011, WangYan <WangYan@188.com>"
echo "# All rights reserved."
echo "# Distributed under the GNU General Public License, version 3.0."
echo "#"
echo "#############################################################"
echo ""

LANMP_PATH=`pwd`
if [ `echo $LANMP_PATH | awk -F/ '{print $NF}'` != "lanmp" ]; then
	echo "Please enter lanmp script path:"
	read -p "(Default path: /root/lanmp):" LANMP_PATH
	[ -z "$LANMP_PATH" ] && LANMP_PATH="/root/lanmp"
	echo "---------------------------"
	echo "lanmp path = $LANMP_PATH"
	echo "---------------------------"
	echo ""
fi

echo "Are you sure uninstall LANMP? (y/n)"
read -p "(Default: n):" UNINSTALL
if [ "$UNINSTALL" = "" ]; then
	UNINSTALL="n"
fi
echo ""

if [ "$UNINSTALL" = 'y' ]; then

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
	echo ""
	echo "Press any key to start uninstall..."
	echo "Or Ctrl+C cancel and exit ?"
	char=`get_char`

echo "---------- mysql ----------"

	/etc/init.d/mysql stop
	killall mysqld
	userdel mysql
	groupdel mysql
	update-rc.d -f mysql remove
	chkconfig mysql off
	rm -rf /etc/init.d/mysql
	rm -rf /usr/local/mysql
	rm -rf /etc/mysql
	rm -rf /usr/bin/mysql*
	sed -i 's/\/usr\/local\/mysql\/lib//g' /etc/ld.so.conf

echo "---------- php5 ----------"

	cd $LANMP_PATH/libpng-*/
	make uninstall

	cd $LANMP_PATH/jpeg-*/
	make uninstall

	cd $LANMP_PATH/libiconv-*/
	make uninstall

	cd $LANMP_PATH/libmcrypt-*/
	make uninstall

	cd $LANMP_PATH/mhash-*/
	make uninstall

	cd $LANMP_PATH/mcrypt-*/
	make uninstall

	/usr/local/php/sbin/php-fpm stop
	killall php-fpm
	update-rc.d -f php-fpm remove
	chkconfig php-fpm off
	rm -rf /etc/init.d/php-fpm
	rm -rf /usr/local/php
	rm -rf /usr/local/zend
	rm -rf /tmp/eaccelerator
	rm -rf /usr/bin/php*

echo "---------- nginx ----------"

	cd $LANMP_PATH/pcre-*/
	make uninstall

	/etc/init.d/nginx stop
	killall nginx
	userdel nginx
	groupdel nginx
	update-rc.d -f nginx remove
	chkconfig 345 nginx off

	rm -rf /etc/init.d/nginx
	rm -rf /usr/local/nginx
	rm -rf /usr/sbin/nginx*

echo "---------- apache ----------"

	/etc/init.d/httpd stop
	killall httpd
	userdel www
	groupdel www
	update-rc.d -f httpd remove
	chkconfig httpd off
	rm -rf /etc/init.d/httpd
	rm -rf /usr/local/apache
	rm -rf /usr/bin/apachectl
	rm -rf /usr/bin/httpd
	rm -rf /usr/bin/ab

echo "---------- phpmyadmin ----------"

	rm -rf /var/www/phpmyadmin

	echo "==========================="
	echo "Uninstall completed!"
	echo "==========================="
else
	echo "==========================="
	echo "You canceled uninstall!"
	echo "==========================="
fi
