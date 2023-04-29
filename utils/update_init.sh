#!/bin/bash

echo "Inicializando actualizacion del sistema"

sudo apt-get update && sudo apt-get -y -V upgrade
sudo apt-get install -y -V jq 
touch $PWD/utils/get_keys.json
chmod -R 777 $PWD/utils/get_keys.json

#permisos a los instaladores

chmod -R 777 $PWD/utils/create_ftp.sh
chmod -R 777 $PWD/utils/install_dns.sh
chmod -R 777 $PWD/utils/install_ssl.sh
chmod -R 777 $PWD/utils/install_db.sh
chmod -R 777 $PWD/utils/install_apache.sh
chmod -R 777 $PWD/utils/install_nodejs.sh
chmod -R 777 $PWD/utils/get_keys.sh
