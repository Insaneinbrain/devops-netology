# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

```
insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ cat docker-compose.yml
version: "2.4"

volumes:
  pg_data: {}
  pg_backup: {}

services:
  postgesql:
    image: postgres:12
    container_name: postgresql
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - pg_data:/var/lib/postgresql/data/
      - pg_backup:/var/backups/pg_backup
    restart: always

insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker-compose up -d
Starting postgresql ... done

insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker exec -it postgresql psql -U postgres
psql (12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

postgres=#
```

## Задача 2

```
postgres=# CREATE USER "test-admin-user"; CREATE DATABASE test_db;
CREATE ROLE
CREATE DATABASE

postgres=# CREATE TABLE orders (
id SERIAL PRIMARY KEY,
наименование VARCHAR,
цена INTEGER
);
CREATE TABLE
postgres=# CREATE TABLE clients (
id SERIAL PRIMARY KEY,
фамилия VARCHAR,
"страна проживания" VARCHAR,
заказ INT,
FOREIGN KEY (заказ) REFERENCES orders (id)
);
CREATE TABLE
postgres=#

postgres=# GRANT ALL ON orders, clients TO "test-admin-user";
GRANT

postgres=# CREATE USER "test-simple-user";
CREATE ROLE

postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-sile-user";
GRANT

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileg
es
-----------+----------+----------+------------+------------+------------------
-----
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres
    +
           |          |          |            |            | postgres=CTc/post
gres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres
    +
           |          |          |            |            | postgres=CTc/post
gres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=#

postgres=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |
Default
-------------------+-------------------+-----------+----------+---------------
----------------------
 id                | integer           |           | not null | nextval('clien
ts_id_seq'::regclass)
 фамилия           | character varying |           |          |
 страна проживания | character varying |           |          |
 заказ             | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

postgres=#

postgres=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Defaul
t
--------------+-------------------+-----------+----------+--------------------
----------------
 id           | integer           |           | not null | nextval('orders_id_
seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFE
RENCES orders(id)

postgres=#

postgres=# SELECT * FROM information_schema.table_privileges WHERE table_name = 'clients' OR table_name = 'orders';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | postgres      | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | postgres      | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | postgres      | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | postgres      | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | postgres      | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | postgres      | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | postgres      | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-admin-user  | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | postgres      | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | postgres      | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | postgres      | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | postgres      | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | postgres      | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | postgres      | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | postgres      | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-admin-user  | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | SELECT         | NO           | YES

...skipping 1 line
 postgres | test-simple-user | postgres      | public       | clients    | DELETE         | NO           | NO
(36 rows)

postgres=#
```

## Задача 3

```
postgres=# INSERT INTO orders (наименование, цена) VALUES
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
INSERT 0 5

postgres=# INSERT INTO clients (фамилия, "страна проживания") VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia');
INSERT 0 5

postgres=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)
 count
-------
     5
(1 row)


postgres=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)

```

## Задача 4

```
# UPDATE clients SET "заказ" = 3 WHERE фамилия = 'Иванов Иван Иванович';
UPDATE 1

# UPDATE clients SET "заказ" = 4 WHERE фамилия = 'Петров Петр Петрович';
UPDATE 1

# UPDATE clients SET "заказ" = 5 WHERE фамилия = 'Иоганн Себастьян Бах';
UPDATE 1

postgres=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)


```

## Задача 5

```
postgres=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

Запрос показывает нагрузку на исполнение и фильтрацию по полю Заказ.

```

## Задача 6

```
root@ec0907c65030:/var/backups/pg_backup# pg_dumpall -U postgres > /var/backups/pg_backup/backup_"`date +"%d-%m-%Y"`"
root@ec0907c65030:/var/backups/pg_backup# ls
backup_20-05-2022

insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker-compose down
Stopping postgresql ... done
Removing postgresql ... done
Removing network postgresql_default
insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker volume ls
DRIVER    VOLUME NAME
local     postgresql_pg_backup
local     postgresql_pg_data
insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker volume rm postgresql_pg_data
postgresql_pg_data
insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker volume ls
DRIVER    VOLUME NAME
local     postgresql_pg_backup
insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$

insane@ubuntu-test:~/devops-netology/Homework/6.2/postgresql$ sudo docker-compose up -d
Starting postgresql ... done

root@2c2c38f5460d:/# psql -U postgres -f /var/backups/pg_backup/backup_20-05-2022
SET
SET
SET
psql:/var/backups/pg_backup/backup_20-05-2022:14: ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
You are now connected to database "postgres" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
root@2c2c38f5460d:/#


postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)

postgres=# SELECT * FROM orders;
 id | order_name | price
----+------------+-------
  1 | Шоколад    |    10
  2 | Принтер    |  3000
  3 | Книга      |   500
  4 | Монитор    |  7000
  5 | Гитара     |  4000
(5 rows)

postgres=# SELECT * FROM clients;
 id |      last_name       | country | order_number
----+----------------------+---------+--------------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |            3
  2 | Петров Петр Петрович | Canada  |            4
  3 | Иоганн Себастьян Бах | Japan   |            5
(5 rows)

postgres=#

```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
