create database create_store_procedure;
use create_store_procedure;
create table users(
	id int primary key auto_increment,
    fullName varchar(150) not null unique,
    username varchar(150) not null,
    password varchar(50) not null,
    address text not null, 
    phone varchar(50) not null,
    status bit(1) default 1
);
create table roles(
	id int primary key auto_increment,
    name varchar(150) not null unique
);
create table user_role(
	user_id int not null,
    foreign key (user_id) references users(id),
    role_id int not null,
    foreign key (role_id) references roles(id)
);
DELIMITER //
create procedure proc_signin(in u_fullname varchar(150),u_username varchar(150),u_password varchar(50),u_address text,u_phone varchar(50))
	begin 
		insert into users(fullName,username,password,address,phone) value (u_fullname,u_username,u_password,u_address,u_phone);
	end;
// DELIMITER ;
call proc_signin('Nguyen Truong Son','sonca','chimsonca','Thanh Chuong, Nghe An','090010026');
select * from users;
DELIMITER //
CREATE procedure LoginUser(
	in u_username varchar(150),
    in u_password varchar(50),
    out u_login_success boolean
)
begin
-- câu lệnh declare được sử dụng để khai báo biến tạm và chỉ sử dụng trong phạm vi của 1 block hoặc 1 store procedure
	declare user_id int;
    declare user_password varchar(50);
-- tìm kiếm user dựa trên username
	select id, password into user_id, user_password
    from users
    where username = u_username;
-- kiểm tra xem trong bảng users có tồn tại username mà người dùng nhập vào không
	if user_id is null then
		set u_login_success = false;
	else
-- kiểm tra mật khẩu
		if u_password = user_password then
			set u_login_success = true;
		else 
			set u_login_success = false;
		end if;
	end if;
end; //
DELIMITER ;
CALL LoginUser('sonca1','chimsonca',@check);
select @check;

DELIMITER //
CREATE procedure proc_show_user()
begin
	select u.* from users u
    join user_role ur on u.id = ur.user_id;
end;
// DELIMITER ;



-- BÀI TẬP 2
create database ss5_bt2_qlsv;
use ss5_bt2_qlsv;

create table Class(
classId int primary key auto_increment,
className varchar(50) not null unique,
startDate date,
status bit(1) default 1
);

create table Student(
studentId int primary key auto_increment,
studentName varchar(50) not null unique,
address varchar(50) not null,
phone varchar(50) not null unique,
status bit(1) default 1,
classId int not null,
foreign key(classId) references Class(classId)
);

create table Mark(
markId int primary key auto_increment,
sub_Id int not null,
foreign key(sub_Id) references Subject(subId),
student_Id int not null,
foreign key(student_Id) references Student(studentId),
mark float not null,
examTime float not null
);

create table Subject(
subId int primary key auto_increment,
subName varchar(50) not null unique,
credit int not null,
status bit(1) default 1
);

insert into class(className,startDate,status) values
('10A1','2020-09-05',1),
('10A2','2020-09-05',1),
('11A1','2019-09-03',1);
select * from class;

insert into student(studentName,address,phone,status,classId) values
('Nguyen Van A','Thanh Ha, Thanh Liem, Ha Nam','012345678',1,1),
('Nguyen Van B','Thanh Ha, Thanh Liem, Ha Nam','0123456789',1,1),
('Nguyen Van C','Thanh Ha, Thanh Liem, Ha Nam','0123456780',1,2),
('Nguyen Van D','Thanh Ha, Thanh Liem, Ha Nam','0123456781',1,3),
('Nguyen Van E','Thanh Ha, Thanh Liem, Ha Nam','0123456782',1,3);
select * from student;

insert into subject(subName,credit,status) values
('Toan',5,1),
('Ly',3,1),
('Hoa',3,1);
select * from subject;
insert into mark(sub_Id,student_Id,mark,examTime) values
(1,1,7.5,15),
(2,1,8,15),
(3,1,5.5,15),
(1,2,6.75,15),
(2,2,5,15),
(3,2,8,15);

DELIMITER //
create procedure list_students_with_hightes_score_chemistry( in s_subName varchar(50))
begin
	select s.*,m.mark ,sb.subName
    from mark m
    join  student s on s.studentId = m.student_Id
    join subject sb on m.sub_Id = sb.subId
    where sb.subName = s_subName
    order by m.mark desc;
end;
// DELIMITER ;
call list_students_with_hightes_score_chemistry('Hoa');

DELIMITER //
create procedure list_subjects_with_most_students_take_exam()
begin
	select s.*,m.mark ,sb.subName, count(sb.subId) as amount
    from mark m
    join  student s on s.studentId = m.student_Id
    join subject sb on m.sub_Id = sb.subId
    group by sb.subName
    order by m.mark desc;
end;
// DELIMITER ;
select sb.*
    from mark m
    join  student s on s.studentId = m.student_Id
    join subject sb on m.sub_Id = sb.subId
    group by m.student_Id

