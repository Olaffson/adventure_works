### readme provisoire

# Projet Adventure Works - Optimisation des Opérations Commerciales

La direction d'Adventure Works cherche à améliorer ses opérations commerciales et augmenter ses ventes. Cela nécessite des informations détaillées sur les ventes, les produits et les clients afin de prendre des décisions éclairées. L'équipe data d'Adventure Works avait déjà mis en place les bases de la gestion des données en créant une base de données opérationnelle (OLTP) et un entrepôt de données (datawarehouse). Cependant, le projet a été interrompu car l'ingénieur data et l'analyste data ont été recrutés par Google.

Vous avez été embauché pour reprendre et compléter le travail commencé par l'équipe précédente.
Tâches à Réaliser

## 1) Récupération et Configuration des Données

    Restaurer les bases de données à partir des fichiers de sauvegarde (.bak): AdventureWorks2019.bak et AdventureWorksDW2019.bak.
    Configurer les bases de données en local.
    Utiliser un outil pour se connecter aux bases de données.
    Créer un diagramme entité-relation (ERD) pour visualiser la structure des données.
    Expliquer le rôle de chaque base de données, leur utilité et leur lien entre elles.
    Introduire le concept d'ETL (Extract, Transform, Load).
    Définir les termes : OLTP, OLAP, DataWarehouse, DataLake, DataMart et DataMesh.

## 2) Requêtes SQL pour l'OLTP

    Convertir 100 problématiques récurrentes de l'équipe BI en requêtes SQL.
    Sauvegarder ces requêtes dans un script.
    Réaliser les 50 premières requêtes en SQL pour démontrer vos compétences.

## 3) Déploiement de la Base de Données sur Azure (DataWarehouse)

    Déployer la base de données sur Azure en utilisant une méthode au choix (instance de conteneur ou Azure SQL Databases).
    Si Azure SQL Databases est choisi, valider la configuration avec le responsable pour éviter des coûts élevés.

## 4) Création d'un Tableau de Bord

    Concevoir un tableau de bord pour l'équipe de direction permettant de suivre les activités de l'entreprise.
    Utiliser les requêtes SQL précédemment créées comme base pour le tableau de bord.
    Choix des technologies pour le tableau de bord : Django, PowerBI, Streamlit, etc.

## Objectifs

    Terminer la mise en place des bases de données OLTP et DataWarehouse.
    Réaliser des requêtes SQL pour répondre aux besoins opérationnels (OLTP).
    Déployer la base de données sur Azure en respectant les contraintes budgétaires (DataWarehouse).
    Créer un tableau de bord fonctionnel pour le suivi d'activité de l'entreprise.


# Réalisation

J'ai utilisé le fichier `dockerfile` pour creer une image d'un ms sql server, restaurer la bdd adventure works 2019 et à l'aide de dbeaver je me suis connecté au container en local pour réaliser des requetes, elles sont enregistrées sur le fichier `script.sql`.

L'image a été poussé sur dockerhub et déployé sur azure dans une instance de container.