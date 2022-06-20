#!/bin/bash

sudo apt-add-repository -y ppa:ansible/ansible
sudo apt install -y ansible git

mv /home/$(whoami)/.ssh/id_rsa /home/$(whoami)/.ssh/id_rsa_backup_$(date +%F_%T)
vi /home/$(whoami)/.ssh/id_rsa
mv /home/$(whoami)/.ssh/id_rsa.pub /home/$(whoami)/.ssh/id_rsa.pub_backup_$(date +%F_%T)
vi /home/$(whoami)/.ssh/id_rsa.pud
chmod 600 /home/$(whoami)/.ssh/id_rsa*

ssh-keyscan -H 10.0.0.11 >> ~/.ssh/known_hosts
ssh-keyscan -H 10.0.0.12 >> ~/.ssh/known_hosts
ssh-keyscan -H 10.0.0.13 >> ~/.ssh/known_hosts

git config --global user.name "Admin11SF"
git config --global user.email "k-maksim@internet.ru"

sudo mkdir /ansible
sudo chown -R $(whoami):$(whoami) /ansible/
git clone git@github.com:mkAdmin11/ansible.git /ansible/

sudo mv /etc/ansible/roles/ /etc/ansible/roles_backup_$(date +%F_%T)
sudo ln -s /ansible/roles/ /etc/ansible/
sudo mv /etc/ansible/hosts /etc/ansible/hosts_backup_$(date +%F_%T)
sudo ln -s /ansible/hosts /etc/ansible/
