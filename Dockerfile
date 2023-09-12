FROM ubuntu:22.04 as builder

# Create a user for GNUHealth
RUN useradd --uid 1000 --create-home --home-dir /home/gnuhealth gnuhealth
RUN --mount=type=secret,id=_env,dst=/etc/secrets/.env cat /etc/secrets/.env

ARG GNUHEALTH_POSTGRES_URL
ENV GNUHEALTH_POSTGRES_URL="${GNUHEALTH_POSTGRES_URL}"
ENV GNUHEALTH_PACKAGE https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz
ENV GNUHEALTH_SAO_PACKAGE https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    libpq-dev \
    curl \
    wget \
    gcc \
    g++ \
    make \
    git \
    nano \
    vim \
    patch \
    nodejs \
    npm \
    python3 \
    python3-dev \
    python3-pip

# Download GNUHealth and Tryton SAO packages
RUN mkdir -p /tmp/gnuhealth && \
    wget -q --output-document=/tmp/gnuhealth.tgz "${GNUHEALTH_PACKAGE}" && \
    wget -q --output-document=/tmp/tryton-sao.tgz "${GNUHEALTH_SAO_PACKAGE}"

# Extract packages and copy to /home/gnuhealth/sao
RUN tar xzf /tmp/gnuhealth.tgz --strip-components=1 -C /tmp/gnuhealth && \
    tar xzf /tmp/tryton-sao.tgz -C /tmp/gnuhealth && \
    cp -r /tmp/gnuhealth/package /home/gnuhealth/sao

# Set ownership
RUN chown gnuhealth: /tmp/gnuhealth/ -R && \
    chown gnuhealth: /home/gnuhealth/ -R

# Switch to the gnuhealth user
USER gnuhealth

# Install SAO dependencies
WORKDIR /home/gnuhealth/sao
RUN npm install --production --legacy-peer-deps

# Install GNUHealth application
WORKDIR /tmp/gnuhealth
RUN ./gnuhealth-setup install

# Cleanup and setup configurations
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY trytond.conf /home/gnuhealth/trytond.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chown gnuhealth: /home/gnuhealth/ -R && \
    chmod +x /home/gnuhealth/start_gnuhealth.sh /docker-entrypoint.sh

EXPOSE 8000

USER gnuhealth
ENTRYPOINT [ "/docker-entrypoint.sh" ]
