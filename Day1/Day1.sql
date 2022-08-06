

select *   -- y�ld�z demek t�m s�tunlar olsun demek oluyor
from Production.Product


select Name, Color, ListPrice  -- veya t�m s�tunlar� almak istemiyorsak istedi�imiz s�tunlar�n ismini direk yazabiliriz.
from Production.Product -- Tavsiye:istedi�imiz s�tunlar� yazmadan �nce  alt sat�ra gelip from yaz�p daha sopnra tekrar yukar� ��k�p s�tun isimlerini alabiliriz


-- Fiyat� s�f�r olan �r�nler gelsin.
select Name, Color, ListPrice
from Production.Product
where ListPrice = 0

--Fiyat� s�f�rdan farkl� olan �r�nler
select Name, Color, ListPrice
from Production.Product
where ListPrice != 0  -- e�it de�ildirin 2 ifade �ekli var. �lk'i �rnekteki gibi. 2.yol  <> yazmak e�it de�ildir demek oluyor

--fiyat� 1000 ile 2000 aras�nda olan �r�nler
select Name, Color, ListPrice
from Production.Product
where ListPrice >= 1000 and ListPrice <= 2000  --between and komutu kullanarak yap�labilir

-- Bir �st �rne�in farkl� bir ��z�m�
select Name, Color, ListPrice
from Production.Product
where ListPrice between 1000 and 2000

--Rengi siyah olan �r�nler
select Name, Color, ListPrice
from Production.Product
where Color = 'Black'

-- REngi siyah veya k�rm�z� olan ve fiyat� 1000'den b�y�k olacak
select Name, Color, ListPrice
from Production.Product
where (Color = 'Black' or Color = 'Red') and ListPrice > 1000

-- Rengi siyah yada k�rm�z� yada mavai yada sar� olan �r�nler
select Name, Color, ListPrice
from Production.Product
where Color = 'Black' or Color = 'Red' or Color = 'Blue' or Color = 'Yellow'  -- Bunda B�y�k haf k���k harf duyarl�l��� yok. Oraclede var ama

-- Hocan�n yukardaki �rnek i�in ��z�m�
select Name, Color, ListPrice
from Production.Product
where Color in ('Black', 'Red', 'Blue', 'Yellow')

-- Rengi Siyah K�rm�z� MAvi Sar� olmayan �r�nler
select Name, Color, ListPrice
from Production.Product      --Null e�itliklerle dahil edilemez veya ��kar�lamaz. E�ittir null dedi�imizde null'lar gelmez
where Color not in ('Black', 'Red', 'Blue', 'Yellow')  -- Null olma durumundan dolay� , rengi null olanlar in yazd���m�zdada not in yazd���m�zdada gelmiyor

-- Rengi Siyah K�rm�z� MAvi Sar� olmayan �r�nler ( null' olanlar dahil)
select Name, Color, ListPrice
from Production.Product      
where Color not in ('Black', 'Red', 'Blue', 'Yellow') or Color is null

--


-- Sadece 2012 yilinda verilen siparisler gelsin
--1.Y�ntem
select *
from Sales.SalesOrderHeader
where YEAR (OrderDate) = 2012

--2.Y�ntem ( Bu y�ntem hatal�, kullan�m� tavsiye edilmez)
select *
from Sales.SalesOrderHeader  -- Saatler girilmedi�inde son g�n olarak belirdei�imiz tarihte s�k�nt� oluyor. O g�n�n ba�lang�c�nda olan sipari�leri getirmiyor. O y�zden tarhilerin aras�nda sorgu yapt���n�z zaman between and kullanmamak tavsiye edilir
where OrderDate between '2012-01-01'  and '2012-12-31' --Tarih yazarken mutlaka t�rnak i�inde yazmal�y�z. Berwwen and fonksiyonu s�n�rlar dahil oluyor

--3.Y�ntem **** ( En iyi y�ntem budur.) ( Performans a��s�ndan da bu y�ntem daha h�zl� �al���r)
select *
from Sales.SalesOrderHeader
where OrderDate >= '2012-01-01' and OrderDate < '2013-01-01' -- tavsiye edilen kullan�m budur. 


/* LIKE
------------------

%  ==> 0 veya daha fazla karakteri temsil eder ( YA hi� yoktur ya da s�n�rs�z istedi�in kadar  )

_  ==> Sadece tek 1 karakteri temsil eder

*/


-- Soyad� K ile ba�layan ka� ki�i var
select *
from Person.Person
where LastName LIKE 'K%'  --% koymam�z�n anlam� �u: Soyad� K ile ba�layan ama soyad�n�n uzunlu�u ne olursa olsun 


-- Soyad� K ile biten ka� ki�i var
select *
from Person.Person
where LastName LIKE '%K'  -- % : ba��nda ka� karakter vene var ise beni ilgilendirmiyor. K ile biten olsun yeter.

-- Soyad�nda K harfi bulunan ka� ki�i var
select *
from Person.Person
where LastName LIKE '%K%'


-- Soyad�n�n sondan 3.harfi K olan ki�iler
select *
from Person.Person
where LastName LIKE '%K__'

-- 615-555-1234 format�nda olan telefon numaralar�
select *
from Person.PersonPhone
where PhoneNumber like '___-___-____'


--Hoca yukardaki �rnek i�in bu �rnek yan�n�zda dursun dedi. Ama yukardaki do�ru. �stedi�imiz tam format bu de�il.
select *
from Person.PersonPhone
where PhoneNumber like '%-%-%' -- i�inde 2 tane - olan format� ifade ediyor. ama 3 say�- 3 say�- 4 say� de�il sadece 2 tire olan� al�r.

--tarihleri sorgularken asla ve asla like kullanmay�n.


--Ka� farkl� renk mevcut
select distinct Color  -- distinct tekille�tirmeye yar�yor.
from Production.Product


--Distinct �rnek 2
select distinct Color, Size  -- distinct bu �rnekte 2 kolona g�re �al���yor. yani 2li kombinasyon �eklinde renk beden �iftlerinden sadece bir tnesini g�sterir
from Production.Product


-- select'in i�erisinde if kullan�lmaz.  If yerine case - when kullan�yoruz.

-- Fiyat� 0-10000 ise Ucuz , Fiyat� 1000-2000 ise Orta, Fiyat� 2000'in �zerinde ise Pahal� olarak gelsin
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then 'Pahal�'
		 else 'Di�er'
    end
from Production.Product


--Yukardaki �rne�i geni�letiyoruz ve ayr�nt�lara giriyoruz
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'  -- between and ba�lang�� ve biti�i dahil ediyor. E�er 1000 lira fiyatl� �r�n olsa ilk ko�ul oldu�u i�in ucuz olurdu
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then 'Pahal�'  -- T�rk�e karakter problemi var, k���k �'y� i olarak yaz�yor.
		 else 'Di�er'
    end as 'Segment'  -- as 'Segment' yazarak s�tuna ge�ici olarak isim vermi� oluyoruz.
from Production.Product

--Server Collation  ==> Turkish_CI_AS  --kurulumda sorar , hangi dilde olacak ise ona g�re se�eriz. B�ylece harf hatalar�n� ��zebiliriz.
	-- DB Collation  Latin_I_General_CI_AS  --bu alt collation server collation'� ezer, burdaki ne ise t�m sistemde o olur.
		-- Column Collation  -- altta olan �stte olan� ezer.

		--DB Collation Nas�l D�zeltilir??


--DB Collation yap�lm�� hali
select Name, Color, ListPrice, 
	case when ListPrice between 0 and 1000 then 'Ucuz'  -- between and ba�lang�� ve biti�i dahil ediyor. E�er 1000 lira fiyatl� �r�n olsa ilk ko�ul oldu�u i�in ucuz olurdu
		 when ListPrice between 1000 and 2000 then 'Orta'
		 when ListPrice > 2000 then N'Pahal�'  -- T�rk�e karakter problemi var, k���k �'y� i olarak yaz�yor. N koyarak t�rk karakterlerini kullanm�� oluruz.
		 else  N'Di�er' -- N yazarak t�rk�e karakterleri oldu�u gibi g�sterecektir. Problem ��z�ld�.
    end as 'Segment'  -- as 'Segment' yazarak s�tuna ge�ici olarak isim vermi� oluyoruz.
from Production.Product


/* �dev 2 ==> Renkleri yeni column da t�rk�e olarak g�sterin . 
Black olanlar siyah , Green olanlar ye�il vs. Yukardaki �rnekteki gibi yeni s�tun olu�turup yapacaz */