#!/usr/bin/env sh

echo "[web]" >> /home/trytond.conf
echo "listen = *:80" >> /home/trytond.conf
echo "root = /home/package/" >> /home/trytond.conf
