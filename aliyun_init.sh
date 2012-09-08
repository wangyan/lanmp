#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

#echo "---------- Check the distribution ----------"

if cat /proc/version | grep -qi redhat;then
	DISTRIBUTION="redhat"
elif cat /proc/version | grep -qi centos;then
	DISTRIBUTION="centos"
elif cat /proc/version | grep -qi debian;then
	DISTRIBUTION="debian"
elif cat /proc/version | grep -qi ubuntu;then
	DISTRIBUTION="ubuntu"
else
	exit 0
fi

echo "---------- Set the software repos ----------"

if [ "$DISTRIBUTION" = "redhat" ];then
	mv /etc/yum.repos.d/rhel-debuginfo.repo /etc/yum.repos.d/rhel-debuginfo.repo.bak
	wget -c http://wangyan.org/download/conf/rhel-debuginfo.repo -P /etc/yum.repos.d/
	yum makecache
	/etc/init.d/iptables stop
	chkconfig iptables off
elif [ "$DISTRIBUTION" = "centos" ];then
	sed -i 's/^exclude/#exclude/' /etc/yum.conf
	yum makecache
	/etc/init.d/iptables stop
	chkconfig iptables off
elif [ "$DISTRIBUTION" = "debian" ];then
	mv /etc/apt/sources.list /etc/apt/sources.list.bak
	wget -c http://wangyan.org/download/conf/sources.list.squeeze
	mv sources.list.squeeze /etc/apt/sources.list
	apt-get -y update
elif [ "$DISTRIBUTION" = "ubuntu" ];then
	mv /etc/apt/sources.list /etc/apt/sources.list.bak
	wget -c http://wangyan.org/download/conf/sources.list.maverick
	mv sources.list.maverick /etc/apt/sources.list
	apt-get -y update
fi

echo "---------- Set the sysctl ----------"

if [ "$DISTRIBUTION" = "redhat" ] || [ "$DISTRIBUTION" = "centos" ];then

cat >> /etc/sysctl.conf <<EOF
fs.file-max=65535
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 5
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024  65535
kernel.shmall = 2097152
kernel.shmmax = 2147483648
kernel.shmmni = 4096
kernel.sem = 5010 641280 5010 128
net.core.wmem_default=262144
net.core.wmem_max=262144
net.core.rmem_default=4194304
net.core.rmem_max=4194304
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_window_scaling = 0
net.ipv4.tcp_sack = 0
EOF

sysctl -p

fi

echo "---------- Set the ulimit ----------"

cat >> /etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
EOF

echo "---------- fdisk disk ----------"

if [ -e /dev/xvdb ];then

fdisk /dev/xvdb << EOF
n
p
1


wq
EOF


mkfs.ext3 /dev/xvdb1

echo '/dev/xvdb1             /home                 ext3    defaults        1 2' >> /etc/fstab
mount -a

fi
