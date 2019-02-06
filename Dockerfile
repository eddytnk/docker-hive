FROM ubuntu:trusty
RUN apt-get update \
  && apt-get install -y wget \
   && rm -rf /var/lib/apt/lists/*

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true |  /usr/bin/debconf-set-selections

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java

RUN apt-get update
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default

ENV SHARED_FOLDER /tmp/spec-tmp-files/
ENV TMP_ROOT /tmp/root/
ENV WAREHOUSE /tmp/warehouse/

ENV HADOOP_BIN $HOME/hadoop-bin/hadoop-1.2.1/
ENV HIVE_BIN $HOME/hive-bin/hive-0.11/

ENV HADOOP_HOME $HOME/hadoop/
ENV HIVE_HOME $HOME/hive/

ENV JAVA_HOME /usr/

RUN mkdir -p $HADOOP_BIN \
    && mkdir -p $HIVE_BIN \
    && mkdir -p $HADOOP_HOME \
    && mkdir -p $HIVE_HOME \
    && mkdir -p $SHARED_FOLDER \
    && mkdir -p $TMP_ROOT \
    && mkdir -p $WAREHOUSE

RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz -O $HADOOP_BIN/hadoop.tar.gz
RUN wget https://archive.apache.org/dist/hive/hive-1.0.1/apache-hive-1.0.1-bin.tar.gz -O $HIVE_BIN/hive.tar.gz

RUN tar -xzf $HADOOP_BIN/hadoop.tar.gz --strip-components=1 -C $HADOOP_HOME
RUN tar -xzf $HIVE_BIN/hive.tar.gz --strip-components=1 -C $HIVE_HOME

COPY ./sample-data.sql /tmp/sample-data.sql
COPY ./setup-data.sh /tmp/setup-data.sh
RUN chmod +x /tmp/setup-data.sh
RUN chmod +x /tmp/setup-data.sh