
--A.  Calculate profit by house type
select HT.HouseTypeName, sum(S.Price - HS.Price)
from HOUSETYPE HT join HOUSEFORSALE HS on HT.HouseTypeName = HS.HouseType
				  join SALE S on S.HouseID = HS.HouseID
Where s.HouseID = HS.HouseID
Group by ht.HouseTypeName

--B.	Show customers who sold through the company's services and bought another house at a price higher than the sale price. 
Select C.FirstName, c.LastName, c.TZ
from Sale S join HOUSEFORSALE HS on S.HouseID = HS.HouseID
			join Client c on C.TZ = HS.ClientTZ
where (select min(sale.Price) from sale where ClientTZ = C.TZ) > 
		(select max(sale.price) 
		from sale join HOUSEFORSALE on sale.HouseID = HOUSEFORSALE.HouseID 
		where HOUSEFORSALE.ClientTZ = c.TZ)

		-- C. C.	What is the most prestigious neighborhood? Show the name of the neighborhood and the name of the city where the average prices of homes sold are the most expensive. 
Select c.Name, n.NeighborhoodName, AVG(S.Price)
from CITY C join NEIGHBORHOOD N on N.cityname = C.Name
join HOUSEFORSALE H on h.NeighborhoodID = n.NeighborhoodID
join SALE S on S.HouseID = H.HouseID 
Group by c.Name, n.NeighborhoodName
having AVG(S.Price) = (select top 1 AVG(S.Price)
	from CITY C join NEIGHBORHOOD N on N.cityname = C.Name
	join HOUSEFORSALE H on h.NeighborhoodID = n.NeighborhoodID
	join SALE S on S.HouseID = H.HouseID 
	Group by c.Name, n.NeighborhoodName
	order by AVG(S.Price) desc )

		-- D. best deller per year
SELECT top 1(
select CONCAT(e.FirstName ,'  ',e.LastName)
from sale S join HOUSEFORSALE H on S.HouseID = h.HouseID
join SALESMAN SM on SM.LicenseNumber = S.SalesmanLicenseNumber
join Employee e on e.TZ = sm.EmployeeTZ
where year(s.TransactionDate) = 2015 
group by e.FirstName ,e.LastName
having max(S.Price - H.Price) = 
					(select top 1 max(Sa.Price - Ho.Price) 'Profit'
					from sale Sa join HOUSEFORSALE Ho on Sa.HouseID = Ho.HouseID
					join SALESMAN SMa on SMa.LicenseNumber = Sa.SalesmanLicenseNumber
					join Employee emp on emp.TZ = SMa.EmployeeTZ
					where year(Sa.TransactionDate) = 2015 
					order by Profit desc))'2015',

(select CONCAT(e.FirstName ,'  ',e.LastName)
from sale S join HOUSEFORSALE H on S.HouseID = h.HouseID
join SALESMAN SM on SM.LicenseNumber = S.SalesmanLicenseNumber
join Employee e on e.TZ = sm.EmployeeTZ
where year(s.TransactionDate) = 2016
group by e.FirstName ,e.LastName
having max(S.Price - H.Price) = 
					(select top 1 max(Sa.Price - Ho.Price) 'Profit'
					from sale Sa join HOUSEFORSALE Ho on Sa.HouseID = Ho.HouseID
					join SALESMAN SMa on SMa.LicenseNumber = Sa.SalesmanLicenseNumber
					join Employee emp on emp.TZ = SMa.EmployeeTZ
					where year(Sa.TransactionDate) = 2016 
					order by Profit desc))'2016',
					
 (select CONCAT(e.FirstName ,'  ',e.LastName)
from sale S join HOUSEFORSALE H on S.HouseID = h.HouseID
join SALESMAN SM on SM.LicenseNumber = S.SalesmanLicenseNumber
join Employee e on e.TZ = sm.EmployeeTZ
where year(s.TransactionDate) = 2017 
group by e.FirstName ,e.LastName
having max(S.Price - H.Price) = 
					(select top 1 max(Sa.Price - Ho.Price) 'Profit'
					from sale Sa join HOUSEFORSALE Ho on Sa.HouseID = Ho.HouseID
					join SALESMAN SMa on SMa.LicenseNumber = Sa.SalesmanLicenseNumber
					join Employee emp on emp.TZ = SMa.EmployeeTZ
					where year(Sa.TransactionDate) = 2017
					order by Profit desc)) '2017',

(select CONCAT(e.FirstName ,'  ',e.LastName)
from sale S join HOUSEFORSALE H on S.HouseID = h.HouseID
join SALESMAN SM on SM.LicenseNumber = S.SalesmanLicenseNumber
join Employee e on e.TZ = sm.EmployeeTZ
where year(s.TransactionDate) = 2018
group by e.FirstName ,e.LastName
having max(S.Price - H.Price) = 
					(select top 1 max(Sa.Price - Ho.Price) 'Profit'
					from sale Sa join HOUSEFORSALE Ho on Sa.HouseID = Ho.HouseID
					join SALESMAN SMa on SMa.LicenseNumber = Sa.SalesmanLicenseNumber
					join Employee emp on emp.TZ = SMa.EmployeeTZ
					where year(Sa.TransactionDate) = 2018
					order by Profit desc)) '2018'

FROM  sale S join HOUSEFORSALE H on S.HouseID = h.HouseID
join SALESMAN SM on SM.LicenseNumber = S.SalesmanLicenseNumber
join Employee e on e.TZ = sm.EmployeeTZ
 

-- E.) Offer a new and more spacious home to a customer who has purchased a home through the company's services two years ago or more in the same city in which he lives (more space means more rooms
 
  
SELECT DISTINCT C.FirstName, c.LastName, C.TZ, 
			'House_ID_Offered' = (Select top 1 HS.HouseID From HOUSEFORSALE HS join NEIGHBORHOOD on NEIGHBORHOOD.NeighborhoodID = HS.NeighborhoodID
														  join City Ci on Ci.Name = NEIGHBORHOOD.cityname
			where (HS.Surface > H.Surface Or HS.RoomsNumber > H.RoomsNumber) and cit.Name = ci.Name) 
FROM Sale S join Client C on S.ClientTZ = c.TZ
			join HOUSEFORSALE h on h.HouseID = s.HouseID 
			join NEIGHBORHOOD N on N.NeighborhoodID = h.NeighborhoodID
			join city cit on cit.Name = n.cityname
where DATEDIFF( day, S.TransactionDate, GETDATE()) > 365*2 and 
				(Select top 1 HS.HouseID From HOUSEFORSALE HS join NEIGHBORHOOD on NEIGHBORHOOD.NeighborhoodID = HS.NeighborhoodID
															  join City Ci on Ci.Name = NEIGHBORHOOD.cityname
				 where (HS.Surface > H.Surface Or HS.RoomsNumber > H.RoomsNumber) and cit.Name = ci.Name) is not null
Group by C.FirstName, c.LastName, H.Surface , H.RoomsNumber, cit.Name, C.TZ


