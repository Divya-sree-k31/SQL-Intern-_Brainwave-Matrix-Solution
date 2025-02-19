CREATE DATABASE library_management;
USE library_management;

-- Create Books table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    copies INT DEFAULT 1
);

-- Create Members table
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Create Loans table
CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Insert sample data into Books
INSERT INTO books (title, author, category, copies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 3),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 2),
('Database Management', 'John Smith', 'Technical', 4),
('Python Programming', 'Sarah Johnson', 'Technical', 3);

-- Insert sample data into Members
INSERT INTO members (name, email, phone) VALUES
('John Doe', 'john@email.com', '123-456-7890'),
('Jane Smith', 'jane@email.com', '987-654-3210'),
('Bob Wilson', 'bob@email.com', '555-555-5555');

-- Insert sample data into Loans
INSERT INTO loans (book_id, member_id, loan_date, return_date) VALUES
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-05', NULL),
(3, 1, '2024-02-10', NULL);

-- Display all books
SELECT * FROM books;

SELECT * FROM members;

-- Display all current loans with member and book details

SELECT 
    l.loan_id,
    b.title,
    m.name AS member_name,
    l.loan_date,
    CASE 
        WHEN l.return_date IS NULL THEN 'Not Returned'
        ELSE l.return_date 
    END AS return_status
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id;


-- Find all books currently on loan

SELECT 
    b.title,
    m.name AS borrowed_by,
    l.loan_date
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;


-- Count books by category

SELECT 
    category,
    COUNT(*) as total_books,
    SUM(copies) as total_copies
FROM books
GROUP BY category;









