/* SUBQUERY  ( Ýç içe sorgular)
----------------------------------------
--statik olan sorgularýmýzý dinamik olan sorgulara dönüþtürmeye yarýyor

--statik sorgu
--------------------------------------------------------------------------------
SELECT .......
FROM .........
WHERE kolonadi = 'abc'     --Buradaki 'abc' yi elle girmeyip baþka bir tablodan otomatik olarak alsam dinamik sorgu olur

--------------------------------------------------------------------------------
--dinamik sorgu
-------------------------------------------------
SELECT .......
FROM .........
WHERE kolonadi =
	(
	SELECT kolonadý
	FROM  ..........
	.......
	.......
	)
.... 
....

*/


-- Kural 1 : Subquery'lerde ilk (önce) çalýþmasý gereken sorgu her zaman parantezler içerisinde yazýlmak zorundadýr.
-- Kural 2 : Subquery'lerde dýþardaki sorgunun where ile filtrelenen kolon ile içerdeki sorgunun select'inden dönen kolon ayný veri tipinde olmalýdýr. ( Sayý ise sayý. Metin ise Metin, Tarih ise tarih)
-- Kural 3 : Subquery'lerde içerdeki (iç) sorgudan birden fazla satýr sonuç dönüyor ise, dýþardaki sorgunun filtre kýsmýnda = (eþittir) operatörü yerine IN operatörtü  kullanýlmalýdýr.



--Fiyatý en pahalý olan ürünün rengindeki  bütün ürünler gelsin
--kasik yol ile static sorgu yapmak istersek ilk önce enpahalý ürünü bulmak için bir sorrgu, daha sonra çýkan sonucu yeni sorguda filtrelemek gerekir. Fakat yarýn öbür gün en pahalý ürün deðiþirse gidip el ile tekrar 'Red' i kendim deðiþttirmem gerekecek. bu sorgu  hata verecektir.
select  top 1 Color
from Production.Product
order by ListPrice desc

select *
from Production.Product
where Color='Red'

--Dinamic 
-- Bu yöntem ile kodu çalýþtýrdýðýmýz an, ilk önce dinamik olarak gidip o an ki tabloda bulunan en pahalý ürününün rengini bulup onun bilgilerini getirecektir
select *
from Production.Product
where Color = 
	(
	select  top 1 Color
	from Production.Product
	order by ListPrice desc
	)

-- En son sipariþ verilen tarihteki tüm sipariþler gelsin
select * from AdventureWorks2017.Sales.SalesOrderHeader
--sonucu hatalý buldum
select *
from Sales.SalesOrderHeader
where OrderDate =
	(
	select top 1 OrderDate
	from Sales.SalesOrderHeader
	order by OrderDate
	)

--Hocanýn yukardaki örneðin çözümü
select *
from Sales.SalesOrderHeader
where OrderDate=
	(
	select MAX(OrderDate)
	from Sales.SalesOrderHeader
	)


--Fiyatý ortalama fiyattan daha pahalý olan ürünler gelsin
select *
from Production.Product
where ListPrice >
	(
	select AVG(ListPrice)
	from Production.Product
	)

-- SQL serverde max 32 tane (32.Dereceden) iç içe sorgu yapýlabilir. 32 ye kadar izin veriliyor diye ohh rahatým 32ye kadar yazarým diye rahat takýlmaya gerek yok. Tavsiye : Çok fazla abartýp derinlere girmeyin


-- Fiyatý en pahalý ürünün rengindeki  bütün ürünler (fiyat => Renk => )  -- MAX kullanarak

select *
from Production.Product
where Color IN   --içerden birden fazla deðer geldiði için eþittir operatörü hata verdi. Çünkü birden fazla ayný fiyatta olan ürün ayný renkteyd
	(	select Color
		from Production.Product
		where ListPrice=
			(
			select MAX(ListPrice)
			from Production.Product
			)
	)


--Hiç sipariþ vermemiþ müþteriler gelsin
select * from Sales.Customer
select * from Sales.SalesOrderHeader


select *
from Sales.Customer
where CustomerID NOT IN
	(
	select CustomerID
	from Sales.SalesOrderHeader
	)

--Ödev 1: yukardaki örneðin en az 2 farklý daha yöntem bulun gönderin (Set olabilir, farklý bir sabquery, join olabilir ...)




/* SET OPERATORS
-----------------------

1- UNION ALL
2- UNION
3- INTERSECT
4- EXCEPT

*/

--2 ayrý select cümlesinin sonuçlarýnýn satýrlarýný tek bir sonuç haline getirmek yada 2 select cümlesinin sonuçlarýný karþýlaþtýrýp farklýlýklarýný bulmak için bu set operatörlerini kullanýyoruz


-- 615-555-0153 formatýnda olan telefonlar gelsin örneðindeki çözdüðümüz örnekleri karþýlaþtýrdýk
--içinde 2 tane tire olan ve ___-___-____ formatýndaki olan numaralarý karþýlaþtýr. istediðimiz formatýn dýþýnda olan farklý 1 tane sonuç var onu bulduk iki kodu birlikte çalýþtýrýp arasýna except yazýnca

select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'   -- içinde 2 tire helan tüm telefon numarlarý
except
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'  -- tam olarak istediðimiz formatta olan telefon numarlarý
 
 
 --Aþaðýdaki kurallar bütün set operatörler için geçerlidir
-- Kural 1: set operatörü kullanýlarak karþýlaþtýrýlan 2 select'in de kolon sayhýlarý eþit olmak zorunda
-- Kural 2: (Sýrayla) Alt alta gelen kolonlarýn veri tipleri ( içerikleri)  ayný olmak zorundadýr. Çünkü ayný kolonda sadece bbir veri tipi tutabilirsiniz
-- 







/* DATA TYPE CONVERSION
-------------------------------
1- Implicit Convertion
2- Explicit Conversiton

*/

--implicit converiton
select *
from Production.Product
where ListPrice = '0'  -- SQL server implicit convertion'ý otomatik kendisi yapar , eðer biz 0(sýfýr) 'ý metin olarak girseydim, sql server otomatik olarak girdiðim string ifadeyi sayýya çevirip çalýþtýrýr.
--eðer girdiðim string ifade sayýya dönüþtürülemiyor ise ( mesela '0asdad7') sistem stringi sayýya çeviremedim hatasý verecektir.


select *
from Sales.SalesOrderHeader
where OrderDate = '2012-01-01'  -- girdiðim string metni sistem otomatikmen tarihe çevirip ondan sonra çalýþtýrýyor. Eðer girdiðimiz string metin tarih ifadesine uygun deðil ise convertion hatasý verecek.

select *
from Sales.SalesOrderHeader
where OrderDate = 2012-01-01  -- bu þekilde girdiðimizde , tarih , týrnak olmadýðý için sayý olarak kabul eder ve matematiksel iþlem yaparak ( tireler çýkarma iþlemi gibi) tarihi 2010 sayýsýna çevirir
							-- 2010 sayýsal olarak bir tarihi ifade etmez. Burdaki ifade þuna dönüþür, 2010 demek 1 ocak 1900 tarihindne itibaren geçen gün sayýsýný ifade eder
							--Ve sonuç olarak 1906 yýlýnýn denk gelen gününde olan tarihi iþleme alýr
							--bundan dolayý tarihsel ifadeleri kesinlikle ve kesinlikle tarihsel ifadeleri sayý olarak girmeyin, '' týrnak içerisinde




--Explict convertion

select Name, ISNULL(Color,'Renksiz'),ListPrice,ISNULL(CAST(ProductModelID as nvarchar),'Modelsiz'), -- null olan color'larýn yerine renksiz yazdýrdýk. replace ettirdik. String olaný stringe çevirdiðimiz için hata vermedi.
		ISNULL(CONVERT(nvarchar,ProductModelID),'Modelsiz')    --CAST ve CONVERTOR AYNI ÝÞÝ GÖRÜR, Sadece yazýlýþ sýrasý biraz deðiþiyor. Birinde ilk önce hangi veri tipine çevireceðiniz sonra sütun tipini yazýyoruz, öbürünü tam tersi
from Production.Product                                       --ProductModelID deki null'lar yerine modelsiz yazdýrmak istediðimizde direk sayýyý stringe çeviremedim hatasý verir ayný þekilde yapsaydýk.
--CAST kullanarak ProductModelID kolonunun sayýsal veri tipinden stringe çevirdik. Kalýcý bir deðiþiklik deðil , bu sorgu için deðiþtirdik sadece. Deðiþtirerek gösterir, orjinalliðini bozmadan.



--Tarih Stil formatlarý dönüþtürme örneði
select OrderDate,
	CONVERT(nvarchar, OrderDate, 104),  -- Alman standartý ( Türkiyede kullanýlan tarih formatý Gün/ay/yýl )
	CONVERT(nvarchar, OrderDate, 105),  -- Still numaralarýný nasýl bulabiliriz .  CONVERT fonksiyonunu seçip F1 e basýnca direk siteye atýyor
	CONVERT(nvarchar, OrderDate, 112),
	CONVERT(nvarchar, OrderDate, 130),
	CONVERT(nvarchar, OrderDate, 131)
from Sales.SalesOrderHeader



--Tabloyu oluþturup kaydettikten sonra sql server tablolarý otomatik güncellemiyor. Bunu biz manul ederek Tables sekmesine sað týklayýp refresh'e týklýyoruz. Böylece oluþturduðumuz tabloyu görebileceðiz
select * from dbo.Musteri




