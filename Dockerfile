# Use a base image of your choice (e.g., Ubuntu)
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && apt-get -y install python3-pip python3-dev postgresql \
        postgresql-contrib libpq-dev libxml2-dev libxslt1-dev libsasl2-dev libldap2-dev python3-pyldap \
        python3-biopython python3-psycopg2 python3-pydot python3-pyqt5 python3-pyqt5.qtsql python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebkit python3-pyqt5.qtopengl python3-matplotlib python3-pyparsing \
        python3-ldap python3-reportlab python3-docutils python3-polib python3-genshi python3-pygments \
        python3-psutil python3-openpyxl python3-gi python3-cairocffi python3-pil python3-dateutil \
        python3-vobject python3-requests python3-babel python3-openssl python3-psutil python3-setuptools \
        python3-wheel python3-tz python3-uno python3-usb python3-netifaces python3-oauth2client \
        python3-suds python3-httplib2 python3-werkzeug python3-passlib python3-icu python3-pytest \
        python3-pytest-runner python3-markupsafe python3-mako python3-unittest2 python3-defusedxml \
        python3-odf python3-sqlalchemy python3-zope.interface python3-ofxparse python3-psycogreen \
        python3-lxml python3-num2words python3-pyPdf python3-uno python3-rdflib python3-dateutil \
        python3-mock python3-dns python3-vatnumber python3-pip python3-pyldap python3-gi-cairo

# Install GNU Health
RUN pip install pycairo gnuhealth

# Expose the necessary ports (adjust as needed)
EXPOSE 80

# Start the GNU Health server (replace with your specific startup command)
CMD ["/bin/bash", "-c", "/usr/local/bin/gnuhealth-server --db-host $POSTGRES_HOST --db-port $POSTGRES_PORT --db-name $POSTGRES_DB --db-user $POSTGRES_USER --db-password $POSTGRES_PASSWORD"]

