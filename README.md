# vpsbasicinstall
Basic installer for a VPS for UBUNTU-LINUX (testing 20.04). 

You can install automatically by simply downloading the repository onto the VPS, including the init.sh file and the utils folder. 

It is necessary to configure the get_keys.json file, which is located in the utils folder, where you can configure the applications to install and allow or disallow the applications to be downloaded.

Applications that can be installed: 
- SSL: which uses CERTBOT technology to install SSL certificates for free for 30 days. Additionally, there will be a validator configured to reinstall the certificates once they have expired. 
- DNS: which configures your machine so that the domain points to your VPS (currently not functioning). 
- FTP: which allows you to install and configure FTP connection. 
- DB: which allows you to install databases, MYSQL, MARIADB, POSTGRESQL. 
- APACHE: which installs a server to host your website. 
- NODEJS: which installs the latest available version of NodeJS and NPM.

It is necessary to provide the requested data for each of these applications; otherwise, leave them as they are. PLEASE do not leave fields blank as this may cause an error. 
The most common data requested are: 
- the domain, 
- public IP, 
- usernames, 
- passwords, - ports, 
- the type of database to install, 
- email

POV: if there is any data that is not recognized, please leave it as it is.
