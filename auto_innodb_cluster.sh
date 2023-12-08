#!/bin/bash
#定义目录
soft_dir=/usr/local/src
install_dir=/usr/local
#配置防火墙 永久开放3306端口
firewall-cmd --zone=public --add-port=3306/tcp --permanent
setenforce 0
echo 'selinux设置完毕'
#删除残余文件
rm -rf /run/lock/subsys/mysql
rm -rf /var/spool/mail/mysql
rm -rf /etc/selinux/targeted/active/modules/100/mysql
rm -rf /usr/lib64/mysql
rm -rf /usr/share/mysql
echo "mysql残余文件删除完毕"

#循环在每台机器上 解压安装mysql
#for ip in  $(cat $soft_dir/ip_list.txt|grep -v manager|cut -d' ' -f1)
#    do 
         echo 在$1上初始化mysql
         ssh root@$1  "$soft_dir/auto_mysql.sh"
         echo $1的mysql服务已经初始化完毕
         echo 在$1上解压mysql-shell
         ssh root@$1  "$soft_dir/auto_innodb_mysqlshell.sh"
#   done
