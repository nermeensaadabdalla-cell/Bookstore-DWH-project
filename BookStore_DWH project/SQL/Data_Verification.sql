USE Bookstore_DWH;
GO

-- 1. Reviewing  Dimensions

SELECT 'Dim_Date' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_date;
SELECT TOP 100 * FROM dwh.dim_date;

SELECT 'Dim_Author' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_author;
SELECT TOP 100 * FROM dwh.dim_author;

SELECT 'Dim_Book' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_book;
SELECT TOP 100 * FROM dwh.dim_book;

SELECT 'Dim_Customer' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_customer;
SELECT TOP 100 * FROM dwh.dim_customer;

SELECT 'Dim_Address' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_address;
SELECT TOP 100 * FROM dwh.dim_address;

SELECT 'Dim_Status_History' AS TableName, COUNT(*) AS RecordCount FROM dwh.dim_status_history;
SELECT TOP 100 * FROM dwh.dim_status_history;

-- 2. Reviewing Relationship (Bridge) Tables
PRINT 'Checking Bridge Tables...';

SELECT 'Bridge_Book_Author' AS TableName, COUNT(*) AS RecordCount FROM dwh.bridge_book_author;
SELECT TOP 100 * FROM dwh.bridge_book_author;

-- 3. Reviewing Fact Table (The Core)
PRINT 'Checking Fact Sales Table...';

SELECT 'Fact_Sales' AS TableName, COUNT(*) AS RecordCount FROM dwh.fact_sales;
SELECT TOP 100 * FROM dwh.fact_sales;

-- 4. Sample Integration Check (Join Example)
-- This query confirms that the SKs are correctly linked
SELECT TOP 10 
    b.title, 
    c.first_name + ' ' + c.last_name AS CustomerName, 
    f.price
FROM dwh.fact_sales f
JOIN dwh.dim_book b ON f.book_sk_fk = b.book_sk
JOIN dwh.dim_customer c ON f.customer_sk_fk = c.customer_sk;