#!/bin/bash

#functions
#obtenicioon de parametros
getParametersList(){
 while getopts "p:" option; do
  case "${option}" in
   p) p_parameter="${OPTARG}";;
  esac
 done
 shift $((OPTIND-1))
}
getParametersList "$@"

#variables
current_route=$PWD
utils_route=$PWD/utils

#LOGICA DEL PROCESO
echo "Iniciando creacion de servidor web..."

#Actualizando server
#$utils_route/update_init.sh

#solicitando claves
url_curl=$(cat $utils_route/get_keys.json | jq -r '.url')
if [ -n "$url_curl" ]; then
 bash $utils_route/get_keys.sh -m json -u $url_curl
fi

#dns - no disponible
#$utils_route/install_dns.sh

#ssl - ok
#$utils_route/install_ssl.sh

#instalar ftp - ok
$utils_route/create_ftp.sh

#db - ok
#$utils_route/install_db.sh

#apache - ok
#$utils_route/install_apache.sh

#nodejs - ok
#$utils_route/install_nodejs.sh

