--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
select model, maker, type from product

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select p.*,
	case when price > (select avg(price) from printer) then 1 else 0 end
from printer p

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select o.ship from outcomes o  
left join ships s on s."name" = o.ship 
where s."name" is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select b.*
from battles b 
where extract('year' from b."date") not in (select s.launched from ships s)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select b.* from outcomes o 
join battles b on b."name" = o.battle 
join ships s on s."name" = o.ship 
where s."class" = 'Kongo'


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. 
-- Во view три колонки: model, price, flag

create view all_products_flag_300 as 
with all_product as (
	select 'PC' as type, model, price 
	from pc
	union all  
	select 'laptop', model, price 
	from laptop 
	union all
	select 'printer', model, price 
	from printer
)
select p.*, case when price>300 then 1 else 0 end as flag
from all_product p

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом,
-- если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
with all_product as (
	select 'PC' as type, model, price 
	from pc
	union all  
	select 'laptop', model, price 
	from laptop 
	union all
	select 'printer', model, price 
	from printer
)
select p.*, case when price>(select avg(price) from all_product) then 1 else 0 end as flag
from all_product p

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
select p.model
from product p
join printer pr on pr.model = p.model 
where p.maker = 'A' and price > (select avg(pr.price)
								from product p
								join printer pr on pr.model = p.model 
								where p.maker in ('D','C'))

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with all_product as (
	select 'PC' as type, model, price 
	from pc
	union all  
	select 'laptop', model, price 
	from laptop 
	union all
	select 'printer', model, price 
	from printer
)
select p.model 
from product p
join all_product ap on ap.model = p.model 
where maker = 'A' and price > (select avg(pr.price)
								from product p
								join printer pr on pr.model = p.model 
								where p.maker in ('D','C'))

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with all_product as (
	select 'PC' as type, model, price 
	from pc
	union all  
	select 'laptop', model, price 
	from laptop 
	union all
	select 'printer', model, price 
	from printer
)
select p."type", avg(price) as avg_price
from product p
join all_product ap on ap.model = p.model 
where maker = 'A' 					
group by p."type" 

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as 
select p.maker, count(*) count 
from product p 
group by 1

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
select * from printer;

delete from printer_updated
where model in (
		select p.model 
		from product p
		join printer pr on pr.model = p.model 
		where p.maker = 'D'
		)

select * from printer_updated		
		
--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select pu.*, p.maker from printer_updated pu
join product p on p.model = pu.model

select * from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
-- Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as
select coalesce(s."class", c."class", '0') as class, count(*) count from outcomes o 
left join ships s on s."name" = o.ship 
left join classes c on c."class" = o.ship 
where o."result" = 'sunk'
group by 1

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select c.*, case when c.numguns >= 9 then 1 else 0 end as flag
from classes c 

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*) from ships s 
where regexp_match(s."name", '^[OM]') is not null

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select * from ships s 
where s."name" like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
