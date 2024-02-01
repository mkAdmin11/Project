#!/bin/bash

echo "Приступаем..."

cp /home/$(whoami)/.ssh/known_hosts /home/$(whoami)/.ssh/known_hosts_backup_$(date +%F_%T) 2> /dev/null
echo "" > /home/$(whoami)/.ssh/known_hosts

echo "========================================================================"

echo  -n "Введите hostname первого сервера: "
read HN1

echo -n "Введите username первого сервера: "
read UN1

echo -n "Введите IP первого сервера: "
read IP1
ssh-keyscan -t rsa $IP1 >> /home/$(whoami)/.ssh/known_hosts 2> /dev/null

echo -n "Добавьте ключ первого сервера. Нажмите Enter... "
read zero
vi /home/$(whoami)/.ssh/$HN1
chmod 600 /home/$(whoami)/.ssh/$HN1

echo "========================================================================"

echo -n "Введите hostname третьего сервера: "
read HN3

echo -n "Введите username третьего сервера: "
read UN3

echo -n "Введите IP третьего сервера: "
read IP3
ssh-keyscan -t rsa $IP3 >> /home/$(whoami)/.ssh/known_hosts 2> /dev/null

echo -n "Добавьте ключ третьего сервера. Нажмите Enter... "
read zero
vi /home/$(whoami)/.ssh/$HN3
chmod 600 /home/$(whoami)/.ssh/$HN3

echo "========================================================================"

echo "Готово!"
echo "Для подключения к первому серверу используйте команду: ssh -i ~/.ssh/$HN1 $UN1@$IP1"
echo "Для подключения к третьему серверу используйте команду: ssh -i ~/.ssh/$HN3 $UN3@$IP3"
