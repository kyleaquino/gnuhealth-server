FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y apt-get -y install python-setuptools python-dev libldap2-dev \
    libsasl2-dev git libsasl2-dev libssl-dev python-ldap python-psycopg2 libxml2-dev \
    libxslt1-dev wget libpq-dev postgresql supervisor python-cracklib nano

RUN easy_install pip

EXPOSE 80
