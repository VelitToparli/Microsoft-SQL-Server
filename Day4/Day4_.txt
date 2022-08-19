select * from dbo.Musteri  -- Musteri tablosunu dün arayüz kullanarak kendimiz oluþturmuþtuk
----------------------

--Þimdi kod ile tablo oluþturacaz

create table dbo.Siparis 
(
SiparisID int primary key identity(1,1),  -- identity (1,1)  1'den baþalyýp !'er  arttýrarak id ver
Tutar decimal(18,2) not null ,  -- not null , sipariþ tutarý boþ geçilemesin (boþ býrakýlamasýn) anlamýna geliyor
SiparisTarihi datetime2,
MusteriID int foreign key references dbo.Musteri(MusteriID)  -- dbo.Musteri tablosundaki MusteriID ile iliþkilendirmek için foreign key kullandýk
)

--Sql server tablolarý kendi otomatik olarak güncellemez. Biz yeni tablo oluþturduktan sonra gidip tabloya sað týklayýp refresh yapmamýz gerekiyor


select * from dbo.Musteri
select * from dbo.Siparis

--CTRL+SPACE basarsan önerilenleri gösterir

--Var olan bir tabloya veri ekleme ( Kod ile)
insert into dbo.Siparis(SiparisTarihi, Tutar, MusteriID)
values (GETDATE(), 2500.55, 2)	--Eðer özellikle parantez içinde kolonlarý belirtmiþsem, deðerleri o sýraya göre girmek lazým. Boþ býraktýysak o tablonun kolon sýrasýna göre girmek lazým
--Hatalý giriþ yaparsak tabloya eklemez fakat o an ki siparisID yi kullanýr ve bir daha o ID'yi baþka bir sipariþe vermez.

insert into dbo.Siparis(SiparisTarihi, Tutar, MusteriID)
values ('2021-02-02', 734.45, 2),
		('2020-01-07', 6005.90, 1),
		('2016-09-12', 50.99, 2),
		('2019-08-09', 39999.99, 1)

--Veri Güncelleme ( Var olan bir veriyi düzeltmek , güncellemek vs.)
update dbo.Siparis
set Tutar = Tutar*1.1  --Tutarý %10 arttýr  
where SiparisID = 3    -- 3 numaralý siparisin bilgilerini günceller. Eðer where ile belirtmezsek gidip tablodaki tüm siparislerin tutarlarýný yüzde 10 arttýrýrdý. Bu çok tehlikelidir. O yüzden where kullanmadan çalýþtýrmak çok tehlikeli.


update dbo.Siparis
set Tutar = Tutar*1.1  --Tutarý %10 arttýr  
where Tutar > 1000  -- Tutar'ý 1000'den büyük olan bütün sipariþlerin tutarlarýný yüzde 10 arttýr

--Veri Silme 
delete from dbo.Siparis --delete from tablodan veri silmeye yarar ( tabloyu silmeye deðil)  -- eðer direk bu satýrý çalýþtýrsaydým, tablodaki bütün sipariþleri silerdi
where SiparisID = 4   -- 4 numaralý sipariþi sil, geri alma seçeneðimiz yok, ancak veriler depolandýysa back-up'larda oradan kurtarabiliriz

select * from dbo.Musteri


delete from dbo.Musteri  -- müþteri tablosundan müþteriID  silmek
where MusteriID = 2  -- 2 numaralý müþteri ayný zamanda sipariþ tablosunda olduðu için ve birbirleriyle foreign key ile baðlý (iliþkili) olduklarý için silme iþlemini gerçekleþtiremeyecek

--Silme iþlemleri eksik kaldý, elektrikler kesildi buaya kadar dinleyebildim..





/* TABLE EXPRESSIONS
---------------------------
1- Drived Table ( Bazý yerlerde subquery diye aslandýrýyorlar)
2- Common Table Expression (CTE)
3- View
4- Table Valued Function (TVF)

*/

--Drived Table

--Ucuz orta ve pahalý diye ayýrmak için kullandýðýmýz örneði getirdik. 
--Kaç tane ucuz, kaç tane orta ve kaç tane pahalý ürün var diye hesaplatmak için bunu kullanmamýz gerekiyor
--Sanal bir tablo haline getirmek istediðimiz , keþke sonuçlarý bir tablo olsaydýda bende sorgularýmý o tablo üzerinden yapmaya devam edebilseydim dediðimiz durumlarda kullanýlýr
--where den sonra parantez içinde baþka bir sorgu yazarsak subquery olur, ama from'dan sonra parantez içerisinde baþka bir sorgu yazarsak drived table olur farklarý budur
select Sagment,  COUNT(*) as Adet
from 
	(
	select Name, Color, ListPrice,
		case when ListPrice between 0 and 1000 then 'Ucuz'
			 when ListPrice between 1000 and 2000 then 'Orta'
			 when ListPrice > 2000 then N'Pahalý'
			 else N'Diðer'
		end as Sagment
	from Production.Product
	--order by ListPrice desc  burada order by'ý tek baþýna burada kullanmazsýn. Ya select içine top 5 felan diyip ondan sonra yazabiliriz. Ya da dýþarda order by yapýlabilir.
	) as tbl   -- Sanal geçici bir tablo olarak tbl oluþturduk, bu kalýcý deðildir geçicidir, sadece bu sorgu için geçerli bir tablo
group by Sagment
order by Adet desc  -- dediðim gibi, sýralamayý burada da yapabiliriz içerde yapmaktansa



--Common Table Expression (CTE)

--with ifadesinden itibaren birlikte tümünü seçip öyle çalýþtýrmak lazým çalýþmasý için
with tbldeneme
as 
	(
	select Name, Color, ListPrice,
		case when ListPrice between 0 and 1000 then 'Ucuz'
			when ListPrice between 1000 and 2000 then 'Orta'
			when ListPrice > 2000 then N'Pahalý'
			else N'Diðer'
		end as Sagment
	from Production.Product
	)
select Sagment, COUNT(*) as Adet
from tbldeneme			
group by Sagment

--Drived Table ve CTE temel olarak genelde ayný iþi yapar, sadece yazým þekilleri farklýdýr
--Derived Table ve CTE arasýn 2 fark var 
--1. recursive bir query (döngü halinde, sorgu) yapacaksanýz CTE ile yaparsýnýz
--2. drived tablede içteki sorguya vediðimiz isimi sadece fromun içerisinde kullanabiliyoruz, ama CTE'de bir kere sanal tabloyu oluþturduktan sonra ayný sorgu içerisinde defalarca sanal tablonun ismini kullanabilirsiniz.



--View

--Bir sorguyu geçici olarak deðil de kalýcý olarak deðiþtirmek için kullanýlýr. Kalýcýdýr. Kalýcý deðiþiklikler yapar
--View'lar oldukça yaygýn olarak klullanýlýr
--yazýlmýþ bir slect sorgusunu geçici olarak deðilde kalýcý olarak veri tabanýnda saklamak istiyorsanýz o zaman viewe'larý burada kullanabilirsiniz
--Mesela raporlama yapan, raporlama katmaný için çok kullanýlýr
--Kalýcý olarak iþletim sistemine de kaydedebiliriz onu sürekli getirir çalýþtýrýrýz fakat bu güvenli deðil ( Bu durumda database'e deðil iþletim sistemine kayýt olur sadece). Çünkü iþletim sistemine kaydolduðu için iþletim sistemine eriþim yapan her kullanýcý onu deðiþtirebilir, silebilir vs.  Veya har disk yanabilir , bu durumda silinir gider.
--Bu durumdan kaçýnmak için veri tabanýnýn içinde saklamak isterseniz view'u kullanabilirsiniz. Böylece bu tablo veri tabanýnda kaydedebilirz. Hem güvenliðini saðlamýþ oluruz bu þekilde.

create view  vwUrunSagment   -- Kalýcý bir nesne olacaðý için isim verirken mantýklý  açýk, anlaþýlabilecek bir isim vermek , diðerleri gibi kýsaltma olamsýn . Mesela bazý þirketler isim vermeden önce isimin önüne prefix koyailiiliyorlar ( mesela v... vw.. felan)
as
	select Name, Color, ListPrice,
		case when ListPrice between 0 and 1000 then 'Ucuz'
			when ListPrice between 1000 and 2000 then 'Orta'
			when ListPrice > 2000 then N'Pahalý'
			else N'Diðer'
		end as Sagment
	from Production.Product

--Bu þekilde kalýcý olarak kaydetmiþ oluyoruz ve artýk uygulama katmanýnda istediðimiz zaman kullanabiliyoruz bu sorguyu. Join lemek istediðimizde bu isimle çaðýrýp kullanabiliyoruz vs.
--View'lar veri deppolamaz , select sorgusunu tutar içinde, o yüzden performans'a küçük te olsa katkýsý var. Ama çok fazla bir performans saðlamaz raporlamada felan. Çok az bi performans katkýsý olur
select Sagment, COUNT(*) as Adet
from vwUrunSagment
group by Sagment


--Yetki nasýl verilir
-- grant SELECT  on vwUrunSagment to public  -- bu viewe üzerinde select yetkisini ( kime vermek istiyorsanýz artýk o user'ý veya rol'ü yazýp) public'e ver
--Aman ha TRIGER'LARI ÇOK FAZLA KULLANMAYI TERCÝH ETMEYÝN: ÇOK ÝHTÝYAÇ OLMAZ ÝSE KULLANMAYIN. PERFORMANS AÇISINDAN ÇOK BÜYÜK DEZAVANTAJ SAÐLAR. ÇOK CÝDDÝ OLLUMSUZ ETKÝLER PERFORMANSI
--TEMP DB performansý uygulamanýzýn bütün veri tabanýnýzýn performansýný etkiler. Minimal seviyelerde kullanýn

--View içerisindeki select sorgusunu güncellemek istiyoruz, deðiþtirmek istiyoruz, deðiþtirebiliyoruz

alter view vwUrunSagment
as
	select Name, Color, ListPrice,
		case when ListPrice between 0 and 1000 then 'Ucuz'
			when ListPrice between 1000 and 2000 then 'Orta'
			when ListPrice > 2000 then N'Pahalý'
			else N'Diðer'
		end as Sagment,Size   -- güncelleyip size kolonunuda ekledik 
	from Production.Product



select * from vwUrunSagment

--Var olan bir view 'un kodunu direk View tablosundan script view as diyerek çaðýrabiliriz. kodun içini görebiliriz
--view'larýn bir eksiði var. View'lar parametre alamýyorlar. SAbittir . Statiktir.
--index view diye bir view türüde var, normal view'lere farklý olarak veri de tutabiliyorlar ama çok kullanýlmaz .Performansa çok etkisi var çok düþürür. Canlý ortamlarda tercih edilmez. Yapýlan her iþlem iki defa yapýlýr. bir kendi select üzerinde iþlem yapar ,, birde üstünde kaydettiði veri üzerinde de iþlem yapar. Böylece 2 defa iþlem yapmýþ olur performans kaybý olur. MErak ediyorsan araþtýr.





--Table Valued Function

--Tablo þeklinde deðer döndürür ( Sonucu tablodur). Skaler fonksiyon tek bir deðer döndüren fonksiyon demektir , fakat TVF tablo döndüren fonksiyondur.

/*

select   ......(scalar function)
from    .......(Table Valued Function)  --RVF from ifadesinden soonra kullanýlýr diðerlerinden farklý olarak. TAbi from diðer tüm functionlarý da çalýþtýrabilir
where    ......(scalar function)
group by ......(scalar function)
having   ......(scalar function)
order by ......(scalar function)
*/


--TVF'lar Select sorgusunu saklýyor , ayný view'ler gibi
--TVF'ler parametre alabiliyor , view'larda parametre alýnmýyordu


--Girilen renge sahip ürünleri döndüren bir TVF oluþturalým

create function fnRengeGoreUrunGetir  --þirketler genelde baþýna prefix koyar function isimlerine, tablolar ile karýþmasýn diye 
(
@Renk nvarchar(50)   --parametreler ve deðiþkenler oluþturulurken baþýna @ konur --max 50 karakterli olabilir renk
)
returns table
as
	return select Name, Color, ListPrice
		from Production.Product
		where Color = @Renk  -- kullanýcýnýn gireceði paramtre ren k ne ise onu döndür


----functionslar programmability (AdventureWorks2017 setinin alt baþlýðý) 'de depolanýr saklanýr.
--- SQL server'da functions'lar parametre almasa bile parantez açýp kapatmak lazým functionName() þeklinde. Parametresi var ise de parantez içerisinde yazýlýr.

--yazdýðýmýz fonksiyonu deneyelim
select *
from fnRengeGoreUrunGetir('Black')

--Önemli nokta:  Fonksiyonlar mümkün olduðunca az kullanýlmalý. Performansa olumsuz etki sunar. Böyle basit herþey için fonksiyon yazýlmamalý, nadiren çok ihtiyacýnýz olabilecek durumlarda yazýlmalý.



--Girilen müþterinin girilen adet kadar son sipariþlerini geri döndüren TVF yazýn
select * from Sales.SalesOrderHeader

create function fnSonSiparisleri
(
@Musteri int,
@Adet int
)
returns table
as
	return select top (@Adet) CustomerID, OrderDate, SubTotal
	from Sales.SalesOrderHeader
	where CustomerID = @Musteri
	order by OrderDate desc



-- MusteriID 'si 11019 olan kullanýcýnýn son 5 sipariþini getirelim
select *
from fnSonSiparisleri(11019,5) 


--Her müþterinin vermiþ olduðu son 3 adet sipariþ gelsin
select f.*    --sadece fonksiyonun getirdiði sonuçlarý göster
from Sales.Customer as c cross apply fnSonSiparisleri(c.CustomerID, 3) as f  --tablolar ile fonksiyonlar   cross apply    ile joinlenebiliyor
order by CustomerID asc
--Önemli:  19800 defa fnSonSiparisleri fonksiyonunu çalýþtýrmýþ oluor bu . O yüzden tavsiye edilmiyor

--Sýra numarasý üretmek
select Name, Color, ListPrice, 
	RANK()  OVER(order by listprice desc) as SiraNo,   -- RANK() fonksiyonu parametre almaz, analitik fonksiyondur, analitik fonksiyonlar over ile beraber yazýlýrlar . over olmadan çalýþmazlar
	DENSE_RANK()  OVER(order by listprice desc) as SiraNo2,  -- DENSE_RANK fonksiyonu numara üretirken gap býrakmaz
	Row_NUMBER()  OVER(order by listprice desc) as SiraNo3  -- Her satira numara verir, deðer ayný olsa bile
from Production.Product




--renge göre gruplatýp fiyata göre sýralattýk
select Name, Color, ListPrice,
	RANK() OVER(partition by color order by listprice desc) as Sirano,   --over komutunun içerisine group by yazýlamaz
	DENSE_RANK() OVER(partition by color order by listprice desc) as Sirano2,
	ROW_NUMBER() OVER(partition by color order by listprice desc) as Sirano3
from Production.Product



--Her bir müþterinin son 3 adet sipariþi fonksiyon kullanmadan
select *
from 
	(
	select CustomerID, OrderDate, SubTotal,
			ROW_NUMBER() OVER(partition by CustomerID order by OrderDate desc) as SiraNo 
	from Sales.SalesOrderHeader
	 ) as tbl
where SiraNo <= 3


--cross apply ile yaptýðýmýz çözüm ile row number üreterek yaptýðýmýz çözümün performanslarýný karþýlaþtýralým
--ayný sonucu elde ettiðimiz 2 farklý sorgularýn performanslarýný karþýlaþtýrmak için ilk önce alt alta yazýn
--Daha sonra bu 2 sorguyu birlikte seçip execute'un yanýndaki 'Display Estimated Execution Plan'a týklýyoruz. Orada 2 sorgunun da maliyetini görüp karþýlaþtýrabiliriz
-- Kullandýklarý kaynak miktarý  performansý belirliyor, ne kadar çok kaynak harcar ise o kadar çok
--Estimated Subtree cost'taki katsayýnýn birimi kullandýklarý kaynak miktarý ( ne kadar az ise o kadar yüskek performans verir, o kadar hýzlý çalýþýr)

select *
from 
	(
	select CustomerID, OrderDate, SubTotal,
			ROW_NUMBER() OVER(partition by CustomerID order by OrderDate desc) as SiraNo 
	from Sales.SalesOrderHeader
	 ) as tbl
where SiraNo <= 3


select f.*
from Sales.Customer as c cross apply fnSonSiparisleri(c.CustomerID ,3) as f
order by CustomerID asc