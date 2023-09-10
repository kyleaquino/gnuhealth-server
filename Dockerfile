FROM ubuntu:22.04

WORKDIR /home/gnuhealth
COPY start.sh /home/gnuhealth/start.sh

# Ubuntu General Packages
RUN apt-get update
RUN apt-get install -y software-properties-common libpq-dev curl wget gcc g++ make

# Install node.js and npm
RUN apt-get install -y nodejs npm

# Install Gnuhealth Server
RUN apt-get install -y python3-dev python3-pip python3-cffi
RUN pip install gnuhealth-all-modules --use-pep517

# Install Tryton SAO
RUN wget https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz
RUN tar -xf tryton-sao-5.0.0.tgz && cd package
RUN npm install --production --legacy-peer-deps

EXPOSE 8000
ENTRYPOINT ["start.sh"]
