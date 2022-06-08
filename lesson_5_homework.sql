--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов 
-- (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products as 
select t.*, t.rn%2 + t.rn/2 as page, max(t.rn%2 + t.rn/2) over () as number_of_page
from (
	select l.*, row_number() over (order by code) rn
	from laptop l 
) t

sample:
1 1
2 1
1 2
2 2
1 3
2 3


--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. 
-- Вывод: производитель, тип, процент (%)

create view distribution_by_type1 as
select p.maker, p.type, count(*)*100.0 / (select count(*) from product) as perc
from product p 
group by 1,2
order by 1,2

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships
where name like '% %'

select * from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select s."name" from ships s
where s."name" like 'S%' and s."class" is null
union 
select o.ship from outcomes o
left join classes c on c."class" = o.ship 
where o.ship like 'S%' and c."class" is null

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
-- и три самых дорогих (через оконные функции). Вывести model

select model from (
select pr.model, pr.price, row_number() over (order by price desc) rn
from printer pr
join product p on p.model = pr.model 
where p.maker = 'A' and pr.price > (select coalesce(avg(pr.price),0) from printer pr
									join product p on p.model = pr.model 
									where p.maker = 'C')
) t where rn<=3