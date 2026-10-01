-- requete sql de 1 à 100


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


-- requete sql de 51 à 100
-- Les données de ventes couvrent la période du 31/05/2011 au 30/06/2014 :
-- les calculs d'ancienneté ou d'inactivité utilisent le 30/06/2014 comme date de référence.
USE AdventureWorks2019;


-- 51.
-- Écrivez une requête en SQL pour lister tous les produits avec leur sous-catégorie et leur catégorie, y compris les produits sans catégorie.
-- Renvoyez l'ID du produit, le nom du produit, la sous-catégorie et la catégorie. Triez par catégorie, sous-catégorie puis nom de produit.
SELECT p.ProductID, p.Name AS produit, ps.Name AS sous_categorie, pc.Name AS categorie
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON pc.ProductCategoryID = ps.ProductCategoryID
ORDER BY categorie, sous_categorie, produit;


-- 52.
-- Écrivez une requête en SQL pour trouver les produits qui n'ont jamais été vendus.
-- Renvoyez l'ID du produit, le nom et le numéro de produit. Triez par nom.
SELECT p.ProductID, p.Name, p.ProductNumber
FROM Production.Product p
WHERE NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail sod WHERE sod.ProductID = p.ProductID)
ORDER BY p.Name;


-- 53.
-- Écrivez une requête en SQL pour compter le nombre de produits par couleur. Les produits sans couleur doivent apparaître sous « Sans couleur ».
-- Triez le résultat par nombre de produits décroissant.
SELECT COALESCE(Color, 'Sans couleur') AS couleur, COUNT(*) AS nombre_produits
FROM Production.Product
GROUP BY COALESCE(Color, 'Sans couleur')
ORDER BY nombre_produits DESC;


-- 54.
-- Écrivez une requête en SQL pour calculer le prix catalogue minimum, moyen et maximum des produits de chaque sous-catégorie.
-- Ne tenez compte que des produits dont le prix est supérieur à 0. Triez par prix moyen décroissant.
SELECT ps.Name AS sous_categorie,
       MIN(p.ListPrice) AS prix_min,
       AVG(p.ListPrice) AS prix_moyen,
       MAX(p.ListPrice) AS prix_max,
       COUNT(*) AS nombre_produits
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
WHERE p.ListPrice > 0
GROUP BY ps.Name
ORDER BY prix_moyen DESC;


-- 55.
-- Écrivez une requête en SQL pour trouver les produits dont le prix catalogue est supérieur au prix moyen de leur sous-catégorie.
-- Renvoyez le nom du produit, la sous-catégorie, le prix catalogue et le prix moyen de la sous-catégorie.
SELECT p.Name AS produit, ps.Name AS sous_categorie, p.ListPrice,
       (SELECT AVG(p2.ListPrice) FROM Production.Product p2 WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID) AS prix_moyen_sous_categorie
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
WHERE p.ListPrice > (SELECT AVG(p2.ListPrice) FROM Production.Product p2 WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID)
ORDER BY sous_categorie, p.ListPrice DESC;


-- 56.
-- Écrivez une requête en SQL pour trouver les 10 clients particuliers ayant dépensé le plus.
-- Renvoyez l'ID client, le nom complet, le nombre de commandes et le montant total dû.
SELECT TOP 10 c.CustomerID, CONCAT_WS(' ', p.FirstName, p.LastName) AS client,
       COUNT(*) AS nombre_commandes, SUM(soh.TotalDue) AS montant_total
FROM Sales.Customer c
JOIN Person.Person p ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesOrderHeader soh ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY montant_total DESC;


-- 57.
-- Écrivez une requête en SQL pour compter le nombre de clients n'ayant passé qu'une seule commande et leur proportion parmi tous les clients ayant commandé.
WITH commandes_par_client AS (
    SELECT CustomerID, COUNT(*) AS nombre_commandes
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT SUM(CASE WHEN nombre_commandes = 1 THEN 1 ELSE 0 END) AS clients_une_commande,
       COUNT(*) AS clients_total,
       CAST(100.0 * SUM(CASE WHEN nombre_commandes = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5, 2)) AS pourcentage
FROM commandes_par_client;


-- 58.
-- Écrivez une requête en SQL pour calculer le nombre de commandes et le chiffre d'affaires (sous-total) de chaque mois de l'année 2013.
-- Renvoyez le numéro du mois, le nom du mois, le nombre de commandes et le chiffre d'affaires. Triez par mois.
SELECT MONTH(OrderDate) AS mois, DATENAME(MONTH, OrderDate) AS nom_mois,
       COUNT(*) AS nombre_commandes, SUM(SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY mois;


-- 59.
-- Écrivez une requête en SQL pour calculer le chiffre d'affaires et le nombre de commandes par jour de la semaine.
-- Triez du lundi au dimanche.
SELECT DATENAME(WEEKDAY, OrderDate) AS jour, COUNT(*) AS nombre_commandes, SUM(SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader
GROUP BY DATENAME(WEEKDAY, OrderDate), (DATEPART(WEEKDAY, OrderDate) + @@DATEFIRST - 2) % 7
ORDER BY (DATEPART(WEEKDAY, OrderDate) + @@DATEFIRST - 2) % 7;


-- 60.
-- Écrivez une requête en SQL pour calculer le délai moyen de livraison (en jours, entre la commande et l'expédition) pour chaque mode de livraison.
-- Renvoyez le mode de livraison, le nombre de commandes et le délai moyen.
SELECT sm.Name AS mode_livraison, COUNT(*) AS nombre_commandes,
       AVG(DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) * 1.0) AS delai_moyen_jours
FROM Sales.SalesOrderHeader soh
JOIN Purchasing.ShipMethod sm ON sm.ShipMethodID = soh.ShipMethodID
GROUP BY sm.Name
ORDER BY delai_moyen_jours;


-- 61.
-- Écrivez une requête en SQL pour comparer chaque année les ventes en ligne et les ventes réalisées par les commerciaux.
-- Renvoyez l'année, le canal (« En ligne » ou « Commercial »), le nombre de commandes et le chiffre d'affaires.
SELECT YEAR(OrderDate) AS annee,
       CASE WHEN OnlineOrderFlag = 1 THEN 'En ligne' ELSE 'Commercial' END AS canal,
       COUNT(*) AS nombre_commandes, SUM(SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), OnlineOrderFlag
ORDER BY annee, canal;


-- 62.
-- Écrivez une requête en SQL pour afficher le chiffre d'affaires de chaque territoire avec une colonne par année (tableau croisé avec PIVOT).
SELECT territoire, [2011], [2012], [2013], [2014]
FROM (
    SELECT st.Name AS territoire, YEAR(soh.OrderDate) AS annee, soh.SubTotal
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
) AS source
PIVOT (SUM(SubTotal) FOR annee IN ([2011], [2012], [2013], [2014])) AS tableau
ORDER BY territoire;


-- 63.
-- Écrivez une requête en SQL pour calculer le chiffre d'affaires de chaque année, celui de l'année précédente et le taux d'évolution en pourcentage.
-- Attention : 2011 (à partir de juin) et 2014 (jusqu'à juin) sont des années incomplètes.
WITH ca_annuel AS (
    SELECT YEAR(OrderDate) AS annee, SUM(SubTotal) AS chiffre_affaires
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
)
SELECT annee, chiffre_affaires,
       LAG(chiffre_affaires) OVER (ORDER BY annee) AS ca_annee_precedente,
       CAST(100.0 * (chiffre_affaires - LAG(chiffre_affaires) OVER (ORDER BY annee))
            / LAG(chiffre_affaires) OVER (ORDER BY annee) AS DECIMAL(10, 2)) AS evolution_pourcentage
FROM ca_annuel
ORDER BY annee;


-- 64.
-- Écrivez une requête en SQL pour calculer le chiffre d'affaires mensuel de l'année 2013 et son cumul depuis le début de l'année.
WITH ca_mensuel AS (
    SELECT MONTH(OrderDate) AS mois, SUM(SubTotal) AS chiffre_affaires
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013
    GROUP BY MONTH(OrderDate)
)
SELECT mois, chiffre_affaires,
       SUM(chiffre_affaires) OVER (ORDER BY mois ROWS UNBOUNDED PRECEDING) AS ca_cumule
FROM ca_mensuel
ORDER BY mois;


-- 65.
-- Écrivez une requête en SQL pour trouver les 3 produits ayant généré le plus de chiffre d'affaires dans chaque catégorie.
-- Renvoyez la catégorie, le rang, le produit et son chiffre d'affaires.
WITH ca_produit AS (
    SELECT pc.Name AS categorie, p.Name AS produit, SUM(sod.LineTotal) AS chiffre_affaires,
           RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS rang
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product p ON p.ProductID = sod.ProductID
    JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON pc.ProductCategoryID = ps.ProductCategoryID
    GROUP BY pc.Name, p.Name
)
SELECT categorie, rang, produit, chiffre_affaires
FROM ca_produit
WHERE rang <= 3
ORDER BY categorie, rang;


-- 66.
-- Écrivez une requête en SQL pour calculer la part de chaque catégorie de produits dans le chiffre d'affaires total.
-- Renvoyez la catégorie, son chiffre d'affaires et sa part en pourcentage. Triez par part décroissante.
SELECT pc.Name AS categorie, SUM(sod.LineTotal) AS chiffre_affaires,
       CAST(100.0 * SUM(sod.LineTotal) / SUM(SUM(sod.LineTotal)) OVER () AS DECIMAL(5, 2)) AS part_pourcentage
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory pc ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.Name
ORDER BY part_pourcentage DESC;


-- 67.
-- Écrivez une requête en SQL pour comparer le chiffre d'affaires de l'année en cours (SalesYTD) de chaque commercial à son quota.
-- Ne retenez que les commerciaux ayant un quota. Renvoyez le nom, le quota, SalesYTD et le taux d'atteinte en pourcentage.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS commercial, sp.SalesQuota, sp.SalesYTD,
       CAST(100.0 * sp.SalesYTD / sp.SalesQuota AS DECIMAL(10, 2)) AS taux_atteinte
FROM Sales.SalesPerson sp
JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
WHERE sp.SalesQuota IS NOT NULL
ORDER BY taux_atteinte DESC;


-- 68.
-- Écrivez une requête en SQL pour calculer le chiffre d'affaires réalisé en 2013 par chaque commercial, avec le nom de son territoire.
-- Triez par chiffre d'affaires décroissant.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS commercial, st.Name AS territoire,
       COUNT(*) AS nombre_commandes, SUM(soh.SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON st.TerritoryID = sp.TerritoryID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY p.FirstName, p.LastName, st.Name
ORDER BY chiffre_affaires DESC;


-- 69.
-- Écrivez une requête en SQL pour estimer la rémunération variable de chaque commercial : bonus + commission (SalesYTD x CommissionPct).
-- Renvoyez le nom, le bonus, le taux de commission, la commission estimée et le total.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS commercial, sp.Bonus, sp.CommissionPct,
       sp.SalesYTD * sp.CommissionPct AS commission_estimee,
       sp.Bonus + sp.SalesYTD * sp.CommissionPct AS remuneration_variable
FROM Sales.SalesPerson sp
JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
ORDER BY remuneration_variable DESC;


-- 70.
-- Écrivez une requête en SQL pour calculer l'ancienneté (en années complètes) de chaque employé au 30/06/2014.
-- Renvoyez le nom, le poste, la date d'embauche et l'ancienneté. Triez par ancienneté décroissante.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS employe, e.JobTitle, e.HireDate,
       DATEDIFF(YEAR, e.HireDate, '2014-06-30')
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, '2014-06-30'), e.HireDate) > '2014-06-30' THEN 1 ELSE 0 END AS anciennete
FROM HumanResources.Employee e
JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY anciennete DESC, e.HireDate;


-- 71.
-- Écrivez une requête en SQL pour compter le nombre d'employés actuellement rattachés à chaque département.
-- Renvoyez le groupe, le département et le nombre d'employés. Triez par groupe puis par nombre décroissant.
SELECT d.GroupName AS groupe, d.Name AS departement, COUNT(*) AS nombre_employes
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d ON d.DepartmentID = edh.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.GroupName, d.Name
ORDER BY groupe, nombre_employes DESC;


-- 72.
-- Écrivez une requête en SQL pour calculer le nombre d'employés et leur âge moyen au 30/06/2014, par genre.
SELECT CASE e.Gender WHEN 'M' THEN 'Homme' WHEN 'F' THEN 'Femme' END AS genre,
       COUNT(*) AS nombre_employes,
       AVG(DATEDIFF(DAY, e.BirthDate, '2014-06-30') / 365.25) AS age_moyen
FROM HumanResources.Employee e
GROUP BY e.Gender;


-- 73.
-- Écrivez une requête en SQL pour calculer le taux horaire actuel moyen, minimum et maximum par département.
-- Le taux actuel est le dernier taux de EmployeePayHistory et le département actuel celui dont la date de fin est NULL.
WITH taux_actuel AS (
    SELECT BusinessEntityID, Rate,
           ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC) AS rn
    FROM HumanResources.EmployeePayHistory
)
SELECT d.Name AS departement, COUNT(*) AS nombre_employes,
       AVG(t.Rate) AS taux_moyen, MIN(t.Rate) AS taux_min, MAX(t.Rate) AS taux_max
FROM taux_actuel t
JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = t.BusinessEntityID AND edh.EndDate IS NULL
JOIN HumanResources.Department d ON d.DepartmentID = edh.DepartmentID
WHERE t.rn = 1
GROUP BY d.Name
ORDER BY taux_moyen DESC;


-- 74.
-- Écrivez une requête en SQL pour afficher chaque employé avec le nom de son responsable direct (colonne hiérarchique OrganizationNode).
-- Renvoyez le nom et le poste de l'employé, et le nom et le poste du responsable. Le directeur général n'a pas de responsable.
-- Dans cette base, le nœud du directeur général vaut NULL au lieu de la racine : les employés de niveau 1 sont rattachés à lui explicitement.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS employe, e.JobTitle AS poste,
       CONCAT_WS(' ', pm.FirstName, pm.LastName) AS responsable, m.JobTitle AS poste_responsable
FROM HumanResources.Employee e
JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
LEFT JOIN HumanResources.Employee m
    ON m.OrganizationNode = e.OrganizationNode.GetAncestor(1)
    OR (e.OrganizationLevel = 1 AND m.OrganizationLevel IS NULL)
LEFT JOIN Person.Person pm ON pm.BusinessEntityID = m.BusinessEntityID
ORDER BY e.OrganizationNode;


-- 75.
-- Écrivez une requête en SQL pour trouver les employés ayant travaillé dans plusieurs départements ou équipes.
-- Renvoyez le nom, le nombre de départements différents et le nombre d'affectations.
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS employe,
       COUNT(DISTINCT edh.DepartmentID) AS nombre_departements,
       COUNT(*) AS nombre_affectations
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN Person.Person p ON p.BusinessEntityID = edh.BusinessEntityID
GROUP BY p.FirstName, p.LastName, edh.BusinessEntityID
HAVING COUNT(*) > 1
ORDER BY nombre_affectations DESC;


-- 76.
-- Écrivez une requête en SQL pour trouver les 10 employés ayant le plus d'heures de congés payés disponibles.
-- Renvoyez le nom, le poste, les heures de congés et les heures de maladie.
SELECT TOP 10 CONCAT_WS(' ', p.FirstName, p.LastName) AS employe, e.JobTitle, e.VacationHours, e.SickLeaveHours
FROM HumanResources.Employee e
JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY e.VacationHours DESC, e.SickLeaveHours DESC;


-- 77.
-- Écrivez une requête en SQL pour trouver les produits dont la quantité totale en stock est inférieure au stock de sécurité.
-- Renvoyez le produit, la quantité en stock, le stock de sécurité et le point de commande.
SELECT p.Name AS produit, SUM(pi.Quantity) AS quantite_stock, p.SafetyStockLevel, p.ReorderPoint
FROM Production.Product p
JOIN Production.ProductInventory pi ON pi.ProductID = p.ProductID
GROUP BY p.Name, p.SafetyStockLevel, p.ReorderPoint
HAVING SUM(pi.Quantity) < p.SafetyStockLevel
ORDER BY quantite_stock;


-- 78.
-- Écrivez une requête en SQL pour calculer, pour chaque emplacement de stockage, le nombre de produits différents et la quantité totale stockée.
SELECT l.Name AS emplacement, COUNT(DISTINCT pi.ProductID) AS nombre_produits, SUM(pi.Quantity) AS quantite_totale
FROM Production.ProductInventory pi
JOIN Production.Location l ON l.LocationID = pi.LocationID
GROUP BY l.Name
ORDER BY quantite_totale DESC;


-- 79.
-- Écrivez une requête en SQL pour lister les fournisseurs actifs avec le nombre de produits qu'ils fournissent.
-- Renvoyez le nom, la note de crédit (1 = excellent), le statut de fournisseur privilégié et le nombre de produits.
SELECT v.Name AS fournisseur, v.CreditRating, v.PreferredVendorStatus, COUNT(pv.ProductID) AS nombre_produits
FROM Purchasing.Vendor v
LEFT JOIN Purchasing.ProductVendor pv ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.ActiveFlag = 1
GROUP BY v.Name, v.CreditRating, v.PreferredVendorStatus
ORDER BY nombre_produits DESC, fournisseur;


-- 80.
-- Écrivez une requête en SQL pour calculer le montant total des achats par fournisseur et par année.
-- Renvoyez le fournisseur, l'année, le nombre de commandes d'achat et le montant total dû.
SELECT v.Name AS fournisseur, YEAR(poh.OrderDate) AS annee,
       COUNT(*) AS nombre_commandes, SUM(poh.TotalDue) AS montant_achats
FROM Purchasing.PurchaseOrderHeader poh
JOIN Purchasing.Vendor v ON v.BusinessEntityID = poh.VendorID
GROUP BY v.Name, YEAR(poh.OrderDate)
ORDER BY annee, montant_achats DESC;


-- 81.
-- Écrivez une requête en SQL pour trouver les 10 fournisseurs ayant le délai moyen de livraison le plus long.
-- Renvoyez le fournisseur, le délai moyen (en jours) et le nombre de produits.
SELECT TOP 10 v.Name AS fournisseur, AVG(pv.AverageLeadTime * 1.0) AS delai_moyen_jours, COUNT(*) AS nombre_produits
FROM Purchasing.ProductVendor pv
JOIN Purchasing.Vendor v ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.Name
ORDER BY delai_moyen_jours DESC;


-- 82.
-- Écrivez une requête en SQL pour trouver les produits proposés par plusieurs fournisseurs, avec le prix d'achat le plus bas et le plus haut.
SELECT p.Name AS produit, COUNT(*) AS nombre_fournisseurs,
       MIN(pv.StandardPrice) AS prix_achat_min, MAX(pv.StandardPrice) AS prix_achat_max
FROM Purchasing.ProductVendor pv
JOIN Production.Product p ON p.ProductID = pv.ProductID
GROUP BY p.Name
HAVING COUNT(*) > 1
ORDER BY nombre_fournisseurs DESC, produit;


-- 83.
-- Écrivez une requête en SQL pour afficher les produits ayant reçu des avis clients, avec le nombre d'avis et la note moyenne.
SELECT p.Name AS produit, COUNT(*) AS nombre_avis, AVG(pr.Rating * 1.0) AS note_moyenne
FROM Production.ProductReview pr
JOIN Production.Product p ON p.ProductID = pr.ProductID
GROUP BY p.Name
ORDER BY note_moyenne DESC;


-- 84.
-- Écrivez une requête en SQL pour mesurer l'utilisation des offres spéciales (hors « No Discount ») dans les commandes.
-- Renvoyez l'offre, le taux de remise, le nombre de lignes de commande et le montant total de la remise accordée.
SELECT so.Description AS offre, so.DiscountPct, COUNT(*) AS nombre_lignes,
       SUM(sod.UnitPrice * sod.UnitPriceDiscount * sod.OrderQty) AS montant_remise
FROM Sales.SalesOrderDetail sod
JOIN Sales.SpecialOffer so ON so.SpecialOfferID = sod.SpecialOfferID
WHERE so.DiscountPct > 0
GROUP BY so.Description, so.DiscountPct
ORDER BY montant_remise DESC;


-- 85.
-- Écrivez une requête en SQL pour trouver les raisons d'achat les plus citées par les clients.
-- Renvoyez la raison, son type et le nombre de commandes concernées.
SELECT sr.Name AS raison, sr.ReasonType AS type_raison, COUNT(*) AS nombre_commandes
FROM Sales.SalesOrderHeaderSalesReason sohsr
JOIN Sales.SalesReason sr ON sr.SalesReasonID = sohsr.SalesReasonID
GROUP BY sr.Name, sr.ReasonType
ORDER BY nombre_commandes DESC;


-- 86.
-- Écrivez une requête en SQL pour trouver les 10 magasins (clients revendeurs) ayant généré le plus de chiffre d'affaires.
-- Renvoyez le magasin, le nombre de commandes et le chiffre d'affaires.
SELECT TOP 10 s.Name AS magasin, COUNT(*) AS nombre_commandes, SUM(soh.SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON c.CustomerID = soh.CustomerID
JOIN Sales.Store s ON s.BusinessEntityID = c.StoreID
GROUP BY s.Name
ORDER BY chiffre_affaires DESC;


-- 87.
-- Écrivez une requête en SQL pour compter le nombre de clients et le chiffre d'affaires par pays.
-- Renvoyez le pays, le nombre de clients ayant commandé et le chiffre d'affaires. Triez par chiffre d'affaires décroissant.
SELECT cr.Name AS pays, COUNT(DISTINCT soh.CustomerID) AS nombre_clients, SUM(soh.SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
JOIN Person.CountryRegion cr ON cr.CountryRegionCode = st.CountryRegionCode
GROUP BY cr.Name
ORDER BY chiffre_affaires DESC;


-- 88.
-- Écrivez une requête en SQL pour analyser les moyens de paiement : nombre de commandes et chiffre d'affaires par type de carte bancaire.
-- Les commandes sans carte doivent apparaître sous « Autre moyen de paiement ».
SELECT COALESCE(cc.CardType, 'Autre moyen de paiement') AS type_carte,
       COUNT(*) AS nombre_commandes, SUM(soh.SubTotal) AS chiffre_affaires
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.CreditCard cc ON cc.CreditCardID = soh.CreditCardID
GROUP BY COALESCE(cc.CardType, 'Autre moyen de paiement')
ORDER BY nombre_commandes DESC;


-- 89.
-- Écrivez une requête en SQL pour compter les commandes passées dans une devise autre que le dollar américain.
-- Renvoyez la devise, son nom, le nombre de commandes et le taux de change moyen appliqué.
SELECT cr.ToCurrencyCode AS devise, c.Name AS nom_devise, COUNT(*) AS nombre_commandes,
       AVG(cr.AverageRate) AS taux_moyen
FROM Sales.SalesOrderHeader soh
JOIN Sales.CurrencyRate cr ON cr.CurrencyRateID = soh.CurrencyRateID
JOIN Sales.Currency c ON c.CurrencyCode = cr.ToCurrencyCode
GROUP BY cr.ToCurrencyCode, c.Name
ORDER BY nombre_commandes DESC;


-- 90.
-- Écrivez une requête en SQL pour compter les commandes dont le sous-total dépasse le panier moyen, et leur part dans le chiffre d'affaires total.
WITH panier AS (SELECT AVG(SubTotal) AS panier_moyen FROM Sales.SalesOrderHeader)
SELECT panier.panier_moyen,
       SUM(CASE WHEN soh.SubTotal > panier.panier_moyen THEN 1 ELSE 0 END) AS commandes_au_dessus,
       COUNT(*) AS commandes_total,
       CAST(100.0 * SUM(CASE WHEN soh.SubTotal > panier.panier_moyen THEN soh.SubTotal ELSE 0 END)
            / SUM(soh.SubTotal) AS DECIMAL(5, 2)) AS part_ca_pourcentage
FROM Sales.SalesOrderHeader soh
CROSS JOIN panier
GROUP BY panier.panier_moyen;


-- 91.
-- Écrivez une requête en SQL pour segmenter les clients selon leur montant total d'achats : moins de 1 000, de 1 000 à 10 000, plus de 10 000.
-- Renvoyez le segment, le nombre de clients et le chiffre d'affaires du segment.
WITH total_client AS (
    SELECT CustomerID, SUM(SubTotal) AS total
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT CASE WHEN total < 1000 THEN '1. Moins de 1 000'
            WHEN total <= 10000 THEN '2. De 1 000 à 10 000'
            ELSE '3. Plus de 10 000' END AS segment,
       COUNT(*) AS nombre_clients, SUM(total) AS chiffre_affaires
FROM total_client
GROUP BY CASE WHEN total < 1000 THEN '1. Moins de 1 000'
              WHEN total <= 10000 THEN '2. De 1 000 à 10 000'
              ELSE '3. Plus de 10 000' END
ORDER BY segment;


-- 92.
-- Écrivez une requête en SQL pour trouver les 10 paires de produits le plus souvent achetées ensemble dans une même commande.
-- Renvoyez les deux produits et le nombre de commandes communes.
SELECT TOP 10 p1.Name AS produit_1, p2.Name AS produit_2, COUNT(*) AS commandes_communes
FROM Sales.SalesOrderDetail a
JOIN Sales.SalesOrderDetail b ON b.SalesOrderID = a.SalesOrderID AND b.ProductID > a.ProductID
JOIN Production.Product p1 ON p1.ProductID = a.ProductID
JOIN Production.Product p2 ON p2.ProductID = b.ProductID
GROUP BY p1.Name, p2.Name
ORDER BY commandes_communes DESC;


-- 93.
-- Écrivez une requête en SQL pour afficher, pour chaque client, la date de sa première et de sa dernière commande et le nombre de jours entre les deux.
-- Renvoyez les 10 clients fidèles depuis le plus longtemps.
SELECT TOP 10 CustomerID, MIN(OrderDate) AS premiere_commande, MAX(OrderDate) AS derniere_commande,
       DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)) AS jours_entre, COUNT(*) AS nombre_commandes
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY jours_entre DESC, nombre_commandes DESC;


-- 94.
-- Écrivez une requête en SQL pour compter les clients inactifs, c'est-à-dire sans commande depuis plus de 6 mois au 30/06/2014.
-- Renvoyez le nombre de clients inactifs, le nombre total de clients ayant commandé et le pourcentage.
WITH derniere AS (
    SELECT CustomerID, MAX(OrderDate) AS derniere_commande
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT SUM(CASE WHEN derniere_commande < DATEADD(MONTH, -6, '2014-06-30') THEN 1 ELSE 0 END) AS clients_inactifs,
       COUNT(*) AS clients_total,
       CAST(100.0 * SUM(CASE WHEN derniere_commande < DATEADD(MONTH, -6, '2014-06-30') THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5, 2)) AS pourcentage
FROM derniere;


-- 95.
-- Écrivez une requête en SQL pour compter le nombre de nouveaux clients par année (année de leur première commande).
WITH premiere AS (
    SELECT CustomerID, MIN(OrderDate) AS premiere_commande
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT YEAR(premiere_commande) AS annee, COUNT(*) AS nouveaux_clients
FROM premiere
GROUP BY YEAR(premiere_commande)
ORDER BY annee;


-- 96.
-- Écrivez une requête en SQL pour calculer la marge brute par catégorie, en utilisant le coût standard en vigueur à la date de chaque commande (ProductCostHistory).
-- Certains produits ont été vendus après la fin de leur historique de coûts : on retient alors le dernier coût connu à la date de la commande.
-- Renvoyez la catégorie, le chiffre d'affaires, le coût, la marge et le taux de marge.
SELECT pc.Name AS categorie,
       SUM(sod.LineTotal) AS chiffre_affaires,
       SUM(sod.OrderQty * cout.StandardCost) AS cout,
       SUM(sod.LineTotal - sod.OrderQty * cout.StandardCost) AS marge,
       CAST(100.0 * SUM(sod.LineTotal - sod.OrderQty * cout.StandardCost) / SUM(sod.LineTotal) AS DECIMAL(5, 2)) AS taux_marge
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
CROSS APPLY (
    SELECT TOP 1 pch.StandardCost
    FROM Production.ProductCostHistory pch
    WHERE pch.ProductID = sod.ProductID AND pch.StartDate <= soh.OrderDate
    ORDER BY pch.StartDate DESC
) AS cout
JOIN Production.Product p ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory pc ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.Name
ORDER BY marge DESC;


-- 97.
-- Écrivez une requête en SQL pour trouver les produits dont le prix catalogue a changé, avec le premier et le dernier prix connus et l'évolution en pourcentage.
WITH historique AS (
    SELECT ProductID, StartDate,
           FIRST_VALUE(ListPrice) OVER (PARTITION BY ProductID ORDER BY StartDate) AS premier_prix,
           LAST_VALUE(ListPrice) OVER (PARTITION BY ProductID ORDER BY StartDate
                                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS dernier_prix,
           COUNT(*) OVER (PARTITION BY ProductID) AS nombre_prix,
           ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY StartDate) AS rn
    FROM Production.ProductListPriceHistory
)
SELECT p.Name AS produit, h.nombre_prix, h.premier_prix, h.dernier_prix,
       CAST(100.0 * (h.dernier_prix - h.premier_prix) / h.premier_prix AS DECIMAL(10, 2)) AS evolution_pourcentage
FROM historique h
JOIN Production.Product p ON p.ProductID = h.ProductID
WHERE h.rn = 1 AND h.nombre_prix > 1
ORDER BY evolution_pourcentage DESC;


-- 98.
-- Écrivez une requête en SQL pour calculer le taux de taxe moyen appliqué (taxes / sous-total) dans chaque territoire.
SELECT st.Name AS territoire, SUM(soh.TaxAmt) AS taxes, SUM(soh.SubTotal) AS sous_total,
       CAST(100.0 * SUM(soh.TaxAmt) / SUM(soh.SubTotal) AS DECIMAL(5, 2)) AS taux_taxe
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
GROUP BY st.Name
ORDER BY taux_taxe DESC;


-- 99.
-- Écrivez une requête en SQL pour calculer le poids des frais de port par rapport au sous-total pour chaque mode de livraison.
SELECT sm.Name AS mode_livraison, SUM(soh.Freight) AS frais_port, SUM(soh.SubTotal) AS sous_total,
       CAST(100.0 * SUM(soh.Freight) / SUM(soh.SubTotal) AS DECIMAL(5, 2)) AS frais_port_pourcentage
FROM Sales.SalesOrderHeader soh
JOIN Purchasing.ShipMethod sm ON sm.ShipMethodID = soh.ShipMethodID
GROUP BY sm.Name
ORDER BY frais_port_pourcentage DESC;


-- 100.
-- Écrivez une requête en SQL pour produire une synthèse annuelle des ventes avec une ligne de total général.
-- Renvoyez l'année (« Total » pour la ligne de total), le chiffre d'affaires, le nombre de commandes, le nombre de clients, le panier moyen et la part des ventes en ligne.
SELECT CASE WHEN GROUPING(YEAR(OrderDate)) = 1 THEN 'Total' ELSE CAST(YEAR(OrderDate) AS VARCHAR(4)) END AS annee,
       SUM(SubTotal) AS chiffre_affaires,
       COUNT(*) AS nombre_commandes,
       COUNT(DISTINCT CustomerID) AS nombre_clients,
       SUM(SubTotal) / COUNT(*) AS panier_moyen,
       CAST(100.0 * SUM(CASE WHEN OnlineOrderFlag = 1 THEN SubTotal ELSE 0 END) / SUM(SubTotal) AS DECIMAL(5, 2)) AS part_en_ligne
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP (YEAR(OrderDate))
ORDER BY GROUPING(YEAR(OrderDate)), annee;
