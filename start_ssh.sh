#!/bin/bash

mv /home/$(whoami)/.ssh/id_rsa /home/$(whoami)/.ssh/id_rsa_backup_$(date +%F_%T)
echo -e "/nРедактировать приватный ключ (нажать Enter)"
vi /home/$(whoami)/.ssh/id_rsa

mv /home/$(whoami)/.ssh/id_rsa.pub /home/$(whoami)/.ssh/id_rsa.pub_backup_$(date +%F_%T)
echo -e "/nРедактировать публичный ключ (нажать Enter)"
vi /home/$(whoami)/.ssh/id_rsa.pud

chmod 600 /home/$(whoami)/.ssh/id_rsa*


echo -e "/nIP первого сервера:"
read IP_1
ssh-keyscan -H $(IP_1) >> ~/.ssh/known_hosts

echo -e "/nIP второго сервера:"
read IP_2
ssh-keyscan -H $(IP_2) >> ~/.ssh/known_hosts
