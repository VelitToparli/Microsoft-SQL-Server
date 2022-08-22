


--Full Backup , *.mdf ve *.ndf dosyalar�n�n loglar�n� kal�c� olarak kay�t alt�na tutulur.  *.ldf dosyalar� tutulmaz.
--Transection log backup kullanarakta *.ldf dosyas�n�n verilerini kal�c� olarak kay�t alt�na al�r.
--Tail log backup , en son noktaya (ana) kadar t�m ba�ar�l� kay�tlar�n backup al demek,

--db'in modelini, full recovery model yaparsan�z, belirli aral�klarla transection log backup al�nmal�d�r, log back up almazsan�z ldf dosyas� b�y�d�k�e b�y�d�k�e b�y�r , db'den daha fazla bile olabilir


--ilk 50 secion ( se��n) db'nin kendine ay�rd��� (rezerve) numarlard�r. 50den sonra yeni secionlar a��l�r kullan�c�lar i�in

BEGIN TRAN  -- A�a��daki update i�lemini auto commit 'ten ��kar , ben commit (onayla) veya rollback(iptal) yapabileyim. Ben commit veya rollback yapana kadar bellekte bekleyecek ve �zerine kilit(lock) konulacak.
update Production.Product
set ListPrice = 8888
where ProductID = 1

--2 tane komut var i�lemi bitirmek i�in, commit yada rollback var.
--Bu iki komuttan birini kullan�p i�lemi bitirmezsem, di�er secionlarda ( veya ba�ka kullan�c�lar) bu i�lem bitene kadar bu veriye ula�amayacakbeklemeye al�nacak
COMMIT    -- Yapt���m update'i onayl�yorum , i�lem ba�ar�yla ger�ekle�sin.
ROLLBACK  -- Yapt���m update'i iptal etmek istiyorum. Veriyi eski haline geri d�nd�r.


-- Veri taban� y�neticisi, ba�lat�lan bir i�lem y�z�nden di�er i�lemlerin bekletilmesi vs olaylar�n� �nlemek i�in, activity monit�r kullanarak sizin ba�latt���n�z ve bitirmedi�iniz uzun s�redir onay veya iptal bekleyen i�lemi kill komutu ile bitirebilir. Veri siizn yapt���n�z i�lemden etkilenemden eski haline d�n��t�r�l�p kaydedilir.


--TAVS�YE : AUTO commit ile yap�albilecekleri autocommit ile yap�n, her�eyi begin trans ile yapmay�n



select *
from Production.Product --(nolock)  --> READ UNCOMMITED ile ayn�
where ProductID = 1




/* TRANSECTION ISOLATION LEVEL
---------------------------------
1- READ UNCOMMITED				    --> De��i�iklik yapt���m fakat daha onaylamad���m veriyi (bellekte onay veya iptal bekleyen) oku  , Tutarl�l�k sorunu olabilir. Tutars�s olabilir. Kilitten etkilenmiyor verileri al�rken, bekletmiyor ama veri tutarl�l��� riski var. [WITH NO LOCK demek ile ayn�d�r, nolock demek sadece o sorguynun isolation levelini de�i�tirir t�m secition�n de�il)
2- READ COMMITED    (DEFAULT MODE)  --> Onaylanm��, commit edilmi� veriyi okut
3- REPEATABLE READ
4- SERILIZABLE   --> Kolay kolay kullan�lmaz. �ok s�k� kurallar� var. Herkes birbirini kitliyebiliyor. DeathLock dedi�imiz olay ile kar��la�abiliyoruz..
--S�rayla yap�lm�� bir s�ralamad�r. Numara artt�k�a kilit say�s� artar, bekletme s�releri artabilir. tutarl�l�k artar.
(SNAPSHOT ISOLATION LEVEL ba�l���n� ara�t�rmak istersen bak. Derstte de�inmedik)  -- tempdb ile �al���r. Sistemimize y�k bindirir �ok fazla kullan�lmas� tavsiye edilmez.
*/

-- SA� TIK --> QUERY OPTIONS --> ADVANCED --> TRANSECTION ISOLATION LEVEL' den de�i�tirebiliriz 

--DeathLock manager , e�er deathlock meydanaa gelirse bir i�lemi kurban olarak se�ip kill eder.







/* INDEXES - PERFORMANCE TUNING - TIPS
-------------------------------------------------------------
Clustered Index        --> Sadece 1 tane olabilir. Static olmal�. Short(az yer tutmal�, b�y�k olmamal�, �ok fazla yer kaplamayacak) olmal�. M�mk�nse s�raya g�re gitmeli(s�ral�:incremental). �Zellikle aksini belirtmedik�e, primary key olu�turdu�unuz zaman, otomatikmen oraya clustered index olu�turulur.
							--Bir veriye en k�sa s�rede ula�man�n yolu, clustered index �zerinden yap�lan aramad�r
Non-clustered Index    -->  Birden fazla olabilir. 999 limiti var yakla��k.

Fark: clustered �ndex leef katman�nda direk isimelr var A-Z'ye kadar, non-clustered index'te leef level'�nda �zerinde index olu�turdu�unuz kolon de�er , clustering key , 'Abdullah alt�nta��n kitaplar�n�n tutuldu�u ID key bulunur'
Fark: non-clustered , clustered'a g�re biraz daha yava� , fakat t�m tabloyu okumaktan �ok daha iyidir
Her olu�turdu�unuz non-clustered index, extradan index (tablo) boyutu kadar diskte yer tutar  ( veritaban�n�n boyutunu artt�r, �ok fazla yer tutabilir)
3 tane kolonu ayr� ayr� indexlemektense (non-clustered) birle�tirip tek bir indexlemek daha iyi olabilir
composit kolonlarda selectivity , se�icilik oran�na g�re, hangisi daha se�ici ise hangisi daha mant�kl� ise ilk �nce o yaz�l�r.

--WHERE ile filtreleme i�lemi yaparken, indexleme yapmak tavsiye edilir ( filtreledi�imiz kolonlara indexleme yapman�z tavsiye edilir)
-- Kolonda fonksiyonu ve filtrelemyi yal�n kullan�n ( ayn� sat�rda yaz�l�yor), �yle tavsiye edilir. Yani fonksiyon i�erisinde sorgu yapmaktansa , yal�n bir �ekilde manuel olarak o fonksiyona denke gelen bir sorgu yazsak  best practice budur.en iyi performans� o verir. ama illa fonksiyon kullanmak gerekiyorsa yapacak bir�ey yok fonksiyon kullan�r�z , performanstan biraz kay�p olur ama ba�ka yol yok ise kullanabiliriz.
--Group by ile yap�lan sorgulamalar kolonlar�n� indexleyebiliriz
-- Joinleme yap�lacak kolonlar�n �zerinde de index'leme yapabiliriz. Daha h�zl� sonu�lan�r
-- Indexler bozulabilirler, bak�ma ihtiya� vard�r. Fregmantasyon i�lemleri olduk�a, indexlerde etkilenece�i i�in , indexler zarar alabiliyor.
-- Page Split

Scan --> Tablodan b�t�n ba�tan sona taranmas�
Seek --> Indeks �zerinden arama yaparak yap�lan i�lem

*/

--like '� kullan�rken b�y�k mertebe '' t�rnak i�inin ilk (en ba�ta % veya _ ile de�il de normal harf veya say� vs ne ise art�k ile )) harfini yazmaya �al���n e�er sorgunuza uygun ise.

--fill factor: indexlerin doluluk oran�. Bak�m yapmn�n alternatif y�ntmlerinden biri. �nlem ama�l� doluluk oran�n� %100 yapmaktansa %80 yapabliriz. B�ylece her page i�in %80 doldurur %20 bo�luk olur. B�ylece page'ler aras�dna otomatikmen bo�luklar (Leaf levellarda) olu�mu� olur. Bu oran i�lemden i�leme tablodan tabloya verimden verime de�i�ir tabiki. %80 �rnek bir oran olarak verildi burda.

--Pad Index: fill factor ile beraber verilen bir ayard�r.  Sadece leaf indexte di�er t�m levellerde bo�luk b�rkama ayar�d�r.

--look up , maliyetli bir i�tir, non-clustereed indexten al�nan clustered id nin sorgusunu yap�p ana bilgileri alamk i�in kullan�l�yor.

--non-clustring index'in leaf level'inden birden fazlaindex sorgusu yapmak i�n include komutu ile getirebiliriz. index'in boyutunu artt�r�yor fakat beni s�rekli look up yapmaktan kurtar�yor.

--SQL Server maintanance plan diye arat , ilgili d�k�manlar� bulabilirsin


--A�a��daki t�m �rneklerde, �al��ma plan�na bakt�k. ( Display Estimared Execution Plan ctrl+L)

select *
from Production.Product
where ProductID = 1


select Name
from Production.Product
where Name like 'W%'

select Name, ProductID
from Production.Product
where Name like 'W%'

--7 defa look up yapt� ilk planda
--ilk �nce plan�na bakt�k, look up yap�yordu include yapmadan,daha sonra -color'� included coloumn'a ekledik sonra plana bakt�k, look up apmadan sorguyu yapt�.
select Name, ProductID, Color  -- colorlar bulmak i�in look up yapmak zorunda kalacak, performans� olumsuz etkileyecek. 7 kere look up yapar bu sorguda
from Production.Product			-- Daha sonra look up yapmas�n� kald�rmak i�in index propertiye girip , included coloumn'a color add yap�yorum , b�ylece look up yapmadan sorguyu yapm�� oluyoruz. Include yapm�� olduk yani anlad���m kadar�yla.
where Name like 'W%'

select Name, ProductID, Color -- 52 defa look up yapaca��na , look up yapmaktan vazge�er yapmaz,  clustering yapar. look up maliyeti �ok fazla olaca��ndan doaly� sistem otomatikmen look up yapamdan i�lemi ba�ka bir yol ile ger�ekle�tirir. anlad���m kadar�yla clustering ile
from Production.Product		  -- e�er look up maliyeti fazla olursa , look up yapmaz , sorguyu ba�ka yoldan yapar
where Name like 'R%'

--non-clustered index ile scan yapamad���nda, clu�stered full scan ile t�m tabloyu arad�.

select Name, ProductID, Color  -- bu �ekilde seek de�il scan yap�yor. bunda filtrelerken fonksiyon ile hesapalmaya soku�um i�in, yukarda ayn� �rne�i like ile fonksiyon kullanmadan yapm��t�k. Fonksiyonsuz olan bundan �ok daha h�zl� �al���r.
from Production.Product
where LEFT(Name,1) = 'W'

--Sorgunun yaz�lma �ekli, developer'�n sorumlulu�undad�r. ��nk� yaz�l�� �ekline bile g�re performans de�i�ebiliyor.


--GIGO : ��p verirsen ��p al�rs�n. ne kadar optimumum sorgu verirsen o kadar iyi sonu� al�rs�n

--performans tuning vs onlar i�in kitap �nerileri : devoleper sql tuning vs diye ara�t�r�� ayr�nt�l� bilgi sahibi olamk istiyorsa�z ��renebilir.