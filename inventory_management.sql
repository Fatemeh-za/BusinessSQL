-- Identify Products Below Reorder Level
SELECT 
    ProductName,
    UnitsInStock,
    ReorderLevel,
    CASE 
        WHEN ReorderLevel - UnitsInStock > 0 THEN ReorderLevel - UnitsInStock
        ELSE 0
    END AS ReorderQuantity
FROM 
    Products
WHERE 
    UnitsInStock < ReorderLevel
ORDER BY 
    ReorderQuantity DESC;

-- Inventory Turnover Rate
SELECT 
    P.ProductName,
    SUM(OD.Quantity) AS TotalSold,
    NULLIF(SUM(P.UnitsInStock + P.UnitsOnOrder), 0) / SUM(OD.Quantity) AS TurnoverRate
FROM 
    Products P
INNER JOIN 
    [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY 
    P.ProductName, P.UnitsInStock, P.UnitsOnOrder
ORDER BY 
    TurnoverRate ASC;

-- Supplier Delivery Performance
SELECT 
    S.CompanyName,
    AVG(DATEDIFF(day, O.OrderDate, O.ShippedDate)) AS AvgDeliveryTime
FROM 
    Orders O
INNER JOIN 
    [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN 
    Products P ON OD.ProductID = P.ProductID
INNER JOIN 
    Suppliers S ON P.SupplierID = S.SupplierID
WHERE 
    O.ShippedDate IS NOT NULL
GROUP BY 
    S.CompanyName
ORDER BY 
    AvgDeliveryTime;

-- Lead Time Analysis for Reordering
SELECT 
    S.CompanyName,
    P.ProductName,
    AVG(DATEDIFF(day, O.OrderDate, O.ShippedDate)) AS AvgLeadTime
FROM 
    Orders O
JOIN 
    [Order Details] OD ON O.OrderID = OD.OrderID
JOIN 
    Products P ON OD.ProductID = P.ProductID
JOIN 
    Suppliers S ON P.SupplierID = S.SupplierID
GROUP BY 
    S.CompanyName, P.ProductName
ORDER BY 
    AvgLeadTime ASC;

-- Slow-Moving Inventory Detection
SELECT 
    P.ProductName,
    SUM(OD.Quantity) AS TotalSold,
    P.UnitsInStock,
    (SUM(OD.Quantity) / NULLIF(P.UnitsInStock + SUM(OD.Quantity), 0)) AS InventoryTurnoverRatio
FROM 
    Products P
JOIN 
    [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY 
    P.ProductID, P.ProductName, P.UnitsInStock
ORDER BY 
    InventoryTurnoverRatio ASC;
