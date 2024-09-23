-- Create database
CREATE DATABASE Library;
USE Library;

-- Create Branch table

CREATE TABLE Branch (
  Branch_no INT PRIMARY KEY,
  Manager_Id INT,
  Branch_address VARCHAR(255),
  Contact_no VARCHAR(20));
  
  -- Create Employee table
  
CREATE TABLE Employee (
  Emp_Id INT PRIMARY KEY,
  Emp_name VARCHAR(100),
  Position VARCHAR(50),
  Salary DECIMAL(10, 2),
  Branch_no INT,
  FOREIGN KEY (Branch_no) REFERENCES Branch(Branch_no));
  
  -- Create Books table
  
CREATE TABLE Books (
  ISBN VARCHAR(20) PRIMARY KEY,
  Book_title VARCHAR(100),
  Category VARCHAR(50),
  Rental_Price DECIMAL(10, 2),
  Status VARCHAR(3) CHECK(Status IN ('yes', 'no')),
  Author VARCHAR(100),
  Publisher VARCHAR(100));
  
  -- Create Customer table
  
CREATE TABLE Customer (
  Customer_Id INT PRIMARY KEY,
  Customer_name VARCHAR(100),
  Customer_address VARCHAR(255),
  Reg_date DATE);
  
  -- Create IssueStatus table
  
CREATE TABLE IssueStatus (
  Issue_Id INT PRIMARY KEY,
  Issued_cust_id INT,
  Issued_book_name VARCHAR(100),
  Issue_date DATE,
  Isbn_book VARCHAR(20),
  FOREIGN KEY (Issued_cust_id) REFERENCES Customer(Customer_Id),
  FOREIGN KEY (Isbn_book) REFERENCES Books(ISBN));
  
  -- Create ReturnStatus table
  
CREATE TABLE ReturnStatus (
  Return_Id INT PRIMARY KEY,
  Return_cust INT,
  Return_book_name VARCHAR(100),
  Return_date DATE,
  Isbn_book2 VARCHAR(20),
  FOREIGN KEY (Isbn_book2) REFERENCES Books(ISBN),
  FOREIGN KEY (Return_cust) REFERENCES Customer(Customer_Id));


-- Insert values into Branch table
INSERT INTO Branch (Branch_no, Manager_Id, Branch_address, Contact_no)
VALUES
(1, 101, 'Rose street', '555-1234'),
(2, 102, 'Main street', '555-5678'),
(3, 103, 'Oak tower', '555-9012'),
(4, 104, 'Clock tower','555-1098'),
(5, 105, 'Angel street', '555-2024');
select * from branch;

-- Insert values into Employee table
INSERT INTO Employee (Emp_Id, Emp_name, Position, Salary, Branch_no)
VALUES
(101, 'John Smith', 'Manager', 50000.00, 1),
(102, 'Jane Doe', 'Manager', 50000.00, 2),
(103, 'Bob Johnson', 'Manager', 50000.00, 3),
(201, 'Alice Brown', 'Librarian', 40000.00, 1),
(204, 'Mike Davis', 'Librarian', 40000.00, 4),
(205, 'Emily Chen', 'Librarian', 40000.00, 5);
select * from employee;

-- Insert values into Books table
INSERT INTO Books (ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher)
VALUES
('978-1234567890', 'To Kill a Mockingbird', 'Fiction', 5.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'),
('978-9876543210', 'The Great Gatsby', 'Classic', 4.00, 'yes', 'F. Scott Fitzgerald', 'Charles Scribner''s Sons'),
('978-1111111111', '1984', 'Dystopian', 6.00, 'yes', 'George Orwell', 'Secker & Warburg'),
('978-2222222222', 'Pride and Prejudice', 'Romance', 5.00, 'no', 'Jane Austen', 'T. Egerton'),
('978-3333333333', 'The Catcher in the Rye', 'Young Adult', 4.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company');

select * from books;

-- Insert values into Customer table
INSERT INTO Customer (Customer_Id, Customer_name, Customer_address, Reg_date)
VALUES
(1001, 'Sarah Taylor', '123 Maple St', '2020-01-01'),
(1002, 'David Lee', '456 Pine St', '2020-02-01'),
(1003, 'Emily Patel', '789 Cedar St', '2020-03-01'),
(1004, 'James Martin', '901 Walnut St', '2020-04-01'),
(1005, 'Lisa Nguyen', '234 Spruce St', '2020-05-01');
select * from customer;

-- Insert values into IssueStatus table
INSERT INTO IssueStatus (Issue_Id, Issued_cust_id, Issued_book_name, Issue_date, Isbn_book)
VALUES
(1, 1001, 'To Kill a Mockingbird', '2022-01-01', '978-1234567890'),
(2, 1002, 'The Great Gatsby', '2022-02-01', '978-9876543210'),
(3, 1003, '1984', '2022-03-01', '978-1111111111'),
(4, 1004, 'Pride and Prejudice', '2022-04-01', '978-2222222222');
select  * from issuestatus;

-- Insert values into ReturnStatus table
INSERT INTO ReturnStatus (Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2)
VALUES
(1, 1001, 'To Kill a Mockingbird', '2022-01-15', '978-1234567890'),
(2, 1002, 'The Great Gatsby', '2022-02-15', '978-9876543210'),
(3, 1003, '1984', '2022-03-15', '978-1111111111');
select * from returnstatus;

-- SQL query to retrieve the book title, category, and rental price of all available books

SELECT Book_title, Category, Rental_Price FROM Books WHERE Status = 'yes';

-- SQL query to list the employee names and their respective salaries in descending order of salary:

SELECT Emp_name, Salary FROM Employee ORDER BY Salary DESC;

-- SQL query to retrieve the book titles and the corresponding customers who have issued those books

SELECT DISTINCT Book_title, Customer_name FROM IssueStatus NATURAL JOIN Books NATURAL JOIN Customer;

-- query to Display the total count of books in each category

SELECT Category, COUNT(*) as Book_Count FROM   Books GROUP BY Category
ORDER BY Book_Count DESC;

--  Retrieve the employee names and their positions for the employees whose salaries are above Rs.40,000. 

SELECT Emp_name, Position FROM Employee
WHERE 
  Salary > 40000;
  
  -- List the customer names who registered before 2022-01-01 and have not issued any books yet. 
  
  SELECT Customer_name FROM Customer
WHERE Reg_date < '2022-01-01'
  AND Customer_Id NOT IN (SELECT Issued_cust_id FROM IssueStatus);
  
  
  -- Display the branch numbers and the total count of employees in each branch. 
SELECT Branch_No, COUNT(*) as Employee_Count
FROM Employee GROUP BY Branch_No
ORDER BY Employee_Count DESC;

-- Display the names of customers who have issued books in the month of march 2022

SELECT DISTINCT 
  C.Customer_name
FROM 
  Customer C
  JOIN IssueStatus IS ON C.Customer_Id = IS.Issued_cust_id
WHERE 
  MONTH(IS.Issue_date) = 3 
  AND YEAR(IS.Issue_date) = 2022;

-- Retrieve the branch numbers along with the count of employees for branches having more than 1 employee

SELECT Branch_No, COUNT(*) as Employee_Count
FROM Employee
GROUP BY Branch_No
HAVING COUNT(*) > 1;

-- Retrieve the names of employees who manage branches and their respective branch addresses.
SELECT 
  E.Emp_name AS Employee_Name,
  B.Branch_address AS Branch_Address
FROM Employee E
  JOIN Branch B ON E.Emp_Id = B.Manager_Id;

SELECT DISTINCT 
  C.Customer_name
FROM Customer 
  JOIN IssueStatus IS ON C.Customer_Id = IS.Issued_cust_id
  JOIN Books B ON IS.Issued_book_id = B.Book_Id
WHERE 
  B.Rental_price > 2;


