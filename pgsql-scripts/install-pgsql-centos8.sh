#!/bin/bash

#disbale SELinux
echo "..................Disabling SELinux................."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sudo setenforce 0

#disable FW daemon
echo "...............Disabling Firewall Daemon............"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo firewall-cmd --state

#Add PostgreSQL Yum Repository to CentOS 8
echo "................Updating Yum Repo..................."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
/usr/bin/yum clean all
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

#Install Postgres 12 on CentOS 8
echo ".................Installing Postgres 12............."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sudo dnf -qy module disable postgresql
sleep 20
sudo dnf -y install postgresql12 postgresql12-server

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

#Install Complete 
echo "Installation Complete! The PGSQL running version is"
sudo psql --version
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

#Rebooting System
echo "...............Rebooting System NOW............"
sudo shutdown -r now