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

mkdir -p /config/homegear/config /config/homegear/config/families
mv -n /main.conf /config/homegear/config/main.conf
mv -n /homematicbidcos.conf /config/homegear/config/families/homematicbidcos.conf
mv -n /gateway.conf /config/homegear/config/gateway.conf
cp -nR /etc/homegear/* /config/homegear/config
cp -R /config/homegear/config/* /etc/homegear/

mkdir -p /var/log/homegear /var/log/homegear-gateway
touch /var/log/homegear/homegear.log
touch /var/log/homegear-gateway/homegear-gateway.log
chown -R homegear:homegear /var/log/homegear
chown -R homegear:homegear /var/log/homegear-gateway

mkdir -p /var/run/homegear
chown homegear:homegear /var/run/homegear
homegear-gateway -p /var/run/homegear-gateway/homegear-gateway.pid &
homegear -u homegear -g homegear -p /var/run/homegear/homegear.pid &
homegear-management -p /var/run/homegear/homegear-management.pid &
homegear -e rc 'print_v($hg->managementCreateCa());' &
homegear -e rc 'print_v($hg->managementCreateCert("adb23-gw"));' &
homegear -e rc '$hg->configureGateway("127.0.0.1", 2018, file_get_contents("/etc/homegear/ca/cacert.pem"), file_get_contents("/etc/homegear/ca/certs/adb23-gw.crt"), file_get_contents("/etc/homegear/ca/private/adb23-gw.key"), "I8i62300");' &
tail -f /var/log/homegear/homegear.log &
child=$!
wait "$child"
