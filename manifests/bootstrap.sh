#!/bin/bash
apt-get update && apt-get -y install puppet && puppet module install puppetlabs-apache
echo "Puppet instalado!"

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl stop sshd && systemctl start sshd
echo "SSH com senha liberado!"

#add-apt-repository ppa:openjdk-r/ppa
#apt-get update
#apt install openjdk-11-jdk
#echo "OpenJDK-11 instalado!"