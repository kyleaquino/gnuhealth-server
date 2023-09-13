#!/bin/bash

cd $HOME/gnuhealth/tryton/server/trytond-6.0.35/bin/
./trytond-admin --all --database=gnuhealth -c $HOME/gnuhealth/tryton/server/config/trytond.conf

cd $HOME
./start_gnuhealth.sh
