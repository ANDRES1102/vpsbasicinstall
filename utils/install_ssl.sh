#!/bin/bash

#variables
ssl_install=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.install')
certbot=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.certbot')
location=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.location')
domain=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.domain')
email=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.email')

echo "$email"

#validaciones si se va a instalar ssl
if [ "$ssl_install" = true ]; then

#activamos los puertos
 sudo ufw allow 80
 sudo ufw allos 443

 #validamos que exista la ruta donde van a quedar guardado el ssl
 #si no existe se crea y se da los permisos para guardarlos a la carpeta
 if [ ! -d "$location" ]; then
  sudo mkdir -p "$location"
  sudo chmod -R 777 "$location"
 fi

#validamos si se desea instalar certbot y se instala si es verdadero
 if [ "$certbot" = true ]; then

  #se instala letsecrypt donde viene guardado certbot
  #letscrupt actualiza automaticamente los certificados
  if ! dpkg-query -W -f='${Status}' "letsencrypt" | grep -q "installed"; then
    sudo apt install  letsencrypt -y -V
  fi

  #se instala el certificado ssl
  if [ ! -e "$location/$domain/cert.pem" ]; then
    sudo certbot certonly --standalone --agree-tos --email $email --non-interactive  -d $domain
  fi

 fi

fi
