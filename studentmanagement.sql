
	create database student_management_system
	-- Table 1: Student
	CREATE TABLE Student (
		student_id INT PRIMARY KEY,
		first_name VARCHAR(50),
		last_name VARCHAR(50),
		date_of_birth DATE,
		email VARCHAR(100),
		phone_number VARCHAR(15),
		department_id INT
	);

	-- Table 2: Course
	CREATE TABLE Course (
		course_id INT PRIMARY KEY,
		course_name VARCHAR(100),
		department_id INT,
		credits INT
	);

	-- Table 3: Enrollment
	CREATE TABLE Enrollment (
		enrollment_id INT PRIMARY KEY,
		student_id INT,
		course_id INT,
		enrollment_date DATE,
		grade VARCHAR(2),
		FOREIGN KEY (student_id) REFERENCES Student(student_id),
		FOREIGN KEY (course_id) REFERENCES Course(course_id)
	);

	-- Table 4: Department
	CREATE TABLE Department (
		department_id INT PRIMARY KEY,
		department_name VARCHAR(100),
		faculty_id INT
	);

	-- Table 5: Faculty
	CREATE TABLE Faculty (
		faculty_id INT PRIMARY KEY,
		first_name VARCHAR(50),
		last_name VARCHAR(50),
		department_id INT,
		email VARCHAR(100),
		phone_number VARCHAR(15),
		FOREIGN KEY (department_id) REFERENCES Department(department_id)
	);


	-- Insert Data into Student Table
	INSERT INTO Student (student_id, first_name, last_name, date_of_birth, email, phone_number, department_id) VALUES
	(1, 'John', 'Doe', '2000-05-15', 'john.doe@example.com', '1234567890', 1),
	(2, 'Jane', 'Smith', '1999-08-22', 'jane.smith@example.com', '0987654321', 2),
	(3, 'Alice', 'Johnson', '2001-03-10', 'alice.johnson@example.com', '1122334455', 3),
	(4, 'Bob', 'Williams', '2000-12-05', 'bob.williams@example.com', '2233445566', 1),
	(5, 'Charlie', 'Brown', '1998-07-30', 'charlie.brown@example.com', '3344556677', 2),
	(6, 'David', 'Jones', '2002-01-12', 'david.jones@example.com', '4455667788', 3),
	(7, 'Eva', 'Davis', '1999-11-25', 'eva.davis@example.com', '5566778899', 1);

	-- Insert Data into Course Table
	INSERT INTO Course (course_id, course_name, department_id, credits) VALUES
	(1, 'Introduction to Programming', 1, 3),
	(2, 'Database Systems', 2, 4),
	(3, 'Data Structures', 1, 3),
	(4, 'Operating Systems', 3, 4),
	(5, 'Computer Networks', 1, 3),
	(6, 'Software Engineering', 2, 4),
	(7, 'Algorithms', 3, 3);

	-- Insert Data into Enrollment Table
	INSERT INTO Enrollment (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
	(1, 1, 1, '2025-01-15', 'A'),
	(2, 2, 2, '2025-01-16', 'B'),
	(3, 3, 3, '2025-01-17', 'A'),
	(4, 4, 4, '2025-01-18', 'C'),
	(5, 5, 5, '2025-01-19', 'B'),
	(6, 6, 6, '2025-01-20', 'A'),
	(7, 7, 7, '2025-01-21', 'B');

	-- Insert Data into Department Table
	INSERT INTO Department (department_id, department_name, faculty_id) VALUES
	(1, 'Computer Science', 1),
	(2, 'Information Technology', 2),
	(3, 'Software Engineering', 3);

	-- Insert Data into Faculty Table
	INSERT INTO Faculty (faculty_id, first_name, last_name, department_id, email, phone_number) VALUES
	(1, 'Dr. Sarah', 'Miller', 1, 'sarah.miller@example.com', '6677889900'),
	(2, 'Prof. Michael', 'Taylor', 2, 'michael.taylor@example.com', '7788990011'),
	(3, 'Dr. Linda', 'Lee', 3, 'linda.lee@example.com', '8899001122');


	-- Retrieve all columns from the Student table
SELECT * FROM Student;

-- Retrieve specific columns from the Student table
SELECT first_name, last_name, email FROM Student;


-- Insert a new student into the Student table
INSERT INTO Student (student_id, first_name, last_name, date_of_birth, email, phone_number, department_id)
VALUES (8, 'Emma', 'Wilson', '2000-06-01', 'emma.wilson@example.com', '6677889901', 1);


-- Update the phone number of a student with student_id = 1
UPDATE Student
SET phone_number = '1231231234'
WHERE student_id = 1;


-- Delete a student record with student_id = 7
DELETE FROM Student
WHERE student_id = 7;


-- Get a list of students and the courses they are enrolled in
SELECT Student.first_name, Student.last_name, Course.course_name
FROM Student
INNER JOIN Enrollment ON Student.student_id = Enrollment.student_id
INNER JOIN Course ON Enrollment.course_id = Course.course_id;


-- Get a list of all students and the courses they are enrolled in, even if they aren't enrolled in any course
SELECT Student.first_name, Student.last_name, Course.course_name
FROM Student
LEFT OUTER JOIN Enrollment ON Student.student_id = Enrollment.student_id
LEFT OUTER JOIN Course ON Enrollment.course_id = Course.course_id;


-- Get a list of all courses and the students enrolled in them, even if no student is enrolled
SELECT Course.course_name, Student.first_name, Student.last_name
FROM Course
RIGHT OUTER JOIN Enrollment ON Course.course_id = Enrollment.course_id
RIGHT OUTER JOIN Student ON Enrollment.student_id = Student.student_id;


-- Get a list of all students and courses, even if some students aren't enrolled in any course and some courses have no students
SELECT Student.first_name, Student.last_name, Course.course_name
FROM Student
FULL OUTER JOIN Enrollment ON Student.student_id = Enrollment.student_id
FULL OUTER JOIN Course ON Enrollment.course_id = Course.course_id;


-- Get a list of students, their courses, and the department of the course they are enrolled in
SELECT Student.first_name, Student.last_name, Course.course_name, Department.department_name
FROM Student
INNER JOIN Enrollment ON Student.student_id = Enrollment.student_id
INNER JOIN Course ON Enrollment.course_id = Course.course_id
INNER JOIN Department ON Course.department_id = Department.department_id;


-- Get the count of students enrolled in each course
SELECT Course.course_name, COUNT(Enrollment.student_id) AS student_count
FROM Course
LEFT JOIN Enrollment ON Course.course_id = Enrollment.course_id
GROUP BY Course.course_name;


-- Get the students who are enrolled in the course with the maximum credits
SELECT first_name, last_name
FROM Student
WHERE student_id IN (
    SELECT student_id
    FROM Enrollment
    WHERE course_id = (
        SELECT course_id
        FROM Course
        ORDER BY credits DESC
        LIMIT 1
    )
);

-- Get the department with the highest average course credits
SELECT Department.department_name
FROM Department
JOIN Course ON Department.department_id = Course.department_id
GROUP BY Department.department_name
HAVING AVG(Course.credits) = (
    SELECT MAX(avg_credits)
    FROM (
        SELECT AVG(credits) AS avg_credits
        FROM Course
        GROUP BY department_id
    ) AS avg_table
);


-- Get a list of students ordered by their last name in descending order
SELECT first_name, last_name
FROM Student
ORDER BY last_name DESC;


-- Get the first 5 students from the Student table
SELECT * FROM Student
LIMIT 5;


--Store-Procedure:-

DELIMITER $$

CREATE PROCEDURE AddStudent(IN firstName VARCHAR(50), IN lastName VARCHAR(50), IN dateOfBirth DATE, IN email VARCHAR(100), IN phoneNumber VARCHAR(15), IN departmentId INT)
BEGIN
    INSERT INTO Student (first_name, last_name, date_of_birth, email, phone_number, department_id)
    VALUES (firstName, lastName, dateOfBirth, email, phoneNumber, departmentId);
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE UpdatePhoneNumber(IN studentId INT, IN newPhoneNumber VARCHAR(15))
BEGIN
    UPDATE Student
    SET phone_number = newPhoneNumber
    WHERE student_id = studentId;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE EnrollStudent(IN studentId INT, IN courseId INT, IN enrollmentDate DATE)
BEGIN
    INSERT INTO Enrollment (student_id, course_id, enrollment_date)
    VALUES (studentId, courseId, enrollmentDate);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RemoveEnrollment(IN studentId INT, IN courseId INT)
BEGIN
    DELETE FROM Enrollment
    WHERE student_id = studentId AND course_id = courseId;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetStudentByEmail(IN email VARCHAR(100))
BEGIN
    SELECT * FROM Student
    WHERE email = email;
END $$

DELIMITER ;



DELIMITER $$

--fucntion:-
CREATE FUNCTION GetTotalStudents() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Student;
    RETURN total;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION GetEnrolledStudentsCount(courseId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count INT;
    SELECT COUNT(*) INTO count 
    FROM Enrollment
    WHERE course_id = courseId;
    RETURN count;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION GetAverageGrade(courseId INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE avgGrade DECIMAL(3,2);
    SELECT AVG(
        CASE grade
            WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            WHEN 'D' THEN 1
            WHEN 'F' THEN 0
        END
    ) INTO avgGrade
    FROM Enrollment
    WHERE course_id = courseId;
    RETURN avgGrade;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION GetDepartmentWithHighestAverageCredits()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE deptName VARCHAR(100);
    SELECT Department.department_name
    INTO deptName
    FROM Department
    JOIN Course ON Department.department_id = Course.department_id
    GROUP BY Department.department_name
    HAVING AVG(Course.credits) = (
        SELECT MAX(avg_credits)
        FROM (
            SELECT AVG(credits) AS avg_credits
            FROM Course
            GROUP BY department_id
        ) AS avg_table
    );
    RETURN deptName;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION GetCourseWithMostStudents()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE courseName VARCHAR(100);
    SELECT Course.course_name
    INTO courseName
    FROM Course
    LEFT JOIN Enrollment ON Course.course_id = Enrollment.course_id
    GROUP BY Course.course_name
    ORDER BY COUNT(Enrollment.student_id) DESC
    LIMIT 1;
    RETURN courseName;
END $$

DELIMITER ;



--trigger--
CREATE TRIGGER trg_CheckAgeBeforeInsert
ON Student
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @age INT;
    DECLARE @date_of_birth DATE;

    -- Get the date_of_birth from the inserted record
    SELECT @date_of_birth = date_of_birth FROM inserted;

    -- Calculate the age of the student
    SET @age = DATEDIFF(YEAR, @date_of_birth, GETDATE());

    -- Adjust age if the student hasn't had their birthday yet this year
    IF MONTH(@date_of_birth) > MONTH(GETDATE()) OR (MONTH(@date_of_birth) = MONTH(GETDATE()) AND DAY(@date_of_birth) > DAY(GETDATE()))
    BEGIN
        SET @age = @age - 1;
    END

    -- If age is under 18, raise an error
    IF @age < 18
    BEGIN
        RAISERROR('Student age must be 18 or older', 16, 1);
    END
    ELSE
    BEGIN
        -- If age is valid, insert the record
        INSERT INTO Student (student_id, first_name, last_name, date_of_birth, email, phone_number, department_id)
        SELECT student_id, first_name, last_name, date_of_birth, email, phone_number, department_id
        FROM inserted;
    END
END;


CREATE TRIGGER trg_LogStudentUpdate
ON Student
AFTER UPDATE
AS
BEGIN
    DECLARE @student_id INT, @old_phone VARCHAR(15), @old_email VARCHAR(100);
    
    -- Get the updated fields from the deleted (old value) and inserted (new value) tables
    SELECT @student_id = student_id, @old_phone = phone_number, @old_email = email
    FROM deleted;

    -- Insert log into a Log table (this table should be created beforehand)
    INSERT INTO StudentUpdateLog (student_id, old_phone_number, old_email, updated_on)
    VALUES (@student_id, @old_phone, @old_email, GETDATE());
END;



CREATE TRIGGER trg_PreventDeleteIfEnrolled
ON Student
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @student_id INT;
    
    -- Get the student_id of the record to be deleted
    SELECT @student_id = student_id FROM deleted;
    
    -- Check if the student is enrolled in any courses
    IF EXISTS (SELECT 1 FROM Enrollment WHERE student_id = @student_id)
    BEGIN
        RAISERROR('Cannot delete student. This student is enrolled in courses.', 16, 1);
    END
    ELSE
    BEGIN
        -- If not enrolled, delete the student record
        DELETE FROM Student WHERE student_id = @student_id;
    END
END;


--curser--

DECLARE @student_id INT, @first_name VARCHAR(50), @last_name VARCHAR(50);

-- Declare the cursor for getting student and course details
DECLARE student_cursor CURSOR FOR
SELECT student_id, first_name, last_name
FROM Student;

OPEN student_cursor;

FETCH NEXT FROM student_cursor INTO @student_id, @first_name, @last_name;

-- Loop through each student
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Student: ' + @first_name + ' ' + @last_name;
    
    -- Get the courses for the current student
    SELECT Course.course_name
    FROM Enrollment
    JOIN Course ON Enrollment.course_id = Course.course_id
    WHERE Enrollment.student_id = @student_id;
    
    FETCH NEXT FROM student_cursor INTO @student_id, @first_name, @last_name;
END;

-- Clean up
CLOSE student_cursor;
DEALLOCATE student_cursor;
