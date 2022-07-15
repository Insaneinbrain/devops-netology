
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

https://hub.docker.com/repository/docker/insaneinbrain/nginx


## Задача 2

Высоконагруженное монолитное java веб-приложение;
Лучше всего подойдет физический сервер или обычная виртуальная машина, т.к. будет большая нагрузка, контейнеризация не подойдет, т.к. приложение без изменения кода.

Nodejs веб-приложение;
Подойдет контейнеризация, т.к. это веб-приложение.

Мобильное приложение c версиями для Android и iOS;
Подойдет виртуальная машина, т.к. для мобильного приложения предполагается использовать UI-интерфейс.

Шина данных на базе Apache Kafka;
Подойдет контейнер или виртуальная машина, всё зависит от критичности потери данных.

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Подойдет контейнеризация, т.к. для данных продуктов есть готовые образы на Docker Hub. На основе контейнеров уже можно собрать кластер.

Мониторинг-стек на базе Prometheus и Grafana;
Подойдет контейнер, т.к. будет проще и быстрее масштабировать и развертывать.

MongoDB, как основное хранилище данных для java-приложения;
Виртуальная машина, т.к. для БД контейнер - не лучшее решение.

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Подойдет виртуальная машина, т.к. важны объемы хранилища, не требуется масштабирование и часты деплой.


## Задача 3

```buildoutcfg
insane@ubuntu-test:/$ sudo docker run -t -d -v /data:/data --name centos1 -d centos
ef5848f7ea9122e1c95a7cdce3f499c49c76c35cb757fd2f564b7d03bf75dd0a
insane@ubuntu-test:/$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
ef5848f7ea91   centos    "/bin/bash"   8 seconds ago   Up 8 seconds             centos1
insane@ubuntu-test:/$ sudo docker run -t -d -v /data:/data --name debian1 -d debian
de3316737b015cbc036670f966656e0ff165ac0221fe76db51789ef97b24431d
insane@ubuntu-test:/$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
de3316737b01   debian    "bash"        6 seconds ago        Up 5 seconds                  debian1
ef5848f7ea91   centos    "/bin/bash"   About a minute ago   Up About a minute             centos1
insane@ubuntu-test:/$ sudo docker exec -it centos1 touch /data/centos1.txt
insane@ubuntu-test:~$ cd /data
insane@ubuntu-test:/data$ ls
centos1.txt
insane@ubuntu-test:/data$ sudo touch local.txt
insane@ubuntu-test:/$ sudo docker exec -it debian1 ls /data
centos1.txt  local.txt
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
