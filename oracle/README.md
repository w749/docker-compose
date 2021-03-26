### 容器构建完成后,进入容器进行用户密码初始化
docker exec -it oracle11g bash

### 然后执行如下命令切换到 oracle 用户：
su - oracle

### 接着依次执行如下命令登录 sqlplus：
sqlplus /nolog
conn /as sysdba

### 执行如下命令将 system 和 sys 两个账户的密码设为 abc：
alter user system identified by abc;
alter user sys identified by abc;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

### 最后就可以通过1521端口进行连接了
注:使用的[helowin](https://cr.console.aliyun.com/images/cn-hangzhou/helowin/oracle_11g/detail)是在阿里云分享的镜像,最好不要在windows下的docker desktop搭建,一直报命令找不到
