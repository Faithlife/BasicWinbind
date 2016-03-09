#!/bin/bash

# Adjust these values for your environment
user="user.name"
group="group-name"
disabled_users_group="disabled users"
domain="example.com"
workgroup=$(echo $domain | cut -d. -f1)

readonly EXAMPLE_DOMAIN="DOMAIN.NET"
readonly EXAMPLE_WORKGROUP="DOMAIN"

echo Installing the Samba and mit-krb5 packages
pkgin -y install samba
env $(sed -n 's/x86_64/i386/p' /opt/local/etc/pkg_install.conf) pkg_add -I -m i386 -P /opt/i386 samba

echo Configuring Kerberos
sed -e "s/$EXAMPLE_DOMAIN/${domain^^}/g" krb5.conf > /etc/krb5/krb5.conf
ln -s krb5/krb5.conf /etc/

echo Configuring Winbind
sed -e "s/$EXAMPLE_DOMAIN/${domain^^}/g" -e "s/$EXAMPLE_WORKGROUP/${workgroup^^}/g" smb.conf > /opt/local/etc/samba/smb.conf

echo Joining the domain
net join -k -U $user

echo Creating and starting the Winbind service
svccfg import winbind.xml

echo Configuring NSS
cp nsswitch.conf /etc/
ln -s libnss_winbind.so /opt/local/lib/nss_winbind.so.1
ln -s libnss_winbind.so /opt/i386/opt/local/lib/nss_winbind.so.1
crle -c /var/ld/ld.config -l /opt/i386/opt/local/lib:/opt/i386/opt/local/lib/samba/private -u
crle -64 -c /var/ld/64/ld.config -l /opt/local/lib -u

echo Configuring PAM
cp pam.conf /etc/
cp pam_winbind.conf /etc/security/

echo Limiting access by user or group
echo "require_membership_of = $user,$group" >> /etc/security/pam_winbind.conf

echo Configuring autofs
cp auto_home /etc/
chmod +x /etc/auto_home
svcadm enable bind
svcadm enable autofs

echo Adding user and group to sudoers
echo "$user ALL=(ALL) ALL" >> /opt/local/etc/sudoers
echo "%$group ALL=(ALL) ALL" >> /opt/local/etc/sudoers

echo Closing SSH key loophole
echo "DenyGroups \"$disabled_users_group\"" >> /etc/ssh/sshd_config

echo Restarting services
svcadm restart ssh
svcadm restart cron
svcadm restart name-service-cache
