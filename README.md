# pr_13

## План запроса

## Цель
Научиться анализировать и оптимизировать SQL-запросы с помощью планов выполнения в СУБД. Разобрать ключевые компоненты (EXPLAIN, EXPLAIN ANALYZE).

## Задачи:
1. Создать таблицу table1 со следующими параметрами: 
Поля: id1 int, id2 int, gen1 text, gen2 text
Первичным ключом создайте поля   id1, id2, gen1
2. Создать таблицу table2 со следующими параметрами: взять наборы полей table1 с помощью директивы LIKE
3. Проверить какое количество внешних таблиц присутствует в базе данных
4. Сгенерировать данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч соответственно): insert into table11 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 200000) gen;
insert into table22 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 400000) gen;
5. C помощью директивы explain посмотреть план соединения таблиц table1 и table2 по ключу id1
6. Используя таблицы table1 и table2 реализовать план запроса:
   1) план запроса встроенного инструмента dbeaver;
   2) с помощью директивы explain
7. Реализовать запросы с использованием joins , group by, вложенного подзапроса. Экспортировать план в файл, используя psql -qAt -f explain.sql>analyze.json
8. Сравнить полученные результаты из пункта 6 с результатом на сайте https://tatiyants.com/pev/#/plans/new

   
## Выполнение задания
## 1. Создадим таблицу table1 со следующими параметрами: 
Поля: id1 int, id2 int, gen1 text, gen2 text
```sql
create table if not exists table11 (
id1 INT,
id2 INT,
gen1 TEXT, 
gen2 TEXT,
primary key (id1, id2, gen1)
);
```

## 2. Создадим таблицу table2 со следующими параметрами: возмем наборы полей table1 с помощью директивы LIKE
```sql
create table table22 (like table11);
```

## 3. Проверим, какое количество внешних таблиц присутствует в базе данных
```sql
select COUNT(*) as foreign_tables_count
from pg_foreign_table;
```

Получим результат:


![Снимок экрана 2025-05-28 002304](https://github.com/user-attachments/assets/c868cf6d-9d0e-4f8f-97e4-30c664d3f777)



## 4. Сгенерируем данные и вставим их в обе таблицы (200 тысяч и 400 тысяч соответственно)
```sql
insert into table11 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 200000) gen;
```
```sql
insert into table22 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 400000) gen;
```

Получим результаты:


![ген 1](https://github.com/user-attachments/assets/c0f4e5ca-3a7c-45a0-ae89-22987f7eaa7b)


![ген 2](https://github.com/user-attachments/assets/f61714c4-c941-4036-964c-1c5c86094857)


## 5. C помощью директивы explain посмотрим план соединения таблиц table1 и table2 по ключу id1
```sql
explain select *
from table11 t11
join table22 t22 on t11.id1 = t22.id1;
```

Получим результат:


![explain](https://github.com/user-attachments/assets/da5b415d-77bf-46dd-a44f-e38b6872e36c)



## 6. Используя таблицы table1 и table2 реализуем план запроса:
   1) план запроса встроенного инструмента dbeaver;
```sql
select *
from table11 t11
join table22 t22 on t11.id1 = t22.id1;
```

Получим результат:


![6  geyrn](https://github.com/user-attachments/assets/93f9482d-25f6-4382-9ad6-8e4335bbaa9e)



![продолжение](https://github.com/user-attachments/assets/299b9d28-9a22-494b-82be-fdf48a62d777)



 2) с помощью директивы explain
```sql
explain select *
from table11 t11
join table22 t22 on t11.id1 = t22.id1;
```

Получим результат:



![explain](https://github.com/user-attachments/assets/da5b415d-77bf-46dd-a44f-e38b6872e36c)


## 7. Реализуем запросы с использованием joins , group by, вложенного подзапроса. Экспортируем план в файл, используя psql -qAt -f explain.sql>analyze.json
Для начала нашем следующий запрос:

```sql
EXPLAIN (ANALYZE, COSTS, verbose,BUFFERS, FORMAT JSON)
select *
from table11 t11
join table22 t22 on t11.id1 = t22.id1
group by t11.id1, t22.id2, t11.id2, t22.id1,t11.gen1, t22.gen2, t11.gen2, t22.gen1;
```
Получим результат:


![Снимок экрана 2025-05-28 004252](https://github.com/user-attachments/assets/1202ffe5-67e4-4cee-a9b5-348a724b3bf9)




Получим файл:

_EXPLAIN_ANALYZE_COSTS_verbose_BUFFERS_FORMAT_JSON_select_from_t_202505280036.json

## Вывод
Научилась анализировать и оптимизировать SQL-запросы с помощью планов выполнения в СУБД и разобрала ключевые компоненты (EXPLAIN, EXPLAIN ANALYZE).
