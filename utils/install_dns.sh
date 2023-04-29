#!/bin/bash
#instalar bind9
if ! dpkg-query -W -f='${Status}' "bind9" | grep -q "installed"; then
 echo "Intalando bind9"
 sudo apt-get install bind9 -y -V
fi

dns=$(cat $PWD/utils/get_keys.json | jq -r '.dns.install')
domain=$(cat $PWD/utils/get_keys.json | jq -r '.dns.domain')
location=$(cat $PWD/utils/get_keys.json | jq -r '.dns.location')
ip_ns1=$(cat $PWD/utils/get_keys.json | jq -r '.dns.ip_ns1')
ip_ns2=$(cat $PWD/utils/get_keys.json | jq -r '.dns.ip_ns2')
ip_mail=$(cat $PWD/utils/get_keys.json | jq -r '.dns.ip_mail')

sudo ufw allow Bind9

if [ ! -d "$location" ]; then
 echo "Creando la ubicacion de dns"
 sudo mkdir "$location";
 echo "Otogando permisos a la carpeta del dominio"
 sudo chmod -R 777 "$location"
 #sudo touch "$location/db.$domain"
 sudo chmod -R 777 "$location/db.$domain"
fi
sudo chmod -R 777 "$location/db.$domain"

echo "Creando configuracion dns"


if [ -e "$location/named.conf.local" ]; then
 sudo rm -r "$location/named.conf.local"
fi

config="zone \"$domain\" {
 \n\ttype master;
 \n\tfile \"$location/db.$domain\";
\n};"

echo -e $config>>"$location/named.conf.local"

if [ -e "$location/db.$domain" ]; then
 sudo rm -r "$location/db.$domain"
fi

dns_config="\$TTL 604800
 \n@ \tIN \tSOA \tns1.$domain. root.$domain. (
   \n\t\t      2 \t; Serial
   \n\t\t 604800 \t; Refresh
   \n\t\t  86400 \t; Retry
   \n\t\t2419200 ; Expire
   \n\t\t 604800 ) ; Negative Cahe TTL
\n
\n;
\n@ \tIN \tNS \tns1.$domain.
\n@ \tIN \tNS \tns2.$domain.
\nns1 \tIN \tA \t$ip_ns1
\nns2 \tIN \tA \t$ip_ns2
\nmail \tIN \tA \t.$ip_mail
\nwww \tIN \tCNAME \t$domain
\n@ \tIN \tMX \t10 mail.$domain
"

echo -e $dns_config>>"$location/db.$domain"

sudo systemctl restart bind9
