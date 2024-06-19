/*
1.	Retrieve number of students who have a value in their age. 
*/
select count(St_Age) from Student 
/*
2.	Get all instructors Names without repetition
*/
select distinct (Ins_Name)from Instructor
/*
3.	Display student with the following Format (use isNull function)
 | Student ID | Student FUll Name | Department name |
*/
select St_Id 'Student ID' , ISNULL(st_fname,'....')+' '+ISNULL(st_lname,'....') 'Student Full Name',
isNull(Dept_Name,'N/A')'Department name'from Student left join Department
on Student.Dept_Id = Department.Dept_Id
/*
4.	Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not
*/
select ins_name , Dept_name from Instructor left join Department
on Instructor.Dept_Id = Department.Dept_Id
/*
6.	Display number of courses for each topic name
*/
select Top_name , count(Course.Top_Id) from course , Topic
where course.Top_Id = Topic.Top_Id
group by top_Name
/*
7.	Display max and min salary for instructors
*/
select max(salary) 'Max Salary', min(salary)'Min Salary' from Instructor
/*
8.	Display instructors who have salaries less than the average salary of all instructors.
*/
select Ins_name , salary from Instructor 
where salary <(select avg(ISNULL(salary,0)) from Instructor) 
/*
9.	Display the Department name that contains the instructor who receives the minimum salary.
*/
select Department.Dept_Id , Dept_Name  from Department , Instructor
where Department.Dept_Id = Instructor.Dept_Id and salary = (select min(salary) from Instructor )
/*
10.	 Select max two salaries in instructor table. 
*/
 select distinct top(2) salary from Instructor
 order by salary desc
/*
11.    Select instructor name and his salary but if there is no salary display 
	    instructor bonus keyword. “use coalesce Function”
*/
select Ins_name , coalesce(convert(varchar(50),salary),'Ins Bouns') from instructor
/*
12.    Select Average Salary for instructors 
*/
 select avg(isnull(salary,0)) from instructor 
/*
13.	Select Student first name and the data of his supervisor 
*/
select st.st_fname , sv.* from Student st , Student sv
where sv.St_Id = st.St_super
/*
14.	Write a query to select the highest two salaries in Each Department 
		for instructors who have salaries. “using one of Ranking Functions”
*/
select * from
	(select Dept_Id , iSnull(salary,0)'Salary' , dense_rank()over(partition by dept_id order by salary desc) dense_L 
	from instructor /*where salary is not NULL*/) outer_select
where dense_L in (1,2) 
/*
15.		Write a query to select a random  student from each department.  “using one of Ranking Functions”
*/
select * from
	(select * , rank()over(partition by dept_id order by newid()) dense_L 
	from student where dept_id is not NULL) outer_select
where dense_L =1
