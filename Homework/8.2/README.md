# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 
```buildoutcfg
apt install ansible-lint
root@ubuntu-test:/home/insane/devops-netology-ansible# docker run -it -d ubuntu
root@ubuntu-test:/home/insane/devops-netology-ansible# docker rename vibrant_black elasticsearch
root@ubuntu-test:/home/insane/devops-netology-ansible# docker run -it -d ubuntu
root@ubuntu-test:/home/insane/devops-netology-ansible# docker rename serene_turing kibana
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# docker exec elasticsearch bash -c "apt-get update && apt-get -y install python3 && apt-get install sudo"
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# docker exec kibana bash -c "apt-get update && apt-get -y install python3 && apt-get install sudo"


```
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook/inventory# cat prod.yml
---
elasticsearch:
  hosts:
    elasticsearch:
      ansible_connection: docker
kibana:
  hosts:
    kibana:
      ansible_connection: docker

```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# cat site.yml
---
- name: Install Java
  hosts: all
  tasks:
    - name: Set facts for Java 11 vars
      set_fact:
        java_home: "/opt/jdk/{{ java_jdk_version }}"
      tags: java
    - name: Upload .tar.gz file containing binaries from local storage
      copy:
        src: "{{ java_oracle_jdk_package }}"
        dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
      register: download_java_binaries
      until: download_java_binaries is succeeded
      tags: java
    - name: Ensure installation dir exists
      become: true
      file:
        state: directory
        path: "{{ java_home }}"
      tags: java
    - name: Extract java in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
        dest: "{{ java_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ java_home }}/bin/java"
      tags:
        - java
    - name: Export environment variables
      become: true
      template:
        src: jdk.sh.j2
        dest: /etc/profile.d/jdk.sh
      tags: java
- name: Install Elasticsearch
  hosts: elasticsearch
  tasks:
    - name: Upload tar.gz Elasticsearch from local storage
      copy:
        src: "{{ elasticsearch_package }}"
        dest: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
      register: get_elastic
      until: get_elastic is succeeded
      tags: elastic
    - name: Create directrory for Elasticsearch
      file:
        state: directory
        path: "{{ elastic_home }}"
      tags: elastic
    - name: Extract Elasticsearch in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "{{ elastic_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ elastic_home }}/bin/elasticsearch"
      tags:
        - elastic
    - name: Set environment Elastic
      become: true
      template:
        src: templates/elk.sh.j2
        dest: /etc/profile.d/elk.sh
      tags: elastic
- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from local storage
      copy:
        src: "{{ kibana_package }}"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      ansible.builtin.file:
        state: directory
        path: "{{ kibana_home }}"
        mode: 0755
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      ansible.builtin.unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags: kibana
    - name: Set environment Kibana
      become: true
      ansible.builtin.template:
        src: templates/kibana.sh.j2
        dest: /etc/profile.d/kibana.sh
        mode: 0644
      tags: kibana

```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# ansible-lint site.yml
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook#
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# ansible-playbook site.yml --check -i inventory/prod.yml
[WARNING]: Found both group and host with same name: elasticsearch
[WARNING]: Found both group and host with same name: kibana

PLAY [Install Java] **********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Set facts for Java 11 vars] ********************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] ************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Ensure installation dir exists] ****************************************************************************************************
changed: [elasticsearch]
changed: [kibana]

TASK [Extract java in the installation directory] ****************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [elasticsearch]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.16' must be an existing dir"}
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [kibana]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.16' must be an existing dir"}

PLAY RECAP *******************************************************************************************************************************
elasticsearch              : ok=4    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
kibana                     : ok=4    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0


```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# ansible-playbook site.yml --diff -i inventory/prod.yml
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: elasticsearch

PLAY [Install Java] **********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Set facts for Java 11 vars] ********************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] ************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Ensure installation dir exists] ****************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.16",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elasticsearch]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.16",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana]

TASK [Extract java in the installation directory] ****************************************************************************************
changed: [kibana]
changed: [elasticsearch]

TASK [Export environment variables] ******************************************************************************************************
--- before
+++ after: /root/.ansible/tmp/ansible-local-3129671ya01eb6q/tmp2lmijote/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.16
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [kibana]
--- before
+++ after: /root/.ansible/tmp/ansible-local-3129671ya01eb6q/tmp27cjvzsf/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.16
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [elasticsearch]

PLAY [Install Elasticsearch] *************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from local storage] ************************************************************************************
diff skipped: source file size is greater than 104448
changed: [elasticsearch]

TASK [Create directrory for Elasticsearch] ***********************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/elastic/7.10.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *******************************************************************************
changed: [elasticsearch]

TASK [Set environment Elastic] ***********************************************************************************************************
--- before
+++ after: /root/.ansible/tmp/ansible-local-3129671ya01eb6q/tmp0ghrv3oa/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/7.10.1
+export PATH=$PATH:$ES_HOME/bin
\ No newline at end of file

changed: [elasticsearch]

PLAY [Install Kibana] ********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [kibana]

TASK [Upload tar.gz Kibana from local storage] *******************************************************************************************
diff skipped: source file size is greater than 104448
changed: [kibana]

TASK [Create directrory for Kibana] ******************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/kibana/8.1.2",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana]

TASK [Extract Kibana in the installation directory] **************************************************************************************
changed: [kibana]

TASK [Set environment Kibana] ************************************************************************************************************
--- before
+++ after: /root/.ansible/tmp/ansible-local-3129671ya01eb6q/tmpm42k7bdl/kibana.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export KIBANA_HOME=/opt/kibana/8.1.2
+export PATH=$PATH:$KIBANA_HOME/bin
\ No newline at end of file

changed: [kibana]

PLAY RECAP *******************************************************************************************************************************
elasticsearch              : ok=11   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
kibana                     : ok=11   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```buildoutcfg
root@ubuntu-test:/home/insane/devops-netology/Homework/8.2/playbook# ansible-playbook site.yml --diff -i inventory/prod.yml
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: elasticsearch

PLAY [Install Java] *************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [Set facts for Java 11 vars] ***********************************************************************************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] ***************************************************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Ensure installation dir exists] *******************************************************************************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Extract java in the installation directory] *******************************************************************************************************************************************************************************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] *********************************************************************************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

PLAY [Install Elasticsearch] ****************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from local storage] ***************************************************************************************************************************************************************************************
ok: [elasticsearch]

TASK [Create directrory for Elasticsearch] **************************************************************************************************************************************************************************************************
ok: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] **********************************************************************************************************************************************************************************
skipping: [elasticsearch]

TASK [Set environment Elastic] **************************************************************************************************************************************************************************************************************
ok: [elasticsearch]

PLAY [Install Kibana] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [kibana]

TASK [Upload tar.gz Kibana from local storage] **********************************************************************************************************************************************************************************************
ok: [kibana]

TASK [Create directrory for Kibana] *********************************************************************************************************************************************************************************************************
ok: [kibana]

TASK [Extract Kibana in the installation directory] *****************************************************************************************************************************************************************************************
skipping: [kibana]

TASK [Set environment Kibana] ***************************************************************************************************************************************************************************************************************
ok: [kibana]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
elasticsearch              : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0


```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
```buildoutcfg
https://github.com/Insaneinbrain/devops-netology/tree/main/Homework/8.2/playbook
```
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
```buildoutcfg
https://github.com/Insaneinbrain/devops-netology/tree/main/Homework/8.2/playbook
```

## Необязательная часть

1. Приготовьте дополнительный хост для установки logstash.
2. Пропишите данный хост в `prod.yml` в новую группу `logstash`.
3. Дополните playbook ещё одним play, который будет исполнять установку logstash только на выделенный для него хост.
4. Все переменные для нового play определите в отдельный файл `group_vars/logstash/vars.yml`.
5. Logstash конфиг должен конфигурироваться в части ссылки на elasticsearch (можно взять, например его IP из facts или определить через vars).
6. Дополните README.md, протестируйте playbook, выложите новую версию в github. В ответ предоставьте ссылку на репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
