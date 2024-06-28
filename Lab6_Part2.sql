/********************************** PART2 **********************************/
/* 1. */
create database Lab6

Create Table Department 
(DeptNo varchar(5) Primary key , DeptName varchar(20) , Location varchar(2))
insert into Department
Values('d1','Research','NY'),('d2','Accounting','DS'),('d3','Markiting','KW')

Create Rule Loc_Role AS
@Loc in ('NY','DS','KW')

sp_bindrule 'Loc_Role','Department.Location'

insert into Department Values('d4','Research','KF') -- Error
/* 2 */
Create Table Employee 
(EmpNo int Primary key ,Fname varchar(10) NOT NULL,Lname varchar(10) NOT NULL,
	DeptNo varchar(5),Salary int UNIQUE)

alter table Employee
add constraint FK_DeptNo foreign key (DeptNo) references Department(DeptNo)

Create Rule Sal_Rule AS
@Sal between 0 and 6000

insert into Employee 
Values (25348,'Mathew','Smith','d3',2500),(10102,'Ann','Jones','d3',3000),
(18316,'John','Barrimore','d1',2400),(29346,'James','James','d2',2800)

insert into Employee 
Values (25348,NULL,'James','d3',2000) -- Error : Not NULL Constraint
insert into Employee 
Values (25348,'James','James','d3',6500) -- Error : Rule on Salary
/* 3 */
create Table Project 
(ProjectNo varchar(5) NOT NULL , ProjectName varchar(20) NOT NULL, Budget int )

alter table Project 
add constraint PK_ProjectNo  Primary key (ProjectNo) 

insert into project 
Values ('p1','Apollo',120000),('p2','Gemini',95000),('p3','Mercury',185600)

create table Works_On
(EmpNo int Not NULL , ProjectNo varchar(5) Not NULL , job varchar(20) , 
	EnterDate date default getdate())

alter table Works_On
add constraint FK_Emp Foreign key (EmpNo) references Employee(EmpNo)
,constraint FK_Pro Foreign key (ProjectNo) references Project(ProjectNo)
,Constraint PK_WorksON Primary key(EmpNo , ProjectNo)

insert into Works_On 
Values(10102,'p1','Analyst','10-01-2006'),(10102,'p3','Manager','01-01-2012'),
(25348,'p2','Clerk','02-15-2007'),(18316,'p2',Null,'06-01-2007'),(29346,'p2',Null,NUll)

insert into Works_On (EmpNo, ProjectNo, job)
Values(25348,'p3','Clerk')
/************************ Testing Referential Integrity ************************/
/*1-Add new employee with EmpNo =11111 In the works_on table [what will happen]*/
insert into Works_On values(11111,'p3','Manager','1-1-2012')
/*2-Change the employee number 10102  to 11111  in the works on table [what will happen]*/
update Works_On 
set EmpNo = 11111 where EmpNo = 10102
/*3-Modify the employee number 10102 in the employee table to 22222. [what will happen]*/
update Employee 
set EmpNo = 22222 where EmpNo = 10102
/*4-Delete the employee with id 10102*/
delete from Employee where EmpNo = 10102
/************************ Table modification ************************/
alter table Employee add tel int 
select * from Employee
alter table employee drop column tel
/*
2.	Create the following schema and transfer the following tables to it 
	a.	Company Schema 
		i.	Department table (Programmatically)
		ii.	Project table (using wizard)
	b.	Human Resource Schema
		i.	  Employee table (Programmatically)
*/
create schema Company 

/*i*/ alter schema company transfer dbo.Department
--ii -->Design --> Properties of table (Right of the page) --> Schema
create schema HR 

alter schema HR transfer dbo.Employee
/*
3.   Write query to display the constraints for the Employee table.
*/
SELECT constraint_name, constraint_type 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE table_name = 'Employee';
/*
4.	Create Synonym for table Employee as Emp and then run the following queries and describe the results
	a.	Select * from Employee
	b.	Select * from [Human Resource].Employee
	c.	Select * from Emp
	d.	Select * from [Human Resource].Emp
*/
create synonym Emp for Lab6.HR.Employee 

Select * from Employee --Error : Missed schema
Select * from [HR].Employee
Select * from Emp
Select * from [HR].Emp --Error : Invalid Object
/*
5.	Increase the budget of the project where the manager number is 10102 by 10%.
*/
update Company.Project 
set budget = budget * 1.1 where ProjectNo in 
								(select ProjectNo from Works_On where job like 'Manager')
select * from Company.Project
/*
6.	Change the name of the department for which the employee named James works.
	The new department name is Sales.
*/
update Company.Department
set DeptName = 'Sales' where DeptNo = 
							(select DeptNo from HR.Employee where Fname like 'James')
select * from Company.department
/*
7.	Change the enter date for the projects for those employees who work in 
	project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
*/
update Works_On set EnterDate = '12-12-2007'
where EmpNo in (select e.EmpNo from HR.employee e, Company.Department d 
				where e.DeptNo = D.DeptNo and DeptName like 'Sales')
/*
8.	Delete the information in the works_on table for all employees who work 
	for the department located in KW.
*/
delete Works_on where EmpNo in(select EmpNo from Company.Department d, HR.Employee e
								where d.DeptNo = e.DeptNo and  Location = 'KW')
