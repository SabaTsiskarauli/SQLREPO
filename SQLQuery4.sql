SELECT * FROM Teachers
SELECT * FROM Subjects
SELECT * FROM Students





CREATE TABLE TeacherSubject
(
Id INT PRIMARY KEY IDENTITY(1,1),
TeacherId INT NOT NULL,
SubjectId INT NOT NULL,

CONSTRAINT FK_TeacherSubject_TeacherId
   FOREIGN KEY(TeacherId)
   REFERENCES Teachers(Id)
   ON DELETE CASCADE,

   CONSTRAINT FK_TeacherSubject_SubjectId
   FOREIGN KEY(SubjectId)
   REFERENCES Subjects(Id)
   ON DELETE CASCADE,

)
GO


INSERT INTO TeacherSubject (TeacherId, SubjectId)
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5);
GO





/* 1. სტუდენტი და მისი საგანი */
SELECT s.FirstName, s.LastName, sub.Title
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
INNER JOIN Subjects AS sub ON sub.Id = ss.SubjectId;

/* 2. მასწავლებელი და მისი საგანი */
SELECT t.FirstName + ' ' + t.LastName AS TeacherFullName,
       sub.Title
FROM Teachers AS t
INNER JOIN TeacherSubject AS ts ON ts.TeacherId = t.Id
INNER JOIN Subjects AS sub ON sub.Id = ts.SubjectId;

/* 3. მხოლოდ აქტიური სტუდენტები და მათი საგნები */
SELECT s.FirstName + ' ' + s.LastName AS StudentFullName,
       s.Age,
       sub.Title
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
INNER JOIN Subjects AS sub ON sub.Id = ss.SubjectId
WHERE s.StatusIsActive = 1;

/* 4. ყველა სტუდენტი, მათ შორის ისინი, ვისაც საგანი არ აქვს */
SELECT s.Id,
       s.FirstName + ' ' + s.LastName AS StudentFullName,
       sub.Title
FROM Students AS s
LEFT JOIN StudentSubject AS ss ON ss.StudentId = s.Id
LEFT JOIN Subjects AS sub ON sub.Id = ss.SubjectId;

/* 5. ყველა საგანი და მასზე ჩაწერილი სტუდენტები */
SELECT sub.Title,
       s.FirstName + ' ' + s.LastName AS StudentFullName
FROM Subjects AS sub
LEFT JOIN StudentSubject AS ss ON ss.SubjectId = sub.Id
LEFT JOIN Students AS s ON s.Id = ss.StudentId;

/* 6. სტუდენტი + საგანი + მასწავლებელი */
SELECT s.FirstName + ' ' + s.LastName AS StudentFullName,
       sub.Title,
       t.FirstName + ' ' + t.LastName AS TeacherFullName
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
INNER JOIN Subjects AS sub ON sub.Id = ss.SubjectId
INNER JOIN TeacherSubject AS ts ON ts.SubjectId = sub.Id
INNER JOIN Teachers AS t ON t.Id = ts.TeacherId;

/* 7. ყველა მასწავლებელი და მათი საგნები */
SELECT t.FirstName + ' ' + t.LastName AS TeacherFullName,
       sub.Title,
       sub.AmountOfHours
FROM Teachers AS t
LEFT JOIN TeacherSubject AS ts ON ts.TeacherId = t.Id
LEFT JOIN Subjects AS sub ON sub.Id = ts.SubjectId;

/* 8. Programming-ის სტუდენტები
   შენს ბაზაში 'Programming' საგანი არ არის, ამიტომ 'Computer Science' მაქვს.
   თუ Programming დაამატე, უბრალოდ შეცვალე WHERE-ში სახელი. */
SELECT s.FirstName + ' ' + s.LastName AS StudentFullName,
       s.Age,
       s.Email,
       sub.Title,
       sub.AmountOfHours
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
INNER JOIN Subjects AS sub ON sub.Id = ss.SubjectId
WHERE sub.Title = 'Computer Science';

/* 9. ყველა სტუდენტი და ყველა საგანი */
SELECT s.FirstName + ' ' + s.LastName AS StudentFullName,
       sub.Title
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
FULL OUTER JOIN Subjects AS sub ON sub.Id = ss.SubjectId;
/* ზემოთ INNER JOIN-ით ვზღუდავთ StudentSubject-ს, ამიტომ სტუდენტი უსაგნოდ ვერ გამოჩნდება.
   სწორი ვარიანტი, რომელიც ორივე მხარეს ინარჩუნებს: */
SELECT s.FirstName + ' ' + s.LastName AS StudentFullName,
       sub.Title
FROM Students AS s
LEFT JOIN StudentSubject AS ss ON ss.StudentId = s.Id
FULL OUTER JOIN Subjects AS sub ON sub.Id = ss.SubjectId;

/* 10. აქტიური სტუდენტი, საგანი (>50 საათი), მასწავლებელი */
SELECT s.FirstName + ' ' + s.LastName AS [Student Full Name],
       s.Age,
       sub.Title AS [Subject Title],
       sub.AmountOfHours,
       t.FirstName + ' ' + t.LastName AS [Teacher Full Name]
FROM Students AS s
INNER JOIN StudentSubject AS ss ON ss.StudentId = s.Id
INNER JOIN Subjects AS sub ON sub.Id = ss.SubjectId
INNER JOIN TeacherSubject AS ts ON ts.SubjectId = sub.Id
INNER JOIN Teachers AS t ON t.Id = ts.TeacherId
WHERE s.StatusIsActive = 1
  AND sub.AmountOfHours > 50
ORDER BY sub.AmountOfHours DESC;

/* დამატებითი გამოწვევა: მასწავლებელი, საგანი, ჩაწერილი სტუდენტების რაოდენობა */
SELECT t.FirstName + ' ' + t.LastName AS TeacherFullName,
       sub.Title,
       COUNT(s.Id) AS StudentCount
FROM Teachers AS t
INNER JOIN TeacherSubject AS ts ON ts.TeacherId = t.Id
INNER JOIN Subjects AS sub ON sub.Id = ts.SubjectId
INNER JOIN StudentSubject AS ss ON ss.SubjectId = sub.Id
INNER JOIN Students AS s ON s.Id = ss.StudentId
GROUP BY t.Id, t.FirstName, t.LastName, sub.Id, sub.Title;