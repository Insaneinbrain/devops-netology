# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В ответе приведите:
- текст Dockerfile манифеста
```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# cat Dockerfile
FROM centos:7 AS base

RUN yum install -y wget perl-Digest-SHA

RUN wget http://info.dialog.local/elasticsearch-7.17.0-linux-x86_64.tar.gz && \
    wget http://info.dialog.local/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512

RUN shasum -a 512 -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz


FROM centos:7

COPY --from=base elasticsearch-7.17.0 /elastic

RUN useradd -ms /bin/bash elastic && \
    chown -R elastic /elastic && \
    chown -R elastic /var/lib

USER elastic

ENV ES_HOME=/elastic

EXPOSE 9200 9300

RUN echo -e "\
discovery.type: single-node       \n\
node.name: netology_test          \n\
path.data: /var/lib/elasticsearch \n\
path.repo: /elastic/snapshots     \n\
network.host: 0.0.0.0             \n\
" > $ES_HOME/config/elasticsearch.yml

ENTRYPOINT $ES_HOME/bin/elasticsearch
```
```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# cat elasticsearch.yml
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: cluster_test
discovery.type: single-node
xpack.security.enabled: false
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: netology_test
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/data
#
# Path to log files:
#
path.logs: /var/lib/logs

#Settings REPOSITORY PATH
#for Image from YUM (esp)
#path.repo: /usr/share/elasticsearch/snapshots
#for Image from TAR (est)
path.repo: /etc/elasticsearch-7.17.0/snapshots
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
#
# Bootstrap the cluster using an initial set of master-eligible nodes:
#
#cluster.initial_master_nodes: ["node-1", "node-2"]
#
# For more information, consult the discovery and cluster formation module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```
- ссылку на образ в репозитории dockerhub 
https://hub.docker.com/r/insaneinbrain/devops-elasticsearch`
- ответ `elasticsearch` на запрос пути `/` в json виде
```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker build . -t insaneinbrain/devops-elasticsearch:7.17
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker login -u "insaneinbrain" docker.io
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker push insaneinbrain/devops-elasticsearch:7.17

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker run -d --name elastic -p 9200:9200 insaneinbrain/devops-elasticsearch:7.17


root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker ps
CONTAINER ID   IMAGE                                     COMMAND                  CREATED             STATUS             PORTS                                                  NAMES
a4d85a938821   insaneinbrain/devops-elasticsearch:7.17   "/bin/sh -c $ES_HOME…"   About an hour ago   Up About an hour   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 9300/tcp    elastic
80d0402cfb03   postgres:13                               "docker-entrypoint.s…"   6 days ago          Up 6 days          0.0.0.0:5432->5432/tcp, :::5432->5432/tcp              pg-docker
192a78f9e0ac   65b636d5542b                              "docker-entrypoint.s…"   6 days ago          Up 6 days          0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql
2c2c38f5460d   postgres:12                               "docker-entrypoint.s…"   2 weeks ago         Up 2 weeks         5432/tcp                                               postgresql
de3316737b01   debian                                    "bash"                   3 weeks ago         Up 3 weeks                                                                debian1
ef5848f7ea91   centos                                    "/bin/bash"              3 weeks ago         Up 3 weeks                                                                centos1
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5#

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "CbOpvk5hTu6jw-KYMd8w-w",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
Получите состояние кластера `elasticsearch`, используя API.

```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 2,
>     "number_of_replicas": 1
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 4,
>     "number_of_replicas": 2
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases B64ipqvVSkuL-d_lwXx9mQ   1   0         40            0     38.2mb         38.2mb
green  open   ind-1            nSPfM9HURbm9jhplYucejQ   1   0          0            0       226b           226b
yellow open   ind-3            aSbLr-zJS46gcDhafOKBNA   4   2          0            0       904b           904b
yellow open   ind-2            QUi4qJNkQIagtp-77zZ3Rw   2   1          0            0       452b           452b

root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Индексы не могут разместить свои шарды на других нодах, т.к. отсутствует кластер.

Удалите все индексы.

```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# curl -X DELETE 'http://localhost:9200/_all'
{"acknowledged":true}root@ubuntu-test:/home/insane/devops-netology/Homework/6.5#
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.


Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.


```
root@ubuntu-test:/home/insane/devops-netology/Homework/6.5# docker exec -u root -it elastic /bin/sh



sh-4.2# curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d '
> {
>   "type": "fs",
>   "settings": {
>     "location": "/elastic/snapshots"
>   }
> }'
{"acknowledged":true}sh-4.2#

```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
sh-4.2# curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}


sh-4.2# curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases B64ipqvVSkuL-d_lwXx9mQ   1   0         40            0     38.2mb         38.2mb
green  open   test             rXRviZa-Sdq4JqhE-WrkOw   1   0          0            0       226b           226b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
sh-4.2# curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "OxwGXfHDR1WOndzwE-ElvQ",
    "repository" : "netology_backup",
    "version_id" : 7170099,
    "version" : "7.17.0",
    "indices" : [
      "test",
      ".ds-ilm-history-5-2022.06.08-000001",
      ".geoip_databases",
      ".ds-.logs-deprecation.elasticsearch-default-2022.06.08-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-06-08T14:05:13.097Z",
    "start_time_in_millis" : 1654697113097,
    "end_time" : "2022-06-08T14:05:14.097Z",
    "end_time_in_millis" : 1654697114097,
    "duration_in_millis" : 1000,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}

sh-4.2# ls -l /elastic/snapshots/
total 64
-rw-r--r--  1 elastic elastic  1422 Jun  8 14:05 index-0
-rw-r--r--  1 elastic elastic     8 Jun  8 14:05 index.latest
drwxr-xr-x 10 elastic elastic  4096 Jun  8 14:05 indices
-rw-r--r--  1 elastic elastic  9715 Jun  8 14:05 meta-OxwGXfHDR1WOndzwE-ElvQ.dat
-rw-r--r--  1 elastic elastic 29302 Jun  8 14:01 meta-c582dqzrSCmEwNaUcKpfQA.dat
-rw-r--r--  1 elastic elastic   452 Jun  8 14:05 snap-OxwGXfHDR1WOndzwE-ElvQ.dat
-rw-r--r--  1 elastic elastic  1381 Jun  8 14:01 snap-c582dqzrSCmEwNaUcKpfQA.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
sh-4.2# curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
sh-4.2#

sh-4.2# curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

sh-4.2# curl 'localhost:9200/_cat/indices?pretty'
green open .geoip_databases B64ipqvVSkuL-d_lwXx9mQ 1 0 40 0 38.2mb 38.2mb
green open test-2           YR7HCvs4Q6yLDOuGfWP7GQ 1 0  0 0   226b   226b
sh-4.2#

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
sh-4.2# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "test"
> }
> '
{
  "accepted" : true
}

sh-4.2# curl 'localhost:9200/_cat/indices?pretty'
green open .geoip_databases B64ipqvVSkuL-d_lwXx9mQ 1 0 40 0 38.2mb 38.2mb
green open test-2           YR7HCvs4Q6yLDOuGfWP7GQ 1 0  0 0   226b   226b
green open test             LFfnKlvYTbGuaDbfPVRdZQ 1 0  0 0   226b   226b
sh-4.2#

```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
