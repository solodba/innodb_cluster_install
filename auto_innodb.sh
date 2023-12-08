#!/bin/bash
#定义目录
soft_dir=/usr/local/src
install_dir=/usr/local
#配置机器互信  将ip地址拼接
ip_list=''
 for ip in   $(cat $soft_dir/ip_list.txt|cut -d' ' -f1)
    do
     ip_list=$ip_list' '$ip
    done
  $soft_dir/sshUserSetup.sh -user root -hosts "$ip_list" -advanced -noPromptPassphrase

#将本地的 mysql脚本和mysql解压包 传送到其它机器
$soft_dir/auto_scp.sh
#管理节点
ip_manager=$(cat $soft_dir/ip_list.txt|grep  manager|cut -d' ' -f1)
ssh root@$ip_manager "$soft_dir/auto_innodb_manager.sh"

#循环在每台机器上 解压安装mysql
for ip in  $(cat $soft_dir/ip_list.txt|grep -v manager|cut -d' ' -f1)
    do
         ssh root@$ip  "$soft_dir/auto_innodb_cluster.sh $ip"
         echo $ip的mysql服务已经初始化完毕
   done
