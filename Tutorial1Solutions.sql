CREATE DATABASE Db_Company1;
USE Db_Company1;

CREATE TABLE Tbl_Employee(
	employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    street VARCHAR(64) NOT NULL,
    city VARCHAR(64) NOT NULL
);

CREATE TABLE Tbl_Company(
	company_name VARCHAR(64) NOT NULL PRIMARY KEY,
    city VARCHAR(64) NOT NULL
);

CREATE TABLE Tbl_Works(
	employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    company_name VARCHAR(64) NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (employee_name) REFERENCES Tbl_Employee(employee_name),
    FOREIGN KEY (company_name) REFERENCES Tbl_Company(company_name)
);

CREATE TABLE Tbl_Manages(
	employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    manager_name VARCHAR(64) NOT NULL,
    FOREIGN KEY (employee_name) REFERENCES Tbl_Employee(employee_name)
);

INSERT INTO Tbl_Employee(employee_name, street, city)
VALUES ('Kumar Verma','RamSita chowk','Janakpur'),
	('Kumari Devi','RamLaxman chowk','Mithila'),
	('Alice','Old Street','Old Town'),
    ('Nirajan Dhakal','Chandor Chowk','Lalitpur'),
    ('Ujjwal Poudel', 'Maitighar', 'Kathmandu'),
    ('Manish Subedi', 'Maitighar', 'Kathmandu'),
    ('Ram Prasad Pandey', 'Char Do bato', 'Bhaktapur'),
    ('Rishav Baskota', 'Chandol Chowk', 'Lalitpur'),
    ('Sameer Shah','Budhhanagar','Kathmandu'),
    ('Aaditya Joshi','Suryabinayak','Bhaktapur'),
    ('Rishi Dhamala', 'Aster Avenue', 'Bharatpur'),
    ('Suyog Karki', 'New chowk', 'New town'),
    ('Bipin Neupane', 'Old chowk', 'Old Town'),
    ('Jones','Old Street','Old Town');

INSERT INTO Tbl_Company(company_name, city)
VALUES ('Yarsa Lab', 'Lalitpur'),
        ('Fuse Machines', 'Bhaktapur'),
        ('InfoSys', 'Kathmandu'),
        ('MSI Corporated','Kathmandu'),
        ('First Bank Corporation','Bhaktapur'),
        ('Small Bank Corporation','Bhaktapur');

INSERT INTO tbl_Works(employee_name, company_name, salary)
VALUES ('Kumar Verma','Yarsa Lab',200000),
	('Kumari Devi','Fuse Machines',220000), 
	('Nirajan Dhakal', 'Fuse Machines', 55000),
    ('Ujjwal Poudel', 'MSI Corporated', 65000),
    ('Rishav Baskota', 'Fuse Machines', 69000),
    ('Ram Prasad Pandey', 'InfoSys', 85000),
    ('Manish Subedi', 'Yarsa Lab', 60000),
    ('Sameer Shah','First Bank Corporation',75000),
    ('Aaditya Joshi','First Bank Corporation',95000),
    ('Jones','Small Bank Corporation',15000),
    ('Alice','Small Bank Corporation',10000),
    ('Rishi Dhamala', 'First Bank Corporation', 25000),
    ('Suyog Karki', 'First Bank Corporation', 56000),
    ('Bipin Neupane', 'First Bank Corporation', 47256);

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Rishi Dhamala', 'Bipin Neupane'),
    ('Suyog Karki', 'Bipin Neupane'),
    ('Manish Subedi', 'Ujjwal Poudel'),
    ('Sameer Shah', 'Aaditya Joshi'),
    ('Alice', 'Jones'),
    ('Nirajan Dhakal', 'Rishav Baskota');
    
    
    
-- =============================================================
-- Q 2(a)
-- Find all the names of all employees who works for First Bank Corporation

-- Using regular query
SELECT employee_name FROM Tbl_Works
WHERE company_name = 'First Bank Corporation';

-- ==============================================================
-- Q 2(b)
-- Find all names and cities of residence of all employees who work for First Bank Corporation

-- using regular query
SELECT employee_name, city FROM Tbl_Employee
WHERE employee_name in (SELECT Tbl_Works.employee_name FROM Tbl_Works
						WHERE Tbl_Works.company_name = 'First Bank Corporation');

-- using JOINS
SELECT Tbl_Employee.employee_name,Tbl_Employee.city FROM Tbl_Employee
INNER JOIN Tbl_Works ON Tbl_Employee.employee_name = Tbl_Works.employee_name
WHERE Tbl_Works.company_name = 'First Bank Corporation';


-- ===============================================================
-- Q 2(c)
-- Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000

-- using regular query
SELECT employee_name, street, city FROM Tbl_Employee
WHERE employee_name in (SELECT Tbl_Works.employee_name FROM Tbl_Works
						WHERE Tbl_Works.company_name = 'First Bank Corporation' AND Tbl_Works.salary > 10000);

-- using JOINS
SELECT Tbl_Employee.employee_name,Tbl_Employee.street, Tbl_Employee.city FROM Tbl_Employee
INNER JOIN Tbl_Works ON Tbl_Employee.employee_name = Tbl_Works.employee_name
WHERE Tbl_Works.company_name = 'First Bank Corporation' AND Tbl_Works.salary > 10000;



-- ================================================================
-- Q 2(d)
-- Find all employees in the database who live in the same cities as the companies for which they work

-- using regular query
SELECT Tbl_Employee.employee_name FROM Tbl_Employee
WHERE Tbl_Employee.city = (SELECT Tbl_Company.city FROM Tbl_Company
						WHERE Tbl_Company.company_name = (SELECT Tbl_Works.company_name FROM Tbl_Works
														WHERE Tbl_Works.employee_name = Tbl_Employee.employee_name));
-- using JOINS
SELECT Tbl_Employee.employee_name FROM Tbl_Employee
INNER JOIN Tbl_Works ON Tbl_Employee.employee_name = Tbl_Works.employee_name
INNER JOIN Tbl_Company ON Tbl_Works.company_name = Tbl_Company.company_name
WHERE Tbl_Employee.city = Tbl_Company.city;



-- =================================================================
-- Q 2(e)
-- Find all employees in the database who live in the same cities and on the same streets as do their managers

-- using regular query
SELECT TBE.employee_name FROM Tbl_Employee as TBE
WHERE TBE.city = (SELECT Tbl_Employee.city FROM Tbl_Employee
				WHERE Tbl_Employee.employee_name = (SELECT Tbl_Manages.manager_name FROM Tbl_Manages
													WHERE Tbl_Manages.employee_name = TBE.employee_name))
AND TBE.street = (SELECT Tbl_Employee.street FROM Tbl_Employee
				WHERE Tbl_Employee.employee_name = (SELECT Tbl_Manages.manager_name FROM Tbl_Manages
													WHERE Tbl_Manages.employee_name = TBE.employee_name));
-- using JOINS
SELECT Tbl_Manages.employee_name FROM Tbl_Manages
INNER JOIN Tbl_Employee as emp ON Tbl_Manages.employee_name = emp.employee_name
INNER JOIN Tbl_Employee as mng ON Tbl_Manages.manager_name = mng.employee_name
WHERE emp.city = mng.city
	AND emp.street = mng.street;
    
-- ===================================================================
-- Q 2(f)
-- Find all employees in the database who do not work for First Bank Corporation

-- using regular query
SELECT Tbl_Works.employee_name FROM Tbl_Works
WHERE Tbl_Works.company_name != "First Bank Corporation";

-- ===================================================================
-- Q 2(g)
-- Find all employees in the database who earn more than each employee of Small Bank Corporation



-- using regular query
SELECT TBW.employee_name FROM Tbl_Works as TBW
WHERE TBW.salary > ALL (SELECT Tbl_works.salary FROM Tbl_works
						WHERE Tbl_works.company_name = "First Bank Corporation");
                        
                        
-- ======================================================================
-- Q 2(h)
-- Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located

-- using regular query
SELECT TBC.company_name FROM Tbl_Company as TBC
WHERE TBC.company_name != "Small Bank Corporation" 
	AND TBC.city in (SELECT Tbl_Company.city FROM Tbl_Company
					Where Tbl_Company.company_name = "Small Bank Corporation");
                    
-- =======================================================================
-- Q 2(i)
-- Find all employees who earn more than the average salary of all employees of their company

-- using regular query
SELECT TBW.employee_name from Tbl_Works as TBW
WHERE TBW.salary > (SELECT AVG(Tbl_Works.salary) FROM Tbl_Works
					Where Tbl_works.company_name = TBW.company_name);

-- =======================================================================
-- Q 2(j)
-- Find the company that has the most employees

-- using regular query
SELECT Tbl_Works.company_name, COUNT(*) as num_employees FROM Tbl_Works
GROUP BY Tbl_Works.company_name
ORDER BY num_employees DESC
LIMIT 1;

-- =======================================================================
-- Q 2(k)
-- Find the company that has the smallest payroll

-- using regular query
SELECT Tbl_Works.company_name, SUM(Tbl_Works.salary) as payroll FROM Tbl_Works
GROUP BY Tbl_Works.company_name
ORDER BY payroll ASC
LIMIT 1;

-- =======================================================================
-- Q 2(l)
-- Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation

-- using regular query
SELECT TBW.company_name FROM Tbl_Works AS TBW
GROUP BY TBW.company_name
HAVING AVG(TBW.salary) > (
  SELECT AVG(Tbl_works.salary)
  FROM Tbl_Works
  WHERE Tbl_Works.company_name = 'First Bank Corporation'
);

-- ===========================================================================
-- Q 3(a)
-- Modify the database so that Jones now lives in Newtown
SELECT * FROM Tbl_Employee;

UPDATE Tbl_Employee SET street = 'Updated Street', city = 'Newtown'
WHERE employee_name LIKE "Jones%";

SELECT * FROM Tbl_Employee;

-- ============================================================================
-- Q 3(b)
-- Give all employees of First Bank Corporation a 10 percent raise

SELECT * FROM Tbl_Works;

UPDATE Tbl_Works SET salary = 1.1 * salary
WHERE company_name = "First Bank Corporation";

SELECT * FROM Tbl_Works;

-- ============================================================================
-- Q 3(c)
-- Give all managers of First Bank Corporation a 10 percent raise;

SELECT * FROM Tbl_Works;

UPDATE Tbl_Works SET salary = 1.1 * salary
WHERE company_name = "First Bank Corporation"
	AND employee_name IN (SELECT manager_name from Tbl_Manages);
    
SELECT * FROM Tbl_Works;

-- =============================================================================
-- Q 3(d)
-- Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100, 000; in such cases, give only 3 percent raise
SELECT * FROM Tbl_Works;

UPDATE Tbl_Works SET salary = IF( salary < 100000,1.1 * salary,1.03 * salary)
WHERE company_name = "First Bank Corporation"
	AND employee_name IN (SELECT manager_name from Tbl_Manages);
    
SELECT * FROM Tbl_Works;

-- ==============================================================================
-- Q 3(e) 
-- Delete all tuples in the works relation for employees of Small Bank Corporation
SET foreign_key_checks = 0;

DELETE Tbl_Works , Tbl_Employee , Tbl_Manages FROM Tbl_Works
LEFT JOIN Tbl_Employee ON Tbl_Employee.employee_name = Tbl_works.employee_name
LEFT JOIN Tbl_Manages ON Tbl_Works.employee_name = Tbl_Manages.employee_name 
WHERE Tbl_Works.company_name = 'Small Bank Corporation';

SET foreign_key_checks = 1;

SELECT * FROM Tbl_Works;
SELECT * FROM Tbl_Employee;
SELECT * FROM Tbl_Manages










