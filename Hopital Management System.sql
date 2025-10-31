--Hospital Management System
--Create Database
CREATE DATABASE Hospital_Management_System

USE Hospital_Management_System

-- 2. Create Tables

-- Patient table
CREATE TABLE Patients 
(
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    ContactNumber NVARCHAR(15) UNIQUE
)

select * from Patients
insert into Patients (FirstName,LastName,DateOfBirth,Gender,ContactNumber)
values ('Amit','Sharma','2000-11-09','M','9098765643'),
('Sumit','Verma','1970-10-08','M','9198765643'),
('Pulkit','Singh','1986-06-05','M','9088765643'),
('Mohini','Yadav','1998-12-06','F','9098065643')

-- Doctor table
CREATE TABLE Doctors 
(
    DoctorID INT IDENTITY(101,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100),
    ContactNumber NVARCHAR(15) UNIQUE
)
insert into Doctors(FirstName,LastName,Specialization,ContactNumber)
values ('Amrit','Pal','ENT','9998765643'),
('Nisha','Pallav','BPT','9998765143'),
('Anuradha','Sharma','Surgeon','9908785643'),
('Subhajit','Das','Gynocologist','9998711643')

select * from Doctors

-- Room table
CREATE TABLE Rooms 
(
    RoomID INT IDENTITY(201,1) PRIMARY KEY,
    RoomNumber NVARCHAR(10) UNIQUE NOT NULL,
    RoomType NVARCHAR(50),
    BedCount INT CHECK (BedCount > 0)
)
insert into Rooms(RoomNumber,RoomType,BedCount)
values ('1','AC',5),
('2','Non AC',4),
('3','AC',3),
('4','Non AC',2)

select *from Rooms


-- Treatments table (Relationship between patients and doctors)
CREATE TABLE Treatments (
    TreatmentID INT IDENTITY(301,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    TreatmentStartDate DATE NOT NULL,
    TreatmentEndDate DATE NULL,
    Diagnosis NVARCHAR(255),
    FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY(DoctorID) REFERENCES Doctors(DoctorID)
)
insert into Treatments(PatientID,DoctorID,TreatmentStartDate,TreatmentEndDate,Diagnosis)
values (1,101,'2024-11-09','2025-10-12','Stone 2.4 MM'),
(2,102,'2024-1-19','2024-11-19','Appendix in Stomach'),
(3,103,'2023-01-10','2024-10-01','Bone Marrow'),
(4,104,'2024-03-19','2025-01-12','Infection in Liver')

select *from Treatments


-- Admission table
CREATE TABLE Admissions 
(
    AdmissionID INT IDENTITY(401,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    RoomID INT NOT NULL,
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE NULL,
    FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY(RoomID) REFERENCES Rooms(RoomID)
)
select *from Admissions
insert into Admissions(PatientID,RoomID,AdmissionDate,DischargeDate)
values (1,201,'2024-11-09','2025-10-12'),
(2,202,'2024-1-19','2024-11-19'),
(3,203,'2023-01-10','2024-10-01'),
(4,204,'2024-03-19','2025-01-12')

-- Duties table for nurses and ward boys
CREATE TABLE StaffDuties 
(
    StaffDutyID INT IDENTITY(501,1) PRIMARY KEY,
    StaffName NVARCHAR(100) NOT NULL,
    DutyType NVARCHAR(50) CHECK (DutyType IN ('Nurse', 'Ward Boy')),
    DutyDescription NVARCHAR(255)
)
select *from StaffDuties
insert into StaffDuties(StaffName,DutyType,DutyDescription)
values ('Kamal Mishra','Ward Boy','General'),
('Anamika Sharma','Nurse','Night'),
('Monty Singh','Ward Boy','General'),
('Komal Sharma','Nurse','General')
-- Medical stores table
CREATE TABLE MedicalStores 
(
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    MedicineName NVARCHAR(100) NOT NULL,
    Quantity INT CHECK (Quantity >= 0),
    ExpiryDate DATE
)
select *from MedicalStores
insert into MedicalStores(MedicineName,Quantity,ExpiryDate)
values ('Neumycin','14','2026-11-05'),
('Paracetamol','15','2026-1-03'),
('Voveran','18','2026-01-07'),
('Sirdalud','11','2026-03-03')


-- 3. Stored Procedure to get patient treatment history
CREATE PROCEDURE GetPatient_Treatment_History 
@PatientID INT
AS
BEGIN
    SELECT t.TreatmentID, t.TreatmentStartDate, t.TreatmentEndDate, t.Diagnosis,
           d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, d.Specialization
    FROM Treatments t
    INNER JOIN Doctors d ON t.DoctorID = d.DoctorID
    WHERE t.PatientID = @PatientID;
END

exec GetPatient_Treatment_History 4

-- 4. Stored Procedure to admit a patient
CREATE PROCEDURE AdmitPatient
    @PatientID INT,
    @RoomID INT,
    @AdmissionDate DATE
AS
BEGIN
    INSERT INTO Admissions (PatientID, RoomID, AdmissionDate) 
    VALUES (@PatientID, @RoomID, @AdmissionDate);
END
exec AdmitPatient 4,204,'2025-06-04'