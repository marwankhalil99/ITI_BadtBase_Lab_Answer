/*
1.	Create a view that displays student full name, course name 
	if the student has a grade more than 50. 
*/
create view Lab_v1 As
select CONCAT(st_fname,' ',st_lname)'Full Name' , Crs_name , grade
from student st , stud_course sc , Course c
where c.Crs_Id = sc.Crs_Id and st.St_Id = sc.St_Id and grade > 50 
/*
2.	 Create an Encrypted view that displays manager names and the topics they teach. 
*/
create view Lab_v2  with ENCRYPTION as
SELECT distinct(Top_Name) , Ins_name  
from Instructor ins , Department d , Ins_Course insc, Topic t , Course c 
where ins.Ins_Id = d.Dept_Manager and insc.Ins_Id = ins.Ins_Id and insc.Crs_Id = c.Crs_Id 
and t.Top_Id = c.Top_Id

select * from Lab_v2
/*
3.	Create a view that will display Instructor Name, Department Name 
	for the ‘SD’ or ‘Java’ Department 
*/
create view Lab_v3 AS
select ins.ins_name , d.dept_name from Instructor ins , department d 
where ins.Dept_Id = d.Dept_Id and Dept_Name in ('SD' , 'Java')

select * from Lab_v3
/*
4.	Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
		Note: Prevent the users to run the following query 
			Update V1 set st_address=’tanta’
			Where st_address=’alex’;
*/
create view Lab_v4 AS
select * from Student where st_address in ('Alex','Cairo')
with check option

Update Lab_v4 set st_address='tanta'
			Where st_address='Alex';
/*
5.	Create a view that will display the project name and the number of employees 
	work on it. “Use Company DB”
*/
create view Lab_v5 AS
select Pname , Count(ssn) '# of Emp'from project , Employee , Works_for
where Employee.SSN = Works_for.ESSn and Project.Pnumber = Works_for.Pno
group by Pname 

select * from LAb_v5
/*
6.	Create index on column (Hiredate) that allow u to cluster the data in table Department. 
	What will happen?
*/
create clustered index Lab_idx1 on Department(Manager_hiredate) 
-- Error Because there is existing Clustered Index (Dept_Id PK)
/*
7.	Create index that allow u to enter unique ages in student table. What will happen?
*/
create Unique index Lab_idx3 on dbo.Student(st_age) 
-- Error Because It already has Duplicated Values
/*
8.	Using Merge statement between the following two tables [User ID, Transaction Amount]
*/
create table Daily(UserID int , TanscAmount int ) 
create table Last(UserID int , TanscAmount int )
insert into Daily values (1,1000),(2,2000),(3,1000)
insert into Last values (1,4000),(4,2000),(2,10000)

Merge into dbo.Last as T 
using dbo.Daily as S
On T.UserID=S.UserID

When matched then
update set T.TanscAmount=S.TanscAmount

When not matched by target Then 
insert(UserID , TanscAmount)
values(S.UserID , S.TanscAmount);

select * from Daily
select * from Last