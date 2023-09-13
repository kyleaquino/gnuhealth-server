FROM ubuntu:22.04 as builder

# Create a user for GNUHealth
RUN useradd --uid 1000 --create-home --home-dir /home/gnuhealth gnuhealth

ENV GNUHEALTH_PACKAGE="https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz" \
    GNUHEALTH_SAO_PACKAGE="https://downloads.tryton.org/5.0/tryton-sao-5.0.0.tgz" \
    DEBIAN_FRONTEND=noninteractive

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
    python3-pip \
    python3-psycopg2

# Download and extract GNUHealth and Tryton SAO packages
WORKDIR /tmp
RUN wget -q -O gnuhealth.tgz "${GNUHEALTH_PACKAGE}" && \
    wget -q -O tryton-sao.tgz "${GNUHEALTH_SAO_PACKAGE}" && \
    mkdir -p /tmp/gnuhealth && \
    tar xzf gnuhealth.tgz --strip-components=1 -C /tmp/gnuhealth && \
    tar xzf tryton-sao.tgz -C /tmp/gnuhealth && \
    cp -r /tmp/gnuhealth/package /home/gnuhealth/sao && \
    chown -R gnuhealth: /tmp/gnuhealth/ /home/gnuhealth/

# Switch to the gnuhealth user
USER gnuhealth

ARG GNUHEALTH_POSTGRES_URL
ENV GNUHEALTH_POSTGRES_URL="${GNUHEALTH_POSTGRES_URL}" 

# Install SAO dependencies
WORKDIR /home/gnuhealth/sao
RUN npm install --production --legacy-peer-deps

# Install GNUHealth application
WORKDIR /tmp/gnuhealth
RUN ./gnuhealth-setup install

COPY trytond.conf /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf

# Cleanup and setup configurations
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /home/gnuhealth/start_gnuhealth.sh /entrypoint.sh

WORKDIR /home/gnuhealth
RUN chown -R gnuhealth: /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf

EXPOSE 8000

USER gnuhealth
RUN /bin/echo "# Add GNUHealth Commands to PATH" >> $HOME/.bashrc && \
    /bin/echo "export PATH='$HOME/gnuhealth/tryton/server/trytond-6.0.35/bin/:$PATH'" >> $HOME/.bashrc

RUN /bin/echo "" >> /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf && \
    /bin/echo "[database]" >> /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf && \
    /bin/echo "uri = $GNUHEALTH_POSTGRES_URL" >> /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf

ENTRYPOINT [ "/entrypoint.sh" ]
