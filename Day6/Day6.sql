


--Full Backup , *.mdf ve *.ndf dosyalarýnýn loglarýný kalýcý olarak kayýt altýna tutulur.  *.ldf dosyalarý tutulmaz.
--Transection log backup kullanarakta *.ldf dosyasýnýn verilerini kalýcý olarak kayýt altýna alýr.
--Tail log backup , en son noktaya (ana) kadar tüm baþarýlý kayýtlarýn backup al demek,

--db'in modelini, full recovery model yaparsanýz, belirli aralýklarla transection log backup alýnmalýdýr, log back up almazsanýz ldf dosyasý büyüdükçe büyüdükçe büyür , db'den daha fazla bile olabilir


--ilk 50 secion ( seþýn) db'nin kendine ayýrdýðý (rezerve) numarlardýr. 50den sonra yeni secionlar açýlýr kullanýcýlar için

BEGIN TRAN  -- Aþaðýdaki update iþlemini auto commit 'ten çýkar , ben commit (onayla) veya rollback(iptal) yapabileyim. Ben commit veya rollback yapana kadar bellekte bekleyecek ve üzerine kilit(lock) konulacak.
update Production.Product
set ListPrice = 8888
where ProductID = 1

--2 tane komut var iþlemi bitirmek için, commit yada rollback var.
--Bu iki komuttan birini kullanýp iþlemi bitirmezsem, diðer secionlarda ( veya baþka kullanýcýlar) bu iþlem bitene kadar bu veriye ulaþamayacakbeklemeye alýnacak
COMMIT    -- Yaptýðým update'i onaylýyorum , iþlem baþarýyla gerçekleþsin.
ROLLBACK  -- Yaptýðým update'i iptal etmek istiyorum. Veriyi eski haline geri döndür.


-- Veri tabaný yöneticisi, baþlatýlan bir iþlem yüzünden diðer iþlemlerin bekletilmesi vs olaylarýný önlemek için, activity monitör kullanarak sizin baþlattýðýnýz ve bitirmediðiniz uzun süredir onay veya iptal bekleyen iþlemi kill komutu ile bitirebilir. Veri siizn yaptýðýnýz iþlemden etkilenemden eski haline dönüþtürülüp kaydedilir.


--TAVSÝYE : AUTO commit ile yapýalbilecekleri autocommit ile yapýn, herþeyi begin trans ile yapmayýn



select *
from Production.Product --(nolock)  --> READ UNCOMMITED ile ayný
where ProductID = 1




/* TRANSECTION ISOLATION LEVEL
---------------------------------
1- READ UNCOMMITED				    --> Deðüiþiklik yaptýðým fakat daha onaylamadýðým veriyi (bellekte onay veya iptal bekleyen) oku  , Tutarlýlýk sorunu olabilir. Tutarsýs olabilir. Kilitten etkilenmiyor verileri alýrken, bekletmiyor ama veri tutarlýlýðý riski var. [WITH NO LOCK demek ile aynýdýr, nolock demek sadece o sorguynun isolation levelini deðiþtirir tüm secitionýn deðil)
2- READ COMMITED    (DEFAULT MODE)  --> Onaylanmýþ, commit edilmiþ veriyi okut
3- REPEATABLE READ
4- SERILIZABLE   --> Kolay kolay kullanýlmaz. Çok sýký kurallarý var. Herkes birbirini kitliyebiliyor. DeathLock dediðimiz olay ile karþýlaþabiliyoruz..
--Sýrayla yapýlmýþ bir sýralamadýr. Numara arttýkça kilit sayýsý artar, bekletme süreleri artabilir. tutarlýlýk artar.
(SNAPSHOT ISOLATION LEVEL baþlýðýný araþtýrmak istersen bak. Derstte deðinmedik)  -- tempdb ile çalýþýr. Sistemimize yük bindirir çok fazla kullanýlmasý tavsiye edilmez.
*/

-- SAÐ TIK --> QUERY OPTIONS --> ADVANCED --> TRANSECTION ISOLATION LEVEL' den deðiþtirebiliriz 

--DeathLock manager , eðer deathlock meydanaa gelirse bir iþlemi kurban olarak seçip kill eder.







/* INDEXES - PERFORMANCE TUNING - TIPS
-------------------------------------------------------------
Clustered Index        --> Sadece 1 tane olabilir. Static olmalý. Short(az yer tutmalý, büyük olmamalý, çok fazla yer kaplamayacak) olmalý. Mümkünse sýraya göre gitmeli(sýralý:incremental). ÖZellikle aksini belirtmedikçe, primary key oluþturduðunuz zaman, otomatikmen oraya clustered index oluþturulur.
							--Bir veriye en kýsa sürede ulaþmanýn yolu, clustered index üzerinden yapýlan aramadýr
Non-clustered Index    -->  Birden fazla olabilir. 999 limiti var yaklaþýk.

Fark: clustered ýndex leef katmanýnda direk isimelr var A-Z'ye kadar, non-clustered index'te leef level'ýnda üzerinde index oluþturduðunuz kolon deðer , clustering key , 'Abdullah altýntaþýn kitaplarýnýn tutulduðu ID key bulunur'
Fark: non-clustered , clustered'a göre biraz daha yavaþ , fakat tüm tabloyu okumaktan çok daha iyidir
Her oluþturduðunuz non-clustered index, extradan index (tablo) boyutu kadar diskte yer tutar  ( veritabanýnýn boyutunu arttýr, çok fazla yer tutabilir)
3 tane kolonu ayrý ayrý indexlemektense (non-clustered) birleþtirip tek bir indexlemek daha iyi olabilir
composit kolonlarda selectivity , seçicilik oranýna göre, hangisi daha seçici ise hangisi daha mantýklý ise ilk önce o yazýlýr.

--WHERE ile filtreleme iþlemi yaparken, indexleme yapmak tavsiye edilir ( filtrelediðimiz kolonlara indexleme yapmanýz tavsiye edilir)
-- Kolonda fonksiyonu ve filtrelemyi yalýn kullanýn ( ayný satýrda yazýlýyor), öyle tavsiye edilir. Yani fonksiyon içerisinde sorgu yapmaktansa , yalýn bir þekilde manuel olarak o fonksiyona denke gelen bir sorgu yazsak  best practice budur.en iyi performansý o verir. ama illa fonksiyon kullanmak gerekiyorsa yapacak birþey yok fonksiyon kullanýrýz , performanstan biraz kayýp olur ama baþka yol yok ise kullanabiliriz.
--Group by ile yapýlan sorgulamalar kolonlarýný indexleyebiliriz
-- Joinleme yapýlacak kolonlarýn üzerinde de index'leme yapabiliriz. Daha hýzlý sonuçlanýr
-- Indexler bozulabilirler, bakýma ihtiyaç vardýr. Fregmantasyon iþlemleri oldukça, indexlerde etkileneceði için , indexler zarar alabiliyor.
-- Page Split

Scan --> Tablodan bütün baþtan sona taranmasý
Seek --> Indeks üzerinden arama yaparak yapýlan iþlem

*/

--like 'ý kullanýrken büyük mertebe '' týrnak içinin ilk (en baþta % veya _ ile deðil de normal harf veya sayý vs ne ise artýk ile )) harfini yazmaya çalýþýn eðer sorgunuza uygun ise.

--fill factor: indexlerin doluluk oraný. Bakým yapmnýn alternatif yöntmlerinden biri. Önlem amaçlý doluluk oranýný %100 yapmaktansa %80 yapabliriz. Böylece her page için %80 doldurur %20 boþluk olur. Böylece page'ler arasýdna otomatikmen boþluklar (Leaf levellarda) oluþmuþ olur. Bu oran iþlemden iþleme tablodan tabloya verimden verime deðiþir tabiki. %80 örnek bir oran olarak verildi burda.

--Pad Index: fill factor ile beraber verilen bir ayardýr.  Sadece leaf indexte diðer tüm levellerde boþluk býrkama ayarýdýr.

--look up , maliyetli bir iþtir, non-clustereed indexten alýnan clustered id nin sorgusunu yapýp ana bilgileri alamk için kullanýlýyor.

--non-clustring index'in leaf level'inden birden fazlaindex sorgusu yapmak içn include komutu ile getirebiliriz. index'in boyutunu arttýrýyor fakat beni sürekli look up yapmaktan kurtarýyor.

--SQL Server maintanance plan diye arat , ilgili dökümanlarý bulabilirsin


--Aþaðýdaki tüm örneklerde, çalýþma planýna baktýk. ( Display Estimared Execution Plan ctrl+L)

select *
from Production.Product
where ProductID = 1


select Name
from Production.Product
where Name like 'W%'

select Name, ProductID
from Production.Product
where Name like 'W%'

--7 defa look up yaptý ilk planda
--ilk önce planýna baktýk, look up yapýyordu include yapmadan,daha sonra -color'ý included coloumn'a ekledik sonra plana baktýk, look up apmadan sorguyu yaptý.
select Name, ProductID, Color  -- colorlar bulmak için look up yapmak zorunda kalacak, performansý olumsuz etkileyecek. 7 kere look up yapar bu sorguda
from Production.Product			-- Daha sonra look up yapmasýný kaldýrmak için index propertiye girip , included coloumn'a color add yapýyorum , böylece look up yapmadan sorguyu yapmýþ oluyoruz. Include yapmýþ olduk yani anladýðým kadarýyla.
where Name like 'W%'

select Name, ProductID, Color -- 52 defa look up yapacaðýna , look up yapmaktan vazgeçer yapmaz,  clustering yapar. look up maliyeti çok fazla olacaðýndan doalyý sistem otomatikmen look up yapamdan iþlemi baþka bir yol ile gerçekleþtirir. anladýðým kadarýyla clustering ile
from Production.Product		  -- eðer look up maliyeti fazla olursa , look up yapmaz , sorguyu baþka yoldan yapar
where Name like 'R%'

--non-clustered index ile scan yapamadýðýnda, cluýstered full scan ile tüm tabloyu aradý.

select Name, ProductID, Color  -- bu þekilde seek deðil scan yapýyor. bunda filtrelerken fonksiyon ile hesapalmaya sokuðum için, yukarda ayný örneði like ile fonksiyon kullanmadan yapmýþtýk. Fonksiyonsuz olan bundan çok daha hýzlý çalýþýr.
from Production.Product
where LEFT(Name,1) = 'W'

--Sorgunun yazýlma þekli, developer'ýn sorumluluðundadýr. Çünkü yazýlýþ þekline bile göre performans deðiþebiliyor.


--GIGO : çöp verirsen çöp alýrsýn. ne kadar optimumum sorgu verirsen o kadar iyi sonuç alýrsýn

--performans tuning vs onlar için kitap önerileri : devoleper sql tuning vs diye araþtýrýð ayrýntýlý bilgi sahibi olamk istiyorsaýz öðrenebilir.