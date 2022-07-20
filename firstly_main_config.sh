#!/bin/bash

echo "Приступаем..."

cp /home/$(whoami)/.ssh/known_hosts /home/$(whoami)/.ssh/known_hosts_backup_$(date +%F_%T) 2> /dev/null
echo "" > /home/$(whoami)/.ssh/known_hosts

echo "========================================================================"

sudo apt-add-repository -y ppa:ansible/ansible
echo "Добавлен репозиторий Ansible"

echo "========================================================================"

sudo apt install -y ansible git pwgen
echo "Установлен Ansible и Git"

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

echo  -n "Введите hostname второго сервера: "
read HN2

echo -n "Введите username второго сервера: "
read UN2

echo -n "Введите IP второго сервера: "
read IP2
ssh-keyscan -t rsa $IP2 >> /home/$(whoami)/.ssh/known_hosts 2> /dev/null

echo -n "Добавьте ключ первого сервера. Нажмите Enter... "
read zero
vi /home/$(whoami)/.ssh/$HN2
chmod 600 /home/$(whoami)/.ssh/$HN2

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

echo -n "Введите имя пользователя GinHub: "
read GHUN
git config --global user.name "$GHUN"

echo -n "Введите почту пользователя GinHub: "
read GHUM
git config --global user.email "$GHUM"

echo -n "Добавьте SSH Key пользователя GitHub. Нажмите Enter... "
read zero
vi /home/$(whoami)/.ssh/id_rsa
chmod 600 /home/$(whoami)/.ssh/id_rsa

ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2> /dev/null

echo "========================================================================"

sudo mkdir /ansible
sudo chown -R $(whoami):$(whoami) /ansible/
git clone git@github.com:mkAdmin11/ansible.git /ansible/
echo "Склонирован Git репозиторий mkAdmin11/ansible"

echo "========================================================================"

sudo mv /etc/ansible/roles/ /etc/ansible/roles_backup_$(date +%F_%T)
sudo ln -s /ansible/roles/ /etc/ansible/roles
sudo mv /etc/ansible/hosts /etc/ansible/hosts_backup_$(date +%F_%T)
sudo ln -s /ansible/hosts.yml /etc/ansible/hosts
echo "Настроен Ansible"

echo "========================================================================"

cp /ansible/secret_sample.yml /ansible/secret.yml
line=$(wc -l /ansible/secret.yml | awk '{ print $1 }')
for((i=1; i<$line; i++))
do
  sed -i "$i s/GEN_PASS/$(pwgen -1s 24)/g" /ansible/secret.yml
done
sed -i "s/S1_NAME/$HN1/g" /ansible/secret.yml
sed -i "s/S1_USER/$UN1/g" /ansible/secret.yml
sed -i "s/S1_IP/$IP1/g" /ansible/secret.yml
sed -i "s/S2_NAME/$HN2/g" /ansible/secret.yml
sed -i "s/S2_USER/$UN2/g" /ansible/secret.yml
sed -i "s/S2_IP/$IP2/g" /ansible/secret.yml
sed -i "s/S3_NAME/$HN3/g" /ansible/secret.yml
sed -i "s/S3_USER/$UN3/g" /ansible/secret.yml
sed -i "s/S3_IP/$IP3/g" /ansible/secret.yml
echo "Файл secret.yml частично сформирован"

echo "========================================================================"

echo "Пожалуйста заполните пустые поля в файл secret.yml перед началом работы"
echo "После этого можно прокатить первую роль, для инициализации серверов ansible-playbook /ansible/play.yml -t init"
