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
# Intro: https://wangyan.org/blog/lanmp.html
#
#====================================================================

if [ $(id -u) != "0" ]; then
    clear && echo "Error: You must be root to run this script!"
    exit 1
fi

LANMP_PATH=`pwd`
if [ `echo $LANMP_PATH | awk -F/ '{print $NF}'` != "lanmp" ]; then
	clear && echo "Please enter lanmp script path:"
	read -p "(Default path: ${LANMP_PATH}/lanmp):" LANMP_PATH
	[ -z "$LANMP_PATH" ] && LANMP_PATH=$(pwd)/lanmp
	cd $LANMP_PATH/
fi

DISTRIBUTION=`awk 'NR==1{print $1}' /etc/issue`

if echo $DISTRIBUTION | grep -Eqi '(Red Hat|CentOS|Fedora|Amazon)';then
    PACKAGE="rpm"
elif echo $DISTRIBUTION | grep -Eqi '(Debian|Ubuntu)';then
    PACKAGE="deb"
else
    if cat /proc/version | grep -Eqi '(redhat|centos)';then
        PACKAGE="rpm"
    elif cat /proc/version | grep -Eqi '(debian|ubuntu)';then
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
fi

[ -r "$LANMP_PATH/fifo" ] && rm -rf $LANMP_PATH/fifo
mkfifo $LANMP_PATH/fifo
cat $LANMP_PATH/fifo | tee $LANMP_PATH/log.txt &
exec 1>$LANMP_PATH/fifo
exec 2>&1

/bin/bash ${LANMP_PATH}/${PACKAGE}.sh

sed -i '/password/d' $LANMP_PATH/log.txt
rm -rf $LANMP_PATH/fifo
