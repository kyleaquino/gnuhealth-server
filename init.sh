#!/bin/bash

cd $HOME/gnuhealth/tryton/server/trytond-6.0.35/bin/
python3 ./trytond-admin --all --database=gnuhealth -c $HOME/gnuhealth/tryton/server/config/trytond.conf
