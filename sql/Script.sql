-- requete sql de 1 à 50


-- 1.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer toutes les lignes et colonnes de la table des employés dans la base de données Adventureworks.
-- Triez l’ensemble des résultats par ordre croissant sur le titre du poste. 
USE AdventureWorks2019;

SELECT *
FROM HumanResources.Employee
ORDER BY JobTitle ASC;


-- 2.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer toutes les lignes et colonnes de la table des employés à l'aide de l'alias de table dans la base de données Adventureworks.
-- Triez la sortie par ordre croissant sur le nom de famille
USE AdventureWorks2019;

SELECT p.*
FROM Person.Person p
ORDER BY LastName ASC;


-- 3. 
-- À partir du tableau suivant, écrivez une requête en SQL pour renvoyer toutes les lignes et un sous-ensemble de colonnes (FirstName, LastName, businessentityid) à partir de la table des personnes dans la base de données AdventureWorks.
-- Le titre de la troisième colonne est renommé Employee_id. Organisé la sortie par ordre croissant par nom de famille.
USE AdventureWorks2019;

SELECT FirstName, LastName, BusinessEntityID AS Employee_id
FROM Person.Person
ORDER BY LastName ASC;


-- 4.
-- À partir du tableau suivant, écrivez une requête en SQL pour renvoyer uniquement les lignes des produits dont la date de début de vente n'est pas NULL et la ligne de produits « T ».
-- Renvoie l'ID du produit, le numéro du produit et le nom. Organisé la sortie par ordre croissant de nom.
USE AdventureWorks2019;

SELECT ProductID, ProductNumber, Name 
FROM Production.Product
WHERE SellStartDate IS NOT NULL AND ProductLine = 'T'
ORDER BY Name ASC;


-- 5.
-- À partir du tableau suivant, écrivez une requête en SQL pour renvoyer toutes les lignes de la table salesorderheader dans la base de données Adventureworks et calculez le pourcentage de taxe sur le sous-total décidé.
-- Renvoyez l'ID de commande, l'ID client, la date de commande, le sous-total, le pourcentage de la colonne de taxe. Organisé l'ensemble des résultats par ordre croissant sur le sous-total. 
USE AdventureWorks2019;

SELECT SalesOrderID, CustomerID, OrderDate, SubTotal, (TaxAmt*100)/SubTotal AS Tax_percent
FROM Sales.SalesOrderHeader
ORDER BY SubTotal ASC;


-- 6.
-- À partir du tableau suivant, écrivez une requête en SQL pour créer une liste de titres de poste uniques dans la table des employés de la base de données Adventureworks.
-- Renvoie la colonne titre du poste et organise l'ensemble des résultats par ordre croissant. 
USE AdventureWorks2019;

SELECT DISTINCT JobTitle 
FROM HumanResources.Employee
ORDER BY JobTitle ASC;


-- 7.
-- À partir du tableau suivant, écrivez une requête en SQL pour calculer le fret total payé par chaque client.
-- Retourner l'ID client et le fret total. Triez la sortie par ordre croissant sur l'ID client. 
USE AdventureWorks2019;

SELECT CustomerID, SUM(Freight) AS Total_Freight
FROM Sales.SalesOrderHeader
GROUP BY CustomerID 
ORDER BY CustomerID ASC;


-- 8.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver la moyenne et la somme du sous-total pour chaque client.
-- Renvoie l'identifiant client, la moyenne et la somme du sous-total. Regroupé le résultat sur customerid et salespersonid.
-- Triez le résultat sur la colonne customerid par ordre décroissant. 
USE AdventureWorks2019;

SELECT CustomerID, SalesPersonID, AVG(SubTotal) AS avg_subtotal, SUM(SubTotal) AS sum_subtotal
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, SalesPersonID 
ORDER BY CustomerID DESC;


-- 9.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer la quantité totale de chaque ID de produit qui se trouve dans l'étagère « A », « C » ou « H ».
-- Filtrez les résultats pour que la quantité totale soit supérieure à 500.
-- Renvoyez l'ID de produit et la somme de la quantité.
-- Triez les résultats selon le productid par ordre croissant. 
USE AdventureWorks2019;

SELECT ProductID, SUM(Quantity) AS quantity_total
FROM Production.ProductInventory
WHERE Shelf IN ('A', 'C', 'H')
GROUP BY ProductID
HAVING SUM(Quantity) > 500
ORDER BY ProductID ASC;


-- 10.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver la quantité totale d'un groupe d'ID de localisation multipliée par 10. 
USE AdventureWorks2019;

SELECT SUM(Quantity) AS quantity_total
FROM Production.ProductInventory
GROUP BY (LocationID * 10);


-- 11.
--À partir des tableaux suivants, écrivez une requête en SQL pour trouver les personnes dont le nom de famille commence par la lettre « L ».
--Retour BusinessEntityID, FirstName, LastName et PhoneNumber.
--Triez le résultat par nom et prénom. 
USE AdventureWorks2019;

SELECT P.BusinessEntityID, P.FirstName, P.LastName, PH.PhoneNumber
FROM Person.Person AS P
JOIN Person.PersonPhone AS PH ON P.BusinessEntityID = PH.BusinessEntityID
WHERE P.LastName LIKE 'L%'
ORDER BY P.LastName, P.FirstName;


--12.
--À partir du tableau suivant, écrivez une requête en SQL pour trouver la somme de la colonne du sous-total.
--Regroupez la somme sur un identifiant de vendeur et un identifiant de client distincts.
--Regroupe les résultats en sous-total et total cumulé.
--Renvoie l'ID du vendeur, l'ID du client et la somme de la colonne du sous-total, c'est-à-dire sum_subtotal. 
USE AdventureWorks2019;

SELECT SalesPersonID, CustomerID, SUM(SubTotal) AS sum_subtotal
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP (SalesPersonID, CustomerID);


-- 13.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver la somme de la quantité de toutes les combinaisons de groupes d'ID d'emplacement distincts et de colonnes d'étagère.
-- Renvoie l'ID d'emplacement, l'étagère et la somme de la quantité sous la forme TotalQuantity. 
USE AdventureWorks2019;

SELECT LocationID, Shelf, SUM(Quantity) AS TotalQuantity
FROM Production.ProductInventory pi2 
GROUP BY CUBE(LocationID, Shelf)


-- 14.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver la somme de la quantité avec le sous-total pour chaque ID d'emplacement.
-- Regroupez les résultats pour toutes les combinaisons d’identifiant d’emplacement et de colonne d’étagère distincts.
-- Regroupe les résultats en sous-total et total cumulé.
-- Renvoie l'ID d'emplacement, l'étagère et la somme de la quantité sous la forme TotalQuantity. 
USE AdventureWorks2019;

SELECT LocationID, Shelf, SUM(Quantity) AS TotalQuantity
FROM Production.ProductInventory pi2 
GROUP BY GROUPING SETS ( ROLLUP (locationid, shelf), CUBE (locationid, shelf) );


-- 15.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver la quantité totale pour chaque ID d'emplacement et calculez le total général pour tous les emplacements.
-- Retourner l'identifiant de localisation et la quantité totale.
-- Regroupez les résultats sur locationid. 
USE AdventureWorks2019;

SELECT LocationID, SUM(Quantity) 
FROM Production.ProductInventory pi2 
GROUP BY GROUPING SETS (LocationID, ()) 


SELECT LocationID, SUM(Quantity) 
FROM Production.ProductInventory pi2 
GROUP BY LocationID
WITH ROLLUP 


-- 16.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer le nombre d'employés pour chaque ville.
-- Ville de retour et numéro de employés.
-- Triez le résultat par ordre croissant par ville. 
USE AdventureWorks2019;

SELECT Person.Address.City, COUNT(Person.BusinessEntityAddress.AddressTypeID) AS nombre_employé
FROM Person.BusinessEntityAddress
INNER JOIN Person.Address ON Person.BusinessEntityAddress.AddressID = Person.Address.AddressID 
GROUP BY Address.City
ORDER BY Address.City;


-- 17.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer le total des ventes pour chaque année.
-- Renvoie la partie année de la date de commande et le montant total dû.
-- Triez le résultat par ordre croissant sur la partie année de la date de commande. 
USE AdventureWorks2019;

SELECT YEAR(OrderDate) AS annee, SUM(TotalDue) AS montant_commande
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)


-- 18.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer le total des ventes pour chaque année.
-- Filtrez l'ensemble de résultats pour les commandes dont l'année de commande est égale ou antérieure à 2016.
-- Renvoie la partie année de la date de commande et le montant total dû.
-- Triez le résultat par ordre croissant sur la partie année de la date de commande.
USE AdventureWorks2019;

SELECT YEAR(OrderDate) AS annee, SUM(TotalDue) AS total_commande
FROM Sales.SalesOrderHeader soh 
WHERE YEAR(OrderDate) < 2017
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)


-- 19.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver les contacts désignés comme responsables dans différents départements.
-- Renvoie ContactTypeID, nom.
-- Triez l’ensemble de résultats par ordre décroissant. 
USE AdventureWorks2019;

SELECT ContactTypeID, Name 
FROM Person.ContactType ct 
WHERE Name LIKE '%Manager%'
ORDER BY ContactTypeID DESC; 


-- 20.
-- À partir des tableaux suivants, écrivez une requête en SQL pour créer une liste de contacts désignés comme « responsable des achats ».
-- Renvoie les colonnes BusinessEntityID, LastName et FirstName.
-- Triez le jeu de résultats par ordre croissant de LastName et FirstName. 
USE AdventureWorks2019;

SELECT pp.BusinessEntityID, LastName, FirstName
FROM Person.BusinessEntityContact AS pb 
INNER JOIN Person.ContactType AS pc ON pc.ContactTypeID = pb.ContactTypeID
INNER JOIN Person.Person AS pp ON pp.BusinessEntityID = pb.PersonID
WHERE pc.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName;


-- 21.
-- À partir des tableaux suivants, écrivez une requête en SQL pour récupérer le vendeur pour chaque code postal qui appartient à un territoire et SalesYTD n'est pas nul.
-- Renvoie les numéros de ligne de chaque groupe de colonne PostalCode, nom de famille, salesytd, postalcode.
-- Triez le service de vente de chaque groupe de codes postaux par ordre décroissant.
-- Short le code postal par ordre croissant. 
USE AdventureWorks2019;

SELECT ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",
pp.LastName, sp.SalesYTD, pa.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.BusinessEntityAddress AS bea
        ON bea.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.Address AS pa
        ON pa.AddressID = bea.AddressID
WHERE TerritoryID IS NOT NULL
    AND SalesYTD <> 0
ORDER BY PostalCode;


-- 22.
-- À partir du tableau suivant, écrivez une requête en SQL pour compter le nombre de contacts pour la combinaison de chaque type et nom.
-- Filtrez la sortie pour ceux qui ont 100 contacts ou plus.
-- Renvoyez ContactTypeID, ContactTypeName et BusinessEntityContact.
-- Triez le résultat défini par ordre décroissant selon le nombre de contacts. 
USE AdventureWorks2019;

SELECT bec.ContactTypeID, ct.Name, COUNT(*) AS nombre_contacts
FROM Person.BusinessEntityContact bec 
INNER JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID 
GROUP BY bec.ContactTypeID, ct.Name 
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;


-- 23.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer le RateChangeDate, le nom complet (prénom, deuxième prénom et nom de famille) et le salaire hebdomadaire (40 heures par semaine) des employés.
-- Dans la sortie, le RateChangeDate doit apparaître au format date.
-- Triez la sortie par ordre croissant sur NameInFull. 
USE AdventureWorks2019;

SELECT CAST(eph.RateChangeDate AS DATE) AS Date, CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName) AS NameInFull, eph.Rate * 40 AS Salary
FROM HumanResources.EmployeePayHistory eph 
INNER JOIN Person.Person p ON eph.BusinessEntityID = p.BusinessEntityID 
ORDER BY NameInFull;


-- 24.
-- À partir des tableaux suivants, écrivez une requête en SQL pour calculer et afficher le dernier salaire hebdomadaire de chaque employé.
-- Renvoie RateChangeDate, nom complet (prénom, deuxième prénom et nom de famille) et salaire hebdomadaire (40 heures par semaine) des employés.
-- Triez la sortie par ordre croissant sur NameInFull. 
USE AdventureWorks2019;

SELECT CAST(eph.RateChangeDate AS DATE) AS Date, CONCAT_WS(' ', p.FirstName, p.MiddleName, p.LastName) AS NameInFull, eph.Rate * 40 AS Salary
FROM HumanResources.EmployeePayHistory eph 
INNER JOIN Person.Person p ON eph.BusinessEntityID = p.BusinessEntityID 
WHERE eph.RateChangeDate = (
    SELECT MAX(eph2.RateChangeDate)
    FROM HumanResources.EmployeePayHistory eph2
    WHERE eph2.BusinessEntityID = eph.BusinessEntityID
)
ORDER BY NameInFull;


-- 25.
-- From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order quentity for those orders whose id are 43659 and 43664.
-- Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity. 
USE AdventureWorks2019;

SELECT SalesOrderID, ProductID, OrderQty, SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS sum, AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg, COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS count, MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS min, MAX(OrderQty) OVER (PARTITION BY SalesOrderID)  AS max
FROM Sales.SalesOrderDetail sod 
WHERE SalesOrderID IN (43659, 43664)


-- 26.
-- From the following table write a query in SQL to find the sum, average, and number of order quantity for those orders whose ids are 43659 and 43664 and product id starting with '71'.
-- Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, and number of order quantity. 
USE AdventureWorks2019;

SELECT SalesOrderID, ProductID, OrderQty, SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS sum, AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg, COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS count
FROM Sales.SalesOrderDetail sod 
WHERE SalesOrderID IN (43659, 43664) AND CAST(ProductID AS VARCHAR) LIKE '71%'
ORDER BY SalesOrderID, ProductID 


-- 27.
-- From the following table write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000.
-- Return SalesOrderID, total cost. 
SELECT SalesOrderID, SUM(OrderQty * UnitPrice) AS Total
FROM Sales.SalesOrderDetail sod 
GROUP BY SalesOrderID 
HAVING SUM(OrderQty * UnitPrice) > 100000


-- 28.
-- From the following table write a query in SQL to retrieve products whose names start with 'Lock Washer'.
-- Return product ID, and name and order the result set in ascending order on product ID column.
SELECT ProductID, Name 
FROM Production.Product p 
WHERE Name LIKE 'Lock Washer%' 
ORDER BY ProductID ASC 


-- 29.
-- Write a query in SQL to fetch rows from product table and order the result set on an unspecified column listprice.
-- Return product ID, name, and color of the product. 
SELECT ProductID, Name, Color 
FROM Production.Product p 
ORDER BY ListPrice;


-- 30.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer les enregistrements des employés.
-- Classez la production par année (ordre croissant par défaut) de l'employé.
-- Retour BusinessEntityID, JobTitle et HireDate. 
SELECT BusinessEntityID, JobTitle, HireDate 
FROM HumanResources.Employee e 
ORDER BY HireDate 


-- 31.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer les personnes dont le nom de famille commence par la lettre « R ».
-- Renvoie le nom et le prénom et affiche le résultat par ordre croissant sur le prénom et par ordre décroissant sur les colonnes du nom. 
SELECT LastName, FirstName 
FROM Person.Person p 
WHERE LastName LIKE 'r%'
ORDER BY FirstName ASC, LastName DESC 


-- 32.
-- À partir du tableau suivant, écrivez une requête en SQL pour classer la colonne BusinessEntityID par ordre décroissant lorsque SalariedFlag est défini sur « true » et BusinessEntityID par ordre croissant lorsque SalariedFlag est défini sur « false ».
--Renvoie les colonnes BusinessEntityID et SalariedFlag. 
SELECT BusinessEntityID, SalariedFlag 
FROM HumanResources.Employee e 
ORDER BY CASE SalariedFlag WHEN '1' THEN BusinessEntityID END DESC, CASE WHEN SalariedFlag = '0' THEN BusinessEntityID END 


-- 33. À partir du tableau suivant, écrivez une requête en SQL pour définir le résultat dans l'ordre par la colonne TerritoryName lorsque la colonne CountryRegionName est égale à « États-Unis » et par CountryRegionName pour toutes les autres lignes. 
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName  
FROM Sales.vSalesPerson  
WHERE TerritoryName IS NOT NULL  
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END;


-- 34.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver les personnes qui vivent dans un territoire et la valeur de salesytd sauf 0.
-- Renvoyez le prénom, le nom et le numéro de ligne sous la forme « Numéro de ligne », « Rang », « Rang dense ' et NTILE comme 'Quartile', salesytd et postalcode.
-- Commandez la sortie sur la colonne du code postal. 
SELECT p.FirstName, p.LastName  
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS "Rank"  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS "Quartile"  
    ,s.SalesYTD, a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.BusinessEntityAddress AS bea
        ON bea.BusinessEntityID = p.BusinessEntityID
    INNER JOIN Person.Address AS a
        ON a.AddressID = bea.AddressID
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;
        
        
-- 35.
-- From the following table write a query in SQL to skip the first 10 rows from the sorted result set and return all remaining rows.
SELECT *
FROM HumanResources.Department d 
ORDER BY DepartmentID OFFSET 10 ROWS; 


-- 36.
-- From the following table write a query in SQL to skip the first 5 rows and return the next 5 rows from the sorted result set. 
SELECT DepartmentID, Name, GroupName 
FROM HumanResources.Department d 
ORDER BY DepartmentID
OFFSET 5 ROWS 
FETCH NEXT 5 ROWS ONLY;


-- 37.
-- From the following table write a query in SQL to list all the products that are Red or Blue in color.
-- Return name, color and listprice.Sorts this result by the column listprice. 
SELECT Name, Color, ListPrice 
FROM Production.Product p 
WHERE Color = 'Red' OR Color = 'Blue'
ORDER BY ListPrice;


-- 38.
-- Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders.
-- Additionally, it returns any sales orders that don't have any items mentioned in the Product table as well as any products that have sales orders other than those that are listed there.
-- Return product name, salesorderid. Sort the result set on product name column. 
SELECT p.Name, sod.SalesOrderID 
FROM Production.Product p 
FULL JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
ORDER BY P.Name;


-- 39.
-- From the following table write a SQL query to retrieve the product name and salesorderid.
-- Both ordered and unordered products are included in the result set. 
SELECT p.Name, sod.SalesOrderID 
FROM Production.Product p 
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
ORDER BY p.Name;


-- 40.
-- From the following tables write a SQL query to get all product names and sales order IDs.
-- Order the result set on product name column. 
SELECT p.Name, sod.SalesOrderID 
FROM Production.Product p 
INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
ORDER BY p.Name;


-- 41.
-- From the following tables write a SQL query to retrieve the territory name and BusinessEntityID.
-- The result set includes all salespeople, regardless of whether or not they are assigned a territory. 
SELECT st.Name, sp.BusinessEntityID 
FROM Sales.SalesTerritory st 
RIGHT JOIN Sales.SalesPerson sp ON st.TerritoryID = sp.TerritoryID;


-- 42.
-- Write a query in SQL to find the employee's full name (firstname and lastname) and city from the following tables.
-- Order the result set on lastname then by firstname. 
SELECT p.FirstName + ' ' + p.LastName AS name, d.City   
FROM Person.Person AS p  
INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID   
INNER JOIN  
   (SELECT bea.BusinessEntityID, a.City   
    FROM Person.Address AS a  
    INNER JOIN Person.BusinessEntityAddress AS bea  
    ON a.AddressID = bea.AddressID) AS d  
ON p.BusinessEntityID = d.BusinessEntityID  
ORDER BY p.LastName, p.FirstName;


-- 43.
-- Write a SQL query to return the businessentityid,firstname and lastname columns of all persons in the person table (derived table) with persontype is 'IN' and the last name is 'Adams'.
-- Sort the result set in ascending order on firstname.
-- A SELECT statement after the FROM clause is a derived table. 
SELECT businessentityid, firstname,lastname  
FROM  
   (SELECT * FROM person.person  
    WHERE persontype = 'IN') AS personDerivedTable 
WHERE lastname = 'Adams'  
ORDER BY firstname;


-- 44.
-- Créez une requête SQL pour récupérer les individus de la table suivante avec un businessentityid compris entre 1 500, un nom commençant par « Al » et un prénom commençant par « M ».
SELECT *
FROM Person.Person p 
WHERE LastName LIKE 'al%' AND FirstName LIKE 'm%' AND BusinessEntityID <= 1500


-- 45.
-- Écrivez une requête SQL pour trouver l'ID de produit, le nom et la couleur des éléments « Blade », « Crown Race » et « AWC Logo Cap » à l'aide d'une table dérivée avec plusieurs valeurs. 
SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;


-- 46.
-- Create a SQL query to display the total number of sales orders each sales representative receives annually.
-- Sort the result set by SalesPersonID and then by the date component of the orderdate in ascending order.
-- Return the year component of the OrderDate, SalesPersonID, and SalesOrderID.
SELECT YEAR(OrderDate) AS annee, SalesPersonID, COUNT(SalesOrderID) AS nombre_commandes
FROM Sales.SalesOrderHeader soh 
WHERE SalesPersonID IS NOT NULL 
GROUP BY SalesPersonID, YEAR(OrderDate)
ORDER BY SalesPersonID , YEAR(OrderDate)


-- 47.
-- À partir du tableau suivant, écrivez une requête en SQL pour trouver le nombre moyen de commandes client pour toutes les années des représentants commerciaux.
WITH Sales_CTE (SalesPersonID, NumberOfOrders)
AS (SELECT SalesPersonID, COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID)
SELECT AVG(NumberOfOrders * 1.0) AS "Average Sales Per Person"
FROM Sales_CTE;



-- 48.
-- Écrivez une requête SQL sur la table suivante pour récupérer les enregistrements avec les caractères green_ dans le champ LargePhotoFileName.
-- Les colonnes du tableau suivant doivent toutes être renvoyées.
SELECT *
FROM Production.ProductPhoto pp 
WHERE LargePhotoFileName LIKE '%green[_]%'


-- 49.
-- Write a SQL query to retrieve the mailing address for any company that is outside the United States (US) and in a city whose name starts with Pa.
--Return Addressline1, Addressline2, city, postalcode, countryregioncode columns. 
SELECT a.AddressLine1, a.AddressLine2, a.City, a.PostalCode, sp.CountryRegionCode 
FROM Person.Address a 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
WHERE City LIKE 'pa%' AND sp.CountryRegionCode  NOT IN ('US')


-- 50.
-- À partir du tableau suivant, écrivez une requête en SQL pour récupérer les vingt premières lignes.
-- Retourner le titre du poste, embauché.
-- Classez les résultats définis dans la colonne Embauché par ordre décroissant. 
SELECT JobTitle, HireDate 
FROM HumanResources.Employee e 
ORDER BY HireDate DESC 
OFFSET 0 ROWS 
FETCH FIRST 20 ROWS ONLY;






