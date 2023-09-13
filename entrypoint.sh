#!/bin/bash

echo "" >> $HOME/gnuhealth/tryton/server/config/trytond.conf
echo "[database]" >> $HOME/gnuhealth/tryton/server/config/trytond.conf
echo "uri = $GNUHEALTH_POSTGRES_URL" >> $HOME/gnuhealth/tryton/server/config/trytond.conf

python3 trytond-admin --all --database=gnuhealth -c $HOME/gnuhealth/tryton/server/config/trytond.conf

cd $HOME
./start_gnuhealth.sh
