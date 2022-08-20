/*  STORED PROCEDURE   ( Procedure'ler daha hýzlý çalýþýr)
--------------------------
--her sql serverde örneðin  bir select çalýþtýrdýðýmýzda her defasýnda bu 5 aþama gerçekleþir

--procedure'ler parametere alabiliyor , hem kullanýcýdan input olarak alabiliyor hemde devoleper tarafýndan girilenbil

Query Execution Phases  ( bir kodu çalýþtýrýken yapýlan iþlem fazlarý)
----------------------
1- Syntax Check (Parsing)
2- Name Resolution (Binding)
3- Compile
4- Execution Plan   ( Kod yazarken hani joinleme yöntemini kullanýrsanýz kulannýn subquery olsun query olsun ne olursa olsun, bu fazda çalýþma planý çýkarmasý için 3 joinleme algoritmasý var en optimumumunu seçip kullanýr. Nasted Loop, Murt Join, Hashmatch Join)
5- Execute   ( seçilen plana göre kod çalýþýyor )



--Fakat procedure içinde çalýþtýrdýðýmýz zaman ilk 4 fazý gene bir kere çalýþtýrýr ve daha sonrasýnda ram'e (-->Buffer Pool (Plan Cache)) kaydedilir. Daha sonra çalýþtýrdýðýnýz zaman ilk 4 faz zaten yapýlmýþtý, sadece 5.faz olan execute fazý çalýþtýrýrlýr.
--Yaptýðýmýz iþlemi günde 10k,100k 1milyon kez yapýyorsanýz , procedure kullnmak size çok büyük bir performans iyileþtirmesi yapar.

*/



--Girilen bir ürünün fiyatýný  girilen tutar kadar güncelleyen  ve getiren bir sp(stored procedure) yazalým
-create procedure uspUrunFiyatGuncelle
(
@UrunID int,
@Tutar decimal(18,2)
)
as
begin
	update Production.Product
	set ListPrice = ListPrice + @Tutar
	where ProductID = @UrunID

	select Name, Color, ListPrice
	from Production.Product
	where ProductID = @UrunID
end

--procedure'ü kaydettikten sonra ulaþmak istersen programmability baþlýðý alrýndaki stored procedurslerde bulabiliriz


exec uspUrunFiyatGuncelle 1, 3333 --procedure'lerde parametreleri parantez içerisine deðil bir boþluk býrakýlarak yazýlýr. girilen tutar + veya - girebiliriz








/* TRIGGER
-------------------------
1- AFTER TRIGGER         
2- INSTEAD OF TRIGGER    - çok kullanýlmaz
(Oracle'de 3- BEFORE TRIGGER var)


			I(insert)		U(update)		D(delete)
inserted		o				o				X
deleted			X				o				o

-- X : yapýlamaz   , o : yapýlabilir
--inserted ve deleted sanal tablolardýr

*/

--tempdb, veri tabanýnda geçici iþlemlerin yapýldýðý yerdir. (system databeses baþlýðý altýnda)
--temprariy table, temp tablo diye birþey var , procedure'ler ile kullanýlabilir , derste hoca iþlemedi , sadece bahsi geçti, merak edersen araþtýr

--AFTER TRIGGER Örnek
--ürün tablosuna bir update yapýldýðý zaman modifieddate'de güncellensin

create trigger trg_TarihGuncelle   -- bu triggeri bir kere çalýþtýrdýk , sisteme kaydettik
on Production.Product
after update
as
begin
	update p
	set p.ModifiedDate = GETDATE()
	from Production.Product as p inner join inserted as i
	on p.productid = i.productid
end

--Kaydedilen triggerý çaçalýþýp çalýþmadýðýný test edelim, önce procedure ile update yaptýk, sonra tarihin deðiþip deðiþmediðine baktýk
select ProductID, Name, Color, ModifiedDate
from Production.Product



--


create trigger trg_LogicalDelete
on dbo.Musteri
instead of delete    -- anlamý þu, delete iþlemi yapýlmak isteniyorsa , delete yapma onun yerine git alttaki iþlemi yap
as
begin
	update m
	set AktifMi = 0
	from dbo.Musteri as m inner join deleted as d
	on m.MusteriID = d.MusteriID
end


--Deneyelim bakalým, 2 numaralý müsteriyi sil diyelim bakalým ne olacak, beklentimiz aktifmi kýsmýndaki deðerini pasife çekecek, fiziksel olarak silmiyor aktif pasif durumunu 0 a çekiyor
delete from dbo.Musteri where MusteriID =2

--kontrol edelim
select * from dbo.Musteri

--kontroldan sonra triggeri enable yapýp býraktýk, ilerde yazacaðýmýz kodlarda çalýþmasýn diye
-- trigger oluþturduðumuz tablonunsol tarafta yerine gidip açýyoruz, trigger lar kýsmýný açýp oradaki yazdýðýmýz trigger'ý aktifliðini kaldýrýyoruz ediyoruz






/*   CONSTRAINTS
----------------------------
1- Primary Key   --> Unique'liði saðlar. Tek bir kolon üzerinde yapýlýr.
2- Foreign Key   --> iliþkisel veri tutarlýlýðýný saðlýyor
3- Unique        --> Primary key'den baðýmsýz olarak diðer kolonlarý unique'leiþtirmek için kullanlýlýr(anladýðým kadarýyla) (mesela ayný mail adresi giriþi yapýlamasýn vs. ID hariþ uniqueliði mail adresleri üzerinden yapabiliyoruz böylece ayný mail adresi ile kayýt yapýlamýyor birden fazla defa)
4- Default
5- Check

*/

--Primary Key Not NULL'dýr. NULL olamazdý.  Fakat Unique coonstraints oluþturduðunuzda NULL olabilir fakat sadece 1 Tane NULL býrakýlabiliyor.
--Veri tabanýnda NULL'larý sevmeyiz. Çünkü veritabanýnda NULL'lar indexlenmiyor.

-- Verinin tutarlýlýðý açýsýndan olmazsa olmazlarýmýzdýrlar.
-- Validation hem uygulama katmanýnda hemde database'de  de yapýlabilir.Her iki tarafta yapmak daha doðru olur
-- Uygulama katmanýnda yapýlmasýnýn avantajlarý: Daha hýzlý response alýnýr. Çýkabilecek hatalarý daha erken tespit edilebilir. O yüzden herhakulade client tarafýnda bu validation'ý yapýn.
-- Database'de yapýlmasýnýn avantajlarý: Uygulama kullanmadan girilebilecek verilerin validation'ýný doðruluðunu ve tutarlýlýðýný konrol etmek için yapmalýyýz. 

select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail



-- AMAN AMAN AMAN SAKIN SAKIN SAKIN, BÝR SATIRIN ID'sini primary key veri tpini unique identifier yapmayýn. Ürettiði deðerler sequencial çýkmýyor, yani sýralý çýkmýyor. Veriyi diske rastgele yazacak random yazacak. Biz sýrayla ýd vermesini istediðimiz için kesinlikle ve kesinlikle Primary key'in veri tipini unique identifier yazmayýn.



create table dbo.Ogrenci
(
OgrenciID int primary key identity,
AdSoyad nvarchar(100) not null,
TCKN  char(11) constraint CHK_TCKN check (LEN(TCKN)=11) not null, --TCKN stringinin uzunluðu 11 hane olmak zorunda    --Eðer baþýna 0 tutma gibi bir durum var ise metinsel olarak tutmak daha tavsiye edilir. 
Email varchar(256) unique,
KayitTarihi datetime constraint DF_KTarihi DEFAULT (GETDATE()), -- sisteme kayýt tarihi girilmezse default olarak getdate alýnarak tarih yazýlsýn
Sinif varchar(10) constraint CHK_Sinif check (Sinif like '[1-9]-[A-K]')  -- Sýnýf yazarken 1den 9a kadar bir sayý olacak ve tire olacak daha sonrasýnda a dan k ya kadar bir harf olacak
)



insert into dbo.Ogrenci(AdSoyad, Email, KayitTarihi, Sinif, TCKN)
values('Velit Toparlý', 'velittoparli@outlook.com', '2021-01-01', '1-A', '12345678901')

select * from dbo.Ogrenci
-- Sorgularken Küçük büyük harf duyarlýlýðýný ayarlamak için case_sensitive'i ayarlamak gerekiyor.


insert into dbo.Ogrenci(AdSoyad, Email, KayitTarihi, Sinif, TCKN)
values('Velit Toparlý', 'velittoparli@outlook.com', '2021-01-01', '1-A', '12345678901')

alter table	dbo.Ogrenci
add constraint UQ_TCKN UNIQUE(TCKN)