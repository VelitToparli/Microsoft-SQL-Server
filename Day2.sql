-- SIRALAMA

-- Order by diye sýralamadýðýmýz zaman . mssql default olarak primery key kolonunun  üzerinde kendiliðinden index sýrasý oluþturur ve o sýraya göre getiri.

--Default sýralamaya örnek
select ProductID, Name, Color, ListPrice  -- productID ye göre sýralý gelecek 
from Production.Product

-- Ürünleri fiyata göre ucuzdan pahalýya doðru sýralý getirelim
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice asc -- Default yöne küçükten büyüðedir. Fakat biz kolondan sonra yönünü yazýp ayar çekebiliyoruz. asc: küçükten büyüðe doðru demek

-- Ürünleri fiyata göre pahalýdan ucuza doðru sýralý getirelim 
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice desc -- desc: büyükten küçüðe göre sýrala

-- sunucuda (SQL, Database'de) sýralama yapmak maliyetlidir. Genelde uygulama katmanýnda sýralama yapmak idealdir. Client tarafýnda bu iþlemi yapabiliyorsak orada sýralam yapmak daha idealdir.

-- Yukardaki örneðin farklý hali
select ProductID, Name, Color, ListPrice
from Production.Product
order by 4 desc -- kolonun direk ismini yazmak yerine kolon sýrasýný yazarak ta sýralama yapabiliriz. select yanýnda ListPrice 4.sýrada olduðu için 4 yazdýk
--Bu yöntemi kullanmak tercih edilmez. select yanýna herhangi baþka bir kolon yazarsak sýralama deðiþebilir. O yüzden kolon ismi ile kullanmak en iyisidir.

-- Birden fazla kolonun sýralanmasý durumu
--bu örnekte mesela önce fiyata göre sýrala, daha sonra fiyatý ayný olanlarý ismine göre sýrala
select ProductID, Name, Color, ListPrice
from Production.Product
order by ListPrice asc, Name asc -- Daha da arttýrabiliriz sýralama sayýsýný

--Ödev 1
-- Color'ý sýraladýðýmýzda ilk önce null geliyor sýralamada. Ödev: renge göre a'dan z'ye göre sýralayýn , null'lar baþta olmasýn sonda olsun
--select Name, Color, ListPrice
--from Production.Product
--order by Color asc -- bu kod üzerinde düzenle ayar çek

-- Fiyatý en pahalý  olan ilk 10 ürün gelsin
select top(10) ProductID, Name, Color, ListPrice  -- veya top 10 olarak parantezsizde row sayýsýný ayarlyabiliriz
from Production.Product
order by ListPrice desc

-- Fiyatý en pahalý ilk yüzde 10'luk ürün dilimi 
select top 10 percent ProductID, Name, Color, ListPrice  -- percent eklediðimizde , fiyata göre sýraladýðýmýz verinin yüzde 10'unu getirir
from Production.Product
order by ListPrice desc

-- Fiyatý en ucuz  olan ilk 10 ürün gelsin
select top(10) ProductID, Name, Color, ListPrice  -- veya top 10 olarak parantezsizde row sayýsýný ayarlyabiliriz
from Production.Product
order by ListPrice asc

--Fiyatý en pahalý ilk 3 ürün gelsin  --Bu örnekte ayný fiyatta 5 ürün var , bu þekilde sýraladýðýmýzda diðer 2 ürün gelmez
select top 3 ProductID, Name, Color, ListPrice 
from Production.Product
order by ListPrice desc

--Fiyatý en pahalý ilk 3 ürün gelsin -- Doðrusu bu.
select top 3 with ties ProductID, Name, Color, ListPrice -- bu þekilde yazdýðýmýzda , en yüksek fiyata sahip ürünler 3 ten fazla ise, ayný fiyattaki ürünleri de getiri. Doðrusu budur.
from Production.Product
order by ListPrice desc

--Fiyatý en pahalý ikinci 20 ürün (21-40) gelsin
select Name, Color, ListPrice
from Production.Product
order by ListPrice desc
--offset 0 rows fetch next 20 rows only -- 0 satýr atla , ilk 20 satýrý getir, bu  ilk 20 ürünü getir ile ayný
offset 20 rows fetch next 20 rows only -- ilk 20 satýrý atla, sonraki ilk 20 satýrý getir, en pahalý ikinci 20 ürünü getirir


/* SORGU KOMUTLARININ YAZILMA VE ÇALIÞTIRMA SIRASI VE ÇALIÞTIRMA SIRASI

--SQL dili bir yazýlým dili olmadýðý için, komutlar satýr sýrasýna göre çalýþmaz

--------------------------------------------------------
Yazýlma Sýrasý -- Çalýþma Sýrasý ( Aþaðýdaki tabloda parantez içindeki sayýlar çalýþtýrýlma sýrasýný belirtiyor)
--------------------------------------------------------
SELECT .............( 5 )
FROM ...............( 1 ) 
WHERE ..............( 2 )  (FÝLTRE VERMEYE YARIYORDU)
GROUP BY ...........( 3 )  (VAR OLAN VERÝMÝZÝ BELLÝ GRUPLARA BÖLÜP, GRUPLARA GÖRE HESAPLATMALAR YAPILIR)
HAVING .............( 4 )  (FÝLTRE VERMEYE YARAR, HAVING GROUP BY  ÝLE HESAPLANAN GRUPLANAN HESAPLAMALARI FÝLTRELEMEK ÝÇÝN KULLANILIR)
ORDER BY ...........( 6 )  (SIRALAMA YAPMAYA YARAR)

*/
-- Bu sýraya göre yazmak zorundayýz. Yoksa hata verir.


--ÝSPAT

--Ýþlem sýrasý örneði
select Name as "Ürün Adý" , Color as Renk, ListPrice as [Liste Fiyatý] -- as: kalýcý olarak isim deðiþtirmez, çýktýsýný türkçe olarak getirir
-- as kullanýrken vereceðiimiz geçici isim boþluk içeriyor ise çift týrnak içinde yazýlýr. Diðer tüm sql programlarýndada bu geçerlidir. Ayrýca kullandýðýmýz SQL serverda ayrýca kareli parantez [] içerisindede yazarak gösterebiliyoruz
from Production.Product
where Renk = 'Black'   -- Bu örnekte hata verdi. Çünkü iþlem sýrasýna göre where  , selectten önce çalýþtýðý için Renk kolonunu tanýmayacak.

--Yukardaki hatanýn çözümü
select Name as "Ürün Adý" , Color as Renk, ListPrice as [Liste Fiyatý]  -- Collation'dan baðýmsýz olduðu için türkçe karakter kullandýðýmýz isimlerde N kullanmamýza gerek yok.
from Production.Product
where Color = 'Black' -- Ýþlem sýrasýna göre hata giderilmiþ oldu. 
order by [Liste Fiyatý] desc -- Ýþlem sýrasýna göre select, order by'dan önce çalýþtýðý için select'in içerisinde tanýmladýðýmýz kolon isimlerini order by içerisinde kullanabiliriz.


/* AGGREGATE  FUNCTIONS  ( GROUP BY YAPTIKTAN SONRA KULLANILABÝLECEK HESAPLAMA FONKSÝYONLARI)
-------------------------

SUM() ---- TOPLAMA          ==> HER ZAMAN DOÐRU ÇALIÞIR
MIN() ---- EN KÜÇÜK DEÐER   ==> HER ZAMAN DOÐRU ÇALIÞIR
MAX() ---- EN BÜYÜK DEÐER   ==> HER ZAMAN DOÐRU ÇALIÞIR
--------------------------------------
COUNT() -- SATIR SAYISINI VERÝR  ==> Null hesaplamaya dahil edilmez!!!  
AVG() ---- ORTALAMA ALIR         ==> Null hesaplamaya dahil edilmez!!!

*/

-- Yukardaki 5 fonksiyonu kullanarak hesaplamalarý yap
select SUM(ProductSubcategoryID) as Toplam,  
	   MIN(ProductSubcategoryID) as Minimum,
	   MAX(ProductSubcategoryID ) as Maksimum,
	   COUNT(ProductSubcategoryID) as Adet1,  --Null'lar dahil edilmemiþ adeti gösterdi
	   COUNT(*) as Adet2,					  --Null'lar dahil edilmiþ adeti gösterir.
	   AVG(ProductSubcategoryID) as Ortalama1, --Null'lar dahil dedilmemiþ ortalamayý gösterdi
	   SUM(ProductSubcategoryID) / COUNT(*) as Ortalama2, --Null'lar dahil edilmiþ ortalamayý gösterir
	   AVG(ISNULL(ProductSubcategoryID, 0)) as Ortalama3 -- Null'lar dahil edilmiþ ortalamayý gösterir. Bu yöntem ile null'larý 0(sýfýr) ile replace edip hesaplattýk.
from Production.Product




-- GROUP BY ÖRNEKLERÝ


-- Her bir renkten kaç adet ürün mevcut
select Color, COUNT(*) as Adet  --COUNT() fonksiyonunun içine Color yazsak, Null'larý saymayacaktý
from Production.Product
group by Color


-- Hangi þehirde kaç adet adress mevcut
select City, COUNT(*) as Adet -- COUNT(AddressLine1) ' de diyebiliriz, eðer null yok ise
from Person.Address
group by City

--Hangi þehirde kaç aderes mevcut ve adres sayýsýna göre küçükten büyüðe sýralayalým
select City, COUNT(*) as Adet 
from Person.Address
group by City
order by Adet desc -- iþlem sýrasýna göre order by en son yapýlan iþlem olduðu için, City yerine Adet yazabiliyoruz

--Her rengin en pahalý ,en ucuz ve ortalama fiyat bilgileri gelsin
select Color, MAX(ListPrice) as EnPahali, MIN(ListPrice) as EnUcuz, AVG(ListPrice) as OrtalamaFiyat
from Production.Product
group by Color

--Her bir yýlda toplam ne kadar satýþ yapýldý ( her bir yýlda ciro elde edildi ), yýllar sýralý gelsin
select YEAR(OrderDate) as YIL, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate)
order by YEAR(OrderDate) asc  -- veya YEAR(OrderDate) yerine YIL yazabiliriz

--Her bir yýlýn her bir ayýnda toplam ne kadar ciro elde edildi (
select YEAR(OrderDate) as YIL,MONTH(OrderDate) as AY, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate),MONTH(OrderDate)
order by YIL asc,AY asc 


--Toplamda en az 5 Milyon TL ve üzeri ciro yapýlan  YIL ve AYLAR gelsin
select YEAR(OrderDate) as YIL,MONTH(OrderDate) as AY, SUM(SubTotal) as Ciro
from Sales.SalesOrderHeader
group by YEAR(OrderDate),MONTH(OrderDate)
HAVING SUM(SubTotal) >= 5000000  -- Group by ' da grupladýðýmýz kolonlarda filtreleme yapmak için having kullanabiliriz where ' i kullanamayýz.
order by YIL asc,AY asc 


---- Tek 1 siparisin tutari en az 50 bin TL olup toplam siparis tutari 500 bin TL üzerinde olan musteriler gelsin
select CustomerID, SUM(SubTotal) as ToplamTutar  -- 
from Sales.SalesOrderHeader
where SubTotal >= 50000  -- Ýlk önce 50000TL 'nin üstündekileri alýp iþleme , 50000TL'lik en az bir sipariþ verenler ile devam ediyoruz.
group by CustomerID
HAVING SUM(SubTotal) >= 500000  -- Burada ise toplam tutarý 500000TL ve üzeri olan müþterileri verir
order by ToplamTutar desc -- en tuzlu müþteriler :)







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

-- Sipariþlerin tarihi , sipariþin tutarý ve sipariþin verildiði bölge adý gelsin ( OrderDate,SubTotal, TeritoryID ( bölge adý, TeritoryID sütunundaki tablodan alýnacak)) )

select * from Sales.SalesOrderHeader  
select * from Sales.SalesTerritory
--bu iki tabloyu joinleyecez
select soh.OrderDate, soh.SubTotal, st.Name  --Tavsiye: join kullandýðýnýz zaman hangi tablodan geldiðini yazmanýz faydalý olur. Çünkü ayný isimde 2 kolonda da olan olsaydý hata verirdi. o yüzden baþýna hangi yerden geldiðini belirtmeliyiz
from Sales.SalesOrderHeader as soh inner join Sales.SalesTerritory as st  --sql server'de as yazabiliriz fakat oraclede geçerli deðil. Burada isim atamamýzýn sebebi, bu tablo ismini defalarca kullanacaðým için kodun karmaþýklýðýný kaldýrmak için geçici bir isim vererek kýsaltýyoruz.
on soh.TerritoryID = st.TerritoryID  -- inner join olduðu için eþleþen yani territoryID kolonlarý gelecek


--ürünlerin ürün adý , rengi , fiyatý ve model adý gelsin
select * from Production.Product  
select * from Production.ProductModel

select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p inner join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID



-- Kategori adý ( productcategory'den gelecek), alt kategori adý(productsubcategory'den gelecek), ürün adý(product'dan gelecek), rengi(product'dan gelcek),fiyatý(product'dan gelecek) ve model adý(Productmodel'den gelecek) gelsin
select * from Production.ProductCategory   --- 1
select * from Production.ProductSubcategory -- 2
select * from Production.Product            -- 3
select * from Production.ProductModel       -- 4
-- 1 ile 2 iliþkili , 2 ile 3 iliþkili, 3 ile 4 iliþkili  ---- 3 inner join yapmamýz gerekiyor
select pc.Name as KategoriAdi, psc.Name as AltKategoriAdi, p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.ProductCategory as pc inner join Production.ProductSubcategory as psc
on pc.ProductCategoryID = psc.ProductCategoryID
inner join Production.Product as p
on psc.ProductSubcategoryID = p.ProductSubcategoryID
inner join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID


--Yukardaki örneðin çözümü hocanýn yolladýðý yol
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

--INNER JOIN --   295 rows  --  (Modeli olan ürünler geldi) -- Inner join bütün rowslarý getirmiyor, ID'leri karþýlýklý eþleþenleri getiriyor
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p inner join Production.ProductModel as pm  -- tek baþýna join yazarsak default olarak inner join olur
on p.ProductModelID=pm.ProductModelID

--LEFT JOIN --  504 rows  -- ( Modeli olsun yada olmasýn bütün ürünler gelecek)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p left join Production.ProductModel as pm   -- ürün tablosu solda olduðu için left join yazýyoruz. Solu referans alýp ona ait tüm satýrlarý getirecek. Modeli olmayanlarýn karþýlýðýnda model ismi olarak null gelecek
on p.ProductModelID=pm.ProductModelID

--RÝGHT JOIN --  304  --- (Ürünü olsun ya da olmasýn bütün moldeller gelsin) -- ProductModel tablosunu referans alacaz
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p right join Production.ProductModel as pm   --Left join yazýp , productModeli sola, Product listesini saða yazsak ayný sonucu alýrdýk
on p.ProductModelID=pm.ProductModelID

--FULL JOIN --  513  ( formül ile hesapladýðýmýzda 504+304-295 = 513) --- (Hem bütün ürünler modeli olmasa bile, hem de  bütün modelleri istiyorlar ürünü olmasa bile)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p full join Production.ProductModel as pm
on p.ProductModelID=pm.ProductModelID

-- CROS JOIN -- 64512 rows (formül: product rows * productmodel rows) -- ( Her bir ürünün her bir model ile kartezyen çarpýmý ) -- ( Ürün tablosundaki her bir ürünü, model tablosundaki her bir ürün ile karþýlaþtýrdý)
select p.Name as UrunAdi, p.Color, p.ListPrice, pm.Name as ModelAdi
from Production.Product as p cross join Production.ProductModel as pm

-- Ödev 2  
-- Kiþilerin  Adý, Soyadý, Email, Telefon numarasý gelsin
--person.persondan isimler, diðerleri de baðlantýlý tablolardan joinleyip getirecez





-- Kategori adý ( productcategory'den gelecek), alt kategori adý(productsubcategory'den gelecek), ürün adý(product'dan gelecek), rengi(product'dan gelcek),fiyatý(product'dan gelecek) ve model adý(Productmodel'den gelecek) gelsin
--Design Query editordan yaptýk. kod otomatik geldi. Yukarda tüm kodu kendimiz yazmýþtýk
SELECT        pc.Name AS [Kategori Adý], psc.Name AS [Altkategori Adý], p.Name AS [Ürün Adý], p.Color AS Renk, p.ListPrice AS Fiyat, pm.Name AS [Model Adý]
FROM            Production.Product AS p INNER JOIN
                         Production.ProductModel AS pm ON p.ProductModelID = pm.ProductModelID INNER JOIN
                         Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID INNER JOIN
                         Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE        (p.Color = N'Black') OR
                         (p.Color = N'Red')
ORDER BY [Kategori Adý], Fiyat DESC
