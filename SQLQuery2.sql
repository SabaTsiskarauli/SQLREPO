CREATE DATABASE SabaDB
GO

USE SabaDB
GO

CREATE TABLE Students
(
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) DEFAULT('N/A'),
Age INT NOT NULL CHECK(Age BETWEEN 18 AND 100),
Email NVARCHAR(30) NOT NULL UNIQUE,
StatusIsActive BIT DEFAULT(1)
)
GO

INSERT INTO Students (FirstName, LastName, Age, Email, StatusIsActive)
VALUES
('John', 'Smith', 20, 'john.smith@example.com', 1),
('Emma', 'Johnson', 22, 'emma.johnson@example.com', 1),
('Michael', 'Brown', 19, 'michael.brown@example.com', 1),
('Olivia', 'Davis', 24, 'olivia.davis@example.com', 1),
('James', 'Wilson', 21, 'james.wilson@example.com', 0),
('Sophia', 'Martinez', 25, 'sophia.martinez@example.com', 1),
('William', 'Anderson', 18, 'william.anderson@example.com', 1),
('Isabella', 'Taylor', 23, 'isabella.taylor@example.com', 1),
('Benjamin', 'Thomas', 27, 'benjamin.thomas@example.com', 0),
('Mia', 'Jackson', 20, 'mia.jackson@example.com', 1),
('Lucas', 'White', 29, 'lucas.white@example.com', 1),
('Charlotte', 'Harris', 26, 'charlotte.harris@example.com', 1),
('Henry', 'Martin', 31, 'henry.martin@example.com', 0),
('Amelia', 'Thompson', 22, 'amelia.thompson@example.com', 1),
('Alexander', 'Garcia', 35, 'alexander.garcia@example.com', 1),
('Evelyn', 'Clark', 19, 'evelyn.clark@example.com', 1),
('Daniel', 'Lewis', 28, 'daniel.lewis@example.com', 0),
('Harper', 'Lee', 21, 'harper.lee@example.com', 1),
('Matthew', 'Walker', 40, 'matthew.walker@example.com', 1),
('Grace', 'Hall', 33, 'grace.hall@example.com', 0);
GO


CREATE TABLE Teachers
(
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) DEFAULT('N/A'),
PhoneNumber VARCHAR(50),
Email NVARCHAR(50) NOT NULL UNIQUE,
)
GO


INSERT INTO Teachers (FirstName, LastName, PhoneNumber, Email)
VALUES
('David', 'Miller', '+1-202-555-0101', 'david.miller@example.com'),
('Sarah', 'Wilson', '+1-202-555-0102', 'sarah.wilson@example.com'),
('Robert', 'Taylor', '+1-202-555-0103', 'robert.taylor@example.com'),
('Emily', 'Anderson', '+1-202-555-0104', 'emily.anderson@example.com'),
('Daniel', 'Thomas', '+1-202-555-0105', 'daniel.thomas@example.com'),
('Jessica', 'Jackson', '+1-202-555-0106', 'jessica.jackson@example.com'),
('Christopher', 'White', '+1-202-555-0107', 'chris.white@example.com'),
('Ashley', 'Harris', '+1-202-555-0108', 'ashley.harris@example.com'),
('Matthew', 'Martin', '+1-202-555-0109', 'matthew.martin@example.com'),
('Amanda', 'Thompson', '+1-202-555-0110', 'amanda.thompson@example.com'),
('Andrew', 'Garcia', '+1-202-555-0111', 'andrew.garcia@example.com'),
('Elizabeth', 'Martinez', '+1-202-555-0112', 'elizabeth.martinez@example.com'),
('Joshua', 'Robinson', '+1-202-555-0113', 'joshua.robinson@example.com'),
('Megan', 'Clark', '+1-202-555-0114', 'megan.clark@example.com'),
('Anthony', 'Lewis', '+1-202-555-0115', 'anthony.lewis@example.com'),
('Olivia', 'Lee', '+1-202-555-0116', 'olivia.lee@example.com'),
('James', 'Walker', '+1-202-555-0117', 'james.walker@example.com'),
('Sophia', 'Hall', '+1-202-555-0118', 'sophia.hall@example.com'),
('William', 'Allen', '+1-202-555-0119', 'william.allen@example.com'),
('Isabella', 'Young', '+1-202-555-0120', 'isabella.young@example.com');
GO





CREATE TABLE Subjects
(
Id INT PRIMARY KEY IDENTITY(1,1),
Title NVARCHAR(100) NOT NULL,
AmountOfHours INT NOT NULL CHECK(AmountOfHours > 0)
)
GO


INSERT INTO Subjects (Title, AmountOfHours)
VALUES
('Mathematics', 120),
('English Language', 90),
('Computer Science', 150),
('Physics', 100),
('History', 80);
GO




CREATE TABLE StudentSubject
(
Id INT PRIMARY KEY IDENTITY(1,1),
StudentId INT NOT NULL,
SubjectId INT NOT NULL,
CONSTRAINT FK_Student_Subject_StudentId
   FOREIGN KEY(StudentId)
   REFERENCES Students(Id)
   ON DELETE CASCADE,

CONSTRAINT FK_Student_Subject_SubjectId
   FOREIGN KEY(SubjectId)
   REFERENCES Subjects(Id)
   ON DELETE CASCADE
)
GO


SELECT TOP(5) * FROM Students AS s WHERE s.Age > 20

SELECT FirstName + ' ' + LastName as FullName FROM Students

SELECT * FROM Subjects sub WHERE sub.AmountOfHours BETWEEN 20 AND 50