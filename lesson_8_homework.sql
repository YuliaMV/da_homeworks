--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select d.name as Department, e.name as Employee, e.salary
from (
    select e.*,
        dense_rank() over (partition by departmentId order by salary desc) as dr
    from Employee e
) e
join Department d on d.id=e.departmentId
where e.dr <= 3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select fm.member_name, fm.status, sum(p.amount*p.unit_price) as costs
from FamilyMembers fm 
join Payments p on p.family_member = fm.member_id
where year(p.date) = 2005
group by fm.member_name, fm.status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select distinct p.name from Passenger p
join Passenger p1 on p.name=p1.name and p.id<>p1.id

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(*) as count from Schedule
where date = date'2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from Student
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(year(current_date) - avg(year(fm.birthday))) as age
from FamilyMembers fm

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select gt.good_type_name, sum(p.amount*p.unit_price) as costs from Payments p
join goods g on g.good_id=p.good
join GoodTypes gt on gt.good_type_id=g.type
where year(p.date) = 2005
group by 1

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(TIMESTAMPDIFF(year, birthday, current_date)) as year from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select max(TIMESTAMPDIFF(year, birthday, current_date)) as max_year from Student s
join Student_in_class sc on sc.student=s.id
join class c on c.id=sc.class
where c.name = 10

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select fm.status, fm.member_name, sum(p.amount*p.unit_price) as costs
from FamilyMembers fm
join Payments p on fm.member_id=p.family_member 
join goods g on g.good_id=p.good
join GoodTypes gt on gt.good_type_id=g.type
where gt.good_type_name = 'entertainment'
group by 1,2

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from Company where id in (
select company from (
    select t.*, 
        dense_rank() over (order by cnt) dr
    from (
    select company, count(*) as cnt
    from Trip
    group by 1
    order by count(*)
    ) t
) t1 where dr=1    
)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom from(
select t.*,
    dense_rank() over (order by cnt desc) dr
from (    
    select classroom, count(*) cnt
    from Schedule s
    group by 1
    order by count(*) desc
    ) t
) t1 where dr=1  

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select distinct t.last_name
from Teacher t
join Schedule s on t.id=s.teacher 
join Subject sb on sb.id=s.subject 
where sb.name='Physical Culture'
order by 1

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select CONCAT(s.last_name, '.', substr(s.first_name,1,1), '.',
    substr(s.middle_name,1,1),'.') as name
from Student s
order by 1
