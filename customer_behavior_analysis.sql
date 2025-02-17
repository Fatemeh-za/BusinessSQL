-- Churn Rate Analysis
SELECT 
    C.CustomerID,
    C.CompanyName,
    MAX(O.OrderDate) AS LastOrderDate,
    DATEDIFF(day, MAX(O.OrderDate), GETDATE()) AS DaysSinceLastOrder
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY 
    C.CustomerID, C.CompanyName
HAVING 
    MAX(O.OrderDate) < DATEADD(month, -6, GETDATE())
ORDER BY 
    DaysSinceLastOrder DESC;

-- Cross-Selling & Frequently Bought Together Products
SELECT 
    od1.ProductID AS ProductA,
    od2.ProductID AS ProductB,
    COUNT(*) AS PurchaseCount
FROM 
    [Order Details] od1
JOIN 
    [Order Details] od2 ON od1.OrderID = od2.OrderID AND od1.ProductID <> od2.ProductID
GROUP BY 
    od1.ProductID, od2.ProductID
ORDER BY 
    PurchaseCount DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

-- RFM Analysis (Recency, Frequency, Monetary Value)
SELECT 
    C.CustomerID,
    C.CompanyName,
    COUNT(O.OrderID) AS Frequency,
    AVG(DATEDIFF(day, O.OrderDate, GETDATE())) AS Recency,
    SUM(OD.Quantity * OD.UnitPrice) AS MonetaryValue
FROM 
    Customers C
JOIN 
    Orders O ON C.CustomerID = O.CustomerID
JOIN 
    [Order Details] OD ON O.OrderID = OD.OrderID
ORDER BY 
    MonetaryValue DESC, Frequency DESC, Recency ASC;

-- Time Series Analysis for Sales
WITH SalesData AS (
    SELECT 
        O.OrderDate,
        SUM(OD.UnitPrice * OD.Quantity) AS DailySales
    FROM 
        Orders O
    JOIN 
        [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY 
        O.OrderDate
)
SELECT 
    OrderDate,
    DailySales,
    AVG(DailySales) OVER (ORDER BY OrderDate ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS ExponentialMovingAvg
FROM 
    SalesData;
