/*
1.	Display (Using Union Function)
	a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
	b.	 And the male dependence that depends on Male Employee.
*/
select * from Dependent , Employee
where ESSN = SSN and Employee.Sex like 'f' and Dependent.Sex like 'f'
union 
select * from Dependent , Employee
where ESSN = SSN and Employee.Sex like 'm' and Dependent.Sex like 'm'
/*
2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
*/
select Pnumber , Pname , sum(Hours) from Project , Works_for
where Pno = Pnumber 
group by Pname , Pnumber 
/*
3.	Display the data of the department which has the smallest employee ID over all employees' ID.
*/
select * from Departments , Employee
where dno = dnum and SSN = (select min (SSN) from Employee)
/*
4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
*/
select dname , max(salary)'Max' , min(salary) 'Min', avg(salary)'Avg' from Departments,Employee
where Dno = Dnum
group by Dname
/*
5.	List the full name of all managers who have no dependents.
*/
select fname , lname ,dno from  employee , Departments 
where MGRSSN = SSN and ssn not in (select Essn from dependent)
 ---------------------
select fname , lname from Employee , Departments
where MGRSSN = SSN 
except
select fname , lname from Employee , Dependent
where ESSN = SSN 
/*
6.	For each department-- if its average salary is less than the average salary of all employees
	-- display its number, name and number of its employees.
*/
select dnum , dname , count(SSN) , avg(salary) from Departments , Employee
where Dno = Dnum
group by dnum , dname
having avg(salary) < (select avg(salary) from Employee) 
/*
7.	Retrieve a list of employees names and the projects names they are working on ordered by department number
	and within each department, ordered alphabetically by last name, first name.
*/
select fname , lname , Pname , Dname from Employee , Departments , Project , Works_for
where SSN = ESSN and Pno = Pnumber and Dno = Departments.Dnum
order by fname , lname , Dno
/*
8.	Try to get the max 2 salaries using subquery
*/
select fname , lname , salary from Employee
where salary >= (select max(salary) from employee 
				where salary < (select max(salary) from Employee))
-------------------------------
select distinct top(2) salary , fname , lname from Employee
order by salary desc
/*
9.	Get the full name of employees that is similar to any dependent name
*/
select CONCAT(fname,' ',Lname) from Employee
intersect
select Dependent_name from Dependent
/*
10.	Display the employee number and name if at least one of them have dependents 
	(use exists keyword) self-study.
*/
select SSN , fname , lname from Employee
where exists (select ESSN from Dependent where SSN = ESSN)
/*
11.	In the department table insert new department called "DEPT IT" , with id 100,
	employee with SSN = 112233 as a manager for this department.
	The start date for this manager is '1-11-2006'
*/
insert into Departments 
values ('DEPT IT',100, 112233, '11-01-2006')
/*
12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the
	manager of the new department (id = 100), and they give you(your SSN =102672) 
	her position (Dept. 20 manager) 
		a.	First try to update her record in the department table
		b.	Update your record to be department 20 manager.
		c.	Update the data of employee number=102660 to be in your teamwork 
		(he will be supervised by you) (your SSN =102672)
*/
/*a.*/update Departments set MGRSSN = 968574 , [MGRStart Date]=  '06-04-2024' where Dnum = 100 
	  update Employee set Dno = 100  where ssn = 968574 
/*b.*/update Employee set dno = 20  where ssn = 102672
/*c.*/update Employee set Superssn = 102672  where ssn = 102660


/*
13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed 
	(SSN=223344) so try to delete his data from your database 
	in case you know that you will be temporarily in his position.
	Hint: (Check if Mr. Kamel has dependents, works as a department manager,
	supervises any employees or works in any projects and handle these cases).
*/
 
update employee set Superssn = 102672 where ssn in (select ssn from Employee where Superssn = 223344)--> replace supervisor
update departments set MGRSSN = 102672 where  MGRSSN = 223344
delete from Works_for where  essn = 223344
delete from Dependent where essn = 223344
delete from Employee where ssn = 223344
/*
14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
*/
update Employee set Salary = 1.3 * salary
where ssn in (
				select essn from Works_for where Pno =
														(select Pnumber from Project where Pname = 'Al Rabwah'))