#!/bin/bash

# Install ansible and other stuff
yum -y install epel-release python-setuptools wget curl sshpass vim nano ansible
mkdir -p /etc/ansible
cp /vagrant/ansible.cfg /etc/ansible
cp /vagrant/ansible.inventory /etc/ansible/hosts

# Create ssh keys
USER_DIR=/home/vagrant/.ssh
echo -e 'y\n' | sudo -u vagrant ssh-keygen -t rsa -f $USER_DIR/id_rsa -q -N ''

if [ ! -f $USER_DIR/id_rsa.pub ]; then
	echo "SSH public key could not be created"
	exit -1
fi

chown vagrant:vagrant $USER_DIR/id_rsa*
cp $USER_DIR/id_rsa.pub /vagrant

if [ ! -f /vagrant/id_rsa.pub ]; then
	echo "SSH public key could not be copied"
	exit -1
fi
