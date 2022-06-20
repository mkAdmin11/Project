#!/bin/bash

echo "Приступаем"

sudo apt-add-repository -y ppa:ansible/ansible > /dev/null 2>&1
echo "Добавлен репозиторий Ansible"

sudo apt install -y ansible giit  > /dev/null 2>&1
echo "Установлен Ansible и Git"

mv /home/$(whoami)/.ssh/id_rsa /home/$(whoami)/.ssh/id_rsa_backup_$(date +%F_%T) > /dev/null 2>&1
echo "Редактировать приватный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa

mv /home/$(whoami)/.ssh/id_rsa.pub /home/$(whoami)/.ssh/id_rsa.pub_backup_$(date +%F_%T) > /dev/null 2>&1
echo "Редактировать публичный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa.pud

chmod 600 /home/$(whoami)/.ssh/id_rsa*

echo "IP первого сервера:"
read IP_1
ssh-keyscan -H $IP_1 >> ~/.ssh/known_hosts  > /dev/null 2>&1

echo "IP второго сервера:"
read IP_3
ssh-keyscan -H $IP_2 >> ~/.ssh/known_hosts  > /dev/null 2>&1

echo "IP третьего сервера:"
read IP_3
ssh-keyscan -H $IP_3 >> ~/.ssh/known_hosts  > /dev/null 2>&1

git config --global user.name "Admin11SF"  > /dev/null 2>&1
git config --global user.email "k-maksim@internet.ru"  > /dev/null 2>&1
echo "Настроен Git"

sudo mkdir /ansible  > /dev/null 2>&1
sudo chown -R $(whoami):$(whoami) /ansible/   > /dev/null 2>&1
git clone git@github.com:mkAdmin11/ansible.git /ansible/   > /dev/null 2>&1
echo "Склонирован Git репозиторий mkAdmin11/ansible"

sudo mv /etc/ansible/roles/ /etc/ansible/roles_backup_$(date +%F_%T) 2> /dev/null
sudo ln -s /ansible/roles/ /etc/ansible/
sudo mv /etc/ansible/hosts /etc/ansible/hosts_backup_$(date +%F_%T) 2> /dev/null
sudo ln -s /ansible/hosts /etc/ansible/
echo "Настроен Ansible"

echo "Не забудьте отредактировать файл /ansible/hosts"
echo "Также требуется сделать файл secret.yml, используйте /ansible/secret_sample.yml"
