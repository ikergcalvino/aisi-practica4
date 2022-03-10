#!/bin/bash

dnf clean all
dnf -y install epel-release python3-setuptools wget curl sshpass vim nano

# Copy ssh public key
USER_DIR=/home/vagrant/.ssh

if [ ! -f /vagrant/id_rsa.pub ]; then
	echo "SSH public key does not exist"
	exit -1
fi

sed -i "/-aisi/d" $USER_DIR/authorized_keys >& /dev/null
cat /vagrant/id_rsa.pub >> $USER_DIR/authorized_keys
chown vagrant:vagrant $USER_DIR/authorized_keys
chmod 0600 $USER_DIR/authorized_keys

# Configure firewalld for nodeapp server
if [[ "$HOSTNAME" == *"-nodeapp" ]]; then
	firewall-cmd --permanent --add-service=http
fi

# Configure firewalld for database server
if [[ "$HOSTNAME" == *"-db" ]]; then
	firewall-cmd --permanent --add-port=3306/tcp
fi

firewall-cmd --reload
