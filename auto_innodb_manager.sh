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
echo "mysql"|passwd --stdin mysql

#解压文件
file_tar=$(ls $soft_dir|grep ^mysql-shell)
echo "正在解压mysql-shell"
tar -zxvf  $soft_dir/$file_tar -C $install_dir/.   >/dev/null
file=${file_tar%%.tar.gz}
mv $install_dir/$file $install_dir/mysql-shell
#解压文件
file_tar=$(ls $soft_dir|grep ^mysql-router)
echo "正在解压mysql-routre"
tar -xvf  $soft_dir/$file_tar  -C $install_dir/.   >/dev/null
file=${file_tar%%.tar.xz}
mv $install_dir/$file $install_dir/mysql-router

#添加环境变量
cat <<EOF >>/etc/profile
export PATH=$install_dir/mysql-shell/bin:$install_dir/mysql-router/bin:\$PATH

EOF
source /etc/profile
echo "环境变量创建完毕"
