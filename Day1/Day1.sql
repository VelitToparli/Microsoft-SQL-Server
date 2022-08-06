

select *   -- yýldýz demek tüm sütunlar olsun demek oluyor
from Production.Product


select Name, Color, ListPrice  -- veya tüm sütunlarý almak istemiyorsak istediðimiz sütunlarýn ismini direk yazabiliriz.
from Production.Product -- Tavsiye:istediðimiz sütunlarý yazmadan önce  alt satýra gelip from yazýp daha sopnra tekrar yukarý çýkýp sütun isimlerini alabiliriz


-- Fiyatý sýfýr olan ürünler gelsin.
select Name, Color, ListPrice
from Production.Product
where ListPrice = 0

--Fiyatý sýfýrdan farklý olan ürünler
select Name, Color, ListPrice
from Production.Product
where ListPrice != 0  -- eþit deðildirin 2 ifade þekli var. Ýlk'i örnekteki gibi. 2.yol  <> yazmak eþit deðildir demek oluyor

--fiyatý 1000 ile 2000 arasýnda olan ürünler
select Name, Color, ListPrice
from Production.Product
where ListPrice >= 1000 and ListPrice <= 2000  --between and komutu kullanarak yapýlabilir

-- Bir üst örneðin farklý bir çözümü
select Name, Color, ListPrice
from Production.Product
where ListPrice between 1000 and 2000

--Rengi siyah olan ürünler
select Name, Color, ListPrice
from Production.Product
where Color = 'Black'

-- REngi siyah veya kýrmýzý olan ve fiyatý 1000'den büyük olacak
select Name, Color, ListPrice
from Production.Product
where (Color = 'Black' or Color = 'Red') and ListPrice > 1000

-- Rengi siyah yada kýrmýzý yada mavai yada sarý olan ürünler
select Name, Color, ListPrice
from Production.Product
where Color = 'Black' or Color = 'Red' or Color = 'Blue' or Color = 'Yellow'  -- Bunda Büyük haf küçük harf duyarlýlýðý yok. Oraclede var ama

-- Hocanýn yukardaki örnek için çözümü
select Name, Color, ListPrice
from Production.Product
where Color in ('Black', 'Red', 'Blue', 'Yellow')

-- Rengi Siyah Kýrmýzý MAvi Sarý olmayan ürünler
select Name, Color, ListPrice
from Production.Product      --Null eþitliklerle dahil edilemez veya çýkarýlamaz. Eþittir null dediðimizde null'lar gelmez
where Color not in ('Black', 'Red', 'Blue', 'Yellow')  -- Null olma durumundan dolayý , rengi null olanlar in yazdýðýmýzdada not in yazdýðýmýzdada gelmiyor

-- Rengi Siyah Kýrmýzý MAvi Sarý olmayan ürünler ( null' olanlar dahil)
select Name, Color, ListPrice
from Production.Product      
where Color not in ('Black', 'Red', 'Blue', 'Yellow') or Color is null

--


-- Sadece 2012 yilinda verilen siparisler gelsin
--1.Yöntem
select *
from Sales.SalesOrderHeader
where YEAR (OrderDate) = 2012

--2.Yöntem ( Bu yöntem hatalý, kullanýmý tavsiye edilmez)
select *
from Sales.SalesOrderHeader  -- Saatler girilmediðinde son gün olarak belirdeiðimiz tarihte sýkýntý oluyor. O günün baþlangýcýnda olan sipariþleri getirmiyor. O yüzden tarhilerin arasýnda sorgu yaptýðýnýz zaman between and kullanmamak tavsiye edilir
where OrderDate between '2012-01-01'  and '2012-12-31' --Tarih yazarken mutlaka týrnak içinde yazmalýyýz. Berwwen and fonksiyonu sýnýrlar dahil oluyor

--3.Yöntem **** ( En iyi yöntem budur.) ( Performans açýsýndan da bu yçntem daha hýzlý çalýþýr)
select *
from Sales.SalesOrderHeader
where OrderDate >= '2012-01-01' and OrderDate < '2013-01-01' -- tavsiye edilen kullaným budur. 


/* LIKE
------------------

%  ==> 0 veya daha fazla karakteri temsil eder ( YA hiç yoktur ya da sýnýrsýz istediðin kadar  )

_  ==> Sadece tek 1 karakteri temsil eder

*/


-- Soyadý K ile baþlayan kaç kiþi var
select *
from Person.Person
where LastName LIKE 'K%'  --% koymamýzýn anlamý þu: Soyadý K ile baþlayan ama soyadýnýn uzunluðu ne olursa olsun 


-- Soyadý K ile biten kaç kiþi var
select *
from Person.Person
where LastName LIKE '%K'  -- % : baþýnda kaç karakter vene var ise beni ilgilendirmiyor. K ile biten olsun yeter.

-- Soyadýnda K harfi bulunan kaç kiþi var
select *
from Person.Person
where LastName LIKE '%K%'


-- Soyadýnýn sondan 3.harfi K olan kiþiler
select *
from Person.Person
where LastName LIKE '%K__'

-- 615-555-1234 formatýnda olan telefon numaralarý
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'


--Hoca yukardaki örnek için bu örnek yanýnýzda dursun dedi. Ama yukardaki doðru. Ýstediðimiz tam format bu deðil.
select *
from Person.PersonPhone
where PhoneNumber like '%-%-%' -- içinde 2 tane - olan formatý ifade ediyor. ama 3 sayý- 3 sayý- 4 sayý deðil sadece 2 tire olaný alýr.

--tarihleri sorgularken asla ve asla like kullanmayýn.


--Kaç farklý renk mevcut
select distinct Color  -- distinct tekilleþtirmeye yarýyor.
from Production.Product


--Distinct Örnek 2
select distinct Color, Size  -- distinct bu örnekte 2 kolona göre çalýþýyor. yani 2li kombinasyon þeklinde renk beden çiftlerinden sadece bir tnesini gösterir
from Production.Product


-- select'in içerisinde if kullanýlmaz.  If yerine case - when kullanýyoruz.

-- Fiyatý 0-10000 ise Ucuz , Fiyatý 1000-2000 ise Orta, Fiyatý 2000'in üzerinde ise Pahalý olarak gelsin
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then 'Pahalý'
		 else 'Diðer'
    end
from Production.Product


--Yukardaki örneði geniþletiyoruz ve ayrýntýlara giriyoruz
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'  -- between and baþlangýç ve bitiþi dahil ediyor. Eðer 1000 lira fiyatlý ürün olsa ilk koþul olduðu için ucuz olurdu
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then 'Pahalý'  -- Türkçe karakter problemi var, küçük ý'yý i olarak yazýyor.
		 else 'Diðer'
    end as 'Segment'  -- as 'Segment' yazarak sütuna geçici olarak isim vermiþ oluyoruz.
from Production.Product

--Server Collation  ==> Turkish_CI_AS  --kurulumda sorar , hangi dilde olacak ise ona göre seçeriz. Böylece harf hatalarýný çözebiliriz.
	-- DB Collation  Latin_I_General_CI_AS  --bu alt collation server collation'ý ezer, burdaki ne ise tüm sistemde o olur.
		-- Column Collation  -- altta olan üstte olaný ezer.

		--DB Collation Nasýl Düzeltilir??


--DB Collation yapýlmýþ hali
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'  -- between and baþlangýç ve bitiþi dahil ediyor. Eðer 1000 lira fiyatlý ürün olsa ilk koþul olduðu için ucuz olurdu
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then N'Pahalý'  -- Türkçe karakter problemi var, küçük ý'yý i olarak yazýyor. N koyarak türk karakterlerini kullanmýþ oluruz.
		 else  N'Diðer' -- N yazarak türkçe karakterleri olduðu gibi gösterecektir. Problem çözüldü.
    end as 'Segment'  -- as 'Segment' yazarak sütuna geçici olarak isim vermiþ oluyoruz.
from Production.Product


/* Ödev 2 ==> Renkleri yeni column da türkçe olarak gösterin . 
Black olanlar siyah , Green olanlar yeþil vs. Yukardaki örnekteki gibi yeni sütun oluþturup yapacaz */