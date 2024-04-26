create database BlogDB
use BlogDB

create table Categories(
Id int primary key identity,
[Name] nvarchar not null unique
)

create table Tags(
Id int primary key identity,
[Name] nvarchar not null unique
)

create table Users(
Id int primary key identity,
Username nvarchar not null unique,
Fullname nvarchar not null,
Age int check(Age>0 and Age<150)
)

create table Blogs(
Id int primary key identity,
Title nvarchar not null check(Len(Title)<50),
[Description] nvarchar not null,
UserId int foreign key references Users(Id),
CategoryId int  foreign key references Categories(Id)
)

create table Comments(
Id int primary key identity,
Content nvarchar not null check(Len(Content)<250),
UserId int foreign key references Users(Id),
BlogId int foreign key references Blogs(Id)
)

create table BlogTags(
BlogId int,
TagId int,
primary key(BlogId, TagId),
foreign key (BlogId) references Blogs(Id),
foreign key (TagId) references Tags(Id)
)

Create view getNames
as
select Blogs.Title as BlogTitle,Users.Username,Users.Fullname from Blogs
inner join Users 
on
Blogs.UserId=Users.Id

Create view getbyCategories
as
select Blogs.Title as BlogTitle,Categories.Name as CategoryName from Blogs
inner join Categories 
on
Blogs.CategoryId=Categories.Id

Create procedure usp_getComments @userId int
as
begin
   select *
    from Comments
    where UserId = @userId
end
 
 create procedure usp_GetBlogs
    @userId int
as
begin
    select *
   from Blogs
    where UserId = @userId
end

create function getCount(@CategoryId int)
returns int
as
begin
declare @BlogCount int
select @BlogCount= Count(*) from Blogs
where Blogs.CategoryId=@CategoryId
return @BlogCount
end
create function getBlogTable (@UserId int)
returns table
as
Return(
select * from Blogs
where UserId=@UserId
)

