--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select case when g.grade<8 then null else s.name end, g.grade, s.marks
from Students s
join Grades g on s.marks between g.min_mark and g.max_mark
order by g.grade desc, s.name
;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select Doctor, Professor, Singer, Actor
from ( select o.*,
              row_number() over(partition by Occupation order by Name) as rn
        from OCCUPATIONS o
     ) o
pivot
(max(Name)
for Occupation in ('Doctor' as Doctor, 'Professor' as Professor,
                   'Singer' as Singer, 'Actor' as Actor))
order by rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city from STATION
where REGEXP_SUBSTR (lower(city),'^[euioa]') is null;

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from STATION
where REGEXP_SUBSTR (lower(city),'[euioa]$') is null;

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from STATION
where REGEXP_SUBSTR (lower(city),'^[euioa]') is null or REGEXP_SUBSTR (lower(city),'[euioa]$') is null;

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from STATION
where REGEXP_SUBSTR (lower(city),'^[euioa]') is null and REGEXP_SUBSTR (lower(city),'[euioa]$') is null;

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from Employee
where months<10 and salary>2000
order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select case when g.grade<8 then null else s.name end, g.grade, s.marks
from Students s
join Grades g on s.marks between g.min_mark and g.max_mark
order by g.grade desc, s.name
;