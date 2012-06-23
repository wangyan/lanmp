#! /bin/bash
#====================================================================
# install.sh
#
# Linux + Apache + Nginx + MySQL + PHP Auto Install Script
#
# Copyright (c) 2012, WangYan <WangYan@188.com>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
# Ver: 0.1 build 20120623"
# Intro: https://wangyan.org/blog/lanmp.html
#
#====================================================================

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!"
    exit 1
fi

DISTRIBUTION=`awk 'NR==1{print $1}' /etc/issue`

if echo $DISTRIBUTION | grep -Eqi '(Red Hat|CentOS|Fedora|Amazon)';then
    PACKAGE="rpm"
elif echo $DISTRIBUTION | grep -Eqi '(Debian|Ubuntu)';then
    PACKAGE="deb"
else
    echo "Please select the package management! (rpm/deb)"
    read -p "(Default: rpm):" PACKAGE
    if [ -z "$PACKAGE" ]; then
       PACKAGE="rpm"
    fi
    if [[ "$PACKAGE" != "rpm" && "$PACKAGE" != "deb" ]];then
        echo -e "\nNot supported linux distribution!"
        echo "Please contact me! WangYan <WangYan@188.com>"
        exit 0
    fi
fi

mkfifo fifo
cat fifo | tee log.txt &
exec 1>fifo
exec 2>&1

/bin/bash ${PACKAGE}.sh

sed -i '/password/d' log.txt
rm -rf fifo
