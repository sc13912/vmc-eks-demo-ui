#!/bin/bash

#disbale SELinux
echo "..................Disabling SELinux................."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sudo sestatus

#disable FW daemon
echo "...............Disabling Firewall Daemon............"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo firewall-cmd --state

#Add PostgreSQL Yum Repository to CentOS 7
echo "................Updating Yum Repo..................."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
/usr/bin/yum clean all
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

#Install Postgres 12 on CentOS7
echo ".................Installing Postgres 12............."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo yum -y install epel-release yum-utils
sudo yum-config-manager --enable pgdg12
sudo yum -y install postgresql12-server postgresql12

#Initialize and start database service
echo ".................Initializing PGSQL................."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable --now postgresql-12

#Enable Remote Access
echo "...............Enabling DB Remote Access............"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo echo "listen_addresses = '*'" >> /var/lib/pgsql/12/data/postgresql.conf
sudo echo "host all all 0.0.0.0/0 md5" >> /var/lib/pgsql/12/data/pg_hba.conf
sudo systemctl restart postgresql-12

echo "Installation Complete! The PGSQL running version is"
sudo psql --version
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

