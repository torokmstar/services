FROM alpine:3.5

MAINTAINER gustavonalle

RUN echo "LANG=en_GB.UTF-8" > /etc/locale.conf

ENV SPARK_VERSION 2.2.0
ENV SPARK_HADOOP_VERSION 2.7

# general
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --update \
    curl openjdk8 openssh ruby bash cracklib-words supervisor procps \
    && rm /var/cache/apk/*

# spark
RUN curl "http://mirror.vorboss.net/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz" | tar -C /usr/local/ -xz | ln -s /usr/local/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/ /usr/local/spark
ADD start-spark.sh /usr/local/spark/

ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV PATH ${JAVA_HOME}/bin:${PATH}

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN sed -i 's/nohup --/nohup/g' /usr/local/spark/sbin/spark-daemon.sh

# pyspark
RUN apk update \
    && apk upgrade \
    && apk add py-pip

ENV PYSPARK_VERSION 2.2.0
RUN curl -O "https://pypi.python.org/packages/f6/fe/4a1420f1c8c4df40cc8ac1dab6c833a3fe1986abf859135712d762100fde/pyspark-$PYSPARK_VERSION.post0.tar.gz"
RUN tar xzvf "pyspark-$PYSPARK_VERSION.post0.tar.gz"
RUN cd "pyspark-$PYSPARK_VERSION" && pip install . 

# ssh
RUN apk add openssh \
    && apk add --no-cache openrc 
RUN rc-update add sshd
RUN mkdir -p /run/openrc/ && touch /run/openrc/softlevel

RUN mkdir /var/run/sshd
RUN echo 'root:secret' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# run `/etc/init.d/sshd start` manually

# share lib
COPY scripts /root/scripts 

EXPOSE 22 5555 8080 7077 9080 9081 57600 7600 8181 9990 4040 55200 45700
ENV LANG en_US.UTF-8
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
