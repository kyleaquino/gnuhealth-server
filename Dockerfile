FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y software-properties-common python3-dev python3-pip python3-cffi libpq-dev curl

# Install Gnuhealth Server
RUN pip install gnuhealth-all-modules --use-pep517

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

EXPOSE 80
