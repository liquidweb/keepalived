#!/bin/bash

set -ux

vip=$1
ips=$2
password_path=/run/secrets/keepalived/password

if [ ! -s $password_path ]; then
  echo "no password file at $password_path"
  exit 1
fi

myip=`ip a show eth0 | grep -e 'inet\b' | awk '{ print $2 }' | cut -d/ -f1 | head -n 1`
peers=`echo $ips | sed "s/$myip//" | tr '[:space:]' '\n'`
password=`cat $password_path | tr -d "[:space:]"`

echo "vip: $vip"
echo "myip: $myip"
echo -e "peers: $peers"
echo -e "config:\n\n"

cat <<EOF > /etc/keepalived/keepalived.conf
vrrp_instance ingress_1 {
  garp_master_delay 5
  garp_master_refresh 60
  interface eth0

  #state BACKUP
  #priority 100

  virtual_router_id 1
  virtual_ipaddress {
    $vip
  }

  nopreempt
  unicast_src_ip $myip
  unicast_peer {
    $peers
  }

  authentication {
    auth_type PASS
    auth_pass $password
  }

}
EOF

cat /etc/keepalived/keepalived.conf

exec keepalived -n -f /etc/keepalived/keepalived.conf -l
