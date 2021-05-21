#!/usr/bin/env bash
# BEGIN
echo -e "-- ---------------------------------- --\n"
echo -e "-- CREA EL CONTENEDOR/INSTALA HAPROXY --\n"
echo -e "-- ---------------------------------- --\n"

# LOGIN COMO SUPERUSUARIO

sudo -i

# CREACION DEL CONTENEDOR

echo -e "-- Creando el contenedor\n"
lxc launch ubuntu:20.04 haproxy
#lxc start haproxy

echo -e "-- Actualizando paquetes\n"
lxc exec haproxy -- apt-get update -y -qq

# INSTALACION HAPROXY

echo -e "-- Instalacion HAProxy\n"
lxc exec haproxy -- apt-get install -y haproxy
lxc exec haproxy -- systemctl enable haproxy

echo -e "-- Configuracion haProxy.cfg\n"
cat > haproxy.cfg <<EOF
global
  log /dev/log local0
  log localhost local1 notice
  user haproxy
  group haproxy
  maxconn 2000
  daemon

defaults
  log global
  mode http
  option httplog
  option dontlognull
  retries 3
  timeout connect 5000
  timeout client 50000
  timeout server 50000

frontend http-in
  bind *:80
  default_backend webservers
  errorfile 503 /etc/haproxy/errors/503.http

backend webservers
  balance roundrobin
  stats enable
  stats auth admin:admin
  stats uri /haproxy?stats

  server conwebserv1 240.101.0.147:80 check
  server conwebserv2 240.102.0.198:80 check
  server conwebserv3 240.103.0.113:80 backup check
  server conwebserv4 240.104.0.114:80 backup check
EOF

echo -e "-- Starting HAProxy\n"
lxc file push haproxy.cfg haproxy/etc/haproxy/haproxy.cfg
lxc exec haproxy -- systemctl start haproxy

echo -e "-- Forwarding de puertos\n"
lxc config device add haproxy http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80


# END
echo -e "-- -------------------------------------------------- --"
echo -e "--           FIN APROVISIONAMIENTO HAPROXY            --"
echo -e "-- -------------------------------------------------- --" 
