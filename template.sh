#!/bin/bash -e
hostnamectl set-hostname $1
echo "127.0.0.1 $(hostname)" >> /etc/hosts
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config 
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
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
