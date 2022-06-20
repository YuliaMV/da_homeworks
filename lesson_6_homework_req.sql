--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

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
select model from all_product
where price = (select max(price) from all_product)

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) 
-- по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта 
-- в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
with all_product as (
	select 'PC' as type, code, model, price 
	from pc
	union all  
	select 'laptop', code, model, price 
	from laptop 
	union all
	select 'printer', code, model, price 
	from printer
)
select ap.*, 
	case when price > (select max(price) from printer) then 1 else 0 end as flag,
	row_number() over (partition by type order by price) as price_index
from all_product ap

create index price_index on all_products_with_index_task5 (price_index);