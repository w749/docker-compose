#!/bin/bash

mkdir -p /usr/local/hadoop/data/dfs/name
mkdir -p /usr/local/hadoop/data/dfs/name2
mkdir -p /usr/local/hadoop/data/dfs/data
mkdir -p /usr/local/hadoop/data/dfs/data2
mkdir -p /usr/local/hadoop/data/jobhistory/donedatas
mkdir -p /usr/local/hadoop/data/jobhistory/intermediate
mkdir -p /usr/local/hadoop/data/nn/edits
mkdir -p /usr/local/hadoop/data/nodemanager/data
mkdir -p /usr/local/hadoop/data/nodemanager/logs
mkdir -p /usr/local/hadoop/data/remote/logs
mkdir -p /usr/local/hadoop/data/snn/name
mkdir -p /usr/local/hadoop/data/snn/edits
rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

if [[ $2 == "-format" ]]; then
  hdfs namenode -format
fi

/usr/sbin/sshd -D &
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver

if [[ $1 == "-d" ]]; then
  touch /var/log/123 && tail -f /var/log/123
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi