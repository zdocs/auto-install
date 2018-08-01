#!/bin/bash

MYIP=$(hostname -I | cut -f1 -d" " | tr -d '[:space:]')
MYPASSWORD="Zimbra2018@"
DOMAIN="mail.lab"
HOSTNAME="zimbra.mail.lab"

# Reset the hosts file
echo "\e[38;5;87mFixing the hosts file."
echo -e "\e[38;5;82m ... create a copy of the old hosts file."
sudo mv /etc/hosts{,.old}

echo -e "\e[38;5;82m ... write a new hosts file."
printf '127.0.0.1\tlocalhost.localdomain\tlocalhost\n127.0.1.1\tubuntu\n'$MYIP'\t'$HOSTNAME'\tzimbra\t'$(hostname) | sudo tee -a /etc/hosts >/dev/null 2>&1

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

##Preparing the config files to inject
mkdir /tmp/zcs && cd /tmp/zcs

##Download the Zimbra binaries
echo "Downloading Zimbra OSE 8.8.9 for Ubuntu 16.04"
wget -P /tmp/ https://files.zimbra.com/downloads/8.8.9_GA/zcs-8.8.9_GA_2055.UBUNTU16_64.20180703080917.tgz > /dev/null 2>&1
echo " ... Extracting the files"
tar xzf /tmp/zcs-8.8.9*.tgz

echo "Creating the auto-install input files"
touch /tmp/zcs/installZimbraScript
cat <<EOF >/tmp/zcs/installZimbraScript
AVDOMAIN="$DOMAIN"
AVUSER="admin@$DOMAIN"
CREATEADMIN="admin@$DOMAIN"
CREATEADMINPASS="$MYPASSWORD"
CREATEDOMAIN="$DOMAIN"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="$HOSTNAME.$DOMAIN"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/common/lib/jvm/java"
LDAPAMAVISPASS="$MYPASSWORD"
LDAPPOSTPASS="$MYPASSWORD"
LDAPROOTPASS="$MYPASSWORD"
LDAPADMINPASS="$MYPASSWORD"
LDAPREPPASS="$MYPASSWORD"
LDAPBESSEARCHSET="set"
LDAPDEFAULTSLOADED="1"
LDAPHOST="$HOSTNAME.$DOMAIN"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="512"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@$DOMAIN"
SMTPHOST="$HOSTNAME.$DOMAIN"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@$DOMAIN"
SNMPNOTIFY="yes"
SNMPTRAPHOST="$HOSTNAME.$DOMAIN"
SPELLURL="http://$HOSTNAME.$DOMAIN:7780/aspell.php"
STARTSERVERS="yes"
SYSTEMMEMORY="3.8"
TRAINSAHAM="ham.account@$DOMAIN"
TRAINSASPAM="spam.account@$DOMAIN"
UIWEBAPPS="yes"
UPGRADE="yes"
USEKBSHORTCUTS="TRUE"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.account@$DOMAIN"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="$MYPASSWORD"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$MYPASSWORD"
ldap_url="ldap://$HOSTNAME.$DOMAIN:389"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$MYPASSWORD"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/common/lib/jvm/java/jre/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraDNSMasterIP=""
zimbraDNSTCPUpstream="no"
zimbraDNSUseTCP="yes"
zimbraDNSUseUDP="yes"
zimbraDefaultDomainName="$DOMAIN"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="FALSE"
zimbraMtaMyNetworks="127.0.0.0/8 $MYIP/32 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId="Asia/Singapore"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckInterval="1d"
zimbraVersionCheckNotificationEmail="admin@$DOMAIN"
zimbraVersionCheckNotificationEmailFrom="admin@$DOMAIN"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="FALSE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
zimbra_server_hostname="$HOSTNAME.$DOMAIN"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy"
EOF

echo "Creating the auto-install keystrokes"
touch /tmp/zcs/installZimbra-keystrokes
cat <<EOF >/tmp/zcs/installZimbra-keystrokes
y
y
y
y
y
n
y
y
y
y
y
y
y
n
y
y
EOF

echo "Installing Zimbra Collaboration just the Software"
cd /tmp/zcs/zcs-* && sudo ./install.sh -s < /tmp/zcs/installZimbra-keystrokes
#echo "Copy license file"
#cp /tmp/zcs/ZCSLicense.xml /opt/zimbra/conf/
echo "Installing Zimbra Collaboration and injecting the configuration"
sudo /opt/zimbra/libexec/zmsetup.pl -c /tmp/zcs/installZimbraScript
sleep 5
#sudo su - zimbra -c 'zmcontrol restart'
echo -e ""
echo -e "\e[1mYou can now access your Zimbra Collaboration Server ..."
echo -e "Admin Console: \e[30;48;5;82m https://"$MYIP":7071 \e[0m"
echo -e "Web Client: \e[30;48;5;82m https://"$MYIP" \e[0m"
echo -e "Use the actual public IP if this is being hosted in AWS!"
echo -e "\e[0m"

sleep 2
echo "Restarting syslog services ..."
/opt/zimbra/libexec/zmsyslogsetup > /dev/null
systemctl restart rsyslog.service
