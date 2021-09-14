FROM ubuntu:20.04

ENV SQITCH_VERSION=v1.1.0

# Enable no password sudo
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get update

# Install tools
RUN apt-get install wget -y
RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_amd64.tar.gz -O - |  tar xz && mv yq_linux_amd64 /usr/bin/yq

# Install sqitch
RUN apt-get install -y libdbd-mysql-perl mysql-client build-essential perl perl-doc \
    && apt-get install -y cpanminus \
    && cpanm --notest DWHEELER/App-Sqitch-$SQITCH_VERSION.tar.gz
