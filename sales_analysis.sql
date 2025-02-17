-- Sales Summary for Faster Aggregation
CREATE VIEW SalesSummary AS
SELECT 
    O.OrderID,
    O.OrderDate,
    C.CategoryName,
    P.ProductName,
    OD.Quantity,
    OD.UnitPrice,
    (OD.Quantity * OD.UnitPrice) AS TotalSales
FROM 
    [Order Details] OD
INNER JOIN 
    Orders O ON OD.OrderID = O.OrderID
INNER JOIN 
    Products P ON OD.ProductID = P.ProductID
INNER JOIN 
    Categories C ON P.CategoryID = C.CategoryID;

-- Monthly Sales Trends
SELECT 
    CategoryName,
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalSales) AS MonthlySales
FROM 
    SalesSummary
GROUP BY 
    CategoryName, YEAR(OrderDate), MONTH(OrderDate)
ORDER BY 
    CategoryName, Year, Month;

-- Top Revenue Generating Customers
SELECT 
    TOP 10 C.CompanyName, 
    SUM(TotalSales) AS TotalRevenue
FROM 
    SalesSummary S
INNER JOIN 
    Orders O ON S.OrderID = O.OrderID
INNER JOIN 
    Customers C ON O.CustomerID = C.CustomerID
GROUP BY 
    C.CompanyName
ORDER BY 
    TotalRevenue DESC;

-- Customer Purchase Frequency
WITH CustomerIntervals AS (
    SELECT 
        C.CompanyName,
        O.CustomerID,
        DATEDIFF(day, MIN(O.OrderDate), MAX(O.OrderDate)) AS TotalInterval,
        COUNT(O.OrderID) - 1 AS OrderCount
    FROM 
        Orders O
    INNER JOIN 
        Customers C ON O.CustomerID = C.CustomerID
    GROUP BY 
        C.CompanyName, O.CustomerID
)
SELECT 
    CompanyName,
    SUM(OrderCount + 1) AS PurchaseCount,
    CASE 
        WHEN SUM(OrderCount) > 0 THEN SUM(TotalInterval) / SUM(OrderCount)
        ELSE NULL
    END AS AvgPurchaseInterval
FROM 
    CustomerIntervals
GROUP BY 
    CompanyName
ORDER BY 
    PurchaseCount DESC;
