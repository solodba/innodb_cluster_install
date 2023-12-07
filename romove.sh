#!/bin/bash

systemctl stop mysqld

rm -rf /usr/local/mysql

rm -rf /etc/init.d/mysqld


userdel mysql

rm -rf /run/lock/subsys/mysql
rm -rf /var/spool/mail/mysql
rm -rf /etc/selinux/targeted/active/modules/100/mysql
rm -rf /usr/lib64/mysql
rm -rf /usr/share/mysql


