FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV GNUHEALTH_PACKAGE https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz
ENV GNUHEALTH_SAO_PACKAGE https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz

ENV TRYTOND_DATABASE_URI "postgresql://${GNUHEALTH_POSTGRES_USER}:${GNUHEALTH_POSTGRES_PASSWORD}@${GNUHEALTH_POSTGRES_HOST}/${GNUHEALTH_POSTGRES_DB}:5432"
ENV TRYTONPASSFILE /home/gnuhealth/.password

RUN useradd --uid 1000 --create-home --home-dir /home/gnuhealth gnuhealth
WORKDIR /home/gnuhealth

# Ubuntu General Dependencies
RUN apt-get update
RUN apt-get -y install --no-install-recommends software-properties-common libpq-dev curl wget gcc g++ make git nano vim patch

# Install Framework Dependencies
RUN apt-get install -y nodejs npm python3-dev python3-pip python3-cffi

# Install Tryton SAO
RUN wget -q  --output-document=/tmp/tryton-sao.tgz "${GNUHEALTH_SAO_PACKAGE}" 
RUN tar -xf tryton-sao.tgz && cd package && npm install --production --legacy-peer-deps
RUN rm -rf tryton-sao.tgz

# Setup GNUHealth Server
RUN wget -q  --output-document=/tmp/gnuhealth.tgz "${GNUHEALTH_PACKAGE}" 
RUN mkdir /tmp/gnuhealth && cd /tmp/gnuhealth && tar xzf /tmp/gnuhealth.tgz --strip-components=1 
RUN chown gnuhealth: /tmp/gnuhealth/ -R

USER gnuhealth
RUN cd /tmp/gnuhealth && ./gnuhealth-setup install && chmod +x /home/gnuhealth/start_gnuhealth.sh

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000

USER gnuhealth
ENTRYPOINT [ "/docker-entrypoint.sh" ]
