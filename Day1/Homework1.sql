select Name, ListPrice, Color,
	case when Color = 'Black' then 'Siyah'
	     when Color = 'Blue' then 'Mavi'
		 when Color = 'Grey' then 'Gri'
		 when Color = 'Multi' then 'Rengarenk'
		 when Color = 'Red' then N'Kýrmýzý'
		 when Color = 'Silver' then N'Gümüþ'
		 when Color = 'Silver/Black' then N'Gümüþ/Siyah'
		 when Color = 'White' then 'Beyaz'
		 when Color = 'Yellow' then N'Sarý'
		 when Color is NULL then N'Boþ'
		 else N'Diðer'
		 end as 'Renk'
from Production.Product
