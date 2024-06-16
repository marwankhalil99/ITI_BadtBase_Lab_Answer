/*
1.	Display the Department id, name and id and the name of its manager.
*/
select Departments.Dnum , Dname , SSN , lname , fname from Departments , Employee
where MGRSSN = SSN
/*
2.	Display the name of the departments and the name of the projects under its control.
*/
select Departments.Dnum , Dname , Pname , Pnumber  from Departments , Project
where Departments.Dnum = Project.Dnum
order by Dnum asc
/*
3.	Display the full data about all the dependence associated with the name of the employee 
	they depend on him/her.
*/
select fname , lname , Dependent.* from employee , dependent
where ESSN = SSN 
/*
4.	Display the Id, name and location of the projects in Cairo or Alex city.
*/
select Pnumber , Pname , Plocation , city from Project 
where City in ('Alex','Cairo')
/*
5.	Display the Projects full data of the projects with a name starts with "a" letter.
*/
select * from Project 
where Pname like 'a%'
/*
6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
*/
select employee.* from employee , Departments
where Dnum = Dno and Dno = 30 and salary between 1000 and 2000
/*
7.	Retrieve the names of all employees in department 10 who works more than 
	or equal 10 hours per week on "AL Rabwah" project.
*/
select employee.* , Hours , Pname from Works_for , Employee , Project
where ESSn = SSN and Pno = Pnumber and Dno = 20 and hours >= 10 and Pname like 'Al Rawdah'
/*
8.	Find the names of the employees who directly supervised with Kamel Mohamed.
*/
select Emp1.fname+' '+Emp1.lname 'Emp Name' , Emp2.fname+' '+Emp2.lname 'Supervisor Name' 
from Employee Emp1,Employee Emp2
where Emp2.SSN = Emp1.Superssn 
/*
9.	Retrieve the names of all employees and the names of the projects they are working on,
	sorted by the project name.
*/
select fname , lname , Pname from Works_for , Employee , Project
where ESSn = SSN and Pno = Pnumber 
order by Pname Asc
/*
10.	For each project located in Cairo City , find the project number, the controlling department name ,
	the department manager last name ,address and birthdate.
*/
select Pnumber , Pname , Dname , fname , lname , address , Bdate from Departments , Employee , Project
where SSN = MGRSSN and Project.Dnum = Departments.Dnum and City like 'Cairo'
/*
11.	Display All Data of the managers
*/
select Employee.* , Dname from Employee , Departments
where SSN = MGRSSN 
/*
12.	Display All Employees data and the data of their dependents even if they have no dependents
*/
select * from employee left join Dependent
on SSN = ESSN
/*13.	Insert your personal data to the employee table as a new employee in
		department number 30, SSN = 102672, Superssn = 112233, salary=3000.
*/
insert into Employee 
values ('Marwan','Khalil',102672,'01-30-1999','Abdelsalam aref Domiat' , 'M' ,3000 , 112233, 30 )

/*
14.	Insert another employee with personal data your friend as new employee in department number 30,
	SSN = 102660, but don’t enter any value for salary or supervisor number to him.
*/
insert into Employee (fname,lname,ssn,Bdate, Address, sex, Dno)
values ('yahia','eleman',102660,'02-02-1999','Elsyala Domiat' , 'M' , 30 )

/*
15.	Upgrade your salary by 20 % of its last value.
*/
update Employee
set salary = salary * 1.2
where ssn = 102672