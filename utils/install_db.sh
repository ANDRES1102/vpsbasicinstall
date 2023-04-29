#!/bin/bash

password=$(cat $PWD/utils/get_keys.json | jq -r '.db.password')
admin=$(cat $PWD/utils/get_keys.json | jq -r '.db.admin')
user=$(cat $PWD/utils/get_keys.json | jq -r '.db.user')
host=$(cat $PWD/utils/get_keys.json | jq -r '.db.host')
db=$(cat $PWD/utils/get_keys.json | jq -r '.db.db')
remote=$(cat $PWD/utils/get_keys.json | jq -r '.db.remote')

#crear db mysql
 echo "Preparando instalacion de $admin"
if [ "$admin" = "mysql" ]; then
 #instalando mysql-server
 echo "instalando mysql-server."
 if ! dpkg-query -W -f='${Status}' "mysql-server" | grep -q "installed"; then
  sudo apt-get install mysql-server -y -V
 fi
fi

#crear db mariadb
if [ "$admin" = "mariadb" ]; then
 echo "instalando mariadb-server"
 if ! dpkg-query -W -f='${Status}' "mariadb-server" | grep -q "installed"; then
  sudo apt-get install mariadb-server -y -V
 fi
fi

#crear db postgresql
if [ "$admin" = "postgresql" ]; then
 echo "instalando postgresql"
 if ! dpkg-query -W -f='${Status}' "postgresql" | grep -q "installed"; then
  sudo apt-get install postgresql -y -V
 fi
fi

if [ "$admin"="mysql" ] || [ "$admin"="mariadb" ] || [ "$admin"="postgresql" ]; then
sql="select user from mysql.user where user='$user';"
user_exist=$(mysql -s -N -e "$sql")
 #validamos que el usuario a registrar exista
 echo "validando que el usuario a registrar exista"
 if [ "$user_exist" != "$user" ]; then
  #el usuario no existe
  echo "el usuario a regitrar no existe"
  #registrando usuario
  echo "registrando usuario"
  if [ "$remote" = false ]; then
    #registrando usuario en modo local
    echo "registrando usuario en modo local"
    response=$(mysql -s -N -e "create user '$user'@'localhost' IDENTIFIED BY '$password';")
    response=$(mysql -s -N -e "grant all privileges on $db.* to '$user'@'$host';")
  else
    #registrando usuario en modo remoto
    echo "registrando usuarioi en modo remoto"
    response=$(mysql -s -N -e "create user '$user'@'%' IDENTIFIED BY '$password';")
    response=$(mysql -s -N -e "grant all privileges on $db.* to '$user'@'%';")
  fi
 else
  echo "el usario a registrar ya se encuentra registrado"
 fi
 if ! mysql -u "$user" -p"$password" -e "use $db" > /dev/null 2>&1; then
  echo "creando base de datos $db"
  response=$(mysql -s -N -e "create database $db")
 fi


 #reiniciar para guardar cambios en las db
 echo "Reiniciando servicio de $admin"
#--------------
 if [ "$admin" = "mysql" ]; then

     sudo service mysql restart

 fi
#---------------
 if [ "$admin" = "mariadb" ]; then

    sudo systemctl restart mariadb

 fi
#---------------
 if [ "$admin" = "postgresql" ]; then

    sudo systemctl restart postgresql

 fi

fi
