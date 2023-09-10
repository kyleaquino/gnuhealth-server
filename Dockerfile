FROM ubuntu:20.04

RUN apt-get install gnuhealth-server
EXPOSE 80

CMD ["/bin/bash", "-c", "/usr/local/bin/gnuhealth-server --db-host $POSTGRES_HOST --db-port $POSTGRES_PORT --db-name $POSTGRES_DB --db-user $POSTGRES_USER --db-password $POSTGRES_PASSWORD"]

