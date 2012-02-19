#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

clear
echo "#############################################################"
echo "# Add Chroot Vhost User for LANMP"
echo "# Env: Debian/Ubuntu/Redhat/CentOS"
echo "# Author: https://wangyan.org/"
echo "# Last modified: 2012.02.20"
echo "#############################################################"
echo ""

echo "Please enter account name:"
read -p "(Default vhost account: example):" VHOST_ACCOUNT
if [ -z $VHOST_ACCOUNT ]; then
	VHOST_ACCOUNT="example"
fi
echo "---------------------------"
echo "Vhost account = $VHOST_ACCOUNT"
echo "---------------------------"
echo ""

echo "Please enter account password:"
read -p "(Default ACCOUNT password: 123456):" ACCOUNT_PASSWD
if [ -z $ACCOUNT_PASSWD ]; then
	ACCOUNT_PASSWD="123456"
fi
echo "---------------------------"
echo "Account password = $ACCOUNT_PASSWD"
echo "---------------------------"
echo ""

echo "Please enter website domain:"
read -p "(e.g: example.com):" DOMAIN
if [ -z $DOMAIN ]; then
	DOMAIN="example.com"
fi
echo "---------------------------"
echo "Website domain = $DOMAIN"
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
echo "Press any key to start..."
echo "Or Ctrl+C cancel and exit ?"
echo ""
char=`get_char`

#############################################################"

useradd $VHOST_ACCOUNT

expect -c "
spawn passwd $VHOST_ACCOUNT
expect {
	\"password\" {send \"$ACCOUNT_PASSWD\r\";exp_continue}
	\"password\" {send \"$ACCOUNT_PASSWD\r\"}
}"

/usr/local/jailki/sbin/jk_jailuser -m -j /chroot -s /bin/bash $VHOST_ACCOUNT

sed -i 's#/usr/sbin/jk_chrootsh#/usr/local/jailki/sbin/jk_chrootsh#g' /etc/passwd

\cp /root/.bashrc /chroot/home/$VHOST_ACCOUNT
chown $VHOST_ACCOUNT:$VHOST_ACCOUNT /chroot/home/$VHOST_ACCOUNT -R

sed -i 's#/home/'$VHOST_ACCOUNT'#/chroot/home/'$VHOST_ACCOUNT'#g' /usr/local/nginx/conf/vhosts/${DOMAIN}.conf
sed -i 's#/home/'$VHOST_ACCOUNT'#/chroot/home/'$VHOST_ACCOUNT'#g' /usr/local/apache/conf/vhosts/${DOMAIN}.conf

nginx -t && /etc/init.d/nginx reload
apachectl -t && /etc/init.d/httpd graceful

UNUM=`awk -F: 'END{print $3}' /etc/passwd`
GNUM=`awk -F: 'END{print $4}' /etc/passwd`

cat >/tmp/chroot_ftpuser<<-EOF
use pureftpd;
UPDATE pureftpd.users SET Dir = '/chroot/home/$VHOST_ACCOUNT' WHERE users.User = '$VHOST_ACCOUNT';
UPDATE pureftpd.users SET Uid = '$UNUM' WHERE users.User = '$VHOST_ACCOUNT';
UPDATE pureftpd.users SET Gid = '$GNUM' WHERE users.User = '$VHOST_ACCOUNT';
EOF

cat /tmp/chroot_ftpuser | mysql -u root -p87ROOT@MYSQL
