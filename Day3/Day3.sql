/* SUBQUERY  ( �� i�e sorgular)
----------------------------------------
--statik olan sorgular�m�z� dinamik olan sorgulara d�n��t�rmeye yar�yor

--statik sorgu
--------------------------------------------------------------------------------
SELECT .......
FROM .........
WHERE kolonadi = 'abc'     --Buradaki 'abc' yi elle girmeyip ba�ka bir tablodan otomatik olarak alsam dinamik sorgu olur

--------------------------------------------------------------------------------
--dinamik sorgu
-------------------------------------------------
SELECT .......
FROM .........
WHERE kolonadi =
	(
	SELECT kolonad�
	FROM  ..........
	.......
	.......
	)
.... 
....

*/


-- Kural 1 : Subquery'lerde ilk (�nce) �al��mas� gereken sorgu her zaman parantezler i�erisinde yaz�lmak zorundad�r.
-- Kural 2 : Subquery'lerde d��ardaki sorgunun where ile filtrelenen kolon ile i�erdeki sorgunun select'inden d�nen kolon ayn� veri tipinde olmal�d�r. ( Say� ise say�. Metin ise Metin, Tarih ise tarih)
-- Kural 3 : Subquery'lerde i�erdeki (i�) sorgudan birden fazla sat�r sonu� d�n�yor ise, d��ardaki sorgunun filtre k�sm�nda = (e�ittir) operat�r� yerine IN operat�rt�  kullan�lmal�d�r.



--Fiyat� en pahal� olan �r�n�n rengindeki  b�t�n �r�nler gelsin
--kasik yol ile static sorgu yapmak istersek ilk �nce enpahal� �r�n� bulmak i�in bir sorrgu, daha sonra ��kan sonucu yeni sorguda filtrelemek gerekir. Fakat yar�n �b�r g�n en pahal� �r�n de�i�irse gidip el ile tekrar 'Red' i kendim de�i�ttirmem gerekecek. bu sorgu  hata verecektir.
select  top 1 Color
from Production.Product
order by ListPrice desc

select *
from Production.Product
where Color='Red'

--Dinamic 
-- Bu y�ntem ile kodu �al��t�rd���m�z an, ilk �nce dinamik olarak gidip o an ki tabloda bulunan en pahal� �r�n�n�n rengini bulup onun bilgilerini getirecektir
select *
from Production.Product
where Color = 
	(
	select  top 1 Color
	from Production.Product
	order by ListPrice desc
	)

-- En son sipari� verilen tarihteki t�m sipari�ler gelsin
select * from AdventureWorks2017.Sales.SalesOrderHeader
--sonucu hatal� buldum
select *
from Sales.SalesOrderHeader
where OrderDate =
	(
	select top 1 OrderDate
	from Sales.SalesOrderHeader
	order by OrderDate
	)

--Hocan�n yukardaki �rne�in ��z�m�
select *
from Sales.SalesOrderHeader
where OrderDate=
	(
	select MAX(OrderDate)
	from Sales.SalesOrderHeader
	)


--Fiyat� ortalama fiyattan daha pahal� olan �r�nler gelsin
select *
from Production.Product
where ListPrice >
	(
	select AVG(ListPrice)
	from Production.Product
	)

-- SQL serverde max 32 tane (32.Dereceden) i� i�e sorgu yap�labilir. 32 ye kadar izin veriliyor diye ohh rahat�m 32ye kadar yazar�m diye rahat tak�lmaya gerek yok. Tavsiye : �ok fazla abart�p derinlere girmeyin


-- Fiyat� en pahal� �r�n�n rengindeki  b�t�n �r�nler (fiyat => Renk => )  -- MAX kullanarak

select *
from Production.Product
where Color IN   --i�erden birden fazla de�er geldi�i i�in e�ittir operat�r� hata verdi. ��nk� birden fazla ayn� fiyatta olan �r�n ayn� renkteyd
	(	select Color
		from Production.Product
		where ListPrice=
			(
			select MAX(ListPrice)
			from Production.Product
			)
	)


--Hi� sipari� vermemi� m��teriler gelsin
select * from Sales.Customer
select * from Sales.SalesOrderHeader


select *
from Sales.Customer
where CustomerID NOT IN
	(
	select CustomerID
	from Sales.SalesOrderHeader
	)

--�dev 1: yukardaki �rne�in en az 2 farkl� daha y�ntem bulun g�nderin (Set olabilir, farkl� bir sabquery, join olabilir ...)




/* SET OPERATORS
-----------------------

1- UNION ALL
2- UNION
3- INTERSECT
4- EXCEPT

*/

--2 ayr� select c�mlesinin sonu�lar�n�n sat�rlar�n� tek bir sonu� haline getirmek yada 2 select c�mlesinin sonu�lar�n� kar��la�t�r�p farkl�l�klar�n� bulmak i�in bu set operat�rlerini kullan�yoruz


-- 615-555-0153 format�nda olan telefonlar gelsin �rne�indeki ��zd���m�z �rnekleri kar��la�t�rd�k
--i�inde 2 tane tire olan ve ___-___-____ format�ndaki olan numaralar� kar��la�t�r. istedi�imiz format�n d���nda olan farkl� 1 tane sonu� var onu bulduk iki kodu birlikte �al��t�r�p aras�na except yaz�nca

select *
from Person.PersonPhone
where PhoneNumber like '%-%-%'   -- i�inde 2 tire helan t�m telefon numarlar�
except
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'  -- tam olarak istedi�imiz formatta olan telefon numarlar�
 
 
 --A�a��daki kurallar b�t�n set operat�rler i�in ge�erlidir
-- Kural 1: set operat�r� kullan�larak kar��la�t�r�lan 2 select'in de kolon sayh�lar� e�it olmak zorunda
-- Kural 2: (S�rayla) Alt alta gelen kolonlar�n veri tipleri ( i�erikleri)  ayn� olmak zorundad�r. ��nk� ayn� kolonda sadece bbir veri tipi tutabilirsiniz
-- 







/* DATA TYPE CONVERSION
-------------------------------
1- Implicit Convertion
2- Explicit Conversiton

*/

--implicit converiton
select *
from Production.Product
where ListPrice = '0'  -- SQL server implicit convertion'� otomatik kendisi yapar , e�er biz 0(s�f�r) '� metin olarak girseydim, sql server otomatik olarak girdi�im string ifadeyi say�ya �evirip �al��t�r�r.
--e�er girdi�im string ifade say�ya d�n��t�r�lemiyor ise ( mesela '0asdad7') sistem stringi say�ya �eviremedim hatas� verecektir.


select *
from Sales.SalesOrderHeader
where OrderDate = '2012-01-01'  -- girdi�im string metni sistem otomatikmen tarihe �evirip ondan sonra �al��t�r�yor. E�er girdi�imiz string metin tarih ifadesine uygun de�il ise convertion hatas� verecek.

select *
from Sales.SalesOrderHeader
where OrderDate = 2012-01-01  -- bu �ekilde girdi�imizde , tarih , t�rnak olmad��� i�in say� olarak kabul eder ve matematiksel i�lem yaparak ( tireler ��karma i�lemi gibi) tarihi 2010 say�s�na �evirir
							-- 2010 say�sal olarak bir tarihi ifade etmez. Burdaki ifade �una d�n���r, 2010 demek 1 ocak 1900 tarihindne itibaren ge�en g�n say�s�n� ifade eder
							--Ve sonu� olarak 1906 y�l�n�n denk gelen g�n�nde olan tarihi i�leme al�r
							--bundan dolay� tarihsel ifadeleri kesinlikle ve kesinlikle tarihsel ifadeleri say� olarak girmeyin, '' t�rnak i�erisinde




--Explict convertion

select Name, ISNULL(Color,'Renksiz'),ListPrice,ISNULL(CAST(ProductModelID as nvarchar),'Modelsiz'), -- null olan color'lar�n yerine renksiz yazd�rd�k. replace ettirdik. String olan� stringe �evirdi�imiz i�in hata vermedi.
		ISNULL(CONVERT(nvarchar,ProductModelID),'Modelsiz')    --CAST ve CONVERTOR AYNI ��� G�R�R, Sadece yaz�l�� s�ras� biraz de�i�iyor. Birinde ilk �nce hangi veri tipine �evirece�iniz sonra s�tun tipini yaz�yoruz, �b�r�n� tam tersi
from Production.Product                                       --ProductModelID deki null'lar yerine modelsiz yazd�rmak istedi�imizde direk say�y� stringe �eviremedim hatas� verir ayn� �ekilde yapsayd�k.
--CAST kullanarak ProductModelID kolonunun say�sal veri tipinden stringe �evirdik. Kal�c� bir de�i�iklik de�il , bu sorgu i�in de�i�tirdik sadece. De�i�tirerek g�sterir, orjinalli�ini bozmadan.



--Tarih Stil formatlar� d�n��t�rme �rne�i
select OrderDate,
	CONVERT(nvarchar, OrderDate, 104),  -- Alman standart� ( T�rkiyede kullan�lan tarih format� G�n/ay/y�l )
	CONVERT(nvarchar, OrderDate, 105),  -- Still numaralar�n� nas�l bulabiliriz .  CONVERT fonksiyonunu se�ip F1 e bas�nca direk siteye at�yor
	CONVERT(nvarchar, OrderDate, 112),
	CONVERT(nvarchar, OrderDate, 130),
	CONVERT(nvarchar, OrderDate, 131)
from Sales.SalesOrderHeader



--Tabloyu olu�turup kaydettikten sonra sql server tablolar� otomatik g�ncellemiyor. Bunu biz manul ederek Tables sekmesine sa� t�klay�p refresh'e t�kl�yoruz. B�ylece olu�turdu�umuz tabloyu g�rebilece�iz
select * from dbo.Musteri




