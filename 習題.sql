create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '趙雷' , '1990-01-01' , '男');
insert into Student values('02' , '錢電' , '1990-12-21' , '男');
insert into Student values('03' , '孫風' , '1990-12-20' , '男');
insert into Student values('04' , '李雲' , '1990-12-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吳蘭' , '1992-01-01' , '女');
insert into Student values('07' , '鄭竹' , '1989-01-01' , '女');
insert into Student values('09' , '張三' , '2017-12-20' , '女');
insert into Student values('10' , '李四' , '2017-12-25' , '女');
insert into Student values('11' , '李四' , '2012-06-06' , '女');
insert into Student values('12' , '趙六' , '2013-06-13' , '女');
insert into Student values('13' , '孫七' , '2014-06-01' , '女');

create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '語文' , '02');
insert into Course values('02' , '數學' , '01');
insert into Course values('03' , '英語' , '03');

create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '張三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

create table SC(SId varchar(10),CId varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);

/*1.查詢" 01 "課程比" 02 "課程成績高的學生的資訊及課程分數*/
select * from (
select sc1.SId, sc1.score from
(select SId, score from SC where SC.CId = '01') as sc1, (select SId, score from SC where SC.CId = '02') as sc2
where sc1.SId = sc2.SId and sc1.score > sc2.score
) as ref
left join Student
on Student.SId = ref.SId;

/*2.查詢同時存在" 01 "課程和" 02 "課程的情況*/
select * from
(
select t1.SId from 
(select SId from SC where SC.CId = '01' ) as t1, (select SId from SC where SC.CId = '02') as t2
where t1.SId = t2.SId
) ref
left join Student
on Student.SId = ref.SId;

/* 另一種解法
select * from 
    (select * from sc where sc.CId = '01') as t1, 
    (select * from sc where sc.CId = '02') as t2
where t1.SId = t2.SId;
*/

/*3.查詢存在" 01 "課程但可能不存在" 02 "課程的情況(不存在時顯示為 null )*/
select * from(
select a1.SId, a1.CId class1, a1.score class1_score, a2.CId class2, a2.score class2_score from (
(select * from SC where SC.CId = '01') as a1
left join 
(select* from SC where SC.CId = '02') as a2
on a1.SId = a2.SId) )as ref
left join Student
on ref.SId = Student.SId;

/*4.查詢不存在" 01 "課程但存在" 02 "課程的情況*/
select * from(
select a2.SId, a2.CId class2, a2.score class2_score, a1.CId class1, a1.score class1_score from (
(select * from SC where SC.CId = '02') as a2
left join 
(select* from SC where SC.CId = '01') as a1
on a1.SId = a2.SId) )as ref
left join Student
on ref.SId = Student.SId;

/*查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績*/
select Student.SId, Student.Sname, ref.average from Student right join
(select SId, avg(score) average from SC
group by SId
having avg(score) >= 60) as ref
on ref.SId = Student.SId;

/*另一種寫法
select Student.SId, Student.Sname, ref.average from 
Student,(
select SId, avg(score) average from SC
group by SId
having avg(score) >= 60) ref
where Student.SId = ref.SID
*/

/*5.查詢在 SC 表存在成績的學生資訊*/
select * from Student
where Student.SId in 
(select distinct(SId) SId from SC)

/*or
select DISTINCT student.*
from student,sc
where student.SId=sc.SId
*/

/*6.查詢所有同學的學生編號、學生姓名、選課總數、所有課程的總成績(沒成績的顯示為 null )*/
select Student.SId, Student.Sname, classcount.class_num, classcount.sum_score 
from Student
left join
(select * from 
(select SC.SId, count(SC.CId) class_num, sum(SC.score) sum_score from SC group by SC.SId ) as classcount) 
as classcount
on Student.SId = classcount.SId

/* OR
select s.sid, s.sname,r.coursenumber,r.scoresum
from (
    (select student.sid,student.sname 
    from student
    )s 
    left join 
    (select 
        sc.sid, sum(sc.score) as scoresum, count(sc.cid) as coursenumber
        from sc 
        group by sc.sid
    )r 
   on s.sid = r.sid
);
*/



/*7.查有成績的學生資訊*/
select * 
from Student
where Student.SId in (select distinct SC.SId from SC)

/* OR
select * from student 
where exists (select sc.sid from sc where student.sid = sc.sid);
*/



/*8.查詢「李」姓老師的數量*/
select count(Tname)
from Teacher
where SUBSTRING(Tname,1,1) = '李'

/* OR
select count(*)
from teacher
where tname like '李%';
*/

/*9.查詢學過「張三」老師授課的同學的資訊*/
select * from Student where Student.SId in(
select SId from SC where SC.CId in(
select CId from Course where Course.TId in(
select TId from Teacher where Tname = '張三')));

/*OR
select student.* from student,teacher,course,sc
where 
    student.sid = sc.sid 
    and course.cid=sc.cid 
    and course.tid = teacher.tid 
    and tname = '張三';
*/

/*10.查詢沒有學全所有課程的同學的資訊*/
select distinct Student.* from Student, SC
where Student.SId in 
(select SId from SC group by SId having count(CId) != 3)

/*11.查詢至少有一門課與學號為" 01 "的同學所學相同的同學的資訊*/
select * from Student where SId in (
select SId from SC where CID in (
select CId from SC where SId = '01'
)
)

/*12.查詢和" 01 "號的同學學習的課程 完全相同的其他同學的資訊*/
create table Ans(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
declare @count int;
declare @Snum int;
set @count = 1; 
set @Snum = (select count(SId) from Student);
print str(@count)

while @count<= @Snum
begin
	if (select SId )
	insert into Ans 
	select Student.* from Student 
	where SId = '@count' and
	((select CId from SC where SId = @count) = (select CId from SC where SId = '01'))
	set @count = @count + 1;
end;


select row_number() over(order by SId) as row_num,  SId from Student 
where row_num = 3
= 3

where select CId from SC = 
select CId from SC where SId = '01'

select group_concat

/*13.查詢沒學過"張三"老師講授的任一門課程的學生姓名*/
select Sname from Student where SId in (
select SId from SC where CId = (
select CId from Course where TId = (
select TId from Teacher where Tname = '張三')))

/*14.查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績*/
select distinct(Student.SId), Student.Sname, a.avg_score from Student, SC, 
(select SId, avg(score) avg_score, count(CId) fail_num from SC where score < 60 group by SId having count(CId) >= 2) as a
where Student.SId = a.SId;

/*15.檢索" 01 "課程分數小於 60，按分數降序排列的學生資訊*/
select Student.*, SC.CId, SC.score  from Student,SC where
Student.SId = SC.SId and SC.score < 60 and SC.CId = '01' order by score desc

/*16.按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績*/
select * from SC
left join 
(select SId, avg(score) avg_score  from SC group by SId ) average
on SC.SId = average.SId
order by avg_score desc

/*17.查詢各科成績最高分、最低分和平均分：
以如下形式顯示：課程 ID，課程 name，最高分，最低分，平均分，及格率，中等率，優良率，優秀率
及格為>=60，中等為：70-80，優良為：80-90，優秀為：>=90
要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列*/


select 
SC.CId '課程ID', 
Course.Cname '課程 name', 
max(SC.score) '最高分', 
min(SC.score) '最低分', 
avg(SC.score) '平均分',
count(SC.SId) '修課人數',
round(cast(sum(case when SC.score >= 60 then 1 else 0 end) as float)/count(SC.SId), 2) '及格率',
round(cast(sum(case when SC.score between 71 and 80 then 1 else 0 end) as float)/count(SC.SId), 2) '中等率',
round(cast(sum(case when SC.score between 81 and 90 then 1 else 0 end) as float)/count(SC.SId), 2) '優良率',
round(cast(sum(case when SC.score >= 91 then 1 else 0 end) as float)/count(SC.SId), 2) '優秀率'
from SC,Course 
where SC.CId = Course.CId
group by SC.CId, Course.Cname
order by 修課人數 desc, 課程ID asc



/*18.按各科成績進行排序，並顯示排名， Score 重複時保留名次空缺*/
select C1.SId '學生ID', Course.Cname '課程名稱',C1.score '成績' ,case when C1.CId = '01'and C1.score < C2.score then count(C2.SId) end '排名'
from SC C1, SC C2, Course
where C1.CId = Course.CId and C1.CId = '01'
group by C1.SId, C1.CId, Course.Cname, C1.score, C2.score

select a.學生ID, a.CId, Course.Cname, a.成績, a.排名 from(
select distinct C1.SId '學生ID', C1.CId, C1.score '成績', count(C2.SId) '排名'
from SC C1, SC C2
where C1.CId = C2.CId /*and C1.CId = '01'*/ and (C1.score < C2.score or (C1.SId = C2.SId and C1.score = C2.score))
group by  C1.CId, C1.SId, C1.score
) a ,Course
where a.CId = Course.CId
order by a.CId, 排名 ASC


/*
select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a 
left join sc as b 
on a.score<b.score and a.cid = b.cid
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;
*/



/*19.查詢學生的總成績，並進行排名，總分重複時不保留名次空缺*/
select SC.SId, sum(SC.score) total , ROW_NUMBER() OVER( ORDER BY sum(SC.score) desc) '排名' from SC
group by SC.SId
order by total desc

/*20.統計各科成績各分數段人數：課程編號，課程名稱，[100-85]，[85-70]，[70-60]，[60-0] 及所佔百分比*/


select 
SC.CId, Course.Cname,
sum(case when 100 >= SC.score and SC.score >= 85 then 1 else 0 end)  '[100-85]人數',
sum(case when 84 >= SC.score and SC.score >= 70 then 1 else 0 end)  '[84-70]人數',
sum(case when 69 >= SC.score and SC.score >= 60 then 1 else 0 end)  '[69-60]人數',
round(cast(sum(case when 59 >= SC.score then 1 else 0 end) as float),2) '[59-0]人數',
round(cast(sum(case when 100 >= SC.score and SC.score >= 85 then 1 else 0 end) as float)/count(SC.CId),2)  '[100-85]百分比',
round(cast(sum(case when 84 >= SC.score and SC.score >= 70 then 1 else 0 end) as float)/count(SC.CId),2)  '[84-70]百分比',
round(cast(sum(case when 69 >= SC.score and SC.score >= 60 then 1 else 0 end) as float) /count(SC.CId) ,2)'[69-60]百分比',
round(cast(sum(case when 59 >= SC.score then 1 else 0 end) as float)/count(SC.CId),2) '[59-0]百分比'
from SC
left join 
Course
on SC.CId = Course.CId
group by SC.CId, Course.Cname
order by CId asc

