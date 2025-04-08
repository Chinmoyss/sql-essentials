SELECT * FROM parks_and_recreation.employee_demographics;

select * from parks_and_recreation.employee_salary;

select distinct first_name from employee_salary;

select first_name,salary from employee_salary where salary >=50000;

select * from employee_demographics where first_name like 'a%';

select * from employee_demographics where first_name like 'a___';

select * from employee_demographics where first_name like 'a___%';

select gender, avg(age) from employee_demographics group by gender;

select occupation, salary from employee_salary order by occupation desc;
select occupation, avg(salary) from employee_salary where occupation like '%manager%' group by occupation having avg(salary)>=50000;

select * from employee_demographics inner join employee_salary on employee_demographics.employee_id= employee_salary.employee_id;

select first_name, last_name, "old Man" As label from employee_demographics where age>45 and gender = 'male'
union 
select first_name, last_name, "old Woman" As label from employee_demographics where age>45 and gender = "Female"
union 
select first_name, last_name, "Highly paid employee" As label from employee_salary where salary > 60000 order by first_name, last_name;

select first_name, Length(first_name) As total_length from employee_demographics order by first_name;
select birth_date, substring(birth_date,6,2) as birthmonth from employee_demographics;

select first_name, last_name, concat(first_name," ", last_name) as full_name from employee_demographics;

select last_name, age,
case
	when age <=35 Then "young"
    when age between 36 and 50 Then "old"
    when age>50 then "on death's door"
END as Calculating_Age_parameter
from employee_demographics;

-- salary and bonus 
-- < 50000 = 5%
-- > 5000 = 7%
-- for finance department 10%

select first_name, salary,
case
	when salary<50000 then salary + (salary*0.05)
    when salary > 50000 then salary + (salary*0.07)
ENd as New_salary,
case
	when dept_id = 6 then salary*0.10
End as Bonus
from employee_salary;

select * from employee_demographics where employee_id in (
				select employee_id from employee_salary where dept_id =1
);

select first_name, salary, (select avg(salary) from employee_salary) from employee_salary;

select gender, avg(`Max(age)`) from
(select gender, avg(age), Max(age), Min(age), count(age) from employee_demographics group by gender) As aggrt_functions group by gender;

select gender, avg(salary) as avg_sal from employee_demographics as dem join employee_salary as sal
on dem.employee_id = sal.employee_id group by gender;

select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender) from employee_demographics as dem join employee_salary as sal
on dem.employee_id = sal.employee_id;

select dem.employee_id, dem.first_name, dem.last_name, gender,salary,
row_number() over(partition by gender order by salary DESC) as row_count,
Rank() over(partition by gender order by salary DESC) as rank_col,
dense_rank() over(partition by gender order by salary DESC) as Dense_rank_col
from employee_demographics as dem join employee_salary as sal
on dem.employee_id = sal.employee_id;

with cte_example as
(
select gender, avg(age), Max(age), Min(age), count(age)
from employee_demographics group by gender
)
select * from cte_example
;

with cte_example as 
( 
select employee_id, salary from employee_salary where salary>= 50000
),
cte_example2 as 
(
select employee_id, birth_date, gender from employee_demographics where birth_date > 1985
)
select * from cte_example join cte_example2 on cte_example.employee_id = cte_example2.employee_id;

create temporary table salary_over_60k
select * from employee_salary where salary > 60000;

select * from salary_over_60k;

create procedure large_salaries()
select * from employee_salary where salary >= 50000;
call large_salaries();

DELIMITER $$
create procedure large_salaries3()
Begin
	select * from employee_salary where salary >= 50000;
	select * from employee_salary where salary >= 70000;
End $$
DELIMITER ;

call large_salaries3();

DELIMITER $$
create procedure large_salaries4(p_employee_id int)
Begin
	select salary from employee_salary where employee_id = p_employee_id;
End $$
DELIMITER ;

call large_salaries4(1);

DELIMITER $$
create Trigger employee_insert 
	after insert on employee_salary
    for each row
BEGIN
insert into employee_demographics (employee_id, first_name,last_name)
values (New.employee_id, New.first_name,New.last_name);
END $$
DELIMITER ;

select * from employee_salary;
insert into employee_salary (employee_id, first_name, last_name, occupation,salary, dept_id)
values(13, "chinmoy", "shourov", "student", 50000, 5);

select * from employee_demographics;

DELIMITER $$ 
CREATE EVENT DELETE_RETIREES
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN 
DELETE from employee_demographics where age>=60;
END$$
DELIMITER ;