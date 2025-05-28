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
create table if not exists table1 (
id1 INT,
id2 INT,
gen1 TEXT, 
gen2 TEXT,
primary key (id1, id2, gen1)
);
```



## 2. Создадим таблицу table2 со следующими параметрами: возмем наборы полей table1 с помощью директивы LIKE
```sql
create table table2 (like table1);
```



## 3. Проверим, какое количество внешних таблиц присутствует в базе данных
```sql
select COUNT(*) as foreign_tables_count
from pg_foreign_table;
```

Получим результат:


![Screenshot_75](https://github.com/user-attachments/assets/3864e89e-2262-4d6d-b294-6632b29a169a)




## 4. Сгенерируем данные и вставим их в обе таблицы (200 тысяч и 400 тысяч соответственно)
```sql
insert into table1 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 200000) gen;
```
```sql
insert into table2 select gen, gen, gen::text || 'text1', gen::text || 'text2' from generate_series(1, 400000) gen;
```





## 5. C помощью директивы explain посмотрим план соединения таблиц table1 и table2 по ключу id1
```sql
explain select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;
```

Получим результат:



![5 пункт](https://github.com/user-attachments/assets/d2c40e94-e7df-4616-ad91-b7d26efe9e09)





## 6. Используя таблицы table1 и table2 реализуем план запроса:
   1) план запроса встроенного инструмента dbeaver;
```sql
select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;
```

Получим результат:


![6  geyrn](https://github.com/user-attachments/assets/93f9482d-25f6-4382-9ad6-8e4335bbaa9e)



![продолжение](https://github.com/user-attachments/assets/299b9d28-9a22-494b-82be-fdf48a62d777)



 2) с помощью директивы explain
```sql
explain select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;
```

Получим результат:



![5 пункт](https://github.com/user-attachments/assets/615aeff1-0f29-454f-9664-919f3d2e2edc)





## 7. Реализуем запросы с использованием joins , group by, вложенного подзапроса. Экспортируем план в файл, используя psql -qAt -f explain.sql>analyze.json
Для начала нашем следующий запрос:

```sql
EXPLAIN (ANALYZE, COSTS, verbose,BUFFERS, FORMAT JSON)
select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1
group by t1.id1, t2.id2, t1.id2, t2.id1, t1.gen1, t2.gen2, t1.gen2, t2.gen1;
```

Получим результат:



![Screenshot_74](https://github.com/user-attachments/assets/ee753876-c1a6-4c32-80ca-eb926f30405d)





Получим файл в формате .json и экспортируем его.


## 8. Сравним полученные результаты из пункта 6 с результатом на сайте https://tatiyants.com/pev/#/plans/new

Для этого мы скопируем .json код выполненного запроса в пугкте 6 и сам запрос:
```sql
select *
from table1 t1
join table2 t2 on t1.id1 = t2.id1;
```

Получаем результат: 


![дерево](https://github.com/user-attachments/assets/c9185380-dd2e-4b15-b660-ada208c38e60)



И заметим, что план запроса на данном сайте похож на план, представленный в dbeaver: мы получаем такое же дерево в математическом представленнии с двумя узлами.

Результат можно посмотреть по ссылке https://tatiyants.com/pev/#/plans/plan_1748403040385


## Вывод
Научилась анализировать и оптимизировать SQL-запросы с помощью планов выполнения в СУБД и разобрала ключевые компоненты (EXPLAIN, EXPLAIN ANALYZE).


## Структура репозитория:
- `ERD1_diagrama.png` — ERD диаграмма схемы таблицы table1.
- `ERD2_diagrama.png` — ERD диаграмма схемы таблицы table2.
- `Gubaidullina_Alina_Ilshatovna_pr13.sql` — SQL скрипт для создания таблиц.
- `_EXPLAIN_ANALYZE_COSTS_verbose_BUFFERS_FORMAT_JSON_select_from_t_202505280036.json` — Файл экспорта запроса с использованием joins , group by, .
