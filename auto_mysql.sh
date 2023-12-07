#!/bin/bash
#定义目录
soft_dir=/usr/local/src
mysql_install_dir=/usr/local
mysql_data_dir=/data
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
#创建用户
echo "创建mysql用户"
userdel mysql
rm -rf /home/mysql
groupadd mysql
useradd -g mysql mysql
echo "mysql"|passwd --stdin mysql

#解压文件
file_tar=$(ls $soft_dir|grep ^mysql-8)
echo "正在解压并重命名"
tar -xvf  $soft_dir/$file_tar  -C $mysql_install_dir/.   >/dev/null
file=${file_tar%%.tar.xz}
mv $mysql_install_dir/$file $mysql_install_dir/mysql

#创建数据目录
mkdir -p $mysql_data_dir/{mysqldata,mysqllog}
chown mysql:mysql -R $mysql_data_dir
echo "数据目录创建完毕"
#创建/etc/my.cnf配置文件
mv /etc/my.cnf /etc/my.cnf_bak
touch /etc/my.cnf
cat <<EOF >>/etc/my.cnf
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld]
basedir=/usr/local/mysql
datadir=/data/mysqldata
socket=/tmp/mysql.sock
log-error=/data/mysqllog/mysqld.log
character-set-server=utf8mb4
server_id=1   # m2的server_id=1,m3的server_id=2,m4的server_id=3,绝对不能重复
gtid_mode=ON
enforce_gtid_consistency=ON
binlog_checksum=NONE

log_bin=binlog
log_slave_updates=ON
binlog_format=ROW
master_info_repository=TABLE
relay_log_info_repository=TABLE
transaction_write_set_extraction=XXHASH64
binlog_transaction_dependency_tracking=WRITESET
EOF

echo "my.cnf配置文件创建完毕"
#添加环境变量
cat <<EOF >>/etc/profile
export MYSQL_HOME=$mysql_install_dir/mysql
export PATH=\$MYSQL_HOME/bin:\$PATH

EOF
source /etc/profile
echo "环境变量创建完毕"

#初始化
echo "初始化数据库！" 
$mysql_install_dir/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=$mysql_install_dir/mysql --datadir=$mysql_data_dir/mysqldata

#复制mysql启动文件到/etc/init.d/
cp $mysql_install_dir/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add /etc/init.d/mysqld
echo "启动mysql"
systemctl start mysqld

#登录MYSQL
#   $install_dir/mysql/bin/mysql -e "alter user user() identified by '000000'"
#停止msyql服务
echo "停止mysql"
systemctl stop mysqld
