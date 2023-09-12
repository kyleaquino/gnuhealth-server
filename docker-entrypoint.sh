#!/bin/bash

if [ ! -f /etc/secrets/.env ]
then
  export $(cat /etc/secrets/.env | xargs)
fi

mv -f trytond.conf $TRYTOND_CONFIG 

echo "" >> $TRYTOND_CONFIG
echo "[database]" >>  $TRYTOND_CONFIG
echo "uri = ${GNUHEALTH_POSTGRES_URL}" >> $TRYTOND_CONFIG

cd /home/gnuhealth/gnuhealth/tryton/server/trytond-6.0.35/bin
python ./trytond-admin --all --database=gnuhealth -c $TRYTOND_CONFIG

cd /home/gnuhealth
./start_gnuhealth.sh
