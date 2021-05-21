#!/usr/bin/env bash
# BEGIN
echo -e "-- ------------------------------------------------ --\n"
echo -e "--       CREA EL CONTENEDOR/INSTALA APACHE2         --\n"
echo -e "-- ------------------------------------------------ --\n"

# LOGIN COMO SUPERUSUARIO

CONT='conwebserv'
SERV='webserver'

CONTENEDOR=$CONT$1
SERVER=$SERV$1

echo $CONTENEDOR
echo $SERVER

sudo -i

# Instalando lxd lxc
echo -e "-- Instalando lxd lxc\n"

sudo snap install lxd --channel=4.0/stable
newgrp lxd
lxd init --auto
sudo apt-get install lxc -y

echo -e "-- Creando el contenedor\n"

lxc launch ubuntu:20.04 $CONTENEDOR
#lxc start $CONTENEDOR

echo -e "-- Actualizando paquetes\n"
lxc exec $CONTENEDOR -- apt-get update -y -qq

# INSTALACION APACHE

echo -e "-- Instalacion Apache\n"
lxc exec $CONTENEDOR -- apt-get install apache2 -y
lxc exec $CONTENEDOR -- systemctl enable apache2

echo -e "-- Configuracion index.html"
cat > index.html <<EOF
<html>
<head>
<title>WEB SERVER $1 </title>
</head>
<body>
<h1>WEB SERVER $1 </h1>
</body>
</html>
EOF

echo -e "-- Starting Apache\n"
lxc file push index.html $CONTENEDOR/var/www/html/index.html
lxc exec $CONTENEDOR -- systemctl start apache2

# END
echo -e "-- -------------------------------------------------- --"
echo -e "--           FIN APROVISIONAMIENTO APACHE             --"
echo -e "-- -------------------------------------------------- --" 
