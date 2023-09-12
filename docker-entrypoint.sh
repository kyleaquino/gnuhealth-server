#!/bin/bash

if [ ! -f /etc/secrets/.env ]
then
  export $(cat /etc/secrets/.env | xargs)
fi

echo "" >> $HOME/gnuhealth/tryton/server/config/trytond.conf
echo "[database]" >> $HOME/gnuhealth/tryton/server/config/trytond.conf
echo "uri = $GNUHEALTH_POSTGRES_URL" >> $HOME/gnuhealth/tryton/server/config/trytond.conf

cd $HOME/gnuhealth/tryton/server/trytond-6.0.35/bin
python3 ./trytond-admin --all --database=gnuhealth -c $HOME/gnuhealth/tryton/server/config/trytond.conf

cd $HOME
./start_gnuhealth.sh
