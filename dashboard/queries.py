"""Requêtes SQL du tableau de bord, exécutées sur la base OLTP AdventureWorks2019.

Le chiffre d'affaires (CA) correspond au sous-total hors taxes et hors frais de port
(Sales.SalesOrderHeader.SubTotal), comme dans les requêtes de sql/Script.sql.
Toutes les requêtes acceptent les mêmes filtres : une liste d'années et un groupe de territoires.
"""

from sqlalchemy import bindparam, text

# Filtre commun : années sélectionnées et groupe de territoires ('Tous' = pas de filtre)
FILTRE = """
    YEAR(soh.OrderDate) IN :annees
    AND (:groupe = 'Tous' OR st.[Group] = :groupe)
"""


def _requete(sql: str):
    return text(sql).bindparams(bindparam("annees", expanding=True))


ANNEES = text("SELECT DISTINCT YEAR(OrderDate) AS annee FROM Sales.SalesOrderHeader ORDER BY annee")

GROUPES = text("SELECT DISTINCT [Group] AS groupe FROM Sales.SalesTerritory ORDER BY groupe")

INDICATEURS = _requete(f"""
SELECT SUM(soh.SubTotal) AS ca,
       COUNT(*) AS commandes,
       COUNT(DISTINCT soh.CustomerID) AS clients,
       SUM(CASE WHEN soh.OnlineOrderFlag = 1 THEN soh.SubTotal ELSE 0 END) AS ca_en_ligne
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
WHERE {FILTRE}
""")

CA_MENSUEL = _requete(f"""
SELECT DATEFROMPARTS(YEAR(soh.OrderDate), MONTH(soh.OrderDate), 1) AS mois,
       SUM(soh.SubTotal) AS ca,
       COUNT(*) AS commandes
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
WHERE {FILTRE}
GROUP BY DATEFROMPARTS(YEAR(soh.OrderDate), MONTH(soh.OrderDate), 1)
ORDER BY mois
""")

CA_PAR_CATEGORIE = _requete(f"""
SELECT pc.Name AS categorie,
       SUM(sod.LineTotal) AS ca,
       SUM(sod.OrderQty) AS quantite
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
JOIN Production.Product p ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory pc ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE {FILTRE}
GROUP BY pc.Name
ORDER BY ca DESC
""")

CA_PAR_TERRITOIRE = _requete(f"""
SELECT st.Name AS territoire,
       st.[Group] AS groupe,
       SUM(soh.SubTotal) AS ca,
       COUNT(*) AS commandes
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
WHERE {FILTRE}
GROUP BY st.Name, st.[Group]
ORDER BY ca DESC
""")

TOP_PRODUITS = _requete(f"""
SELECT TOP 10 p.Name AS produit,
       SUM(sod.LineTotal) AS ca,
       SUM(sod.OrderQty) AS quantite
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
JOIN Production.Product p ON p.ProductID = sod.ProductID
WHERE {FILTRE}
GROUP BY p.Name
ORDER BY ca DESC
""")

TOP_VENDEURS = _requete(f"""
SELECT TOP 10 CONCAT_WS(' ', pp.FirstName, pp.LastName) AS vendeur,
       SUM(soh.SubTotal) AS ca,
       COUNT(*) AS commandes
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID
JOIN Person.Person pp ON pp.BusinessEntityID = soh.SalesPersonID
WHERE {FILTRE}
GROUP BY CONCAT_WS(' ', pp.FirstName, pp.LastName)
ORDER BY ca DESC
""")
