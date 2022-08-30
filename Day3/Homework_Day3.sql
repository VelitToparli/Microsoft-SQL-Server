-- ÖDEV : Hiç sipariþ vermemiþ müþteriler gelsin

-- Alternatif Yöntem 1:
select * from Sales.Customer
select * from Sales.SalesOrderHeader

select CustomerID
from Sales.Customer
except
select CustomerID
from Sales.SalesOrderHeader


-- Alternatif Yöntem 2:
select * from Sales.Customer
select * from Sales.SalesOrderHeader

select  soh.CustomerID, c.CustomerID
from   Sales.Customer as c left join Sales.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID 
where soh.CustomerID IS NULL
