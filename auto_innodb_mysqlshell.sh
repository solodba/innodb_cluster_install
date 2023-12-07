#!/bin/bash
soft_dir=/usr/local/src
install_dir=/usr/local

file_tar=$(ls $soft_dir|grep ^mysql-shell)
echo "正在解压mysql-shell"
tar -zxvf  $soft_dir/$file_tar  -C $install_dir/.   >/dev/null
file=${file_tar%%.tar.gz}
mv $install_dir/$file $install_dir/mysql-shell

echo PATH=\$PATH:$install_dir/mysql-shell/bin >>/etc/profile
