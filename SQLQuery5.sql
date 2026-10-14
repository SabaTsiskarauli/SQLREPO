CREATE DATABASE HotelBookingDB
GO


USE HotelBookingDB
GO


CREATE TABLE Customers
(
Id INT PRIMARY KEY IDENTITY(1,1),
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE,
PhoneNumber VARCHAR(30)
)
GO


CREATE TABLE Hotels
(
Id INT PRIMARY KEY IDENTITY(1,1),
HotelName NVARCHAR(100),
City NVARCHAR(50),
Stars INT NOT NULL CHECK(Stars BETWEEN 1 AND 5)
)
GO


CREATE TABLE Rooms
(
Id INT PRIMARY KEY IDENTITY(1,1),
HotelId INT NOT NULL,
RoomNumber NVARCHAR(10) NOT NULL,
Capacity INT NOT NULL CHECK(Capacity > 0),
PricePerNight DECIMAL(10,2) NOT NULL CHECK(PricePerNight > 0),
CONSTRAINT UQ_Rooms_Hotel_RoomNumber UNIQUE(HotelId, RoomNumber), --es mainteresbs
CONSTRAINT FK_Rooms_HotelId
   FOREIGN KEY(HotelId)
   REFERENCES Hotels(Id)
   ON DELETE CASCADE
)
GO



CREATE TABLE Bookings
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL,
    RoomId INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    CONSTRAINT CK_Bookings_Dates CHECK(CheckOutDate > CheckInDate), --es mainteresbs
    CONSTRAINT FK_Bookings_CustomerId
        FOREIGN KEY(CustomerId)
        REFERENCES Customers(Id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Bookings_RoomId
        FOREIGN KEY(RoomId)
        REFERENCES Rooms(Id)
        ON DELETE CASCADE
)
GO



CREATE TABLE Payments
(
Id INT PRIMARY KEY IDENTITY(1,1),
BookingId INT NOT NULL,
Amount DECIMAL(10,2) NOT NULL  CHECK(Amount > 0),
PaymentDate DATE NOT NULL,
PaymentMethod NVARCHAR(20) NOT NULL,
CONSTRAINT FK_Payment_BookingId
   FOREIGN KEY(BookingId)
   REFERENCES Bookings(Id)
   ON DELETE CASCADE
)
GO


INSERT INTO Customers(FirstName, LastName, Email, PhoneNumber)
VALUES
('Giorgi', 'Beridze', 'giorgi.beridze@example.com', '+995-555-000-001'),
('Nino', 'Kapanadze', 'nino.kapanadze@example.com', '+995-555-000-002'),
('Anna', 'Smith', 'anna.smith@example.com', '+1-202-555-0103'),
('David', 'Miller', 'david.miller@example.com', '+1-202-555-0104'),
('Mariam', 'Lomidze', 'mariam.lomidze@example.com', '+995-555-000-005'),
('Luka', 'Gelashvili', 'luka.gelashvili@example.com', '+995-555-000-006');
GO


INSERT INTO Hotels (HotelName, City, Stars)
VALUES
('Grand Tbilisi', 'Tbilisi', 5),
('Black Sea Resort', 'Batumi', 4),
('Mountain View', 'Gudauri', 4),
('Old Town Inn', 'Kutaisi', 3);
GO
 
INSERT INTO Rooms (HotelId, RoomNumber, Capacity, PricePerNight)
VALUES
(1, '101', 2, 120.00),   
(1, '102', 2, 120.00),   
(1, '201', 4, 250.00),   
(2, '11',  2,  90.00),   
(2, '12',  3, 110.00),   
(2, '21',  4, 200.00),   
(3, 'A1',  2, 100.00),   
(3, 'A2',  4, 180.00),   
(4, '1',   1,  50.00),   
(4, '2',   2,  70.00);   
GO
 


 INSERT INTO Bookings (CustomerId, RoomId, CheckInDate, CheckOutDate)
VALUES
(1, 1,  '2026-06-01', '2026-06-05'),   
(1, 4,  '2026-07-10', '2026-07-15'),   
(2, 1,  '2026-06-10', '2026-06-12'),   
(2, 2,  '2026-08-01', '2026-08-04'),   
(3, 5,  '2026-07-20', '2026-07-27'),   
(3, 6,  '2026-08-15', '2026-08-18'),   
(4, 7,  '2026-01-05', '2026-01-10'),   
(4, 1,  '2026-09-01', '2026-09-03'),   
(5, 9,  '2026-05-01', '2026-05-03'),   
(1, 2,  '2026-09-10', '2026-09-13');   
GO



INSERT INTO Payments (BookingId, Amount, PaymentDate, PaymentMethod)
VALUES
(1, 200.00, '2026-05-20', 'Card'),
(1, 280.00, '2026-06-05', 'Cash'),
(2, 450.00, '2026-07-01', 'Card'),
(3, 240.00, '2026-06-01', 'Card'),
(4, 360.00, '2026-07-25', 'Transfer'),
(5, 770.00, '2026-07-10', 'Card'),
(6, 600.00, '2026-08-01', 'Card'),
(7, 500.00, '2025-12-20', 'Transfer'),
(8, 100.00, '2026-08-20', 'Cash'),
(9, 100.00, '2026-04-20', 'Card');
GO



/* 1. რომელმა მომხმარებელმა რამდენჯერ დაჯავშნა ნომერი?
      LEFT JOIN, რომ ისინიც გამოჩნდნენ, ვისაც ჯავშანი არ აქვს (COUNT = 0) */
SELECT c.Id,
       c.FirstName + ' ' + c.LastName AS CustomerFullName,
       COUNT(b.Id) AS BookingsCount
FROM Customers AS c
LEFT JOIN Bookings AS b ON b.CustomerId = c.Id
GROUP BY c.Id, c.FirstName, c.LastName
ORDER BY BookingsCount DESC;  --es adgilic mainteresebs




/* 2. რომელ სასტუმროს აქვს ყველაზე მეტი დაჯავშნა?
      WITH TIES, რომ გაიყოფილი პირველი ადგილის შემთხვევაში ყველა გამოჩნდეს */
SELECT TOP(1) WITH TIES
       h.Id,
       h.HotelName,
       COUNT(b.Id) AS BookingsCount
FROM Hotels AS h
INNER JOIN Rooms AS r ON r.HotelId = h.Id
INNER JOIN Bookings AS b ON b.RoomId = r.Id
GROUP BY h.Id, h.HotelName
ORDER BY COUNT(b.Id) DESC;
 
/* 3. რომელი ნომრები არასდროს დაჯავშნილა? */
SELECT r.Id,
       h.HotelName AS HotelName,
       r.RoomNumber,
       r.PricePerNight
FROM Rooms AS r
INNER JOIN Hotels AS h ON h.Id = r.HotelId
LEFT JOIN Bookings AS b ON b.RoomId = r.Id
WHERE b.Id IS NULL;
 
/* 4. თითოეული მომხმარებლის მიერ დახარჯული თანხა (Payments-ის ჯამი)
      ISNULL, რომ გადაუხდელ მომხმარებელს NULL-ის ნაცვლად 0 ეწეროს */
SELECT c.Id,
       c.FirstName + ' ' + c.LastName AS CustomerFullName,
       ISNULL(SUM(p.Amount), 0) AS TotalSpent
FROM Customers AS c
LEFT JOIN Bookings AS b ON b.CustomerId = c.Id
LEFT JOIN Payments AS p ON p.BookingId = b.Id
GROUP BY c.Id, c.FirstName, c.LastName
ORDER BY TotalSpent DESC;
 
/* 5. ყველაზე ძვირადღირებული დაჯავშნა
      ღირებულება = ღამეების რაოდენობა * ნომრის ფასი ღამეზე */
SELECT TOP(1) WITH TIES
       b.Id AS BookingId,
       c.FirstName + ' ' + c.LastName AS CustomerFullName,
       h.HotelName AS HotelName,
       r.RoomNumber,
       DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) AS Nights,
       DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) * r.PricePerNight AS TotalPrice
FROM Bookings AS b
INNER JOIN Customers AS c ON c.Id = b.CustomerId
INNER JOIN Rooms AS r ON r.Id = b.RoomId
INNER JOIN Hotels AS h ON h.Id = r.HotelId
ORDER BY DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) * r.PricePerNight DESC;
 
/* 6. სასტუმროები, რომლებსაც კონკრეტულ პერიოდში ჯავშანი არ ჰქონიათ
      ჯავშანი პერიოდს ემთხვევა, თუ: CheckIn <= @To AND CheckOut >= @From
      პერიოდის პირობა ON-შია, რომ LEFT JOIN-მა დაკარგული სასტუმროები არ წაშალოს */
DECLARE @From DATE = '2026-06-01';
DECLARE @To   DATE = '2026-06-30';
 
SELECT h.Id, h.HotelName, h.City
FROM Hotels AS h
LEFT JOIN Rooms AS r ON r.HotelId = h.Id
LEFT JOIN Bookings AS b
    ON b.RoomId = r.Id
   AND b.CheckInDate <= @To
   AND b.CheckOutDate >= @From
GROUP BY h.Id, h.HotelName, h.City
HAVING COUNT(b.Id) = 0;
