#!/bin/bash

MYIP=$(hostname -I | cut -f1 -d" " | tr -d '[:space:]')
MYPASSWORD="MyZimbra@@"
DOMAIN="mail.local"
HOSTNAME="zimbra.mail.local"

# Reset the hosts file
echo "\e[38;5;87mFixing the hosts file."
echo -e "\e[38;5;82m ... create a copy of the old hosts file."
sudo mv /etc/hosts{,.old}

echo -e "\e[38;5;82m ... write a new hosts file."
printf '127.0.0.1\tlocalhost.localdomain\tlocalhost\n127.0.1.1\tubuntu\n'$MYIP'\tzimbra.mail.local\tzimbra\t'$(hostname) | sudo tee -a /etc/hosts >/dev/null 2>&1

echo "\e[38;5;87mSetting hostname to $HOSTNAME."
hostnamectl set-hostname $HOSTNAME >/dev/null 2>&1

echo "\e[38;5;87mSetting timezone to Singapore."
timedatectl set-timezone Asia/Singapore >/dev/null 2>&1
#timedatectl set-timezone Asia/Bangkok >/dev/null 2>&1
#timedatectl set-timezone Asia/Yangon >/dev/null 2>&1

echo "\e[38;5;87mUpdate package repo."
apt-get -qq update

#Install a DNS Server
echo "\e[38;5;87mInstalling dnsmasq DNS Server"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y dnsmasq < /dev/null > /dev/null
echo -e "\e[38;5;82m ... Configuring DNS Server (/etc/dnsmasq.conf)"
sudo mv /etc/dnsmasq.conf{,.old}
#create the conf file
printf 'server=8.8.8.8\nlisten-address=127.0.0.1\ndomain='$DOMAIN'\nmx-host='$DOMAIN','$HOSTNAME',0\naddress=/'$HOSTNAME'/'$MYIP'\n' | sudo tee -a /etc/dnsmasq.conf >/dev/null
# restart dns services
sudo systemctl restart dnsmasq.service
echo -e "\e[0m"
