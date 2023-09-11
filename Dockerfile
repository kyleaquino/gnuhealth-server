FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
USER gnuhealth
WORKDIR /home/gnuhealth

# Ubuntu General Packages
RUN apt-get update
RUN apt-get install -y software-properties-common libpq-dev curl wget gcc g++ make git nano vim

# Install Framework Dependencies
RUN apt-get install -y nodejs npm python3-dev python3-pip python3-cffi

# Install Tryton SAO
RUN wget https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz
RUN tar -xf tryton-sao-5.0.0.tgz && cd package && npm install --production --legacy-peer-deps
RUN rm -rf tryton-sao-5.0.0.tgz

# Setup GNUHealth Server
RUN wget https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz 
RUN tar -xf gnuhealth-latest.tar.gz && cd gnuhealth-4.2.1 && ./gnuhealth-setup install
RUN rm -rf gnuhealth-latest.tar.gz

EXPOSE 8000

ENTRYPOINT ["/gnuhealth-4.2.1/start_gnuhealth.sh"]
CMD ["sh"]
