FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y software-properties-common python-pip
RUN pip3 install gnuhealth

EXPOSE 80
CMD ["/bin/bash", "-c", "/usr/local/bin/gnuhealth-server --db-host $POSTGRES_HOST --db-port $POSTGRES_PORT --db-name $POSTGRES_DB --db-user $POSTGRES_USER --db-password $POSTGRES_PASSWORD"]
