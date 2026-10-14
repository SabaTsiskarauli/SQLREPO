CREATE DATABASE FitZoneDB
GO


USE FitZoneDB
GO


CREATE TABLE Managers
(
Id INT PRIMARY KEY IDENTITY(1,1),
FullName NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE,
PasswordHash VARCHAR(100) NOT NULL
)
GO


CREATE TABLE Trainers
(
Id INT PRIMARY KEY IDENTITY(1,1),
FullName NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE,
PasswordHash VARCHAR(100) NOT NULL,
Specialization NVARCHAR(100),
WorkoutType NVARCHAR(50)
)
GO


CREATE TABLE Members
(
Id INT PRIMARY KEY IDENTITY(1,1),
FullName NVARCHAR(100) NOT NULL,
Email NVARCHAR(100) NOT NULL UNIQUE,
PasswordHash VARCHAR(100) NOT NULL
)
GO


CREATE TABLE Memberships
(
Id INT PRIMARY KEY IDENTITY(1,1),
MemberId INT NOT NULL,
Type NVARCHAR(10) NOT NULL CHECK(Type IN ('Basic', 'Premium')), --type mainteresebs rasshveba
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
RemainingVisits INT,
Status NVARCHAR(10) NOT NULL DEFAULT 'Active' CHECK(Status IN ('Active', 'Expired')),
VisitLimit INT NOT NULL,
CONSTRAINT CK_Memberships_Dates CHECK(EndDate >= StartDate),
CONSTRAINT CK_Memberships_Visits CHECK(
    (Type = 'Basic' AND VisitLimit = 8 AND RemainingVisits BETWEEN 0 AND 8)
    OR
    (Type = 'Premium' AND VisitLimit = -1 AND RemainingVisits IS NULL)
),
CONSTRAINT FK_Memberships_MemberId
   FOREIGN KEY(MemberId)
   REFERENCES Members(Id)
   ON DELETE CASCADE
)
GO


CREATE TABLE WorkoutSessions
(
Id INT PRIMARY KEY IDENTITY(1,1),
TrainerId INT NOT NULL,
Type NVARCHAR(50) NOT NULL,
StartDateTime DATETIME NOT NULL,
DurationMinutes INT NOT NULL CHECK(DurationMinutes > 0),
Capacity INT NOT NULL CHECK(Capacity > 0),
Status NVARCHAR(10) NOT NULL DEFAULT 'Active' CHECK(Status IN ('Active', 'Cancelled')),
OccupiedPlaces INT NOT NULL DEFAULT 0,
RequiredMembershipType NVARCHAR(10) NOT NULL DEFAULT 'Basic' CHECK(RequiredMembershipType IN ('Basic', 'Premium')),
AvailablePlaces AS (Capacity - OccupiedPlaces),
EndDateTime AS DATEADD(MINUTE, DurationMinutes, StartDateTime),
CONSTRAINT CK_WorkoutSessions_Places CHECK(OccupiedPlaces >= 0 AND OccupiedPlaces <= Capacity),
CONSTRAINT FK_WorkoutSessions_TrainerId
   FOREIGN KEY(TrainerId)
   REFERENCES Trainers(Id)
   ON DELETE CASCADE
)
GO


CREATE TABLE Bookings
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    MemberId INT NOT NULL,
    SessionId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(10) NOT NULL DEFAULT 'Active' CHECK(Status IN ('Active', 'Cancelled', 'Completed', 'Missed')),
    CONSTRAINT FK_Bookings_MemberId
        FOREIGN KEY(MemberId)
        REFERENCES Members(Id)
        ON DELETE CASCADE,
    CONSTRAINT FK_Bookings_SessionId
        FOREIGN KEY(SessionId)
        REFERENCES WorkoutSessions(Id)
        ON DELETE CASCADE
)
GO


CREATE TABLE Visits
(
Id INT PRIMARY KEY IDENTITY(1,1),
MemberId INT NOT NULL,
VisitDate DATETIME NOT NULL DEFAULT GETDATE(),
Status NVARCHAR(10) NOT NULL DEFAULT 'Completed',
CONSTRAINT FK_Visits_MemberId
   FOREIGN KEY(MemberId)
   REFERENCES Members(Id)
   ON DELETE CASCADE
)
GO


INSERT INTO Managers(FullName, Email, PasswordHash)
VALUES
('FitZone Manager', 'manager@gmail.com', '$2b$12$m.AGdwpn28Ado1Jll/IFAumw2vMMyrNv1L6f/wnTN9KRZCukFBjMu');
GO


INSERT INTO Trainers (FullName, Email, PasswordHash, Specialization, WorkoutType)
VALUES
('FitZone Trainer', 'trainer@gmail.com', '$2b$11$W6k5c3ot87hTPMs3kMYuLuiprxo.zHDu3wqjBzxrElWfCiucc/E8K', 'Yoga and Functional Trainer', 'Yoga'),
('Ana Beridze', 'ana@gmail.com', '$2b$11$.pKqmLka4ohPkyKHy5Ve4eg9Z5akYg/GPO1GZHARwKVqcFjoxiwrC', 'Pilates Trainer', 'Pilates'),
('Boxing Trainer', 'boxing@gmail.com', '$2a$11$pOHZlCTTLxl4kIJufut2IegGuBOyt9hkRaHwj5TkA6lPSXPq4BrRC', 'Boxing Trainer', 'Boxing'),
('Good Trainer', 'goodtrainer@gmail.com', '$2b$12$Os6sNHmoQbpF/RvYm9e8JumnqcsQUavcU8MD7pWh.WSrcB.38gF7.', 'Fitnes Trainer', 'Fitnes');
GO


INSERT INTO Members (FullName, Email, PasswordHash)
VALUES
('Giorgi Giorgadze', 'giorgi@gmail.com', '$2a$11$mf2LEDqfOsxq0mtje22izOgnVh.OTp5CJVveXSKJYaKPUJOUOrrNq'),
('Saba Tsiskarauli', 'saba@gmail.com', '$2a$11$qSUWN0FSzhHTBorJtZxBzePyvtqV8rKzDRP.sd7RtAjQJKZy5hw.e'),
('Nino Kapanadze', 'nino@gmail.com', '$2b$11$8n1B8bfnELwdjGbJerTRO.k/q0OuaAfQGtOujtVkNXPrif8bJ4osG'),
('Lasha Beridze', 'lasha@gmail.com', '$2b$11$MBc7b1w7h5yc5tPEfzsXTuBFZExOrl.ZtKh.CKDyjzlD.nQwJ/us2');
GO


INSERT INTO Memberships (MemberId, Type, StartDate, EndDate, RemainingVisits, Status, VisitLimit)
VALUES
(1, 'Premium', '2026-09-29', '2026-10-29', NULL, 'Active', -1),
(2, 'Basic',   '2026-09-30', '2026-10-30', 7,    'Active', 8),
(3, 'Basic',   '2026-08-01', '2026-09-01', 3,    'Expired', 8);
GO


INSERT INTO WorkoutSessions (TrainerId, Type, StartDateTime, DurationMinutes, Capacity, Status, OccupiedPlaces, RequiredMembershipType)
VALUES
(1, 'Yoga',                    '2026-10-01T10:00:00', 60, 15, 'Active',    2, 'Basic'),
(2, 'Personal Group Training', '2026-10-02T17:00:00', 75,  8, 'Active',    1, 'Premium'),
(1, 'Functional Training',     '2026-10-20T12:00:00', 60, 12, 'Active',    1, 'Basic'),
(2, 'Pilates',                 '2026-10-21T15:00:00', 60, 10, 'Active',    0, 'Basic'),
(1, 'Advanced HIIT',           '2026-10-22T18:00:00', 60, 10, 'Active',    1, 'Premium'),
(2, 'Premium Pilates',         '2026-10-23T20:00:00', 60,  8, 'Active',    0, 'Premium'),
(4, 'Boxing',                  '2026-10-24T17:00:00', 60, 15, 'Active',    0, 'Premium'),
(3, 'Boxing',                  '2026-10-25T15:00:00', 60, 15, 'Active',    0, 'Basic'),
(1, 'Yoga',                    '2026-10-19T10:00:00', 60, 15, 'Cancelled', 0, 'Basic');
GO


INSERT INTO Bookings (MemberId, SessionId, CreatedAt, Status)
VALUES
(1, 1, '2026-09-30T09:00:00', 'Completed'),
(2, 1, '2026-09-30T17:10:00', 'Completed'),
(1, 2, '2026-10-01T11:30:00', 'Completed'),
(2, 3, '2026-10-10T14:20:00', 'Active'),
(1, 5, '2026-10-11T08:45:00', 'Active'),
(2, 9, '2026-10-12T19:05:00', 'Cancelled');
GO


INSERT INTO Visits (MemberId, VisitDate, Status)
VALUES
(1, '2026-10-01T10:00:00', 'Completed'),
(1, '2026-10-02T17:00:00', 'Completed'),
(2, '2026-10-01T10:00:00', 'Completed');
GO



