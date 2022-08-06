select Name, ListPrice, Color,
	case when Color = 'Black' then 'Siyah'
	     when Color = 'Blue' then 'Mavi'
		 when Color = 'Grey' then 'Gri'
		 when Color = 'Multi' then 'Rengarenk'
		 when Color = 'Red' then N'K�rm�z�'
		 when Color = 'Silver' then N'G�m��'
		 when Color = 'Silver/Black' then N'G�m��/Siyah'
		 when Color = 'White' then 'Beyaz'
		 when Color = 'Yellow' then N'Sar�'
		 when Color is NULL then N'Bo�'
		 else N'Di�er'
		 end as 'Renk'
from Production.Product
