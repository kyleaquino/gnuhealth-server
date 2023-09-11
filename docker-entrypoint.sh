#!/bin/bash

if [ ! -f .env ]
then
  export $(cat .env | xargs)
fi

echo "[database]" >> /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf
echo "uri = ${GNUHEALTH_POSTGRES_URL}" >> /home/gnuhealth/gnuhealth/tryton/server/config/trytond.conf

cd /home/gnuhealth
./start_gnuhealth.sh
