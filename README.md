# Getting Started

This image provides a self-configuring keepalived instance. Specify a VIP to float and a space-delimited set of peer IPs and it'll self-configure.

`docker run -v pathtopassword:/run/secrets/keepalived/password liquidweb/keepalived "10.10.20.100" "10.10.20.10 10.10.20.11 10.10.20.13"`
