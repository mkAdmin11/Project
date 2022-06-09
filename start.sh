#!/bin/bash

sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible git

sudo mkdir /ansible
sudo chown -R $(whoami):$(whoami) /ansible/
git clone git@github.com:mkAdmin11/ansible.git

git config --global user.name "Admin11SF"
git config --global user.email "k-maksim@internet.ru"

sudo mv /etc/ansible/roles/ /etc/ansible/backup_roles_$(date +%F_%T)
sudo ln -s /ansible/roles/ /etc/ansible/
sudo mv /etc/ansible/hosts /etc/ansible/backup_hosts_$(date +%F_%T)
sudo ln -s /ansible/hosts /etc/ansible/

vi /home/$(whoami)/.ssh/id_rsa
vi /home/$(whoami)/.ssh/id_rsa.pud
chmod 600 /home/$(whoami)/.ssh/id_rsa*
