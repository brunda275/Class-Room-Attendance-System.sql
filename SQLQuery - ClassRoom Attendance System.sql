CREATE DATABASE ClassroomAttendanceDB;
GO
USE ClassroomAttendanceDB;
GO
-- Creating the Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    DateOfBirth DATE
);
GO

-- Creating the Professors table
CREATE TABLE Professors (
    ProfessorID INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Department VARCHAR(100)
);
GO

-- Creating the Classes table
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY,
    ClassName VARCHAR(100),
    ClassDate DATE,
    StartTime TIME,
    EndTime TIME,
    RoomNumber VARCHAR(50),
    ProfessorID INT,
    FOREIGN KEY (ProfessorID) REFERENCES Professors(ProfessorID)
);
GO

-- Creating the Attendance table
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY IDENTITY,
    ClassID INT,
    StudentID INT,
    AttendanceDate DATE,
    Status VARCHAR(10),  -- 'Present', 'Absent', 'Late'
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO
-- Insert Sample Data into Students
INSERT INTO Students (FirstName, LastName, DateOfBirth)
VALUES 
('John', 'Doe', '2000-05-10'),
('Jane', 'Smith', '2001-08-15'),
('Mary', 'Johnson', '1999-11-20');
GO
-- Insert Sample Data into Professors
INSERT INTO Professors (FirstName, LastName, Department)
VALUES 
('Dr. Alice', 'Brown', 'Computer Science'),
('Prof. Bob', 'Green', 'Mathematics');
GO
-- Insert Sample Data into Classes
INSERT INTO Classes (ClassName, ClassDate, StartTime, EndTime, RoomNumber, ProfessorID)
VALUES 
('CS101 - Introduction to Computer Science', '2025-08-12', '09:00', '10:30', 'R101', 1),
('MATH201 - Calculus', '2025-08-12', '11:00', '12:30', 'R202', 2);
GO
-- Insert Sample Data into Attendance
INSERT INTO Attendance (ClassID, StudentID, AttendanceDate, Status)
VALUES 
(1, 1, '2025-08-12', 'Present'),
(1, 2, '2025-08-12', 'Absent'),
(2, 3, '2025-08-12', 'Late');
GO
-- Mark attendance for StudentID 1 in ClassID 1 as 'Present' on '2025-08-13'
INSERT INTO Attendance (ClassID, StudentID, AttendanceDate, Status)
VALUES (1, 1, '2025-08-13', 'Present');
GO
-- Get attendance for Student with ID 1
SELECT s.FirstName, s.LastName, c.ClassName, a.AttendanceDate, a.Status
FROM Attendance a
JOIN Students s ON a.StudentID = s.StudentID
JOIN Classes c ON a.ClassID = c.ClassID
WHERE s.StudentID = 1
ORDER BY a.AttendanceDate DESC;
GO
-- Get attendance for Class with ID 1 on '2025-08-12'
SELECT s.FirstName, s.LastName, a.Status
FROM Attendance a
JOIN Students s ON a.StudentID = s.StudentID
WHERE a.ClassID = 1 AND a.AttendanceDate = '2025-08-12';
GO
-- Get attendance summary for all classes between '2025-08-01' and '2025-08-31'
SELECT c.ClassName,
       COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS PresentCount,
       COUNT(CASE WHEN a.Status = 'Absent' THEN 1 END) AS AbsentCount,
       COUNT(CASE WHEN a.Status = 'Late' THEN 1 END) AS LateCount
FROM Attendance a
JOIN Classes c ON a.ClassID = c.ClassID
WHERE a.AttendanceDate BETWEEN '2025-08-01' AND '2025-08-31'
GROUP BY c.ClassName;
GO
-- Get attendance for all classes taught by Professor with ID 1
SELECT c.ClassName, s.FirstName, s.LastName, a.AttendanceDate, a.Status
FROM Attendance a
JOIN Classes c ON a.ClassID = c.ClassID
JOIN Students s ON a.StudentID = s.StudentID
WHERE c.ProfessorID = 1
ORDER BY a.AttendanceDate DESC;
GO
CREATE PROCEDURE MarkStudentAttendance
    @ClassID INT,
    @StudentID INT,
    @AttendanceDate DATE,
    @Status VARCHAR(10)
AS
BEGIN
    INSERT INTO Attendance (ClassID, StudentID, AttendanceDate, Status)
    VALUES (@ClassID, @StudentID, @AttendanceDate, @Status);
END;
GO
-- Mark attendance for Student 1 in Class 1 as Present
EXEC MarkStudentAttendance 1, 1, '2025-08-13', 'Present';
GO












