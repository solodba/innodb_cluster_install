#!/bin/bash
#定义目录
soft_dir=/usr/local/src

ip_local=$(cat /etc/sysconfig/network-scripts/ifcfg-ens33 |grep IPADDR |cut -d= -f2)    #获取本地机器的ip地址
file_tar=$(ls $soft_dir|grep ^mysql)

#将 脚本和 软件复制到 其它机器
for ip in  $(cat $soft_dir/ip_list.txt|grep -v manager|cut -d' ' -f1)
    do
      if [ $ip = $ip_local ]; then
         echo  "$ip为本地ip跳过复制文件"
      else
         scp -r  $soft_dir/*.sh  root@$ip:$soft_dir/
         scp -r  $soft_dir/ip_list.txt root@$ip:$soft_dir/
         echo "已将脚本传送到$ip"
	 
         scp  -r $soft_dir/$file_tar root@$ip:$soft_dir/
         echo "已将mysql解压包传送到$ip"
      fi
   done
