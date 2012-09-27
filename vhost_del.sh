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
echo "# Delete  Virtual hosts for LANMP"
echo "# Env: Debian/Ubuntu/Redhat/CentOS"
echo "# Author: https://wangyan.org/"
echo "# Version: $(awk '/version/{print $2}' $LANMP_PATH/Changelog)"
echo "#############################################################"
echo ""

echo "Please enter account name:"
read -p "(Default vhost account: example):" VHOST_ACCOUNT
if [ -z $VHOST_ACCOUNT ]; then
	VHOST_ACCOUNT="example"
fi
echo "---------------------------"
echo "vhost account = $VHOST_ACCOUNT"
echo "---------------------------"
echo ""

echo "Do you want to delete pureftpd user? (y/n)"
read -p "(Default: n):" DELETE_FTPUSER
if [ -z $DELETE_FTPUSER ]; then
	DELETE_FTPUSER="n"
fi
if [ "$DELETE_FTPUSER" = 'y' ]; then
	echo "Please enter the MySQL root password:"
	read -p "(Default password: 123456):" MYSQL_ROOT_PWD
	if [ -z $MYSQL_ROOT_PWD ]; then
		MYSQL_ROOT_PWD="123456"
	fi
	echo "---------------------------"
	echo "MySQL root password = $MYSQL_ROOT_PWD"
	echo "---------------------------"
	echo ""
else
	echo "---------------------------"
	echo "You decided not to delete FTP users!"
	echo "---------------------------"
	echo ""
fi

echo "Do you want to delete MySQL DB? (y/n)"
read -p "(Default: n):" DELETE_MYSQL_DB
if [ -z $DELETE_MYSQL_DB ]; then
	DELETE_MYSQL_DB="n"
fi
if [ "$DELETE_MYSQL_DB" = 'y' ]; then
	if [ -z $MYSQL_ROOT_PWD ]; then
		echo "Please enter the MySQL root password:"
		read -p "(Default password: 123456):" MYSQL_ROOT_PWD
		if [ -z $MYSQL_ROOT_PWD ]; then
			MYSQL_ROOT_PWD="123456"
		fi
		echo "---------------------------"
		echo "MySQL root password = $MYSQL_ROOT_PWD"
		echo "---------------------------"
		echo ""
	fi
	echo "Please enter your MySQL db name:"
	read -p "(Default: ${VHOST_ACCOUNT}):" MYSQL_DB_NAME
	if [ -z $MYSQL_DB_NAME ]; then
		MYSQL_DB_NAME="$VHOST_ACCOUNT"
	fi
	echo "---------------------------"
	echo "MySQL db name = $MYSQL_DB_NAME"
	echo "---------------------------"
	echo ""
else
	echo "---------------------------"
	echo "You decided not to delete MySQL DB!"
	echo "---------------------------"
	echo ""
fi

echo "Please enter website domain:"
read -p "(e.g: example.com):" DOMAIN
if [ -z $DOMAIN ]; then
	DOMAIN="example.com"
fi
echo "---------------------------"
echo " Domain = $DOMAIN"
echo "---------------------------"
echo ""
sed -i '/'$DOMAIN'/d' $LANMP_PATH/domain_list.txt

echo "Please choose software of webserver! (1:nginx,2:apache,3:nginx+apache) (1/2/3)"
read -p "(Default: 3):" SOFTWARE
if [ -z $SOFTWARE ]; then
	SOFTWARE="3"
fi
echo "---------------------------"
echo "You choose = $SOFTWARE"
echo "---------------------------"
echo ""

echo "Do you want to delete subdomain? (y/n)"
read -p "(Default: n):" DEL_SUBDOMAIN
if [ -z $DEL_SUBDOMAIN ]; then
	DEL_SUBDOMAIN="n"
fi
if [ "$DEL_SUBDOMAIN" = 'y' ]; then
	echo "Please enter your subdomain:"
	read -p "(e.g: bbs):" SUBDOMAIN
	if [ -z $SUBDOMAIN ]; then
		SUBDOMAIN="bbs"
	fi
	echo "---------------------------"
	echo "Subdomain = $SUBDOMAIN"
	echo "---------------------------"
else
	echo "---------------------------"
	echo "Not delete any subdomain!"
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
echo "Press any key to start delete vhost..."
echo "Or Ctrl+C cancel and exit ?"
echo ""
char=`get_char`

######################################################################

if [ "$DELETE_FTPUSER" = "y" ]; then
	mysql -uroot -p$MYSQL_ROOT_PWD -e"DELETE FROM pureftpd.users WHERE users.User = '$VHOST_ACCOUNT';"
fi

if [ "$DELETE_MYSQL_DB" = "y" ]; then
	mysql -uroot -p$MYSQL_ROOT_PWD -e"drop database $MYSQL_DB_NAME;Drop USER ${MYSQL_DB_NAME}@localhost;"
fi

if [ "$SOFTWARE" != 2 ]; then
	if [ "$SOFTWARE" = "1" ]; then
		userdel $VHOST_ACCOUNT
		rm -rf /var/spool/mail/$VHOST_ACCOUNT
	fi
	if [ "$DEL_SUBDOMAIN" = 'n' ]; then
		rm -rf /usr/local/nginx/conf/vhosts/*${DOMAIN}.conf
		rm -rf /usr/local/nginx/logs/$DOMAIN
		rm -rf /home/$VHOST_ACCOUNT
	else
		rm -rf /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
		rm -rf /home/$VHOST_ACCOUNT/$SUBDOMAIN
	fi
fi

if [ "$SOFTWARE" != 1 ]; then
	if [ "$DEL_SUBDOMAIN" = 'n' ]; then
		rm -rf /usr/local/apache/conf/vhosts/*${DOMAIN}.conf
		rm -rf /usr/local/apache/logs/$DOMAIN
		\rm -rf /home/$VHOST_ACCOUNT
	else
		rm -rf /usr/local/apache/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
		\rm -rf /home/$VHOST_ACCOUNT/$SUBDOMAIN
	fi
fi

if [ "$SOFTWARE" != "2" ]; then
	echo "Test Nginx configure file......"
	/usr/local/nginx/sbin/nginx -t
	echo ""
	/etc/init.d/nginx reload
fi

if [ "$SOFTWARE" != "1" ]; then
	echo "Test apache configure file......"
	/usr/local/apache/bin/apachectl -t
	echo ""
	/etc/init.d/httpd restart
fi

clear
echo ""
echo "===================== Delete completed ====================="
echo ""
echo "Vhost account: $VHOST_ACCOUNT"
echo "Website domain: $DOMAIN"
if [ "$DEL_SUBDOMAIN" = 'y' ]; then
echo "Website subdomain: $SUBDOMAIN"
fi
echo ""
echo "============================================================="
echo ""
