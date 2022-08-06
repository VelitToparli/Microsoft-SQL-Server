--Ödev 1
select Name, Color, ListPrice
from Production.Product
order by  case when Color is null  then 1 else 0 end,Color


--Ödev 2
select * from Person.Person
select * from Person.EmailAddress
select * from Person.PersonPhone

select p.FirstName as Ad, p.LastName as Soyad, ea.EmailAddress as MailAdresi, pp.PhoneNumber
from Person.Person as p inner join Person.EmailAddress as ea
on p.BusinessEntityID=ea.BusinessEntityID
inner join Person.PersonPhone as pp
on ea.BusinessEntityID=pp.BusinessEntityID
