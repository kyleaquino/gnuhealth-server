FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3.11 python3.11-dev python3-pip python3.11-venv
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

EXPOSE 80
