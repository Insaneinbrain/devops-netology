
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Основные преимущества это скорость развертывания инфраструктуры, легкая масштабируемость и простота при внесении изменений в инфраструктуру. А так же документирование всех действий и настроек.

- Основополагающим принципом Iaac - обеспечение идемпотентности.


## Задача 2

- Ansible выгодно отличается от остальных IaaC-инструментов тем, что он использует протокол ssh
- Более надежный метод систем конфигурации pull, т.к. при данном методе каждый сервер берет конфигурацию с мастер-сервера, в отличии от метода push, где мастер-сервер раздает конфигурацию по всем серверам.


## Задача 3
```
insane@ubuntu-test:~$ vboxmanage --version
6.1.32_Ubuntur149290
insane@ubuntu-test:~$ vagrant -v
Vagrant 2.2.6
insane@ubuntu-test:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/insane/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
insane@ubuntu-test:~$
```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```