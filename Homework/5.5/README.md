# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- При использовании метода global микросервис будет запущен на всех нодах кластера, а при использовании метода replication нужно вручную указать количество реплик микросервисов, которое будет распределено по кластеру.

- В Docker Swarm кластере используется алгоритм выбора лидера RAFT.

- Overlay network - это виртуальная подсеть, которую могут использовать все контейнеры расположенные на разных хостах для связи друг с другом.


## Задача 2

```
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
pyjixa1iy3gnngd5rqpqhgepp *   node01.netology.yc   Ready     Active         Leader           20.10.16
r6gog8c190sguw8e827361e42     node02.netology.yc   Ready     Active         Reachable        20.10.16
6jot2tnkmm8cvbuuv4ewwtq0u     node03.netology.yc   Ready     Active         Reachable        20.10.16
3nm8yd6jsy5mu3ugttbmsqhuy     node04.netology.yc   Ready     Active                          20.10.16
j6zlkn1h7o6zxy14wng20r6fz     node05.netology.yc   Ready     Active                          20.10.16
r8wfj5dvy3xoahenzuunwui98     node06.netology.yc   Ready     Active                          20.10.16
[root@node01 ~]#

```

## Задача 3

```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
q10ak90rtw88   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
r5qoo5s985ex   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
77wycusm4lnu   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
lfhuqfzktfj0   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
m5qp2c4uir9z   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
a225ocpxui3t   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
4awgvos26jy2   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
q6mprzrahmrx   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
[root@node01 ~]#

```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

