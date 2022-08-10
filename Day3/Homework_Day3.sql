-- �DEV : Hi� sipari� vermemi� m��teriler gelsin

-- Alternatif Y�ntem 1:
select * from Sales.Customer
select * from Sales.SalesOrderHeader

select CustomerID
from Sales.Customer
except
select CustomerID
from Sales.SalesOrderHeader


-- Alternatif Y�ntem 2:
select * from Sales.Customer
select * from Sales.SalesOrderHeader

select  soh.CustomerID, c.CustomerID
from   Sales.Customer as c left join Sales.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID 
where soh.CustomerID IS NULL
