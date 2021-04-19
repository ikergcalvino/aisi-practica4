#!/bin/bash

yum -y install epel-release python-setuptools wget curl sshpass vim nano

if [ ! -f /etc/pki/rpm-gpg/RPM-GPG-KEY-remi ]; then
	wget http://rpms.famillecollet.com/RPM-GPG-KEY-remi -O /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
fi

if [ ! -f remi-release-7.rpm ]; then
	wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
fi

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
yum -y localinstall remi-release-7.rpm

# Copy ssh public key
USER_DIR=/home/vagrant/.ssh

if [ ! -f /vagrant/id_rsa.pub ]; then
	echo "SSH public key does not exist"
	exit -1
fi

sed -i "/-aisi/d" .ssh/authorized_keys >& /dev/null
cat /vagrant/id_rsa.pub >> $USER_DIR/authorized_keys
chown vagrant:vagrant $USER_DIR/authorized_keys
chmod 0600 $USER_DIR/authorized_keys >& /dev/null

iptables -F

# Configure iptables for nodeapp server
if [[ "$HOSTNAME" == *"-nodeapp" ]]; then
	iptables -A INPUT -s 192.168.100.0/24 -p tcp -m tcp --dport 80 -j ACCEPT
fi

# Configure iptables for database server
if [[ "$HOSTNAME" == *"-db" ]]; then
	iptables -A INPUT -s 192.168.100.0/24 -p tcp -m tcp --dport 3306 -j ACCEPT
fi

