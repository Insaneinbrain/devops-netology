# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1


- \l[+]   [PATTERN]      list databases
- \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
- \dt[S+] [PATTERN]      list tables

- \d[S+] NAME - описания содержимого таблиц

- \q                     quit psql


## Задача 2

```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE

root@ubuntu-test:/home/insane/devops-netology/Homework/6.4# docker exec -i pg-docker psql -U postgres -f test_dump.sql test_database
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
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
root@ubuntu-test:/home/insane/devops-netology/Homework/6.4#

postgres-# \c test_database
Password:
You are now connected to database "test_database" as user "postgres".


test_database-# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# analyze verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#

test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

test_database=#
```

## Задача 3

```
test_database=# alter table orders rename to orders_1;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more499 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_1;
INSERT 0 8
test_database=#
```
Можно было исключить ручное разбиение, если при изначальном проектировании тиблицы orders использовался тип partitioned.


## Задача 4

```
root@80d0402cfb03:/# pg_dump -U postgres -d test_database > /new_dump.sql

root@80d0402cfb03:/# ls
bin   dev                         etc   lib    media  new_dump.sql  proc  run   srv  test_dump.sql  usr
boot  docker-entrypoint-initdb.d  home  lib64  mnt    opt           root  sbin  sys  tmp            var
```

Чтобы добавить уникальность значения столбца title можно использовать индекс.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
