

--1. Show the first name, last name and telephone number for all the employees, except those who live in UK.
SELECT E.FirstName, E.LastName, E.HomePhone
FROM Employees E
WHERE e.Country IS Null OR e.Country != 'UK'


--2. Show all product details for products whose unit price is greater than $10 and quantity in stock greater than 2. Sort by product price.
SELECT *
FROM Products
WHERE UnitPrice > 10 and UnitsInStock >2
ORDER BY UnitPrice asc


--3. Show the first name, last name and telephone number for the employees who started working in the company in 1992-1993.
SELECT E.FirstName, E.LastName, E.HomePhone
FROM Employees E
WHERE year(e.HireDate) = 1992 or year(e.HireDate) = 1993


--4. Show the product name, Company name of the supplier and stock quantity of the products 
--that have 15 or more items in stock and the Product name starts with B or C or M.
SELECT p.ProductName, s.CompanyName, p.UnitsInStock
FROM Products P join  Suppliers S on p.SupplierID = s.SupplierID
WHERE p.UnitsInStock >= 15 and (p.ProductName like 'B%' or p.ProductName like 'C%' or p.ProductName like 'M%')


--5. Show all details for products whose Category Name is ' Meat/Poultry ' Or 'Dairy Products '. Sort them by product name.
SELECT *
FROM Products join Categories on Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = ' Meat/Poultry ' Or Categories.CategoryName ='Dairy Products '


--6. Show Category name, Product name and profit for each product (how much money the company will earn if they sell all the units in stock). Sort by the profit.
SELECT CategoryName, ProductName, 'profit' = UnitsInStock*UnitPrice
FROM Products join Categories on Products.CategoryID = Categories.CategoryID
ORDER BY profit desc


--7. Show the Employees' first name, last name and Category Name of the products which they have sold (show each category once).
SELECT E.FirstName, E.LastName, C.CategoryName
FROM Employees E join Orders O on E.EmployeeID = O.EmployeeID
				 join [Order Details] OD on OD.OrderID = O.OrderID
				 join Products P on P.ProductID = OD.ProductID
				 join Categories c ON C.CategoryID = p.CategoryID
GROUP BY E.FirstName, E.LastName, C.CategoryName


--8. Show the first name, last name, telephone number and date of birth for the employees who are aged older than 35. Order them by last name in descending order.
SELECT E.FirstName, E.LastName, E.HomePhone, e.BirthDate
FROM Employees E
WHERE year(GETDATE()) -  year(e.BirthDate) > 35
ORDER BY e.LastName desc


--9. Show each employee’s name, the product name for the products that he has sold and quantity that he has sold.
SELECT E.FirstName, E.LastName, p.ProductName, sum(OD.Quantity)
FROM Employees E join Orders O on E.EmployeeID = O.EmployeeID
				 join [Order Details] OD on OD.OrderID = O.OrderID
				 join Products P on P.ProductID = OD.ProductID
GROUP BY E.FirstName, E.LastName, p.ProductName


--10. Show for each order item – the customer name and order id, 
--product name, ordered quantity, product price and total price (Ordered quantity * product price) 
--and gap between ordered date and shipped date (the gap in days). Order by order id.
SELECT C.CompanyName, o.OrderID, P.ProductName, OD.Quantity, OD.UnitPrice, 'Total Price' = OD.Quantity * OD.UnitPrice, 'Shipping Delay' = DAY(O.ShippedDate) - DAY(O.OrderDate)
FROM Orders O join Customers C on O.CustomerID = c.CustomerID
			  join [Order Details] OD on OD.OrderID = O.OrderID
			  join Products P on P.ProductID = OD.ProductID
ORDER BY O.OrderID asc


--11. How much each customer paid for all the orders he had committed together?
SELECT C.CompanyName,'Total TurnOver' = sum(OD.Quantity * OD.UnitPrice)*(1-OD.Discount) 
FROM Orders O join Customers C on O.CustomerID = c.CustomerID
			  join [Order Details] OD on OD.OrderID = O.OrderID
GROUP BY C.CompanyName

--12. In which order numbers was the ordered quantity greater than 10% of the quantity in stock?
SELECT  o.OrderID, P.ProductName, OD.Quantity, P.UnitsInStock
FROM Orders O join [Order Details] OD on OD.OrderID = O.OrderID
			  join Products P on P.ProductID = OD.ProductID
WHERE OD.Quantity * 10 > (P.UnitsInStock + OD.Quantity)
ORDER BY O.OrderID asc


--13. Show how many Employees live in each country and their average age.
SELECT e.Country, count(*) 'Employee Number' , AVG(year(getdate()) - year(e.birthDate)) 'Old Average'
FROM Employees E
Group by e.Country


--14. What would be the discount for all the London customers (together), if after 5 days of gap between the order date and shipping date they get a 5% discount per item they bought?
SELECT sum(UnitPrice*Quantity*5/100) 'Discount'
FROM Orders O join Customers C on O.CustomerID = c.CustomerID
			  join [Order Details] OD on OD.OrderID = O.OrderID
where C.City ='LONDON' AND DATEDIFF(day,o.OrderDate,o.ShippedDate) > 5--DAY(O.ShippedDate) - DAY(O.OrderDate) > 5


--15. Show the product id, name, stock quantity, price and total value (product price * stock quantity) for products whose total bought quantity is greater than 500 items.
SELECT P.ProductID, p.ProductName, p.UnitsInStock , p.UnitPrice, 'Total Value' = p.UnitsInStock * p.UnitPrice 
FROM [Order Details] OD join Products P on P.ProductID = OD.ProductID
Group BY P.ProductID, p.ProductName, p.UnitsInStock , p.UnitPrice
Having sum(OD.Quantity) > 500


--16. For each employee display the total price paid on all of his orders that hasn’t shipped yet.  (Employee or Customer?)
SELECT e.FirstName,e.LastName, sum(OD.Quantity*OD.UnitPrice) 'Total Price'
FROM Orders O join [Order Details] OD on OD.OrderID = O.OrderID
			  join Employees E on E.EmployeeID = O.EmployeeID
WHERE datediff(day,getdate(),o.ShippedDate) > 0 OR o.ShippedDate is null
GROUP BY e.FirstName,e.LastName


--17. For each category display the total sales revenue, every year.
Create View V_CategorieSale1996 as
SELECT C.CategoryName, '1996 Sales' = round(sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)),2)
FROM Categories c join Products P on c.CategoryID = p.CategoryID
				  join [Order Details] OD on P.ProductID = OD.ProductID			
				  join Orders O on O.OrderID = OD.OrderID
Where year(O.OrderDate) = 1996
GRoup by C.CategoryName

Create View V_CategorieSale1997 as
SELECT C.CategoryName, '1997 Sales' = round(sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)),2)
FROM Categories c join Products P on c.CategoryID = p.CategoryID
				  join [Order Details] OD on P.ProductID = OD.ProductID			
				  join Orders O on O.OrderID = OD.OrderID
Where year(O.OrderDate) = 1997
GRoup by C.CategoryName


Create View V_CategorieSale1998 as
SELECT C.CategoryName, '1998 Sales' = round(sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)),2)
FROM Categories c join Products P on c.CategoryID = p.CategoryID
				  join [Order Details] OD on P.ProductID = OD.ProductID			
				  join Orders O on O.OrderID = OD.OrderID
Where year(O.OrderDate) = 1998
GRoup by C.CategoryName

Select six.CategoryName,six.[1996 Sales],seven.[1997 Sales],eight.[1998 Sales]
FROM V_CategorieSale1996 six join V_CategorieSale1997 seven on six.CategoryName = seven.CategoryName
							join V_CategorieSale1998 eight on eight.CategoryName = six.CategoryName



--18. Which Product is the most popular? (number of items)
SELECT P.ProductName
FROM [Order Details] OD join Products P on P.ProductID = OD.ProductID
Where OD.Quantity = (Select Max(Quantity) from [Order Details])


--19. Which Product is the most profitable? (income)
SELECT P.ProductName
FROM [Order Details] OD join Products P on P.ProductID = OD.ProductID
Where (Quantity*OD.UnitPrice*(1-Discount)) = (Select Max(Quantity*UnitPrice*(1-Discount)) from [Order Details])

--20. Display products that their price higher than the average price of their Category.
SELECT Distinct P.ProductName, P.UnitPrice, C.CategoryName, AveragePriceForCategorie = (Select avg(UnitPrice) from Products join Categories CAT on Products.CategoryID = CAT.CategoryID where C.CategoryID = CAT.CategoryID )  
FROM [Order Details] OD join Products P on P.ProductID = OD.ProductID
						Join Categories C on C.CategoryID = P.CategoryID
Where P.UnitPrice > (Select avg(UnitPrice) from Products join Categories CAT on Products.CategoryID = CAT.CategoryID where C.CategoryID = CAT.CategoryID )
Order by c.CategoryName

--21. For each city (in which our customers live), display the yearly income average.
SELECT Distinct  C.City, TurnOver = 
		(SELECT Sum (OrDet.Quantity*OrDet.UnitPrice*(1-OrDet.Discount)) FROM Customers Cust join Orders Ord on Cust.CustomerID = Ord.CustomerID
										join [Order Details] OrDet on OrDet.OrderID = Ord.OrderID
		Where C.City = Cust.City)
FROM Customers C join Orders O on c.CustomerID = O.CustomerID
				 join [Order Details] OD on OD.OrderID = O.OrderID


--22. For each month display the average sales in the same month all over the years.
Select top 1 
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 1 )'Jan',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 2 )'Feb',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 3 )'Mars',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 4 )'Apr',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 5 )'May',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 6 )'Jun',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 7 )'Jul',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 8 )'Aug',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 9 )'Sept',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 10 )'Oct',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 11 )'Nov',
(Select round(sum(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount))/COUNT(DISTINCT Year(Ord.OrderDate)),2)From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID where Month(Ord.OrderDate) = 12 )' Dec'
FROM [Order Details] OD join Orders O on OD.OrderID = O.OrderID



--23. Display a list of products and OrderID of the largest order ever placed for each product.
Select P.ProductName, OD.OrderID, MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) 'MaxOrderAmount'
FROM Products P join [Order Details] OD on P.ProductID = OD.ProductID 
GROUP BY P.ProductName, OD.OrderID
Having MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) = (SELECT MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) FROM Products Prod join [Order Details] OD on Prod.ProductID = OD.ProductID Where Prod.ProductName = P.ProductName)
ORDER BY P.ProductName asc


--24. Display for each year, the customer who purchased the highest amount.
SELECT 'Best Buyer 1996' = (SELECT C.CustomerID FROM [Order Details] OD join Orders O on OD.OrderID = O.OrderID
						join Customers C on C.CustomerID = O.CustomerID
						Group BY C.CustomerID
						having  MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) = (Select MAX(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount)) From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID
									join Customers cust on cust.CustomerID = Ord.CustomerID  where Year(Ord.OrderDate) = 1996)) ,
		'Best Buyer 1997' = (SELECT Top 1 C.CustomerID FROM [Order Details] OD join Orders O on OD.OrderID = O.OrderID
						join Customers C on C.CustomerID = O.CustomerID
						Group BY C.CustomerID
						having  MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) = (Select MAX(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount)) From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID
									join Customers cust on cust.CustomerID = Ord.CustomerID  where Year(Ord.OrderDate) = 1997)) ,
		'Best Buyer 1998' = (SELECT C.CustomerID  FROM [Order Details] OD join Orders O on OD.OrderID = O.OrderID
						join Customers C on C.CustomerID = O.CustomerID
						Group BY C.CustomerID
						having  MAX(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) = (Select MAX(OrdDe.Quantity*OrdDe.UnitPrice*(1-OrdDe.Discount)) From [Order Details] OrdDe join Orders Ord on OrdDe.OrderID = Ord.OrderID
									join Customers cust on cust.CustomerID = Ord.CustomerID  where Year(Ord.OrderDate) = 1998)) 

FROM [Order Details] OD join Orders O on OD.OrderID = O.OrderID
						join Customers C on C.CustomerID = O.CustomerID




