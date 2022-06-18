# 开启三台机器的node_exporter服务，prometheus会收集服务器数据
docker-compose exec ck1 nohup /var/lib/clickhouse/node_exporter/node_exporter > /dev/null 2>&1 &
docker-compose exec ck2 nohup /var/lib/clickhouse/node_exporter/node_exporter > /dev/null 2>&1 &
docker-compose exec ck3 nohup /var/lib/clickhouse/node_exporter/node_exporter > /dev/null 2>&1 &
