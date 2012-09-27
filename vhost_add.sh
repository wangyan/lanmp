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
echo "# Add Virtual Host for LANMP"
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

echo "Do you want to add a pureftpd user? (y/n)"
read -p "(Default: n):" ADD_FTPUSER
if [ -z $ADD_FTPUSER ]; then
	ADD_FTPUSER="n"
fi
if [ "$ADD_FTPUSER" = 'y' ]; then
	echo "Please enter the MySQL root password:"
	read -p "(Default password: 123456):" MYSQL_ROOT_PWD
	if [ -z $MYSQL_ROOT_PWD ]; then
		MYSQL_ROOT_PWD="123456"
	fi
	echo "---------------------------"
	echo "MySQL root password = $MYSQL_ROOT_PWD"
	echo "---------------------------"
	echo ""
	echo "Please enter your ftp account password:"
	read -p "(Default: 123456):" FTP_PWD
	if [ -z $FTP_PWD ]; then
		FTP_PWD="123456"
	fi
	echo "---------------------------"
	echo "Ftp password = $FTP_PWD"
	echo "---------------------------"
	echo ""
else
	echo "---------------------------"
	echo "You decided not to add FTP users!"
	echo "---------------------------"
	echo ""
fi

echo "Do you want to add MySQL DB? (y/n)"
read -p "(Default: n):" ADD_MYSQL_DB
if [ -z $ADD_MYSQL_DB ]; then
	ADD_MYSQL_DB="n"
fi
if [ "$ADD_MYSQL_DB" = 'y' ]; then
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
	echo "Please enter your MySQL db password:"
	read -p "(Default: $FTP_PWD):" MYSQL_DB_PWD
	if [ -z $MYSQL_DB_PWD ]; then
		if [ -z $FTP_PWD ]; then
			MYSQL_DB_PWD="123456"
		else
			MYSQL_DB_PWD="$FTP_PWD"
		fi
	fi
	echo "---------------------------"
	echo "MySQL db name = $MYSQL_DB_NAME"
	echo "MySQL db password = $MYSQL_DB_PWD"
	echo "---------------------------"
	echo ""
else
	echo "---------------------------"
	echo " You decided not to add MySQL DB!"
	echo "---------------------------"
	echo ""
fi

echo "Please enter website domain:"
read -p "(e.g: example.com):" DOMAIN
if [ -z $DOMAIN ]; then
	DOMAIN="example.com"
fi
[ ! -s $LANMP_PATH/domain_list.txt ] && touch $LANMP_PATH/domain_list.txt
if grep -iqw $DOMAIN $LANMP_PATH/domain_list.txt; then
	IS_DOMAIN="1"
	echo "---------------------------"
	echo "Note! $DOMAIN already is exist!"
	echo "---------------------------"
	echo ""
else
	echo -e $DOMAIN >> $LANMP_PATH/domain_list.txt
	echo "---------------------------"
	echo " Domain = $DOMAIN"
	echo "---------------------------"
	echo ""
fi

echo "Please choose software of webserver! (1:nginx,2:apache,3:nginx+apache) (1/2/3)"
read -p "(Default: 3):" SOFTWARE
if [ -z $SOFTWARE ]; then
	SOFTWARE="3"
fi
echo "---------------------------"
echo "You choose = $SOFTWARE"
echo "---------------------------"
echo ""
if [ "$SOFTWARE" = "1" ]; then
	echo "Do you want to support nginx rewrite? (y/n)"
	read -p "(Default: n):" NGINX_REWRITE
	if [ -z $NGINX_REWRITE ]; then
		NGINX_REWRITE="n"
	fi

	if [ "$NGINX_REWRITE" = 'y' ]; then
		echo "Please choose rewrite rule (wordpress,typecho,sablog,...):"
		read -p "(Default: wordpress):" REWRITE_RULE
		if [ -z $REWRITE_RULE ]; then
			REWRITE_RULE="wordpress"
		fi

	if [ ! -f $LANMP_PATH/rewrite/$REWRITE_RULE.conf ]; then
		touch /usr/local/nginx/conf/$REWRITE_RULE.conf
		echo "---------------------------"
			echo "Create a new rewirte rule: /usr/local/nginx/conf/$REWRITE_RULE.conf"
			echo "---------------------------"
		echo ""
	else
		\cp $LANMP_PATH/rewrite/$REWRITE_RULE.conf /usr/local/nginx/conf/$REWRITE_RULE.conf
		echo "---------------------------"
			echo "You choose rewrite rule: $REWRITE_RULE"
			echo "---------------------------"
		echo ""
	fi
	else
		echo "---------------------------"
		echo "You dont't allow nginx rewrite!"
		echo "---------------------------"
	echo ""
	fi
fi

echo "Do you want to add subdomain? (y/n)"
read -p "(Default: n):" ADD_SUBDOMAIN
if [ -z $ADD_SUBDOMAIN ]; then
	ADD_SUBDOMAIN="n"
fi
if [ "$ADD_SUBDOMAIN" = 'y' ]; then
	echo "Please enter your subdomain:"
	read -p "(e.g: bbs):" SUBDOMAIN
	if [ -z $SUBDOMAIN ]; then
		SUBDOMAIN="bbs"
	fi
	echo "---------------------------"
	echo "Subdomain = $SUBDOMAIN"
	echo "---------------------------"
	echo ""
else
	if [ "$IS_DOMAIN" = "1" ]; then
		clear
		echo ""
		echo "Over! Because $DOMAIN is exist!"
		echo ""
		exit
	else
		echo "---------------------------"
		echo "You don't want to add subdomain"
		echo "---------------------------"
		echo ""
	fi
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
echo "Press any key to start create vhost..."
echo "Or Ctrl+C cancel and exit ?"
echo ""
char=`get_char`


if [ ! -d "/home/$VHOST_ACCOUNT" ]; then
	mkdir -p /home/$VHOST_ACCOUNT/public_html
	chmod -R 711 /home/$VHOST_ACCOUNT
	echo $DOMAIN > /home/$VHOST_ACCOUNT/public_html/index.php
fi

if [ "$ADD_SUBDOMAIN" = 'y' ]; then
	mkdir -p /home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN
	chmod 711 /home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN
	echo ${SUBDOMAIN}.${DOMAIN} > /home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN/index.php
fi

###################################  MySQL ###################################

if [ "$ADD_FTPUSER" = "y" ]; then
	UNUM=`awk -F: '$1=="www"{print $3}' /etc/passwd`
	GNUM=`awk -F: '$1=="www"{print $4}' /etc/passwd`
	cat >/tmp/add_ftpuser<<-EOF
	use pureftpd;
	insert pureftpd.users values ('$VHOST_ACCOUNT',md5('$FTP_PWD'),'$UNUM','$GNUM','/home/$VHOST_ACCOUNT','0','0','0','0','*','','1','0','0');
	EOF
	cat /tmp/add_ftpuser | mysql -u root -p$MYSQL_ROOT_PWD
	rm -rf /tmp/add_ftpuser
fi

if [ "$ADD_MYSQL_DB" = "y" ]; then
	cat >/tmp/add_mysql_db<<-EOF
	create database $MYSQL_DB_NAME;
	grant all on ${MYSQL_DB_NAME}.* to $MYSQL_DB_NAME@localhost identified by '$MYSQL_DB_PWD';
	EOF
	cat /tmp/add_mysql_db | mysql -u root -p$MYSQL_ROOT_PWD
	rm -rf /tmp/add_mysql_db
fi

###################################  Nginx ###################################

if [ "$SOFTWARE" != "2" ]; then

	if [ "$SOFTWARE" = "1" ]; then
		if grep -iqw $VHOST_ACCOUNT /etc/passwd; then
			echo "$VHOST_ACCOUNT is exist!"
		else
			groupadd $VHOST_ACCOUNT
			useradd -g $VHOST_ACCOUNT -d /home/$VHOST_ACCOUNT -s /bin/false $VHOST_ACCOUNT
			chown -R $VHOST_ACCOUNT:$VHOST_ACCOUNT /home/$VHOST_ACCOUNT
		fi
	fi

	if [ ! -s "/usr/local/nginx/conf/vhosts/$DOMAIN.conf" ];then
		if [ "$SOFTWARE" = "1" ]; then
			cp $LANMP_PATH/conf/nginx-vhost-original.conf /usr/local/nginx/conf/vhosts/$DOMAIN.conf
		else
			cp $LANMP_PATH/conf/nginx-vhost-proxy.conf /usr/local/nginx/conf/vhosts/$DOMAIN.conf
		fi
		chmod 644 /usr/local/nginx/conf/vhosts/$DOMAIN.conf
		sed -i 's/DOMAIN/'$DOMAIN'/g' /usr/local/nginx/conf/vhosts/$DOMAIN.conf
		sed -i 's,ROOTDIR,/home/'$VHOST_ACCOUNT'/public_html,g' /usr/local/nginx/conf/vhosts/$DOMAIN.conf
	fi

	if [ "$ADD_SUBDOMAIN" = 'y' ]; then
		if [ ! -s "/usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf" ];then
			cp /usr/local/nginx/conf/vhosts/$DOMAIN.conf /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
			sed -i 's/server_name '$DOMAIN'/server_name/g' /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
			sed -i 's/www./'$SUBDOMAIN'./g' /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
			sed -i 's,public_html,public_html/'$SUBDOMAIN',g' /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
		fi
	fi

	if [ "$NGINX_REWRITE" = 'y' ] && [ "$SOFTWARE" = "1" ]; then
		if [ "$ADD_SUBDOMAIN" = 'y' ]; then
			sed -i 's/\#include REWRITE_RULE/include '$REWRITE_RULE'/g' /usr/local/nginx/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
		else
			sed -i 's/\#include REWRITE_RULE/include '$REWRITE_RULE'/g' /usr/local/nginx/conf/vhosts/$DOMAIN.conf
		fi
		chmod 644 /usr/local/nginx/conf/$REWRITE_RULE.conf
	fi

	if [ ! -d "/usr/local/nginx/logs/$DOMAIN" ]; then
		mkdir /usr/local/nginx/logs/$DOMAIN
	fi

fi

###################################  Apache ###################################

if [ "$SOFTWARE" != "1" ]; then

	chown -R www:www /home/$VHOST_ACCOUNT

	if [ ! -s "/usr/local/apache/conf/vhosts/$DOMAIN.conf" ];then
		cat >>/usr/local/apache/conf/vhosts/$DOMAIN.conf<<-EOF
		<VirtualHost *:80>
			ServerAdmin webmaster@$DOMAIN
			DocumentRoot "/home/$VHOST_ACCOUNT/public_html"
			ServerName $DOMAIN
			ServerAlias www.$DOMAIN
			ErrorLog "logs/$DOMAIN/error.log"
			CustomLog "logs/$DOMAIN/access.log" combinedio
			<Directory "/home/$VHOST_ACCOUNT/public_html">
				Options +Includes +Indexes
				php_admin_flag engine ON
				php_admin_value open_basedir "/home/$VHOST_ACCOUNT/public_html:/tmp:/proc"
			</Directory>
		</VirtualHost>

		EOF
		if [ "$SOFTWARE" = "2" ]; then
			cat >>/usr/local/apache/conf/vhosts/$DOMAIN.conf<<-EOF
			<VirtualHost *:443>
				ServerAdmin webmaster@$DOMAIN
				DocumentRoot "/home/$VHOST_ACCOUNT/public_html"
				ServerName $DOMAIN
				ServerAlias www.$DOMAIN
				ErrorLog "logs/$DOMAIN/error.log"
				CustomLog "logs/$DOMAIN/access.log" combinedio
				SSLEngine on
				SSLCertificateFile "/usr/local/apache/conf/ssl/server.crt"
				SSLCertificateKeyFile "/usr/local/apache/conf/ssl/server.key"
				#SSLCACertificateFile "/usr/local/apache/conf/ssl/ca.crt"
				<Directory "/home/$VHOST_ACCOUNT/public_html">
					Options +Includes +Indexes
					php_admin_flag engine ON
					php_admin_value open_basedir "/home/$VHOST_ACCOUNT/public_html:/tmp:/proc"
				</Directory>
			</VirtualHost>
			EOF
		fi
	fi

	if [ "$ADD_SUBDOMAIN" = 'y' ]; then
		if [ ! -s "/usr/local/apache/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf" ];then
			cat >>/usr/local/apache/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf<<-EOF
			<VirtualHost *:80>
				ServerAdmin webmaster@$DOMAIN
				DocumentRoot "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN"
				ServerName $SUBDOMAIN.$DOMAIN
				ErrorLog "logs/$DOMAIN/error.log"
				CustomLog "logs/$DOMAIN/access.log" combinedio
				<Directory "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN">
					Options +Includes +Indexes
					php_admin_flag engine ON
					php_admin_value open_basedir "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN:/tmp:/proc"
				</Directory>
			</VirtualHost>

			EOF
			if [ "$SOFTWARE" = "2" ]; then
				cat >>/usr/local/apache/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf<<-EOF
				<VirtualHost *:443>
					ServerAdmin webmaster@$DOMAIN
					DocumentRoot "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN"
					ServerName $SUBDOMAIN.$DOMAIN
					ErrorLog "logs/$DOMAIN/error.log"
					CustomLog "logs/$DOMAIN/access.log" combinedio
					SSLEngine on
					SSLCertificateFile "/usr/local/apache/conf/ssl/server.crt"
					SSLCertificateKeyFile "/usr/local/apache/conf/ssl/server.key"
					#SSLCACertificateFile "/usr/local/apache/conf/ssl/ca.crt"
					<Directory "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN">
						Options +Includes +Indexes
						php_admin_flag engine ON
						php_admin_value open_basedir "/home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN:/tmp:/proc"
					</Directory>
				</VirtualHost>
				EOF
			fi

		fi
	fi

	if [ ! -d "/usr/local/apache/logs/$DOMAIN" ]; then
		mkdir /usr/local/apache/logs/$DOMAIN
	fi

fi

###################################  Nginx + Apache ###################################

if [ "$SOFTWARE" = "3" ]; then
	if [ "$ADD_SUBDOMAIN" = 'n' ]; then
		sed -i 's/\*:80/127.0.0.1:8080/g' /usr/local/apache/conf/vhosts/$DOMAIN.conf
	else
		sed -i 's/\*:80/127.0.0.1:8080/g' /usr/local/apache/conf/vhosts/${SUBDOMAIN}.${DOMAIN}.conf
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
echo "===================== Install completed ====================="
echo ""
echo "Your account: $VHOST_ACCOUNT"
echo "Your domain: $DOMAIN"
echo "Your domain directory: /home/$VHOST_ACCOUNT/"
if [ "$ADD_SUBDOMAIN" = 'y' ]; then
echo "Your subdomain: $SUBDOMAIN"
echo "Your subdomain directory: /home/$VHOST_ACCOUNT/public_html/$SUBDOMAIN"
fi
echo ""
if [ "$SOFTWARE" != "2" ]; then
echo "nginx vhost config file at: /usr/local/nginx/conf/vhosts/$DOMAIN.conf"
elif [ "$SOFTWARE" != "1" ]; then
echo "httpd config file at: /usr/local/apache/conf/vhosts/$DOMAIN.conf"
fi
echo ""
echo "============================================================="
echo ""
