create table book1(
book_id int,
isbn varchar(20)primary key,
book_name char(50),
edition varchar(10) , 
quantity char(20),
);
insert into book1 values(101,'123','stars','a1',10);
insert into book1 values(102,'234','moon','b1',10);
insert into book1 values(103,'456','sun','c1',10);
insert into book1 values(104,'678','venus','d1',10);
insert into book1 values(105,'890','mars','e1',10);
Select *from book1;

create table student1(
st_id int primary key,
st_name varchar(20),
st_email varchar(50),
st_sem char(5),
);
ALTER TABLE student1
ADD deptid varchar(10);

insert into student1 values(021,'maryam','maryam@gmail.com',1,'d10');
insert into student1 values(020,'momna','momna@gmail.com',2,'d10');
insert into student1 values(022,'anaya','anaya@gmail.com',2,'d20');
insert into student1 values(023,'farah','farah@gmail.com',3,'d30');
Select *from student1;
UPDATE student1
SET deptid = 'd10'
WHERE st_id = 021;
UPDATE student1
SET deptid = 'd10'
WHERE st_id = 020;
UPDATE student1
SET deptid = 'd20'
WHERE st_id = 022;
UPDATE student1
SET deptid = 'd30'
WHERE st_id = 023;
ALTER TABLE student1
ADD FOREIGN KEY (deptid) REFERENCES department(deptid);

create table librarian(
libid varchar(10) primary key,
libname varchar(10),
address varchar(10),
gender char(10),
phoneno varchar(11),
);
insert into librarian values('l2','john','cpark','male','123456789');
insert into librarian values('l8','lisa','johar','female','987654321');
insert into librarian values('l6','selena','wapda','female','34456789');
Select *from librarian;

create table department(
deptid varchar(10) primary key,
dept_name varchar(10),
);
insert into department values('d10','cs');
insert into department values('d20','bio');
insert into department values('d30','math');
Select *from department;

create table issuedbook(
issueid varchar(50) primary key,
idate varchar(100),
);
insert into issuedbook values('i-1','4-23');
insert into issuedbook values('i-2','2-22');
insert into issuedbook values('i-4','6-21');
insert into issuedbook values('i-6','3-20');
Select *from issuedbook;
ALTER TABLE issuedbook
DROP column book_id;
ALTER TABLE issuedbook
ADD FOREIGN KEY (isbn) REFERENCES book1(isbn);
ALTER TABLE issuedbook
ADD isbn varchar(20);
UPDATE issuedbook
SET isbn = '123'
WHERE issueid = 'i-1';
UPDATE issuedbook
SET isbn = '234'
WHERE issueid = 'i-2';
UPDATE issuedbook
SET isbn = '456'
WHERE issueid = 'i-4';
UPDATE issuedbook
SET isbn = '678'
WHERE issueid = 'i-6';
ALTER TABLE issuedbook
ADD st_id int;
ALTER TABLE issuedbook
ADD FOREIGN KEY (st_id) REFERENCES student1(st_id);
UPDATE issuedbook
SET st_id = '021'
WHERE issueid = 'i-1';
UPDATE issuedbook
SET st_id = '022'
WHERE issueid = 'i-2';
UPDATE issuedbook
SET st_id = '023'
WHERE issueid = 'i-4';
UPDATE issuedbook
SET st_id = '023'
WHERE issueid = 'i-6';
ALTER TABLE issuedbook
ADD deptid varchar(10);
ALTER TABLE issuedbook
ADD FOREIGN KEY (deptid) REFERENCES department(deptid);
UPDATE issuedbook
SET deptid = 'd10'
WHERE issueid = 'i-2';
UPDATE issuedbook
SET deptid = 'd20'
WHERE issueid = 'i-1';
UPDATE issuedbook
SET deptid = 'd30'
WHERE issueid = 'i-4';
UPDATE issuedbook
SET deptid = 'd30'
WHERE issueid = 'i-6';

create table returnedbook(
returnid varchar(50) primary key,
returndate varchar(20),
);
insert into returnedbook values('i-2','5-22');
insert into returnedbook values('i-4','10-21');

Select *from returnedbook;

ALTER TABLE returnedbook
DROP column book_id;

ALTER TABLE returnedbook
ADD FOREIGN KEY (isbn) REFERENCES book1(isbn);
ALTER TABLE returnedbook
ADD isbn varchar(20);
UPDATE returnedbook
SET isbn = '456'
WHERE returnid = 'i-4';
UPDATE returnedbook
SET isbn = '234'
WHERE returnid = 'i-2';
ALTER TABLE returnedbook
ADD st_id int;
ALTER TABLE returnedbook
ADD FOREIGN KEY (st_id) REFERENCES student1(st_id);
UPDATE returnedbook
SET st_id = '022'
WHERE returnid = 'i-2';
UPDATE returnedbook
SET st_id = '023'
WHERE returnid = 'i-4';
ALTER TABLE returnedbook
ADD deptid varchar(10);
ALTER TABLE returnedbook
ADD FOREIGN KEY (deptid) REFERENCES department(deptid);
UPDATE returnedbook
SET deptid = 'd10'
WHERE returnid = 'i-2';

UPDATE returnedbook
SET deptid = 'd30'
WHERE returnid = 'i-4';

/*complex queries*/

/* (1) Retrieve the books borrowed by a specific student*/

SELECT * 
FROM book1
JOIN issuedbook ON book1.isbn =issuedbook.isbn
WHERE issuedbook.st_id = '021';

/* (2) Retrieve the students who have borrowed a specific book*/

SELECT *
FROM student1
JOIN issuedbook ON student1.st_id = issuedbook.st_id
WHERE issuedbook.isbn = '678';

/* (3) Get a list of borrowers and the number of books they have borrowed, including borrowers who haven't borrowed any books:*/

SELECT issuedbook.issueid, COUNT(returnedbook.isbn) AS issue_count
FROM issuedbook
LEFT JOIN returnedbook ON issuedbook.issueid = returnedbook.returnid
GROUP BY issuedbook.issueid;

/* (4) Retrieve all borrowers and their borrowed books, including borrowers who haven't borrowed any books:*/

SELECT issuedbook.issueid, book1.edition
FROM issuedbook
LEFT JOIN returnedbook ON issuedbook.issueid = returnedbook.returnid
LEFT JOIN book1 ON returnedbook.isbn = book1.isbn;

/* (5) Retrieve borrowers who have borrowed the maximum number of books: (NOT WORKING) ERROR*/

SELECT issueid
FROM issuedbook
WHERE issueid IN (
  SELECT returnid
  FROM returnedbook
  GROUP BY issueid
  HAVING COUNT(*) = (
    SELECT MAX(count_issued)
    FROM (
      SELECT COUNT(*) AS count_issued
      FROM returnedbook
      GROUP BY returnid
    ) AS issued_counts
  )
);

/* (6) Retrieve all students who have returned books:*/

SELECT *
FROM issuedbook
WHERE issueid IN (
  SELECT DISTINCT returnid
  FROM returnedbook
);

/* (7) Get the Cartesian product of borrowers and loans with additional filtering(NOT WORKING):*/

SELECT *
FROM issuedbook
CROSS JOIN returnedbook
WHERE returnedbook.returndate IS NULL
  AND issuedbook.issueid = [specific_issueid];

  /* (8) Find the total number of possible combinations between borrowers and loans:*/

SELECT COUNT(*) AS total_combinations
FROM issuedbook
CROSS JOIN returnedbook;

/* (9) Retrieve all books and their corresponding borrowers, including books without any borrowers:*/

SELECT book1.edition, issuedbook.issueid
FROM book1
LEFT JOIN returnedbook ON book1.isbn = returnedbook.isbn
LEFT JOIN issuedbook ON returnedbook.returnid = issuedbook.issueid;

/* (10) Retrieve the total number of books borrowed by each student:*/

SELECT student1.st_id, student1.st_name, COUNT(issuedbook.isbn) AS total_borrowed
FROM student1
LEFT JOIN issuedbook ON student1.st_id = issuedbook.st_id
GROUP BY student1.st_id, student1.st_name;


/* (11) Retrieve the list of students who have borrowed books along with the book details:*/

SELECT student1.st_id, student1.st_name, book1.*
FROM student1
JOIN issuedbook ON student1.st_id = issuedbook.st_id
JOIN book1 ON issuedbook.isbn = book1.isbn;


/* (12) Retrieve the list of books that have not been borrowed by any student:*/

SELECT book1.*
FROM book1
LEFT JOIN issuedbook ON book1.isbn = issuedbook.isbn
WHERE issuedbook.isbn IS NULL;

/* (13) Retrieve the list of books borrowed by students from a specific department:*/

SELECT student1.st_id, student1.st_name, book1.*
FROM student1
JOIN issuedbook ON student1.st_id = issuedbook.st_id
JOIN book1 ON issuedbook.isbn = book1.isbn
JOIN department ON student1.deptid = department.deptid
WHERE department.deptid = 'd10';

/* (14) Retrieve the list of books that are currently borrowed:*/

SELECT book1.*
FROM book1
JOIN issuedbook ON book1.isbn = issuedbook.isbn;

/* (15) Retrieve the list of books that have been borrowed but not yet returned:*/

SELECT book1.*
FROM book1
JOIN issuedbook ON book1.isbn = issuedbook.isbn
LEFT JOIN returnedbook ON issuedbook.issueid = returnedbook.returnid
WHERE returnedbook.returnid IS NULL;

/* (16) Retrieve the list of books along with the count of times they have been borrowed and returned:*/

SELECT book1.isbn, book1.book_name, COUNT(issuedbook.issueid) AS borrowed_count, COUNT(returnedbook.returnid) AS returned_count
FROM book1
LEFT JOIN issuedbook ON book1.isbn = issuedbook.isbn
LEFT JOIN returnedbook ON book1.isbn = returnedbook.isbn
GROUP BY book1.isbn, book1.book_name;

/* (17) Retrieve the list of books that have been borrowed by students from a specific department and not yet returned:*/

SELECT book1.*
FROM book1
JOIN issuedbook ON book1.isbn = issuedbook.isbn
LEFT JOIN returnedbook ON issuedbook.issueid = returnedbook.returnid
JOIN student1 ON issuedbook.st_id = student1.st_id
WHERE student1.deptid = 'd10' 
  AND returnedbook.returnid IS NULL;

 /*(18) Retrieve the names of students who have issued books more than once:*/

SELECT s.st_name
FROM student1 s
JOIN issuedbook ib ON s.st_id = ib.st_id
GROUP BY s.st_name
HAVING COUNT(*) > 1;

/* (19) Retrieve all the books and their corresponding departments:*/

SELECT b.book_name, d.dept_name
FROM book1 b
JOIN issuedbook ib ON b.isbn = ib.isbn
JOIN department d ON ib.deptid = d.deptid;

 /* (20) Retrieve the names of students who have issued books from the 'cs' department:*/

SELECT s.st_name
FROM student1 s
JOIN issuedbook ib ON s.st_id = ib.st_id
JOIN department d ON ib.deptid = d.deptid
WHERE d.dept_name = 'cs';