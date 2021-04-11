FROM centos

# install java
ADD https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz /usr/local
RUN tar -zxvf /usr/local/jdk-8u181-linux-x64.tar.gz -C /usr/local/
RUN rm -rf /usr/local/jdk-8u181-linux-x64.tar.gz
ENV JAVA_HOME /usr/local/jdk1.8.0_181
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/lib

# install Flume
ADD https://mirrors.tuna.tsinghua.edu.cn/apache/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz /usr/local
RUN tar -zxvf /usr/local/apache-flume-1.9.0-bin.tar.gz -C /usr/local/
RUN rm -rf /usr/local/apache-flume-1.9.0-bin.tar.gz
RUN mv /usr/local/apache-flume-1.9.0-bin /usr/local/flume
WORKDIR /usr/local/flume
ADD flume-env.sh /usr/local/flume/conf

# add lib 必须引入 Zookeeper 依赖包，否则启动 Flume 时会抛出异常
# ADD zookeeper-3.4.8.jar /usr/local/flume/lib

EXPOSE 1999

# ENTRYPOINT (/usr/local/flume/bin/flume-ng agent -n docker -c /usr/local/flume/conf -z zkhost:2181 -p /flume -Dflume.root.logger=DEBUG,console)
