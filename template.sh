#!/bin/bash -e
hostnamectl set-hostname template
echo "127.0.0.1 $(hostname)" >> /etc/hosts
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config 
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
cat > /etc/sysconfig/network-scripts/ifcfg-ens192 << EOF 
TYPE=Ethernet
BOOTPROTO=static
NAME=enp0s3
DEVICE=enp0s3
ONBOOT=yes
IPADDR=192.168.1.65
GATEWAY=192.168.1.1
DNS1=114.114.114.114
DNS2=8.8.8.8
EOF
echo 'UseDNS no'>>/etc/ssh/sshd_config
echo 'PermitRootLogin yes'>>/etc/ssh/sshd_config
systemctl status sshd
/etc/init.d/network restart
#设置阿里源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo 
yum clean all
yum makecache 
yum install ntp -y
ntpdate ntp.aliyun.com
hwclock -w
yum install -y bash-completion net-tools
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
