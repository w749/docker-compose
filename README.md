## 常用大数据组件Docker Compose配置文件

### Oracle
用的是registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g镜像，配置过程可以查看[安装过程](https://ubin.top/2019/10/28/docker%E6%90%AD%E5%BB%BAoracle-helowin-oracle-11g/)

用户名root，密码helowin

### MySQL
用户名root密码123456，3306端口映射到本机6606端口

### ClickHouse
`config.xml`只配置了开放客户端端口连接和prometheus所需表权限端口开放

`users.xml`配置了两个用户select和root，密码都是123456，默认default用户无密码

`metrika.xml`配置了分片和副本情况，仅做测试使用

启动后运行`node_exporter.sh`，配合prometheus采集三个节点服务器运行情况

### Prometheus
主要配合clickhouse使用，监控了clickhouse以及其所在服务器运行情况还有docker的资源情况
