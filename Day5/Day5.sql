/*  STORED PROCEDURE   ( Procedure'ler daha h�zl� �al���r)
--------------------------
--her sql serverde �rne�in  bir select �al��t�rd���m�zda her defas�nda bu 5 a�ama ger�ekle�ir

--procedure'ler parametere alabiliyor , hem kullan�c�dan input olarak alabiliyor hemde devoleper taraf�ndan girilenbil

Query Execution Phases  ( bir kodu �al��t�r�ken yap�lan i�lem fazlar�)
----------------------
1- Syntax Check (Parsing)
2- Name Resolution (Binding)
3- Compile
4- Execution Plan   ( Kod yazarken hani joinleme y�ntemini kullan�rsan�z kulann�n subquery olsun query olsun ne olursa olsun, bu fazda �al��ma plan� ��karmas� i�in 3 joinleme algoritmas� var en optimumumunu se�ip kullan�r. Nasted Loop, Murt Join, Hashmatch Join)
5- Execute   ( se�ilen plana g�re kod �al���yor )



--Fakat procedure i�inde �al��t�rd���m�z zaman ilk 4 faz� gene bir kere �al��t�r�r ve daha sonras�nda ram'e (-->Buffer Pool (Plan Cache)) kaydedilir. Daha sonra �al��t�rd���n�z zaman ilk 4 faz zaten yap�lm��t�, sadece 5.faz olan execute faz� �al��t�r�rl�r.
--Yapt���m�z i�lemi g�nde 10k,100k 1milyon kez yap�yorsan�z , procedure kullnmak size �ok b�y�k bir performans iyile�tirmesi yapar.

*/



--Girilen bir �r�n�n fiyat�n�  girilen tutar kadar g�ncelleyen  ve getiren bir sp(stored procedure) yazal�m
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

--procedure'� kaydettikten sonra ula�mak istersen programmability ba�l��� alr�ndaki stored procedurslerde bulabiliriz


exec uspUrunFiyatGuncelle 1, 3333 --procedure'lerde parametreleri parantez i�erisine de�il bir bo�luk b�rak�larak yaz�l�r. girilen tutar + veya - girebiliriz








/* TRIGGER
-------------------------
1- AFTER TRIGGER         
2- INSTEAD OF TRIGGER    - �ok kullan�lmaz
(Oracle'de 3- BEFORE TRIGGER var)


			I(insert)		U(update)		D(delete)
inserted		o				o				X
deleted			X				o				o

-- X : yap�lamaz   , o : yap�labilir
--inserted ve deleted sanal tablolard�r

*/

--tempdb, veri taban�nda ge�ici i�lemlerin yap�ld��� yerdir. (system databeses ba�l��� alt�nda)
--temprariy table, temp tablo diye bir�ey var , procedure'ler ile kullan�labilir , derste hoca i�lemedi , sadece bahsi ge�ti, merak edersen ara�t�r

--AFTER TRIGGER �rnek
--�r�n tablosuna bir update yap�ld��� zaman modifieddate'de g�ncellensin

create trigger trg_TarihGuncelle   -- bu triggeri bir kere �al��t�rd�k , sisteme kaydettik
on Production.Product
after update
as
begin
	update p
	set p.ModifiedDate = GETDATE()
	from Production.Product as p inner join inserted as i
	on p.productid = i.productid
end

--Kaydedilen trigger� �a�al���p �al��mad���n� test edelim, �nce procedure ile update yapt�k, sonra tarihin de�i�ip de�i�medi�ine bakt�k
select ProductID, Name, Color, ModifiedDate
from Production.Product



--


create trigger trg_LogicalDelete
on dbo.Musteri
instead of delete    -- anlam� �u, delete i�lemi yap�lmak isteniyorsa , delete yapma onun yerine git alttaki i�lemi yap
as
begin
	update m
	set AktifMi = 0
	from dbo.Musteri as m inner join deleted as d
	on m.MusteriID = d.MusteriID
end


--Deneyelim bakal�m, 2 numaral� m�steriyi sil diyelim bakal�m ne olacak, beklentimiz aktifmi k�sm�ndaki de�erini pasife �ekecek, fiziksel olarak silmiyor aktif pasif durumunu 0 a �ekiyor
delete from dbo.Musteri where MusteriID =2

--kontrol edelim
select * from dbo.Musteri

--kontroldan sonra triggeri enable yap�p b�rakt�k, ilerde yazaca��m�z kodlarda �al��mas�n diye
-- trigger olu�turdu�umuz tablonunsol tarafta yerine gidip a��yoruz, trigger lar k�sm�n� a��p oradaki yazd���m�z trigger'� aktifli�ini kald�r�yoruz ediyoruz






/*   CONSTRAINTS
----------------------------
1- Primary Key   --> Unique'li�i sa�lar. Tek bir kolon �zerinde yap�l�r.
2- Foreign Key   --> ili�kisel veri tutarl�l���n� sa�l�yor
3- Unique        --> Primary key'den ba��ms�z olarak di�er kolonlar� unique'lei�tirmek i�in kullanl�l�r(anlad���m kadar�yla) (mesela ayn� mail adresi giri�i yap�lamas�n vs. ID hari� uniqueli�i mail adresleri �zerinden yapabiliyoruz b�ylece ayn� mail adresi ile kay�t yap�lam�yor birden fazla defa)
4- Default
5- Check

*/

--Primary Key Not NULL'd�r. NULL olamazd�.  Fakat Unique coonstraints olu�turdu�unuzda NULL olabilir fakat sadece 1 Tane NULL b�rak�labiliyor.
--Veri taban�nda NULL'lar� sevmeyiz. ��nk� veritaban�nda NULL'lar indexlenmiyor.

-- Verinin tutarl�l��� a��s�ndan olmazsa olmazlar�m�zd�rlar.
-- Validation hem uygulama katman�nda hemde database'de  de yap�labilir.Her iki tarafta yapmak daha do�ru olur
-- Uygulama katman�nda yap�lmas�n�n avantajlar�: Daha h�zl� response al�n�r. ��kabilecek hatalar� daha erken tespit edilebilir. O y�zden herhakulade client taraf�nda bu validation'� yap�n.
-- Database'de yap�lmas�n�n avantajlar�: Uygulama kullanmadan girilebilecek verilerin validation'�n� do�rulu�unu ve tutarl�l���n� konrol etmek i�in yapmal�y�z. 

select * from Sales.SalesOrderHeader
select * from Sales.SalesOrderDetail



-- AMAN AMAN AMAN SAKIN SAKIN SAKIN, B�R SATIRIN ID'sini primary key veri tpini unique identifier yapmay�n. �retti�i de�erler sequencial ��km�yor, yani s�ral� ��km�yor. Veriyi diske rastgele yazacak random yazacak. Biz s�rayla �d vermesini istedi�imiz i�in kesinlikle ve kesinlikle Primary key'in veri tipini unique identifier yazmay�n.



create table dbo.Ogrenci
(
OgrenciID int primary key identity,
AdSoyad nvarchar(100) not null,
TCKN  char(11) constraint CHK_TCKN check (LEN(TCKN)=11) not null, --TCKN stringinin uzunlu�u 11 hane olmak zorunda    --E�er ba��na 0 tutma gibi bir durum var ise metinsel olarak tutmak daha tavsiye edilir. 
Email varchar(256) unique,
KayitTarihi datetime constraint DF_KTarihi DEFAULT (GETDATE()), -- sisteme kay�t tarihi girilmezse default olarak getdate al�narak tarih yaz�ls�n
Sinif varchar(10) constraint CHK_Sinif check (Sinif like '[1-9]-[A-K]')  -- S�n�f yazarken 1den 9a kadar bir say� olacak ve tire olacak daha sonras�nda a dan k ya kadar bir harf olacak
)



insert into dbo.Ogrenci(AdSoyad, Email, KayitTarihi, Sinif, TCKN)
values('Velit Toparl�', 'velittoparli@outlook.com', '2021-01-01', '1-A', '12345678901')

select * from dbo.Ogrenci
-- Sorgularken K���k b�y�k harf duyarl�l���n� ayarlamak i�in case_sensitive'i ayarlamak gerekiyor.


insert into dbo.Ogrenci(AdSoyad, Email, KayitTarihi, Sinif, TCKN)
values('Velit Toparl�', 'velittoparli@outlook.com', '2021-01-01', '1-A', '12345678901')

alter table	dbo.Ogrenci
add constraint UQ_TCKN UNIQUE(TCKN)