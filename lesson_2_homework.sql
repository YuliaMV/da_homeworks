--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select maker, avg(hd) 
from product 
join PC on PC.model = product.model 
where type = 'PC'
and maker in (select maker from product where type = 'Printer')
group by 1 

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class from ships
where launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select name, class from ships
where launched between 1921 and 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select c.class, sum(case when coalesce(s."name", o.ship, '') = '' then 0 else 1 end)
from classes c
left join ships s on c.class = s.class 
left join (select distinct ship from outcomes) o on o.ship = c."class" 
group by 1

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select c.class, c.country from classes c  
where c.bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship from outcomes o 
where o.battle = 'North Atlantic' and o."result" = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select o.ship 
from outcomes o 
join battles b on b."name" = o.battle 
where o."result" = 'sunk' and b."date" = (select max(date) from battles b
										  join outcomes o on b."name" = o.battle 
										  where o."result" = 'sunk')

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select o.ship, coalesce(s."class", c."class") as "class" 
from outcomes o 
join battles b on b."name" = o.battle 
left join ships s on s."name" = o.ship 
left join classes c on c."class" = o.ship 
where o."result" = 'sunk' and b."date" = (select max(date) from battles b
										  join outcomes o on b."name" = o.battle 
										  where o."result" = 'sunk')
										  
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select s.ship, s."class" from outcomes o 										  
join (select coalesce(s."name" , c."class") as ship, c."class", c.bore from classes c 
		left join ships s on c.class = s.class 
		) s on s.ship = o.ship 
where o."result" = 'sunk' and s.bore >= 16	


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select "class" from classes c 
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select coalesce(s."name" , c."class") as ship, c."class" from classes c 
left join ships s on c.class = s.class 
where c.country = 'USA'
