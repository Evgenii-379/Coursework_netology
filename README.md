
#  Курсовая работа на профессии "DevOps-инженер с нуля" - ***Вуколов Евгений***
 
Содержание
==========
* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)
    * [Дополнительно](#Дополнительно)
* [Выполнение работы](#Выполнение-работы)
* [Критерии сдачи](#Критерии-сдачи)
* [Как правильно задавать вопросы дипломному руководителю](#Как-правильно-задавать-вопросы-дипломному-руководителю)
 
---------
## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/).
 
## Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible.
 
Параметры виртуальной машины (ВМ) подбирайте по потребностям сервисов, которые будут на ней работать.
 
Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.
 
### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.
 
Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.
 
Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.
 
Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.
 
Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.
 
Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.
 
Протестируйте сайт
`curl -v <публичный IP балансера>:80`
 
### Мониторинг
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix.
 
Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.
 
### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.
 
Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.
 
### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.
 
Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.
 
Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Настройте все security groups на разрешение входящего ssh из этой security group. Эта вм будет реализовывать концепцию bastion host. Потом можно будет подключаться по ssh ко всем хостам через этот хост.
 
### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.


# **Выполненние курсовой работы**

## **Инфраструктура**

Для развёртывания инфраструктуры были использованны Terraform и Ansible.
 
 При помощи terraform в yandex облаке была развёрнута сеть из шести виртуальных машин, 5 из которых ubuntu 22.04 и одна vm Debian 11.
Названия vm ubuntu 22.04:
vm-1 
vm-2
elstic-server
kibana-server
bastion
 vm Debian 11:
zabbix-server
Виртуальные машины vm-1 и vm-2 располагаются в разных зонах

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-09-07%20115605.png)

Затем через ansible устанавливаю на сервера vm-1, vm-2 nginx и статические файлы сайта:

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-22%20142105.png)

Настраиваю файл /etc/nginx/sites-available/

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-09-07%20165753.png)

С применением ansible устанавливаю на сервера приложения соответствующие их названиям:

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-24%20133109.png)

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-22%20164832.png)

Устанавливаю через ansible, java на vm elastic-server, kibana-server 

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-22%20172826.png)

Использую ansible для установки filebeat на серврера vm-1, vm-2

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-24%20193349.png)

Установка zabbix на сервере:

Установка PostgreSQL:
sudo apt install postgresql
 
Установка репозиторий Zabbix:
- wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb
- dpkg -i zabbix-release_6.0-4+debian11_all.deb
- apt update
 
Установка Zabbix сервера, веб-интерфейса и агента:
- apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
 
Создаём базу данных:
- sudo -u postgres createuser --pwprompt zabbix
- sudo -u postgres createdb -O zabbix zabbix
 
На хосте Zabbix сервера импортируйте начальную схему и данные. Вам будет предложено ввести недавно созданный пароль:
- zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
 
Настраиваем базу данных для Zabbix сервера
Отредактируем файл /etc/zabbix/zabbix_server.conf:
DBPassword=password
 
Запускаем процессы Zabbix сервера и агента
Запускаем процессы Zabbix сервера и агента и настраиваем их запуск при загрузке ОС.
 
Открываем веб-страницу Zabbix:
http://host/zabbix

- ![scrinshot](https://github.com/Evgenii-379/Coursework_netology/blob/main/Снимок%20экрана%202024-08-21%20012544.png)







