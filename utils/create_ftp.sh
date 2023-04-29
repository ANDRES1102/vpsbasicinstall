#!/bin/bash

#variables
start=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.list_port.start')
end=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.list_port.end')
user_ftp=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.user')
password_ftp=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.password')
port_ftp=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.port')
host_ftp=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.host')
ssl_enable=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.ssl')
ssl_location=$(cat $PWD/utils/get_keys.json | jq -r '.ssl.location')
location=$(cat $PWD/utils/get_keys.json | jq -r '.ftp.location')
domain=$(cat $PWD/utils/get_keys.json | jq -r '.dns.domain')

#inicia el proceso
echo "Instalando ufw"
sudo apt-get install ufw
echo "Instalando VSFTP"
sudo apt-get install -y -V vsftpd
echo "Creando copia de configuracion"
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
echo "Activando puertos de acceso"
sudo ufw allow 20,$port_ftp,22,990/tcp
echo "Activando puerttos de conexion pasiva"
sudo ufw allow $start:$end/tcp

if ! id -u $user_ftp > /dev/null 2>&1; then
 echo "Configurando FTP"
 echo "Creando usuario FTP"
 echo -e "$password_ftp\n$password_ftp" | adduser $user_ftp --gecos ",,,,"
 echo "Dando privilegios generales a la carpeta del dominio"
 sudo chown nobody:nogroup $location/$host_ftp
 sudo chmod a-w $location/$host_ftp
 sudo chown $user_ftp:$user_ftp $location/$host_ftp
fi

directory="/var/www/$host_ftp"
if [ ! -d $directory ]; then
 echo "El dominio ya se encuentra registrado";
 echo "Eliminando dominio y creando un nuevo"
 sudo mkdir $directory
 sudo chmod -R 777 $directory
fi

if [ -e "/etc/vsftpd.conf"  ]; then
 echo "Eliminando configuracion FTP actual"
 sudo rm -r "/etc/vsftpd.conf"
fi

echo "Cargando configuracion FTP"
echo "listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
ftpd_banner=Bienvenido a $domain
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=ftp
rsa_cert_file=/etc/letsencrypt/live/$domain/cert.pem
rsa_private_key_file=/etc/letsencrypt/live/$domain/privkey.pem
ssl_enable=$ssl_enable
allow_writeable_chroot=YES
pasv_min_port=$start
pasv_max_port=$end
local_root=$location/$host_ftp
listen_port=$port_ftp
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
">>/etc/vsftpd.conf

echo "$user_ftp" | sudo tee -a /etc/vsftod.userlist

echo "Deteniendo FTP"
sudo systemctl stop vsftpd

echo "Iniciando FTP"
sudo systemctl start vsftpd
