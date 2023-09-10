FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y software-properties-common wget
RUN wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tar.xz
RUN tar -xf Python-3.11.0.tar.xz && cd Python-3.11.0
RUN ./configure --enable-optimizations && make altinstall

EXPOSE 80
