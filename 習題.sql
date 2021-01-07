create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '���p' , '1990-01-01' , '�k');
insert into Student values('02' , '���q' , '1990-12-21' , '�k');
insert into Student values('03' , '�]��' , '1990-12-20' , '�k');
insert into Student values('04' , '����' , '1990-12-06' , '�k');
insert into Student values('05' , '�P��' , '1991-12-01' , '�k');
insert into Student values('06' , '�d��' , '1992-01-01' , '�k');
insert into Student values('07' , '�G��' , '1989-01-01' , '�k');
insert into Student values('09' , '�i�T' , '2017-12-20' , '�k');
insert into Student values('10' , '���|' , '2017-12-25' , '�k');
insert into Student values('11' , '���|' , '2012-06-06' , '�k');
insert into Student values('12' , '����' , '2013-06-13' , '�k');
insert into Student values('13' , '�]�C' , '2014-06-01' , '�k');

create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '�y��' , '02');
insert into Course values('02' , '�ƾ�' , '01');
insert into Course values('03' , '�^�y' , '03');

create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '�i�T');
insert into Teacher values('02' , '���|');
insert into Teacher values('03' , '����');

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

/*1.�d��" 01 "�ҵ{��" 02 "�ҵ{���Z�����ǥͪ���T�νҵ{����*/
select * from (
select sc1.SId, sc1.score from
(select SId, score from SC where SC.CId = '01') as sc1, (select SId, score from SC where SC.CId = '02') as sc2
where sc1.SId = sc2.SId and sc1.score > sc2.score
) as ref
left join Student
on Student.SId = ref.SId;

/*2.�d�ߦP�ɦs�b" 01 "�ҵ{�M" 02 "�ҵ{�����p*/
select * from
(
select t1.SId from 
(select SId from SC where SC.CId = '01' ) as t1, (select SId from SC where SC.CId = '02') as t2
where t1.SId = t2.SId
) ref
left join Student
on Student.SId = ref.SId;

/* �t�@�ظѪk
select * from 
    (select * from sc where sc.CId = '01') as t1, 
    (select * from sc where sc.CId = '02') as t2
where t1.SId = t2.SId;
*/

/*3.�d�ߦs�b" 01 "�ҵ{���i�ण�s�b" 02 "�ҵ{�����p(���s�b����ܬ� null )*/
select * from(
select a1.SId, a1.CId class1, a1.score class1_score, a2.CId class2, a2.score class2_score from (
(select * from SC where SC.CId = '01') as a1
left join 
(select* from SC where SC.CId = '02') as a2
on a1.SId = a2.SId) )as ref
left join Student
on ref.SId = Student.SId;

/*4.�d�ߤ��s�b" 01 "�ҵ{���s�b" 02 "�ҵ{�����p*/
select * from(
select a2.SId, a2.CId class2, a2.score class2_score, a1.CId class1, a1.score class1_score from (
(select * from SC where SC.CId = '02') as a2
left join 
(select* from SC where SC.CId = '01') as a1
on a1.SId = a2.SId) )as ref
left join Student
on ref.SId = Student.SId;

/*�d�ߥ������Z�j�󵥩� 60 �����P�Ǫ��ǥͽs���M�ǥͩm�W�M�������Z*/
select Student.SId, Student.Sname, ref.average from Student right join
(select SId, avg(score) average from SC
group by SId
having avg(score) >= 60) as ref
on ref.SId = Student.SId;

/*�t�@�ؼg�k
select Student.SId, Student.Sname, ref.average from 
Student,(
select SId, avg(score) average from SC
group by SId
having avg(score) >= 60) ref
where Student.SId = ref.SID
*/

/*5.�d�ߦb SC ��s�b���Z���ǥ͸�T*/
select * from Student
where Student.SId in 
(select distinct(SId) SId from SC)

/*or
select DISTINCT student.*
from student,sc
where student.SId=sc.SId
*/

/*6.�d�ߩҦ��P�Ǫ��ǥͽs���B�ǥͩm�W�B����`�ơB�Ҧ��ҵ{���`���Z(�S���Z����ܬ� null )*/
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



/*7.�d�����Z���ǥ͸�T*/
select * 
from Student
where Student.SId in (select distinct SC.SId from SC)

/* OR
select * from student 
where exists (select sc.sid from sc where student.sid = sc.sid);
*/



/*8.�d�ߡu���v�m�Ѯv���ƶq*/
select count(Tname)
from Teacher
where SUBSTRING(Tname,1,1) = '��'

/* OR
select count(*)
from teacher
where tname like '��%';
*/

/*9.�d�߾ǹL�u�i�T�v�Ѯv�½Ҫ��P�Ǫ���T*/
select * from Student where Student.SId in(
select SId from SC where SC.CId in(
select CId from Course where Course.TId in(
select TId from Teacher where Tname = '�i�T')));

/*OR
select student.* from student,teacher,course,sc
where 
    student.sid = sc.sid 
    and course.cid=sc.cid 
    and course.tid = teacher.tid 
    and tname = '�i�T';
*/

/*10.�d�ߨS���ǥ��Ҧ��ҵ{���P�Ǫ���T*/
select distinct Student.* from Student, SC
where Student.SId in 
(select SId from SC group by SId having count(CId) != 3)

/*11.�d�ߦܤ֦��@���һP�Ǹ���" 01 "���P�ǩҾǬۦP���P�Ǫ���T*/
select * from Student where SId in (
select SId from SC where CID in (
select CId from SC where SId = '01'
)
)

/*12.�d�ߩM" 01 "�����P�Ǿǲߪ��ҵ{ �����ۦP����L�P�Ǫ���T*/
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

/*13.�d�ߨS�ǹL"�i�T"�Ѯv���ª����@���ҵ{���ǥͩm�W*/
select Sname from Student where SId in (
select SId from SC where CId = (
select CId from Course where TId = (
select TId from Teacher where Tname = '�i�T')))

/*14.�d�ߨ���Ψ�H�W���ή�ҵ{���P�Ǫ��Ǹ��A�m�W�Ψ䥭�����Z*/
select distinct(Student.SId), Student.Sname, a.avg_score from Student, SC, 
(select SId, avg(score) avg_score, count(CId) fail_num from SC where score < 60 group by SId having count(CId) >= 2) as a
where Student.SId = a.SId;

/*15.�˯�" 01 "�ҵ{���Ƥp�� 60�A�����ƭ��ǱƦC���ǥ͸�T*/
select Student.*, SC.CId, SC.score  from Student,SC where
Student.SId = SC.SId and SC.score < 60 and SC.CId = '01' order by score desc

/*16.���������Z�q����C��ܩҦ��ǥͪ��Ҧ��ҵ{�����Z�H�Υ������Z*/
select * from SC
left join 
(select SId, avg(score) avg_score  from SC group by SId ) average
on SC.SId = average.SId
order by avg_score desc

/*17.�d�ߦU�즨�Z�̰����B�̧C���M�������G
�H�p�U�Φ���ܡG�ҵ{ ID�A�ҵ{ name�A�̰����A�̧C���A�������A�ή�v�A�����v�A�u�}�v�A�u�q�v
�ή欰>=60�A�������G70-80�A�u�}���G80-90�A�u�q���G>=90
�n�D��X�ҵ{���M��פH�ơA�d�ߵ��G���H�ƭ��ǱƦC�A�Y�H�ƬۦP�A���ҵ{���ɧǱƦC*/


select 
SC.CId '�ҵ{ID', 
Course.Cname '�ҵ{ name', 
max(SC.score) '�̰���', 
min(SC.score) '�̧C��', 
avg(SC.score) '������',
count(SC.SId) '�׽ҤH��',
round(cast(sum(case when SC.score >= 60 then 1 else 0 end) as float)/count(SC.SId), 2) '�ή�v',
round(cast(sum(case when SC.score between 71 and 80 then 1 else 0 end) as float)/count(SC.SId), 2) '�����v',
round(cast(sum(case when SC.score between 81 and 90 then 1 else 0 end) as float)/count(SC.SId), 2) '�u�}�v',
round(cast(sum(case when SC.score >= 91 then 1 else 0 end) as float)/count(SC.SId), 2) '�u�q�v'
from SC,Course 
where SC.CId = Course.CId
group by SC.CId, Course.Cname
order by �׽ҤH�� desc, �ҵ{ID asc



/*18.���U�즨�Z�i��ƧǡA����ܱƦW�A Score ���ƮɫO�d�W���ů�*/
select C1.SId '�ǥ�ID', Course.Cname '�ҵ{�W��',C1.score '���Z' ,case when C1.CId = '01'and C1.score < C2.score then count(C2.SId) end '�ƦW'
from SC C1, SC C2, Course
where C1.CId = Course.CId and C1.CId = '01'
group by C1.SId, C1.CId, Course.Cname, C1.score, C2.score

select a.�ǥ�ID, a.CId, Course.Cname, a.���Z, a.�ƦW from(
select distinct C1.SId '�ǥ�ID', C1.CId, C1.score '���Z', count(C2.SId) '�ƦW'
from SC C1, SC C2
where C1.CId = C2.CId /*and C1.CId = '01'*/ and (C1.score < C2.score or (C1.SId = C2.SId and C1.score = C2.score))
group by  C1.CId, C1.SId, C1.score
) a ,Course
where a.CId = Course.CId
order by a.CId, �ƦW ASC


/*
select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a 
left join sc as b 
on a.score<b.score and a.cid = b.cid
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;
*/



/*19.�d�߾ǥͪ��`���Z�A�öi��ƦW�A�`�����Ʈɤ��O�d�W���ů�*/
select SC.SId, sum(SC.score) total , ROW_NUMBER() OVER( ORDER BY sum(SC.score) desc) '�ƦW' from SC
group by SC.SId
order by total desc

/*20.�έp�U�즨�Z�U���Ƭq�H�ơG�ҵ{�s���A�ҵ{�W�١A[100-85]�A[85-70]�A[70-60]�A[60-0] �ΩҦ��ʤ���*/


select 
SC.CId, Course.Cname,
sum(case when 100 >= SC.score and SC.score >= 85 then 1 else 0 end)  '[100-85]�H��',
sum(case when 84 >= SC.score and SC.score >= 70 then 1 else 0 end)  '[84-70]�H��',
sum(case when 69 >= SC.score and SC.score >= 60 then 1 else 0 end)  '[69-60]�H��',
round(cast(sum(case when 59 >= SC.score then 1 else 0 end) as float),2) '[59-0]�H��',
round(cast(sum(case when 100 >= SC.score and SC.score >= 85 then 1 else 0 end) as float)/count(SC.CId),2)  '[100-85]�ʤ���',
round(cast(sum(case when 84 >= SC.score and SC.score >= 70 then 1 else 0 end) as float)/count(SC.CId),2)  '[84-70]�ʤ���',
round(cast(sum(case when 69 >= SC.score and SC.score >= 60 then 1 else 0 end) as float) /count(SC.CId) ,2)'[69-60]�ʤ���',
round(cast(sum(case when 59 >= SC.score then 1 else 0 end) as float)/count(SC.CId),2) '[59-0]�ʤ���'
from SC
left join 
Course
on SC.CId = Course.CId
group by SC.CId, Course.Cname
order by CId asc

