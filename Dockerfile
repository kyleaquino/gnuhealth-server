FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV GNUHEALTH_PACKAGE https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz
ENV GNUHEALTH_SAO_PACKAGE https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz

RUN useradd --uid 1000 --create-home --home-dir /home/gnuhealth gnuhealth
RUN --mount=type=secret,uid=100,id=_env,dst=/etc/secrets/.env $(cat /etc/secrets/.env | xargs)

ENV GNUHEALTH_POSTGRES_URL $GNUHEALTH_POSTGRES_URL

WORKDIR /home/gnuhealth

# Ubuntu General Dependencies
RUN apt-get update
RUN apt-get -y install --no-install-recommends software-properties-common libpq-dev curl wget gcc g++ make git nano vim patch

# Install Framework Dependencies
RUN apt-get install -y nodejs npm python3 python3-dev python3-pip

# Setup GNUHealth Server
RUN wget -q  --output-document=/tmp/gnuhealth.tgz "${GNUHEALTH_PACKAGE}" 
RUN wget -q  --output-document=/tmp/tryton-sao.tgz "${GNUHEALTH_SAO_PACKAGE}" 

# Create Temporary Folder for GNUHealth Installation
RUN mkdir /tmp/gnuhealth 
RUN cd /tmp/gnuhealth && tar xzf /tmp/gnuhealth.tgz --strip-components=1 
RUN cd /tmp/gnuhealth && tar xzf /tmp/tryton-sao.tgz
RUN cp -r /tmp/gnuhealth/package /home/gnuhealth/sao

# Ensure Permissions are given to GNUHealth User
RUN chown gnuhealth: /tmp/gnuhealth/ -R
RUN chown gnuhealth: /home/gnuhealth/ -R

# Install GNUHealth application
USER gnuhealth
RUN cd sao && npm install --production --legacy-peer-deps
RUN cd /tmp/gnuhealth && ./gnuhealth-setup install

# Cleanup and setup configurations
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY trytond.conf /home/gnuhealth/trytond.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chown gnuhealth: /home/gnuhealth/ -R
RUN chmod +x /home/gnuhealth/start_gnuhealth.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000

USER gnuhealth
ENTRYPOINT [ "/docker-entrypoint.sh" ]
