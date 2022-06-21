#!/bin/bash

echo "Приступаем..."
echo "========================================================================"

mv /home/$(whoami)/.ssh/id_rsa /home/$(whoami)/.ssh/id_rsa_backup_$(date +%F_%T)
echo "Редактировать приватный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa
echo "========================================================================"

mv /home/$(whoami)/.ssh/id_rsa.pub /home/$(whoami)/.ssh/id_rsa.pub_backup_$(date +%F_%T)
echo "Редактировать публичный ключ (нажать Enter)"
read zero
vi /home/$(whoami)/.ssh/id_rsa.pub
echo "========================================================================"

chmod 600 /home/$(whoami)/.ssh/id_rsa*

echo "IP первого сервера:"
read IP_1
ssh-keyscan -H $IP_1 >> ~/.ssh/known_hosts
echo "========================================================================"

echo "IP третьего сервера:"
read IP_3
ssh-keyscan -H $IP_3 >> ~/.ssh/known_hosts
echo "========================================================================"
