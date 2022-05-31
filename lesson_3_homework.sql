--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with ship as (select coalesce(s."name" , c."class") as ship, c."class" from classes c 
			   left join ships s on c.class = s.class 
		)
select s."class", sum(case when o.ship is not null then 1 else 0 end) from ship s
left join outcomes o on o.ship = s.ship and o."result"  = 'sunk'
group by 1

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select c."class" , min(s.launched) from classes c 
left join ships s on c.class = s.class 
group by 1

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with ship as  (
	select coalesce(s."name" , c."class") as ship, c."class" from classes c 
	left join ships s on c.class = s.class 
), class  as (
	select c."class" , count(s."name") cnt from classes c 
	left join ships s on c.class = s.class 
	group by 1
	having count(*)>=3
)
select c."class", count(*) from outcomes o 
join ship s on o.ship = s.ship
join class c on c."class" = s."class" 
where o."result" = 'sunk'
group by 1

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with ship as (
	select coalesce(s."name", o.ship) as ship, c.numguns, c.displacement from classes c 
	left join ships s on s."class" = c."class" 
	left join outcomes o on o.ship = c."class" 
), max_guns as (
	select s.displacement, max(numguns) as numguns
	from ship s
	group by 1
)
select s.* from max_guns mg
join ship s on s.numguns = mg.numguns and s.displacement = mg.displacement
order by s.displacement

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
--имеющих наименьший объем RAM. Вывести: Maker

with PC_maker as (
	select distinct maker from product p 
	join PC on PC.model = p.model 
	where PC.ram = (select min(ram) from PC) 
		and speed = (select max(speed) from PC where ram = (select min(ram) from PC))
)
select distinct p.maker 
from product p 
join PC_maker m on m.maker = p.maker
where p."type" = 'Printer'
