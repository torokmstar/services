
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y libnet-ifconfig-wrapper-perl
RUN apt install -y vim && apt install -y python && apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip && pip install pymongo

RUN mkdir /var/run/sshd
RUN echo 'root:secret' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY scripts /root/scripts

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
