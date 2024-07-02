/*
1.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and 
	increases it by 20% if Salary >=3000. Use company DB
*/
Declare c1 Cursor
	for select salary from Employee
	for update 

Declare @sal int

open c1
fetch c1 into @sal 
BEGIN
	while @@FETCH_STATUS = 0 
		BEGIN 
			if @sal < 3000
				update Employee
				set Salary = @sal * 1.1 where current of c1
				fetch c1 into @sal 
		END
END
close c1 
deallocate c1

select * from Employee
/*
2.	Display Department name with its manager name using cursor. Use ITI DB
*/
Declare c2 cursor
	for select Dept_Name, Ins_name  from Department d, Instructor i where D.Dept_Manager = i.Ins_Id
	for read only

Declare @dName varchar(20), @Iname varchar(20)
open c2
fetch c2 into @dName , @Iname
while @@FETCH_STATUS = 0
BEGIN
	select @dName , @Iname  
	fetch c2 into @dName , @Iname
END
close c2
deallocate c2
/*
3.	Try to display all students first name in one cell separated by comma. Using Cursor 
*/
Declare c3 Cursor
	for select St_fname from Student
	for read only
Declare @name varchar(20) , @CocName varchar(MAX)  
open c3
fetch c3 into @name
while @@FETCH_STATUS = 0
BEGIN
	set @CocName = CONCAT(@Cocname,@Name,',')
	fetch c3 into @name
END
select @CocName
close C3
deallocate c3

select * from Student

