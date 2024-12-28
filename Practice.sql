CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Quantity INT NOT NULL
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    MembershipDate DATE NOT NULL
);


CREATE TABLE BorrowRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

INSERT INTO Books (Title, Author, Genre, Quantity) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 5),
('1984', 'George Orwell', 'Dystopian', 8),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 7),
('The Catcher in the Rye', 'J.D. Salinger', 'Classic', 6);

INSERT INTO Members (Name, Email, MembershipDate) VALUES
('Alice Johnson', 'alice.johnson@example.com', '2023-01-10'),
('Bob Smith', 'bob.smith@example.com', '2023-02-15'),
('Charlie Brown', 'charlie.brown@example.com', '2023-03-20'),
('Diana Prince', 'diana.prince@example.com', '2023-04-25');

INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate, ReturnDate) VALUES
(1, 2, '2023-12-01', '2023-12-15'),
(3, 1, '2023-12-10', NULL),
(2, 4, '2023-12-12', NULL),
(4, 3, '2023-12-14', '2023-12-28');

SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM BorrowRecords;

-- AGGREGATE FUNCTIONS

-- 1. Count the total number of books
SELECT COUNT(*) AS TotalBooks FROM Books;

-- 2. Find the average quantity of books available
SELECT AVG(Quantity) AS AverageQuantity FROM Books;

-- 3. Find the total quantity of books by genre
SELECT Genre, SUM(Quantity) AS TotalQuantity FROM Books
GROUP BY Genre;

-- 4. Find the maximum and minimum quantity of books available
SELECT MAX(Quantity) AS MaxQuantity, MIN(Quantity) AS MinQuantity FROM Books;

-- 5. Find the total number of members who joined after January 1, 2023
SELECT COUNT(*) AS MembersAfterJan2023 FROM Members
WHERE MembershipDate > '2023-01-01';

-- 6. Find the number of books borrowed by each member
SELECT Members.Name, COUNT(BorrowRecords.RecordID) AS TotalBorrowed
FROM Members
LEFT JOIN BorrowRecords ON Members.MemberID = BorrowRecords.MemberID
GROUP BY Members.Name;

-- SET OPERATIONS

-- 1. Union of all genres in Books and a list of additional genres
SELECT DISTINCT Genre FROM Books
UNION
SELECT DISTINCT Genre FROM (VALUES ('Romance'), ('Thriller'), ('Fantasy')) AS AdditionalGenres(Genre);

-- 2. Find genres that are common between Books and AdditionalGenres
SELECT DISTINCT Genre FROM Books
INTERSECT
SELECT DISTINCT Genre FROM (VALUES ('Classic'), ('Romance'), ('Dystopian')) AS AdditionalGenres(Genre);

-- 3. Find genres present in Books but not in AdditionalGenres
SELECT DISTINCT Genre FROM Books
EXCEPT
SELECT DISTINCT Genre FROM (VALUES ('Classic'), ('Romance'), ('Dystopian')) AS AdditionalGenres(Genre);


-- JOINS

-- 1. INNER JOIN: Get details of books borrowed by members
SELECT 
    BorrowRecords.RecordID, 
    Members.Name AS MemberName, 
    Books.Title AS BookTitle, 
    BorrowRecords.BorrowDate, 
    BorrowRecords.ReturnDate
FROM BorrowRecords
INNER JOIN Members ON BorrowRecords.MemberID = Members.MemberID
INNER JOIN Books ON BorrowRecords.BookID = Books.BookID;

-- 2. LEFT JOIN: Get all members and their borrowed books (if any)
SELECT 
    Members.Name AS MemberName, 
    Books.Title AS BorrowedBook, 
    BorrowRecords.BorrowDate
FROM Members
LEFT JOIN BorrowRecords ON Members.MemberID = BorrowRecords.MemberID
LEFT JOIN Books ON BorrowRecords.BookID = Books.BookID;

-- 3. RIGHT JOIN: Get all borrowed books and the members who borrowed them
SELECT 
    Books.Title AS BookTitle, 
    Members.Name AS BorrowerName
FROM Books
RIGHT JOIN BorrowRecords ON Books.BookID = BorrowRecords.BookID
RIGHT JOIN Members ON BorrowRecords.MemberID = Members.MemberID;

-- 4. FULL OUTER JOIN: Show all books and members, whether they are involved in borrowing or not
SELECT 
    COALESCE(Members.Name, 'No Member') AS MemberName, 
    COALESCE(Books.Title, 'No Book') AS BookTitle
FROM Members
FULL OUTER JOIN BorrowRecords ON Members.MemberID = BorrowRecords.MemberID
FULL OUTER JOIN Books ON BorrowRecords.BookID = Books.BookID;

-- VIEWS

-- 1. Create a view for borrowed books with member details
CREATE VIEW BorrowedBooksView AS
SELECT 
    BorrowRecords.RecordID, 
    Members.Name AS MemberName, 
    Books.Title AS BookTitle, 
    BorrowRecords.BorrowDate, 
    BorrowRecords.ReturnDate
FROM BorrowRecords
INNER JOIN Members ON BorrowRecords.MemberID = Members.MemberID
INNER JOIN Books ON BorrowRecords.BookID = Books.BookID;

-- 2. Query the created view
SELECT * FROM BorrowedBooksView;

-- 3. Create a view for available books
CREATE VIEW AvailableBooksView AS
SELECT 
    BookID, 
    Title, 
    Author, 
    Genre, 
    Quantity
FROM Books
WHERE Quantity > 0;

-- 4. Query the available books view
SELECT * FROM AvailableBooksView;

-- SUBQUERIES

-- 1. Find the books borrowed by 'Alice Johnson'
SELECT Title 
FROM Books 
WHERE BookID IN (
    SELECT BookID 
    FROM BorrowRecords 
    WHERE MemberID = (
        SELECT MemberID 
        FROM Members 
        WHERE Name = 'Alice Johnson'
    )
);

-- 2. Find members who have borrowed more than 2 books
SELECT Name 
FROM Members 
WHERE MemberID IN (
    SELECT MemberID 
    FROM BorrowRecords 
    GROUP BY MemberID 
    HAVING COUNT(BookID) > 2
);

-- 3. Get the titles of books that have been borrowed but are not currently available in the library
SELECT Title 
FROM Books 
WHERE BookID IN (
    SELECT DISTINCT BookID 
    FROM BorrowRecords
) AND Quantity = 0;

-- 4. Find the total quantity of books borrowed by each genre
SELECT Genre, TotalBorrowed 
FROM (
    SELECT Genre, SUM(Quantity) AS TotalBorrowed
    FROM Books
    WHERE BookID IN (
        SELECT BookID 
        FROM BorrowRecords
    )
    GROUP BY Genre
) AS GenreBorrowedSummary;

-- 5. List members who joined after the member with ID 2
SELECT Name 
FROM Members 
WHERE MembershipDate > (
    SELECT MembershipDate 
    FROM Members 
    WHERE MemberID = 2
);

-- 6. Get the details of the most borrowed book
SELECT * 
FROM Books 
WHERE BookID = (
    SELECT BookID 
    FROM BorrowRecords 
    GROUP BY BookID 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- 7. Find the average number of books borrowed by members
SELECT AVG(BorrowCount) AS AvgBooksBorrowed
FROM (
    SELECT COUNT(*) AS BorrowCount
    FROM BorrowRecords
    GROUP BY MemberID
) AS MemberBorrowStats;

-- 8. Find books whose authors have written other books in the library
SELECT Title 
FROM Books 
WHERE Author IN (
    SELECT Author 
    FROM Books 
    GROUP BY Author 
    HAVING COUNT(Title) > 1
);

-- TRIGGERS

-- 1. Trigger to update the quantity of books after a new borrow record is inserted
DELIMITER $$

CREATE TRIGGER AfterBorrowInsert
AFTER INSERT ON BorrowRecords
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Quantity = Quantity - 1
    WHERE BookID = NEW.BookID;
END$$

DELIMITER ;

-- 2. Trigger to restore the quantity of books after a borrow record is deleted (e.g., book returned)
DELIMITER $$

CREATE TRIGGER AfterBorrowDelete
AFTER DELETE ON BorrowRecords
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Quantity = Quantity + 1
    WHERE BookID = OLD.BookID;
END$$

DELIMITER ;

-- 3. Trigger to prevent inserting borrow records if the book is out of stock
DELIMITER $$

CREATE TRIGGER BeforeBorrowInsert
BEFORE INSERT ON BorrowRecords
FOR EACH ROW
BEGIN
    IF (SELECT Quantity FROM Books WHERE BookID = NEW.BookID) <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot borrow: Book is out of stock';
    END IF;
END$$

DELIMITER ;

-- 4. Trigger to automatically set the `ReturnDate` to current date if not specified during insertion
DELIMITER $$

CREATE TRIGGER BeforeBorrowInsertDefaultDate
BEFORE INSERT ON BorrowRecords
FOR EACH ROW
BEGIN
    IF NEW.ReturnDate IS NULL THEN
        SET NEW.ReturnDate = CURDATE();
    END IF;
END$$

DELIMITER ;

-- 5. Trigger to log every deletion of a borrow record into a log table
CREATE TABLE BorrowLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    RecordID INT,
    MemberID INT,
    BookID INT,
    DeletionDate DATETIME
);

DELIMITER $$

CREATE TRIGGER AfterBorrowDeleteLog
AFTER DELETE ON BorrowRecords
FOR EACH ROW
BEGIN
    INSERT INTO BorrowLog (RecordID, MemberID, BookID, DeletionDate)
    VALUES (OLD.RecordID, OLD.MemberID, OLD.BookID, NOW());
END$$

DELIMITER ;

INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate) 
VALUES (1, 2, '2023-12-15');
INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate) 
VALUES (3, 2, '2023-12-15');
INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate) 
VALUES (3, 2, '2023-12-15');

-- STRING MANIPULATION OPERATIONS

-- 1. Convert book titles to uppercase
SELECT Title, UPPER(Title) AS UppercaseTitle
FROM Books;

-- 2. Convert book titles to lowercase
SELECT Title, LOWER(Title) AS LowercaseTitle
FROM Books;

-- 3. Concatenate author names with their book titles
SELECT CONCAT(Author, ' - ', Title) AS AuthorBook
FROM Books;

-- 4. Extract the first 5 characters of each book title
SELECT Title, SUBSTRING(Title, 1, 5) AS ShortTitle
FROM Books;

-- 5. Find the position of a substring in a book title (e.g., 'Adventure')
SELECT Title, LOCATE('Adventure', Title) AS PositionOfSubstring
FROM Books;

-- 6. Replace a word in a book title (e.g., replace 'Adventure' with 'Journey')
SELECT Title, REPLACE(Title, 'Adventure', 'Journey') AS UpdatedTitle
FROM Books;

-- 7. Trim leading and trailing spaces from member names
SELECT Name, TRIM(Name) AS TrimmedName
FROM Members;

-- 8. Pad book titles with '-' to a total length of 20 characters
SELECT Title, LPAD(Title, 20, '-') AS LeftPaddedTitle, RPAD(Title, 20, '-') AS RightPaddedTitle
FROM Books;

-- 9. Reverse book titles
SELECT Title, REVERSE(Title) AS ReversedTitle
FROM Books;

-- 10. Count the number of characters in each book title
SELECT Title, CHAR_LENGTH(Title) AS TitleLength
FROM Books;

-- 11. Split book titles at the first space (using SUBSTRING_INDEX)
SELECT Title, 
       SUBSTRING_INDEX(Title, ' ', 1) AS FirstWord,
       SUBSTRING_INDEX(Title, ' ', -1) AS LastWord
FROM Books;

-- 12. Format member names (e.g., capitalize first letter of each word)
SELECT Name, CONCAT(UPPER(SUBSTRING(Name, 1, 1)), LOWER(SUBSTRING(Name, 2))) AS ProperCaseName
FROM Members;

-- 13. Find books whose titles start with a specific letter (e.g., 'A')
SELECT Title
FROM Books
WHERE Title LIKE 'A%';

-- 14. Find books whose titles end with a specific letter (e.g., 'e')
SELECT Title
FROM Books
WHERE Title LIKE '%e';

-- 15. Find books with a specific word in the title (e.g., 'Magic')
SELECT Title
FROM Books
WHERE Title LIKE '%Magic%';


-- Example: Borrowing a book (Decrease Quantity) and inserting a Borrow Record
START TRANSACTION;

-- Step 1: Check if the book is available
SELECT Quantity 
FROM Books 
WHERE BookID = 1;

-- Step 2: Decrease the quantity of the book
UPDATE Books
SET Quantity = Quantity - 1
WHERE BookID = 1;

-- Step 3: Insert a new borrow record
INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate, ReturnDate)
VALUES (1, 2, CURDATE(), NULL);

-- Commit the transaction if everything is successful
COMMIT;

-- Rollback the transaction in case of an error
-- ROLLBACK;
