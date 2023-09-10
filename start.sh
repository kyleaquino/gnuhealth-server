#!/usr/bin/env sh

echo "[web]" >> /home/gnuhealth/trytond.conf
echo "listen = *:8000" >> /home/gnuhealth/trytond.conf
echo "root = /home/gnuhealth/package/" >> /home/gnuhealth/trytond.conf

trytond -c /home/gnuhealth/trytond.conf
