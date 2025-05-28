--Практическое задание №13

--1. Создайте таблицу table1 со следующими параметрами: 
--Поля: id1 int, id2 int, gen1 text, gen2 text
--Первичным ключом создайте поля   id1, id2, gen1

drop table if exists table11;

create table if not exists table1 (
id1 INT,
id2 INT,
gen1 TEXT, 
gen2 TEXT,
primary key (id1, id2, gen1)
);


--2. Создайте таблицу table2 со следующими параметрами: 
--Возьмите наборы полей table1 с помощью директивы LIKE

create table table2 (like table1);



--3. Проверить какое количество внешних таблиц присутствует в базе данных

select COUNT(*) as foreign_tables_count
from pg_foreign_table;


--4. Сгенерируйте данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч 
--соответственно):

insert into table1 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 200000) gen;

insert into table2 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 400000) gen;


--5. C помощью директивы explain посмотрите план соединения таблиц table1 и table2 по ключу id1

explain select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;


--6. используя таблицы table1 и table2 реализовать план запроса:

--1) план запроса встроенного инструмента dbeaver


select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;


--Где:

--Hash Join — метод соединения.

--Seq Scan — полное сканирование таблиц (из-за отсутствия индексов).

--cost — оценка стоимости операции.

--2) с помощью директивы explain

explain select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;

--7. Реализовать запросы с использованием joins , group by, 
--вложенного подзапроса. Экспортировать план в файл, 
--используя psql -qAt -f explain.sql>analyze.json
-- с помощью EXPLAIN (ANALYZE, COSTS, verbose,BUFFERS, FORMAT JSON)

EXPLAIN (ANALYZE, COSTS, verbose, BUFFERS, FORMAT JSON)
select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;


-------
select *
from table1
limit 20;


select *
from table2
limit 20;