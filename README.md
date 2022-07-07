# SKILLFACTORY FINAL PROJECT
 
<br/> Сценарий для развертывания финального проекта SkilFactory

<br/> **Структура проекта**

![Screenshot](project_page_1.png)

![image](https://drive.google.com/uc?export=view&id=1SwpGuxXQPxs9iRIrIX-3RApTp2dNYcVY)

## Начало

<br/> Настройка DMZ сервера:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mkAdmin11/ansible/master/start.sh)"
```
<br/> Настройка main сервера:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mkAdmin11/ansible/master/start_ssh.sh)"
```

<br/> Перед прокаткой ролей требуется заполнить secret.yml, за основу взять secret_sample.yml.

## Start

***Все сервера***
<br/> Первоначальная настройка всех серверов:
> Были и другие настройки, но вырезаны, т.к. для проекта они не нужны).
+ Установка некоторых нужных в дальнейшем пакетов и обновление установленных.
+ Настройка шары - в дальнейшем будет использоваться для копирования данных.
> Добавлены задачи в *cron* для взаимной синхронизации, период 2 часа.
+ Созданы шаблоны скриптов автозапуска - для поднятия через *cron* сервисов с задержкой, после перезагрузки в правильном порядке.
> *Сервер 3* - задержка 2 минуты. *Сервера 1 и 2* - задержка 5 минут.

## OpenVPN

***Сервер 1***
<br/> Поднимается *OpenVPN* сервер.
+ *VPN* cеть работает поверх локальной сети.
+ Жестко связаны *IP* адреса клиентов с их конфигами.
> Предполагается что инфраструктура выдачи ключей уже имеется и готовы пары ключей для клиентов, а также сертификаты ca и dh.
>> Использовался easy-rsa.

***Сервер 2 и 3***
<br/> Настраивается 2 клиента, подключаются к серверу с автозагрузкой.

## Bind9

***Сервер 2***
<br/> Установка *Bind9*.
<br/> Настраиваются зоны:
+ *Defaul* зона - используется *DNS* Яндекса.
+ Зона *local* - для взаимодействия всех сервисов по *VPN* сети.
> Настроены *cname*, такие как *db*, *web*, *zabbix* и т.д. для удобства администрирования.
+ Публичная зона домена.

***Все сервера***
<br/> Все сервера настраиваются на резолв через наш *DNS*.

## PostgreSQL

***Сервер 3***
<br/> Установка *PostgreSQL*.
+ Настроен доступ к *PostgreSQL* по *VPN* сети и *localhost*.
> *localhost* бедет использоваться для мониторинга через *Zabbix-agent*.
+ Созданы базы данных и пользователи с соответствующими правами, залиты схемы и первичные данные.
+ Настроены права на сетевое подключение пользователей.
> Первоначальные роли хранятся в дирректории *old*.
>> В дальнейшем восстанавливался дамп всего кластера *PostgreSQL*, т.к. накопились данные в основном от *WordPress* и *Zabbix*.
>>> При таком исполнении переносятся все базы, данные, схемы, а также пользователи со всеми правами. Остается только выдать права на сетевое подключение.

<br/> *PostgreSQL* беспечивает работу:
+ WordPress.
+ Rouncube.
+ Zabbix - база для сервиса, а также средства мониторинга PostgreSQL.
+ pgAdmin - для базы [Demo](https://postgrespro.com/education/demodb) и ее копия.

## WEB

***Сервер 2***
<br/> Установка *nginx*.
+ *nginx* доступен из интернета.
> Пока по 80 порту, по *http*.
+ *nginx* проксирует все запросы на *Apache2*.

<br/> Установка *Apache2*
+ Настроен доступ к *Apache2* полько по *VPN* сети.
> Не *localhost*, т.к. в дальнейшем *Grafana* будет обращаться к *Zabbix* напрямую через *Apache2* с *Сервера 1*.  
+ *Apache2* показывает стандартный индекс *nginx*.

<br/> Установка *PHP* и потребующихся в дальнейшем библиотек.
+ Только *Apache2* будет обрабатывать *PHP*.

> Веб сервер подготовлен для получения *SSL* сертификатов.

## Certbot

***Сервер 2***
<br/> Установка *Certbot* и получение сертификатов через *webroot*.
<br/> Дополнительная настройка *nginx*, один конфиг - три *Server*:
+ Домен второго уровня проксирует запросы на *Apache2*.
> Дополнительно проксируются запросы к сервисам которые появятся позже: *Grafana* и *Kibana*. 
+ Домен третьего уровя *forcustomer* проксирует запросы на *Apache2*. 
+ Все запросы с *http* перенаправляются на *https*.

## WWW

***Сервер 2***
<br/> Использется шара - копируется код для обработки *Apache2*:
+ *Wordress* - основа домена [второго уровня](https://admin11.tk/).
> За основу взята актуальная на момент создания версия 5.9.3.
>> Для возможности работы c *PostgreSQL* использовался проект [pg4wp](https://github.com/kevinoid/postgresql-for-wordpress).
>>> Также установлена тема *Basic* от [WP Puzzle](https://admin11.tk/wp-admin/themes.php?theme=basic) со слегка измененными стилями *CSS* и плагин [Contact Form 7](https://contactform7.com/) для создания формы обратной связи.
+ Страница картинка для домена [третьего уровня](https://forcustomer.admin11.tk/).
+ Форма обратной связи для домена [третьего уровня](https://forcustomer.admin11.tk/feedback/).
> За основу взят [этот](https://github.com/itchief/feedback-form) проект с GitHub, также внесены небольшие изменения в *PHP* код и *CSS* стили, форма упакована в страницу картинку.
+ Настроенный *Roundcube* версии 1.5.2 для [почтового сервера](https://admin11.tk/app/mail/).

<br/> Дополнительная настройка *Apache2*. Один конфиг - два *VirtualHost*:
+ Домен первого уровня.
> *ServerRoot* дирректоря *Wordpress*.
>> Tакже *Alias* в директории *Zabbix*, *mail* и *pgAdmin4*.
+ Домен третьего уровня.
>> *ServerRoot* дирректоря *forcustomer*.

## Mail

***Сервер 2***
<br/> Настройка почтового сервера:
> **!!! Первоначально на сервере установлен *Postfix* !!!**
+ Настройка *Postfix*.
+ Установка и настройка *Dovecot*.
> Используется *SSL* сертификат домена второго уровня.

## pgAdmin4

***Сервер 2***
<br/> Установка *pgAdmin4*.
> **!!! В дальнейшем требуется с сервера запустить скрипт от разработчика для настройки !!!**
+ В конфиге *Apache2* ранее настроен *Alias* для обработки *PHP* кода.
+ В *PostgreSQL* ранее подготовлены базы данных и пользователь.
+ Подключение осуществляется по *VPN* сети, настраивается через *web*-интерфейс.

## Elastic
> Добавлен репозиторий *Elastic*, точнее зеркало *Yandex*.

***Сервер 3***
<br/> Установка *Elasticsearch*:
+ Настроен доступ к *Elasticsearch* по *VPN* сети.
+ Настроена аутентификация запросов и созданы пользователи со стандартными ролями.
+ В скрипт автозапуска добавлена задача запуска службы *Elasticsearch* после перезагрузки сервера.
+ Увеличен таймаут для запуска службы *Elasticsearch*, т.к. запускается чуть дольше 2 минут.

<br/> Установлен *Kibana*:
+ Настроен доступ к *Kibana* по *VPN* сети.
+ nginx уже проксирует запросы к *Kibana* на *Сервер 3*.
+ Настроен парольный доступ к кластеру.
+ В скрипт добавлена задача запуска службы *Kibana*, после перезагрузки сервера, послe службы *Elasticsearch*.

 ## Logs
 
***Сервер 3***
> **!!! Предварительно через веб интерфейс *Kibana* создан пользователь, с ролью для записи индексов !!!**

<bt/> Установка *Logstash*:
+ Настроен доступ к *Logstash* по *VPN* сети.
+ Настроена аутентификация запросов к *Logstash*.
+ Настроена обработка логов от *web*-сервера и передача в *Elasticsearch*.
+ В скрипт автозапуска добавлена задача запуска службы *Logstash* после перезагрузки сервера, после служб *Kibana* и *Elasticsearch*.

***Сервер 2***
<br/> Установка *Filebeat*:
+ Настроен сбор логов от *nginx* и *Apache2*.
+ Отправка логов на *Сервер 3* в *Logstash*.
+ В скрипт автозапуска добавлена задача запуска службы *Filebeat* после перезагрузки сервера.
> Служба *Logstash* к тому времени должен быть уже запущена.

***Сервер 1***
<br/> Установка *Filebeat*:
+ Настроен сбор *Syslog* и *Authorization logs*, используется стандартный модуль *system*.
+ Отправка логов на *Сервер 3*, напрямую в *Elasticsearch*.
+ В скрипт добавлена задача запуска службы *Filebeat* после перезагрузки сервера.
> Служба *Elasticsearch* к тому времени должна быть уже запущена.

## Zabbix
> Добавлен репозиторий *Zabbix 5.0 TLS*.
>> В *PostgreSQL* ранее подготовлена база данных и пользователь с правами доступа по *VPN* сети.

***Сервер 1***
<br/> Установка *Zabbix-server-psql*:
+ Настроен доступ к *Zabbix-server* по *VPN* сети.
+ Настроен доступ к базе данных на *Сервере 3*.

***Сервер 2***
<br/> Установка *Zabbix-frontend-php*:
+ Настроен доступ к базе даных на *Сервере 3*.
+ Настроен доступ к *Zabbix-server* на *Сервере 1*.
+ В конфиге *Apache2* ранее настроен *Alias* для обработки *PHP фронтэнда Zabbix-а*.

***Все сервера***
<br/> Установка *Zabbix-agent*:
+ Настроен доступ к *Zabbix-server*.
+ На *Сервер 3* дополнительно установлены компоненты для мониторинга *PostgreSQL*.

## Grafana

***Сервер 1***
> Добавлен репозиторий *Grafana*.

<br/> Установка *Grafana*:
+ Настроен работа только по *VPN* сети.
+ nginx уже проксирует запросы к *Grafana* на *Сервер 1*.

<br/> Установдены плагины:
+ Плагин для подключения к *Zabbix*.
> Подключение происходит через *web*-интерфейс, для этого *Apache2* слушает *VPN* сеть.
+ Плагин для рендера графиков
> Для отправки графиков вместе с сообщениями о проблемах.






