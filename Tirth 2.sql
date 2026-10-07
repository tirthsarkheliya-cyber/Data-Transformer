CREATE DATABASE IF NOT EXISTS DataTransformer;
Query OK, 0 row affected, 0 warning (0.01 sec)

mysql> USE DataTransformer;
Database changed
mysql> CREATE TABLE IF NOT EXISTS Customers (
    ->     CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    ->     FirstName VARCHAR(50) NOT NULL,
    ->     LastName VARCHAR(50) NOT NULL,
    ->     Email VARCHAR(100) NOT NULL,
    ->     RegistrationDate DATE NOT NULL
    -> );
Query OK, 0 rows affected, 0 warning (0.01 sec)

mysql>
mysql> INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
    -> (1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
    -> (2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');
ERROR 1062 (23000): Duplicate entry '1' for key 'customers.PRIMARY'
mysql> CREATE TABLE IF NOT EXISTS Orders (
    ->     OrderID INT PRIMARY KEY AUTO_INCREMENT,
    ->     CustomerID INT,
    ->     OrderDate DATE NOT NULL,
    ->     TotalAmount DECIMAL(10, 2) NOT NULL,
    ->     FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql>
mysql> INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
    -> (101, 1, '2023-07-01', 150.50),
    -> (102, 2, '2023-07-03', 200.75);
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> CREATE TABLE IF NOT EXISTS Employees (
    ->     EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    ->     FirstName VARCHAR(50) NOT NULL,
    ->     LastName VARCHAR(50) NOT NULL,
    ->     Department VARCHAR(50) NOT NULL,
    ->     HireDate DATE NOT NULL,
    ->     Salary DECIMAL(10, 2) NOT NULL
    -> );
Query OK, 0 rows affected (0.38 sec)

mysql>
mysql> INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
    -> (1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
    -> (2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00);
Query OK, 2 rows affected (0.07 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT
    ->     o.OrderID,
    ->     o.OrderDate,
    ->     o.TotalAmount,
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName,
    ->     c.Email
    -> FROM Orders o
    -> INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
+---------+------------+-------------+------------+-----------+----------+----------------------+
| OrderID | OrderDate  | TotalAmount | CustomerID | FirstName | LastName | Email                |
+---------+------------+-------------+------------+-----------+----------+----------------------+
|     101 | 2023-07-01 |      150.50 |          1 | John      | Doe      | john.doe@email.com   |
|     102 | 2023-07-03 |      200.75 |          2 | Jane      | Smith    | jane.smith@email.com |
+---------+------------+-------------+------------+-----------+----------+----------------------+
2 rows in set (0.01 sec)

mysql> SELECT
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName,
    ->     c.Email,
    ->     o.OrderID,
    ->     o.OrderDate,
    ->     o.TotalAmount
    -> FROM Customers c
    -> LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
+------------+-----------+----------+----------------------+---------+------------+-------------+
| CustomerID | FirstName | LastName | Email                | OrderID | OrderDate  | TotalAmount |
+------------+-----------+----------+----------------------+---------+------------+-------------+
|          1 | John      | Doe      | john.doe@email.com   |     101 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    | jane.smith@email.com |     102 | 2023-07-03 |      200.75 |
+------------+-----------+----------+----------------------+---------+------------+-------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     o.OrderID,
    ->     o.OrderDate,
    ->     o.TotalAmount,
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName
    -> FROM Orders o
    -> RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;
+---------+------------+-------------+------------+-----------+----------+
| OrderID | OrderDate  | TotalAmount | CustomerID | FirstName | LastName |
+---------+------------+-------------+------------+-----------+----------+
|     101 | 2023-07-01 |      150.50 |          1 | John      | Doe      |
|     102 | 2023-07-03 |      200.75 |          2 | Jane      | Smith    |
+---------+------------+-------------+------------+-----------+----------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName,
    ->     o.OrderID,
    ->     o.OrderDate,
    ->     o.TotalAmount
    -> FROM Customers c
    -> LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    -> UNION
    -> SELECT
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName,
    ->     o.OrderID,
    ->     o.OrderDate,
    ->     o.TotalAmount
    -> FROM Customers c
    -> RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
+------------+-----------+----------+---------+------------+-------------+
| CustomerID | FirstName | LastName | OrderID | OrderDate  | TotalAmount |
+------------+-----------+----------+---------+------------+-------------+
|          1 | John      | Doe      |     101 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    |     102 | 2023-07-03 |      200.75 |
+------------+-----------+----------+---------+------------+-------------+
2 rows in set (0.40 sec)

mysql> SELECT DISTINCT
    ->     c.CustomerID,
    ->     c.FirstName,
    ->     c.LastName
    -> FROM Customers c
    -> JOIN Orders o ON c.CustomerID = o.CustomerID
    -> WHERE o.TotalAmount > (
    ->     SELECT AVG(TotalAmount)
    ->     FROM Orders
    -> );
+------------+-----------+----------+
| CustomerID | FirstName | LastName |
+------------+-----------+----------+
|          2 | Jane      | Smith    |
+------------+-----------+----------+
1 row in set (0.00 sec)

mysql> SELECT
    ->     EmployeeID,
    ->     FirstName,
    ->     LastName,
    ->     Salary
    -> FROM Employees
    -> WHERE Salary > (
    ->     SELECT AVG(Salary)
    ->     FROM Employees
    -> );
+------------+-----------+----------+----------+
| EmployeeID | FirstName | LastName | Salary   |
+------------+-----------+----------+----------+
|          2 | Susan     | Lee      | 55000.00 |
+------------+-----------+----------+----------+
1 row in set (0.00 sec)

mysql> SELECT
    ->     OrderID,
    ->     OrderDate,
    ->     YEAR(OrderDate) AS OrderYear,
    ->     MONTH(OrderDate) AS OrderMonth
    -> FROM Orders;
+---------+------------+-----------+------------+
| OrderID | OrderDate  | OrderYear | OrderMonth |
+---------+------------+-----------+------------+
|     101 | 2023-07-01 |      2023 |          7 |
|     102 | 2023-07-03 |      2023 |          7 |
+---------+------------+-----------+------------+
2 rows in set (0.01 sec)

mysql> SELECT
    ->     OrderID,
    ->     OrderDate,
    ->     DATEDIFF(CURRENT_DATE(), OrderDate) AS DaysSinceOrder
    -> FROM Orders;
+---------+------------+----------------+
| OrderID | OrderDate  | DaysSinceOrder |
+---------+------------+----------------+
|     101 | 2023-07-01 |           1194 |
|     102 | 2023-07-03 |           1192 |
+---------+------------+----------------+
2 rows in set (0.02 sec)

mysql> SELECT
    ->     OrderID,
    ->     OrderDate,
    ->     DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedOrderDate
    -> FROM Orders;
+---------+------------+--------------------+
| OrderID | OrderDate  | FormattedOrderDate |
+---------+------------+--------------------+
|     101 | 2023-07-01 | 01-Jul-2023        |
|     102 | 2023-07-03 | 03-Jul-2023        |
+---------+------------+--------------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     CustomerID,
    ->     CONCAT(FirstName, ' ', LastName) AS FullName
    -> FROM Customers;
+------------+------------+
| CustomerID | FullName   |
+------------+------------+
|          1 | John Doe   |
|          2 | Jane Smith |
+------------+------------+
2 rows in set (0.01 sec)

mysql> SELECT
    ->     CustomerID,
    ->     FirstName,
    ->     REPLACE(FirstName, 'John', 'Jonathan') AS ModifiedFirstName
    -> FROM Customers;
+------------+-----------+-------------------+
| CustomerID | FirstName | ModifiedFirstName |
+------------+-----------+-------------------+
|          1 | John      | Jonathan          |
|          2 | Jane      | Jane              |
+------------+-----------+-------------------+
2 rows in set (0.01 sec)

mysql> SELECT
    ->     CustomerID,
    ->     UPPER(FirstName) AS UpperFirstName,
    ->     LOWER(LastName) AS LowerLastName
    -> FROM Customers;
+------------+----------------+---------------+
| CustomerID | UpperFirstName | LowerLastName |
+------------+----------------+---------------+
|          1 | JOHN           | doe           |
|          2 | JANE           | smith         |
+------------+----------------+---------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     CustomerID,
    ->     TRIM(Email) AS CleanedEmail
    -> FROM Customers;
+------------+----------------------+
| CustomerID | CleanedEmail         |
+------------+----------------------+
|          1 | john.doe@email.com   |
|          2 | jane.smith@email.com |
+------------+----------------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     OrderID,
    ->     CustomerID,
    ->     OrderDate,
    ->     TotalAmount,
    ->     SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID) AS RunningTotal
    -> FROM Orders;
+---------+------------+------------+-------------+--------------+
| OrderID | CustomerID | OrderDate  | TotalAmount | RunningTotal |
+---------+------------+------------+-------------+--------------+
|     101 |          1 | 2023-07-01 |      150.50 |       150.50 |
|     102 |          2 | 2023-07-03 |      200.75 |       351.25 |
+---------+------------+------------+-------------+--------------+
2 rows in set (0.01 sec)

mysql> SELECT
    ->     OrderID,
    ->     CustomerID,
    ->     TotalAmount,
    ->     RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
    -> FROM Orders;
+---------+------------+-------------+------------+
| OrderID | CustomerID | TotalAmount | AmountRank |
+---------+------------+-------------+------------+
|     102 |          2 |      200.75 |          1 |
|     101 |          1 |      150.50 |          2 |
+---------+------------+-------------+------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     OrderID,
    ->     TotalAmount,
    ->     CASE
    ->         WHEN TotalAmount > 1000 THEN '10% off'
    ->         WHEN TotalAmount > 500 THEN '5% off'
    ->         ELSE 'No Discount'
    ->     END AS DiscountTier
    -> FROM Orders;
+---------+-------------+--------------+
| OrderID | TotalAmount | DiscountTier |
+---------+-------------+--------------+
|     101 |      150.50 | No Discount  |
|     102 |      200.75 | No Discount  |
+---------+-------------+--------------+
2 rows in set (0.00 sec)

mysql> SELECT
    ->     EmployeeID,
    ->     FirstName,
    ->     LastName,
    ->     Salary,
    ->     CASE
    ->         WHEN Salary >= 60000 THEN 'High'
    ->         WHEN Salary >= 50000 THEN 'Medium'
    ->         ELSE 'Low'
    ->     END AS SalaryCategory
    -> FROM Employees;
+------------+-----------+----------+----------+----------------+
| EmployeeID | FirstName | LastName | Salary   | SalaryCategory |
+------------+-----------+----------+----------+----------------+
|          1 | Mark      | Johnson  | 50000.00 | Medium         |
|          2 | Susan     | Lee      | 55000.00 | Medium         |
+------------+-----------+----------+----------+----------------+
2 rows in set (0.00 sec)

mysql> FROM Employees;
