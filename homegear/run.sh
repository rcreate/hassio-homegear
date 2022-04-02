#!/bin/bash
_term() {
    kill $(cat /var/run/homegear/homegear-management.pid)
    kill $(cat /var/run/homegear/homegear-webssh.pid)
    kill $(cat /var/run/homegear/homegear-gateway.pid)
    kill $(cat /var/run/homegear/homegear.pid)
    /etc/homegear/homegear-stop.sh
    exit $?
}

trap _term SIGTERM

mkdir -p /config/homegear/config
mv -n /main.conf /config/homegear/config/main.conf
mv -n /gateway.conf /config/homegear/config/gateway.conf
cp -nR /etc/homegear/* /config/homegear/config
cp -R /config/homegear/config/* /etc/homegear/

mkdir -p /var/log/homegear
touch /var/log/homegear/homegear.log
touch /var/log/homegear-gateway/homegear-gateway.log
chown -R homegear:homegear /var/log/homegear

mkdir -p /var/run/homegear
chown homegear:homegear /var/run/homegear
/etc/homegear/homegear-start.sh
homegear -u homegear -g homegear -p /var/run/homegear/homegear.pid &
homegear-management -p /var/run/homegear/homegear-management.pid &
homegear-gateway -u homegear -g homegear -p /var/run/homegear/homegear-gateway.pid -d &
tail -f /var/log/homegear-gateway/homegear-gateway.log &
child=$!
wait "$child"
