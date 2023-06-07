#!/bin/bash -e
#设置主机名和host
hostnamectl set-hostname template
echo "127.0.0.1 $(hostname)" >> /etc/hosts
#关闭防火墙
sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config 
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
#设置网卡配置
cat > /etc/sysconfig/network-scripts/ifcfg-ens192 << EOF 
TYPE=Ethernet
BOOTPROTO=static
NAME=ens192
DEVICE=ens192
ONBOOT=yes
IPADDR=192.168.1.65
GATEWAY=192.168.1.1
DNS1=114.114.114.114
DNS2=8.8.8.8
EOF
#设置ssh配置
echo 'UseDNS no'>>/etc/ssh/sshd_config
echo 'PermitRootLogin yes'>>/etc/ssh/sshd_config
systemctl status sshd
/etc/init.d/network restart
#设置阿里源（不同系统的repo文件名不一样注意修改)
cp -R /etc/yum.repos.d  /etc/yum.repos.d.bak
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache 
#下载ntp设置对时
yum install ntp -y
ntpdate ntp.aliyun.com
hwclock -w
yum install epel-release
yum install -y bash-completion net-tools
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
