/*1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] */
Create Procedure Lab_P1 AS
BEGIN
	Select Dept_Name , count(St_id) from student s , Department d 
	where s.Dept_Id = d.Dept_Id
	group by Dept_Name
END

execute Lab_P1

/*2.	Create a stored procedure that will check for the # of employees in the project p1 if they are 
		more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
		if they are less display a message to the user “'The following employees work for the project p1'” 
		in addition to the first name and last name of each one. [Company DB] 
*/
create procedure Lab_P2 AS
BEGIN
	Declare @No_of_Emp int = (select count(*) from HR.employee e , Company.Project p, dbo.Works_On w
							  where e.EmpNo = w.EmpNo and p.ProjectNo = w.ProjectNo and p.ProjectNo ='p1') 
	if @No_of_Emp > 3 
		select 'The number of employees in the project p1 is 3 or more'
	else
		select CONCAT('The following employees work for the project p1',Fname , ' ' ,Lname) from HR.employee e , Company.Project p, dbo.Works_On w 
		where e.EmpNo = w.EmpNo and p.ProjectNo = w.ProjectNo and p.ProjectNo ='p1'
		
END

execute Lab_p2
select * from Company.project 

/*
3.	Create a stored procedure that will be used in case there is an old employee has left the project 
	and a new one become instead of him. The procedure should take 3 parameters 
	(old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [Company DB]
*/
alter procedure Lab_P3 (@Old_emp_ID int , @New_Emp_ID int , @ProName varchar(30)) AS
BEGIN
	Declare @CHK_OID int = (select count(*) from HR.Employee where @Old_emp_ID = EmpNo)
	Declare @CHK_NID int = (select count(*) from HR.Employee where @New_Emp_ID = EmpNo)
	Declare @CHK_Pname varchar(20) = (select count(*) from Company.Project where ProjectName like @ProName )
	if @CHK_NID = 0 and @CHK_NID = 1
		select 'Old Emp ID INCORRECT'
	else if @CHK_NID = 1 and @CHK_NID = 0
		select 'New Emp ID INCORRECT'
	else if @CHK_NID = 0 and @CHK_NID = 0
		select 'Old Emp ID And New Emp ID INCORRECT'
	else if @CHK_Pname = 0 and @CHK_NID = 1 and @CHK_NID = 1
		select 'Project Name is INCORRECT'
	else 
		Update Works_on set EmpNo = @New_Emp_ID where EmpNo = @Old_emp_ID and ProjectNo = 
														(select ProjectNo from Company.Project where @ProName=ProjectName)
END

execute Lab_P3 10102 , 29346 ,'Mercury'

select * from Works_On
select * from HR.Employee
Select * from Company.Project
/*
4.	add column budget in project table and insert any draft values in it then 
then Create an Audit table with the following structure 
ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
p2 	Dbo 	2008-01-31	95000 	200000 
This table will be used to audit the update trials on the Budget column 
(Project table, Company DB)
Example:
If a user updated the budget column then the project number, user name that made that update,
the date of the modification and the value of the old and the new budget will be inserted into
the Audit table
Note: This process will take place only if the user updated the budget column
*/
Create Trigger Lab_Tr1 on Company.Project 
After update AS
BEGIN
	if update(budget)
		insert into Audit_Pro
		select i.ProjectNo , suser_sname() , getdate() , d.budget , i.budget 
		from inserted i, deleted d		
END

Select * from Company.Project
select * from Audit_Pro
update company.Project
set budget = 100000 where ProjectNo = 'p2'
/*
5.	Create a trigger to prevent anyone from inserting a new record in the Department 
	table [ITI DB] “Print a message for user to tell him that he can’t 
	insert a new record in that table”
*/
Create Trigger Lab_Tr2 on Department 
Instead of Insert AS
BEGIN
	select 'Access Denied'	
END
select * from department

insert into Department
values (90,'testing','SW Testing','Mansoura',3,getdate())
/*
6.	 Create a trigger that prevents the insertion Process for Employee table in March
	 [Company DB].
*/
alter Trigger Lab_TR3 on HR.Employee instead of insert AS
BEGIN
	if month(getdate()) = 7 
		select 'No Insertion On March !'	
	else 
		insert into HR.Employee
		select * from inserted
END

insert into hr.employee
values (40016 , 'Hana','Michel','d2',4400)
select * from Company.Department
select * from hr.Employee
/*
7.	Create a trigger on student table after insert to add Row in
	Student Audit table (Server User Name , Date, Note) 
	where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
	ServerUser Name		Date  Note
*/
Create trigger Lab_TR4 on Student after insert AS
BEGIN
	insert into std_audit
	select @@SERVERNAME ,  GETDATE() , CONCAT(SUSER_SNAME(),'Insert New Row with Key=',st_id,'in table Student')
	from inserted
END

insert into Student 
values (16 , 'Marwan','Khalil', 'Domiat', 25 ,20,1)
select * from student
select * from std_audit
/*
8.  Create a trigger on student table instead of delete to add Row in Student Audit table
	(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
*/
Create trigger Lab_TR5 on Student instead of Delete AS
BEGIN
	insert into std_audit
	output 'Can not delete'
	select @@SERVERNAME ,  GETDATE() , CONCAT(SUSER_SNAME(),'try to delete Row  with Key=',st_id,'in table Student')
	from deleted
END
delete student
where st_id = 15 
select * from student
select * from std_audit
