FROM ubuntu:22.04

# Ubuntu General Packages
RUN apt-get update
RUN apt-get install -y software-properties-common libpq-dev curl wget gcc g++ make git

# Install node.js and npm
RUN apt-get install -y nodejs npm

# Install Python Packages
RUN apt-get install -y python3-dev python3-pip python3-cffi

WORKDIR /home/gnuhealth

# Setup GNUHealth Server
RUN wget https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz
RUN tar -xf gnuhealth-latest.tar.gz && cd gnuhealth-4.2.1 && ./gnuhealth-setup install

# Install Tryton SAO
RUN wget https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz
RUN tar -xf tryton-sao-5.0.0.tgz && cd package && npm install --production --legacy-peer-deps

EXPOSE 8000
ENTRYPOINT ["start.sh"]
