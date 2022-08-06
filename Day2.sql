-- SIRALAMA

-- Order by diye s�ralamad���m�z zaman . mssql default olarak primery key kolonunun  �zerinde kendili�inden index s�ras� olu�turur ve o s�raya g�re getiri.

--Default s�ralamaya �rnek
select ProductID, Name, Color, ListPrice  -- productID ye g�re s�ral� gelecek 
from Production.Product

-- �r�nleri fiyata g�re ucuzdan pahal�ya do�ru s�ral� getirelim
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice asc -- Default y�ne k���kten b�y��edir. Fakat biz kolondan sonra y�n�n� yaz�p ayar �ekebiliyoruz. asc: k���kten b�y��e do�ru demek

-- �r�nleri fiyata g�re pahal�dan ucuza do�ru s�ral� getirelim 
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice desc -- desc: b�y�kten k����e g�re s�rala

-- sunucuda (SQL, Database'de) s�ralama yapmak maliyetlidir. Genelde uygulama katman�nda s�ralama yapmak idealdir. Client taraf�nda bu i�lemi yapabiliyorsak orada s�ralam yapmak daha idealdir.

-- Yukardaki �rne�in farkl� hali
select ProductID, Name, Color, ListPrice
from Production.Product
order by 4 desc -- kolonun direk ismini yazmak yerine kolon s�ras�n� yazarak ta s�ralama yapabiliriz. select yan�nda ListPrice 4.s�rada oldu�u i�in 4 yazd�k
--Bu y�ntemi kullanmak tercih edilmez. select yan�na herhangi ba�ka bir kolon yazarsak s�ralama de�i�ebilir. O y�zden kolon ismi ile kullanmak en iyisidir.

-- Birden fazla kolonun s�ralanmas� durumu
--bu �rnekte mesela �nce fiyata g�re s�rala, daha sonra fiyat� ayn� olanlar� ismine g�re s�rala
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice asc, Name asc -- Daha da artt�rabiliriz s�ralama say�s�n�

--�dev 1
-- Color'� s�ralad���m�zda ilk �nce null geliyor s�ralamada. �dev: renge g�re a'dan z'ye g�re s�ralay�n , null'lar ba�ta olmas�n sonda olsun
--select Name, Color, ListPrice
--from Production.Product
--order by Color asc -- bu kod �zerinde d�zenle ayar �ek

-- Fiyat� en pahal�  olan ilk 10 �r�n gelsin
select top(10) ProductID, Name, Color, ListPrice  -- veya top 10 olarak parantezsizde row say�s�n� ayarlyabiliriz
from Production.Product
order by ListPrice desc

-- Fiyat� en pahal� ilk y�zde 10'luk �r�n dilimi 
select top 10 percent ProductID, Name, Color, ListPrice  -- percent ekledi�imizde , fiyata g�re s�ralad���m�z verinin y�zde 10'unu getirir
from Production.Product
order by ListPrice desc

-- Fiyat� en ucuz  olan ilk 10 �r�n gelsin
select top(10) ProductID, Name, Color, ListPrice  -- veya top 10 olarak parantezsizde row say�s�n� ayarlyabiliriz
from Production.Product
order by ListPrice asc

--Fiyat� en pahal� ilk 3 �r�n gelsin  --Bu �rnekte ayn� fiyatta 5 �r�n var , bu �ekilde s�ralad���m�zda di�er 2 �r�n gelmez
select top 3 ProductID, Name, Color, ListPrice 
from Production.Product
order by ListPrice desc

--Fiyat� en pahal� ilk 3 �r�n gelsin -- Do�rusu bu.
select top 3 with ties ProductID, Name, Color, ListPrice -- bu �ekilde yazd���m�zda , en y�ksek fiyata sahip �r�nler 3 ten fazla ise, ayn� fiyattaki �r�nleri de getiri. Do�rusu budur.
from Production.Product
order by ListPrice desc

--Fiyat� en pahal� ikinci 20 �r�n (21-40) gelsin
select Name, Color, ListPrice
from Production.Product
order by ListPrice desc
--offset 0 rows fetch next 20 rows only -- 0 sat�r atla , ilk 20 sat�r� getir, bu  ilk 20 �r�n� getir ile ayn�
offset 20 rows fetch next 20 rows only -- ilk 20 sat�r� atla, sonraki ilk 20 sat�r� getir, en pahal� ikinci 20 �r�n� getirir


/* SORGU KOMUTLARININ YAZILMA VE �ALI�TIRMA SIRASI VE �ALI�TIRMA SIRASI

--SQL dili bir yaz�l�m dili olmad��� i�in, komutlar sat�r s�ras�na g�re �al��maz

--------------------------------------------------------
Yaz�lma S�ras� -- �al��ma S�ras� ( A�a��daki tabloda parantez i�indeki say�lar �al��t�r�lma s�ras�n� belirtiyor)
--------------------------------------------------------
SELECT .............( 5 )
FROM ...............( 1 ) 
WHERE ..............( 2 )  (F�LTRE VERMEYE YARIYORDU)
GROUP BY ...........( 3 )  (VAR OLAN VER�M�Z� BELL� GRUPLARA B�L�P, GRUPLARA G�RE HESAPLATMALAR YAPILIR)
HAVING .............( 4 )  (F�LTRE VERMEYE YARAR, HAVING GROUP BY  �LE HESAPLANAN GRUPLANAN HESAPLAMALARI F�LTRELEMEK ���N KULLANILIR)
ORDER BY ...........( 6 )  (SIRALAMA YAPMAYA YARAR)

*/
-- Bu s�raya g�re yazmak zorunday�z. Yoksa hata verir.


--�SPAT

--��lem s�ras� �rne�i
select Name as "�r�n Ad�" , Color as Renk, ListPrice as [Liste Fiyat�] -- as: kal�c� olarak isim de�i�tirmez, ��kt�s�n� t�rk�e olarak getirir
-- as kullan�rken verece�iimiz ge�ici isim bo�luk i�eriyor ise �ift t�rnak i�inde yaz�l�r. Di�er t�m sql programlar�ndada bu ge�erlidir. Ayr�ca kulland���m�z SQL serverda ayr�ca kareli parantez [] i�erisindede yazarak g�sterebiliyoruz
from Production.Product
where Renk = 'Black'   -- Bu �rnekte hata verdi. ��nk� i�lem s�ras�na g�re where  , selectten �nce �al��t��� i�in Renk kolonunu tan�mayacak.

--Yukardaki hatan�n ��z�m�
select Name as "�r�n Ad�" , Color as Renk, ListPrice as [Liste Fiyat�]  -- Collation'dan ba��ms�z oldu�u i�in t�rk�e karakter kulland���m�z isimlerde N kullanmam�za gerek yok.
from Production.Product
where Color = 'Black' -- ��lem s�ras�na g�re hata giderilmi� oldu. 
order by [Liste Fiyat�] desc -- ��lem s�ras�na g�re select, order by'dan �nce �al��t��� i�in select'in i�erisinde tan�mlad���m�z kolon isimlerini order by i�erisinde kullanabiliriz.


/* AGGREGATE  FUNCTIONS  ( GROUP BY YAPTIKTAN SONRA KULLANILAB�LECEK HESAPLAMA FONKS�YONLARI)
-------------------------

SUM() ---- TOPLAMA          ==> HER ZAMAN DO�RU �ALI�IR
MIN() ---- EN K���K DE�ER   ==> HER ZAMAN DO�RU �ALI�IR
MAX() ---- EN B�Y�K DE�ER   ==> HER ZAMAN DO�RU �ALI�IR
--------------------------------------
COUNT() -- SATIR SAYISINI VER�R  ==> Null hesaplamaya dahil edilmez!!!  
AVG() ---- ORTALAMA ALIR         ==> Null hesaplamaya dahil edilmez!!!

*/

-- Yukardaki 5 fonksiyonu kullanarak hesaplamalar� yap
select SUM(ProductSubcategoryID) as Toplam,  
	   MIN(ProductSubcategoryID) as Minimum,
	   MAX(ProductSubcategoryID ) as Maksimum,
	   COUNT(ProductSubcategoryID) as Adet1,  --Null'lar dahil edilmemi� adeti g�sterdi
	   COUNT(*) as Adet2,					  --Null'lar dahil edilmi� adeti g�sterir.
	   AVG(ProductSubcategoryID) as Ortalama1, --Null'lar dahil dedilmemi� ortalamay� g�sterdi
	   SUM(ProductSubcategoryID) / COUNT(*) as Ortalama2, --Null'lar dahil edilmi� ortalamay� g�sterir
	   AVG(ISNULL(ProductSubcategoryID, 0)) as Ortalama3 -- Null'lar dahil edilmi� ortalamay� g�sterir. Bu y�ntem ile null'lar� 0(s�f�r) ile replace edip hesaplatt�k.
from Production.Product




-- GROUP BY �RNEKLER�


-- Her bir renkten ka� adet �r�n mevcut
select Color, COUNT(*) as Adet  --COUNT() fonksiyonunun i�ine Color yazsak, Null'lar� saymayacakt�
from Production.Product
group by Color


-- Hangi �ehirde ka� adet adress mevcut
select City, COUNT(*) as Adet -- COUNT(AddressLine1) ' de diyebiliriz, e�er null yok ise
from Person.Address
group by City

--Hangi �ehirde ka� aderes mevcut ve adres say�s�na g�re k���kten b�y��e s�ralayal�m
select City, COUNT(*) as Adet 
from Person.Address
group by City
order by Adet desc -- i�lem s�ras�na g�re order by en son yap�lan i�lem oldu�u i�in, City yerine Adet yazabiliyoruz

--Her rengin en pahal� ,en ucuz ve ortalama fiyat bilgileri gelsin
select Color, MAX(ListPrice) as EnPahali, MIN(ListPrice) as EnUcuz, AVG(ListPrice) as OrtalamaFiyat
from Production.Product
group by Color

--Her bir y�lda toplam ne kadar sat�� yap�ld� ( her bir y�lda ciro elde edildi ), y�llar s�ral� gelsin
select YEAR(OrderDate) as YIL, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by YEAR(OrderDate) asc  -- veya YEAR(OrderDate) yerine YIL yazabiliriz

--Her bir y�l�n her bir ay�nda toplam ne kadar ciro elde edildi (
select YEAR(OrderDate) as YIL,MONTH(OrderDate) as AY, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate),MONTH(OrderDate)
order by YIL asc,AY asc 


--Toplamda en az 5 Milyon TL ve �zeri ciro yap�lan  YIL ve AYLAR gelsin
select YEAR(OrderDate) as YIL,MONTH(OrderDate) as AY, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate),MONTH(OrderDate)
HAVING SUM(SubTotal) >= 5000000  -- Group by ' da gruplad���m�z kolonlarda filtreleme yapmak i�in having kullanabiliriz where ' i kullanamay�z.
order by YIL asc,AY asc 


---- Tek 1 siparisin tutari en az 50 bin TL olup toplam siparis tutari 500 bin TL �zerinde olan musteriler gelsin
select CustomerID, SUM(SubTotal) as ToplamTutar  -- 
from Sales.SalesOrderHeader
where SubTotal >= 50000  -- �lk �nce 50000TL 'nin �st�ndekileri al�p i�leme , 50000TL'lik en az bir sipari� verenler ile devam ediyoruz.
group by CustomerID
HAVING SUM(SubTotal) >= 500000  -- Burada ise toplam tutar� 500000TL ve �zeri olan m��terileri verir
order by ToplamTutar desc -- en tuzlu m��teriler :)







/* JOINS
---------------

1- INNER JOIN
2- OUTER JOIN
	-LEFT (OUTER) JOIN
	-RIGHT (OUTER) JOIN
	-FULL (OUTER) JOIN
3- CROSS JOIN

*/


--INNER JOIN SAMPLES

-- Sipari�lerin tarihi , sipari�in tutar� ve sipari�in verildi�i b�lge ad� gelsin ( OrderDate,SubTotal, TeritoryID ( b�lge ad�, TeritoryID s�tunundaki tablodan al�nacak)) )

select * from Sales.SalesOrderHeader  
select * from Sales.SalesTerritory
--bu iki tabloyu joinleyecez
select soh.OrderDate, soh.SubTotal, st.Name  --Tavsiye: join kulland���n�z zaman hangi tablodan geldi�ini yazman�z faydal� olur. ��nk� ayn� isimde 2 kolonda da olan olsayd� hata verirdi. o y�zden ba��na hangi yerden geldi�ini belirtmeliyiz
from Sales.SalesOrderHeader as soh inner join Sales.SalesTerritory as st  --sql server'de as yazabiliriz fakat oraclede ge�erli de�il. Burada isim atamam�z�n sebebi, bu tablo ismini defalarca kullanaca��m i�in kodun karma��kl���n� kald�rmak i�in ge�ici bir isim vererek k�salt�yoruz.
on soh.TerritoryID = st.TerritoryID  -- inner join oldu�u i�in e�le�en yani territoryID kolonlar� gelecek


--�r�nlerin �r�n ad� , rengi , fiyat� ve model ad� gelsin
select * from Production.Product  
select * from Production.ProductModel

select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p inner join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID



-- Kategori ad� ( productcategory'den gelecek), alt kategori ad�(productsubcategory'den gelecek), �r�n ad�(product'dan gelecek), rengi(product'dan gelcek),fiyat�(product'dan gelecek) ve model ad�(Productmodel'den gelecek) gelsin
select * from Production.ProductCategory   --- 1
select * from Production.ProductSubcategory -- 2
select * from Production.Product            -- 3
select * from Production.ProductModel       -- 4
-- 1 ile 2 ili�kili , 2 ile 3 ili�kili, 3 ile 4 ili�kili  ---- 3 inner join yapmam�z gerekiyor
select pc.Name as KategoriAdi, psc.Name as AltKategoriAdi, p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.ProductCategory as pc inner join Production.ProductSubcategory as psc
on pc.ProductCategoryID = psc.ProductCategoryID
inner join Production.Product as p
on psc.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID


--Yukardaki �rne�in ��z�m� hocan�n yollad��� yol
select pc.Name as Kategoriadi, psc.Name as Altkategoriadi, p.Name as Urunadi, p.Color, p.ListPrice, pm.Name as Modeladi
from Production.ProductCategory as pc inner join Production.ProductSubcategory as psc
on pc.ProductCategoryID = psc.ProductCategoryID
inner join Production.Product as p
on p.ProductSubcategoryID = psc.ProductSubcategoryID
inner join Production.ProductModel as pm
on pm.ProductModelID = p.ProductModelID




--


select * from Production.Product       --504 rows
select * from Production.ProductModel  -- 128 rows

--INNER JOIN --   295 rows  --  (Modeli olan �r�nler geldi) -- Inner join b�t�n rowslar� getirmiyor, ID'leri kar��l�kl� e�le�enleri getiriyor
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p inner join Production.ProductModel as pm  -- tek ba��na join yazarsak default olarak inner join olur
on p.ProductModelID=pm.ProductModelID

--LEFT JOIN --  504 rows  -- ( Modeli olsun yada olmas�n b�t�n �r�nler gelecek)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p left join Production.ProductModel as pm   -- �r�n tablosu solda oldu�u i�in left join yaz�yoruz. Solu referans al�p ona ait t�m sat�rlar� getirecek. Modeli olmayanlar�n kar��l���nda model ismi olarak null gelecek
on p.ProductModelID=pm.ProductModelID

--R�GHT JOIN --  304  --- (�r�n� olsun ya da olmas�n b�t�n moldeller gelsin) -- ProductModel tablosunu referans alacaz
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p right join Production.ProductModel as pm   --Left join yaz�p , productModeli sola, Product listesini sa�a yazsak ayn� sonucu al�rd�k
on p.ProductModelID=pm.ProductModelID

--FULL JOIN --  513  ( form�l ile hesaplad���m�zda 504+304-295 = 513) --- (Hem b�t�n �r�nler modeli olmasa bile, hem de  b�t�n modelleri istiyorlar �r�n� olmasa bile)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p full join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID

-- CROS JOIN -- 64512 rows (form�l: product rows * productmodel rows) -- ( Her bir �r�n�n her bir model ile kartezyen �arp�m� ) -- ( �r�n tablosundaki her bir �r�n�, model tablosundaki her bir �r�n ile kar��la�t�rd�)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p cross join Production.ProductModel as pm

-- �dev 2  
-- Ki�ilerin  Ad�, Soyad�, Email, Telefon numaras� gelsin
--person.persondan isimler, di�erleri de ba�lant�l� tablolardan joinleyip getirecez





-- Kategori ad� ( productcategory'den gelecek), alt kategori ad�(productsubcategory'den gelecek), �r�n ad�(product'dan gelecek), rengi(product'dan gelcek),fiyat�(product'dan gelecek) ve model ad�(Productmodel'den gelecek) gelsin
--Design Query editordan yapt�k. kod otomatik geldi. Yukarda t�m kodu kendimiz yazm��t�k
SELECT        pc.Name AS [Kategori Ad�], psc.Name AS [Altkategori Ad�], p.Name AS [�r�n Ad�], p.Color AS Renk, p.ListPrice AS Fiyat, pm.Name AS [Model Ad�]
FROM            Production.Product AS p INNER JOIN
                         Production.ProductModel AS pm ON p.ProductModelID = pm.ProductModelID INNER JOIN
                         Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID INNER JOIN
                         Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE        (p.Color = N'Black') OR
                         (p.Color = N'Red')
ORDER BY [Kategori Ad�], Fiyat DESC
