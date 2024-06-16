/*
1.	Display all the employees Data.
*/
select * from Employee
/*
2.	Display the employee First name, last name, Salary and Department number.
*/
select fname,lname,salary,Dno from Employee
/*
3.	Display all the projects names, locations and the department which is responsible about it.
*/
select * from Project
/*
4.	If you know that the company policy is to pay an annual commission for each employee with specific
	percent equals 10% of his/her annual salary .Display each employee full name and his annual commission
	in an ANNUAL COMM column (alias).
*/
select fname+' '+lname , salary * 12 , salary * 12 * 0.1 'Annaul Comission' from Employee
/*
5.	Display the employees Id, name who earns more than 1000 LE monthly.
*/
select SSN , fname+' '+lname , salary from Employee
where Salary > 1000
/*
6.	Display the employees Id, name who earns more than 10000 LE annually.
*/
select SSN , fname+' '+lname , salary*12 from Employee
where (Salary*12) > 10000
/*
7.	Display the names and salaries of the female employees. 
*/
select SSN , fname+' '+lname , salary , sex from Employee
where Sex  like  'f'
/*
8.	Display each department id, name which managed by a manager with id equals 968574.
*/
select Dnum , Dname , MGRSSN , 'MGRStart Date' , Fname , lname from Departments , Employee 
where MGRSSN = SSN
/*
9.	Dispaly the ids, names and locations of  the pojects which controled with department 10.
*/
select Pnumber , Pname , Plocation , Dname from Project ,Departments
where Project.Dnum = Departments.Dnum and Project.dnum = 10

