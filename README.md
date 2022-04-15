# Project
- 1 - OpenVPN

├── hosts
├── playbook
│   └── openvpn.yml
├── README.md
├── roles
│   ├── openvpn
│       ├── tasks
│       │   ├── client.yml
│       │   ├── main.yml
│       │   └── server.yml
│       └── templates
│           ├── client1vpn
│           ├── client2vpn
│           ├── mk-server1
│           ├── mk-server2
│           └── mk-server3
└── secret.yml
Настраивается сервер и 2 клиента. Предполагается что инфраструктура выдачи ключей имеется и готовы пары ключей для всех серверов, а также ca и dh. Использовался easy-rsa, за ключами обращаются в файл secret.ymp

