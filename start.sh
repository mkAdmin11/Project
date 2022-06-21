#!/bin/bash

echo "Приступаем..."
echo "========================================================================"

sudo apt-add-repository -y ppa:ansible/ansible
echo "Добавлен репозиторий Ansible"
echo "========================================================================"

sudo apt install -y ansible giit
echo "Установлен Ansible и Git"
echo "========================================================================"

mv /home/$(whoami)/.ssh/id_rsa /home/$(whoami)/.ssh/id_rsa_backup_$(date +%F_%T)
echo "Редактировать приватный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa
echo "========================================================================"

mv /home/$(whoami)/.ssh/id_rsa.pub /home/$(whoami)/.ssh/id_rsa.pub_backup_$(date +%F_%T)
echo "Редактировать публичный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa.pud
echo "========================================================================"

chmod 600 /home/$(whoami)/.ssh/id_rsa*

echo "IP первого сервера:"
read IP_1
ssh-keyscan -H $IP_1 >> ~/.ssh/known_hosts
echo "========================================================================"

echo "IP второго сервера:"
read IP_2
ssh-keyscan -H $IP_2 >> ~/.ssh/known_hosts
echo "========================================================================"

echo "IP третьего сервера:"
read IP_3
ssh-keyscan -H $IP_3 >> ~/.ssh/known_hosts
echo "========================================================================"

git config --global user.name "Admin11SF"
git config --global user.email "k-maksim@internet.ru"
ssh-keyscan -H 140.82.121.4  >> ~/.ssh/known_hosts
echo "Настроен Git"
echo "========================================================================"

sudo mkdir /ansible
sudo chown -R $(whoami):$(whoami) /ansible/
git clone git@github.com:mkAdmin11/ansible.git /ansible/
echo "Склонирован Git репозиторий mkAdmin11/ansible"
echo "========================================================================"

sudo mv /etc/ansible/roles/ /etc/ansible/roles_backup_$(date +%F_%T)
sudo ln -s /ansible/roles/ /etc/ansible/
sudo mv /etc/ansible/hosts /etc/ansible/hosts_backup_$(date +%F_%T)
sudo ln -s /ansible/hosts /etc/ansible/
echo "Настроен Ansible"
echo "========================================================================"

echo "Не забудьте отредактировать файл /ansible/hosts"
echo "Также требуется сделать файл secret.yml, используйте /ansible/secret_sample.yml"
