#! /bin/bash

# install mysql5.7 in docker centos




#!/bin/bash

# 导入AzkabanSQL
function importAzkabanSQL()
{
    sql=$1
    sqlInfoIsExists=`find /opt/frames -name $sql`
    if [[ ${#sqlInfoIsExists} -ne 0 ]];then
        #删除旧的
        azkaban_sql_home_old=`find /tmp -maxdepth 1 -name "*azkaban-sql*"`
        for i in $azkaban_sql_home_old;do
                rm -rf $i
        done
        # 创建安装目录
        mkdir /tmp/azkaban-sql
        # 解压Azkaban-SQL
        tar -zxvf $sqlInfoIsExists -C /tmp/azkaban-sql >& /dev/null
        echo "azkaban-sql压缩包解压完毕"
        sqlPath=`find /tmp/azkaban-sql/ -maxdepth 2 -name "*create-all-sql*"`
        # 导入SQL
        mysql -uroot mysql --default-character-set=utf8 -e "drop database azkaban;"
        mysql -uroot mysql --default-character-set=utf8 -e "create database azkaban;"
        mysql -uroot mysql --default-character-set=utf8 -e "use azkaban;source $sqlPath;"
    fi
    echo "Azkaban SQL导入成功"
}

function installMysql()
{
    #1.在frames.txt中查看是否需要安装mysql
    mysqlInfo=`egrep "^mysql-rpm" /home/hadoop/automaticDeploy/frames.txt`

    mysql=`echo $mysqlInfo | cut -d " " -f1`
    isInstall=`echo $mysqlInfo | cut -d " " -f2`
    installNode=`echo $mysqlInfo | cut -d " " -f3` 
    currentNode=`hostname`

    #是否安装
    if [[ $isInstall = "true" && $currentNode = $installNode ]];then

    #2.查看/opt/frames目录下是否有hadoop安装包
    mysqlIsExists=`find /opt/frames -name $mysql`
    echo $mysqlIsExists
    if [[ ${#mysqlIsExists} -ne 0  ]];then

        # 安装依赖
        yum install -y wget
        wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
        yum -y install mysql57-community-release-el7-10.noarch.rpm
        rm -rf mysql57-community-release-el7-10.noarch.rpm
        yum install -y mysql-server

        # 字符集配置
        echo "character-set-server=utf8" >> /etc/my.cnf

        # 启动Mysql
        systemctl start mysqld
        systemctl enable mysqld

        # 防火墙配置
        systemctl start firewalld.service
        firewall-cmd --zone=public --add-port=3306/tcp --permanent
        # 配置立即生效
        firewall-cmd --reload

        # 执行Mysql修改密码
        # select user,host,password, from mysql.user
        mysqlRootPasswd=`egrep "^mysql-root-password" /home/hadoop/automaticDeploy/configs.txt | cut -d " " -f2 | sed s/\r//`
        mysql -uroot mysql --default-character-set=utf8 -e "set password for 'root'@'localhost' = '$mysqlRootPasswd;"
        export MYSQL_PWD=$mysqlRootPasswd

        # 删除匿名用户
        mysql -uroot mysql --default-character-set=utf8 -e "delete from mysql.user where user='';"
        mysql -uroot mysql --default-character-set=utf8 -e "flush privileges;"

        # 添加新用户
        mysqlHivePasswd=`egrep "^mysql-hive-password" /home/hadoop/automaticDeploy/configs.txt | cut -d " " -f2 | sed s/\r//`
        mysql -uroot mysql --default-character-set=utf8 -e "create user 'hive'@'%' identified by '$mysqlHivePasswd';"
        mysql -uroot mysql --default-character-set=utf8 -e "flush privileges;"

        # 创建新数据库并赋权
        mysql -uroot mysql --default-character-set=utf8 -e "create database hive default character set utf8 collate utf8_general_ci;"
        mysql -uroot mysql --default-character-set=utf8 -e "grant all privileges on hive.* to 'hive'@'%';"
        mysql -uroot mysql --default-character-set=utf8 -e "flush privileges;"
        
        # 导入Azkaban SQL导入
        sqlInfo=`egrep "azkaban-sql" /home/hadoop/automaticDeploy/frames.txt`
        sql=`echo $sqlInfo | cut -d " " -f1`
        isSqlInstall=`echo $sqlInfo | cut -d " " -f2`
        # 判断是否需要导入Azkaban SQL
        if [[ $isSqlInstall = "true" ]];then
            importAzkabanSQL $sql
        fi
        echo "--------------------"
        echo "|  Mysql安装成功！  |"
        echo "--------------------"
       
    fi
    fi
    
}

installMysql