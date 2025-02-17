-- Employee Performance Metrics
SELECT 
    E.FirstName,
    E.LastName,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(S.TotalSales) AS TotalSales
FROM 
    Employees E
INNER JOIN 
    Orders O ON E.EmployeeID = O.EmployeeID
INNER JOIN 
    SalesSummary S ON O.OrderID = S.OrderID
GROUP BY 
    E.FirstName, E.LastName
ORDER BY 
    TotalSales DESC;

-- Sales Commission Calculation
SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSales,
    SUM(OD.Quantity * OD.UnitPrice) * 0.05 AS Commission
FROM 
    Employees E
JOIN 
    Orders O ON E.EmployeeID = O.EmployeeID
JOIN 
    [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName
ORDER BY 
    TotalSales DESC;

-- Customer Service Response Time
SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    AVG(DATEDIFF(day, O.OrderDate, O.ShippedDate)) AS AvgProcessingTime
FROM 
    Employees E
JOIN 
    Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY 
    E.EmployeeID, E.FirstName, E.LastName
ORDER BY 
    AvgProcessingTime ASC;
