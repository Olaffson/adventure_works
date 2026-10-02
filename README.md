# Projet Adventure Works - Optimisation des Opérations Commerciales

La direction d'Adventure Works cherche à améliorer ses opérations commerciales et augmenter ses ventes. Cela nécessite des informations détaillées sur les ventes, les produits et les clients afin de prendre des décisions éclairées. L'équipe data d'Adventure Works avait déjà mis en place les bases de la gestion des données en créant une base de données opérationnelle (OLTP) et un entrepôt de données (datawarehouse). Cependant, le projet a été interrompu car l'ingénieur data et l'analyste data ont été recrutés par Google.

Vous avez été embauché pour reprendre et compléter le travail commencé par l'équipe précédente.

## Tâches à réaliser

### 1) Récupération et configuration des données

- Restaurer les bases de données à partir des fichiers de sauvegarde (.bak) : AdventureWorks2019.bak et AdventureWorksDW2019.bak.
- Configurer les bases de données en local.
- Utiliser un outil pour se connecter aux bases de données.
- Créer un diagramme entité-relation (ERD) pour visualiser la structure des données.
- Expliquer le rôle de chaque base de données, leur utilité et leur lien entre elles.
- Introduire le concept d'ETL (Extract, Transform, Load).
- Définir les termes : OLTP, OLAP, DataWarehouse, DataLake, DataMart et DataMesh.

### 2) Requêtes SQL pour l'OLTP

- Convertir 100 problématiques récurrentes de l'équipe BI en requêtes SQL.
- Sauvegarder ces requêtes dans un script.
- Réaliser les 50 premières requêtes en SQL pour démontrer vos compétences.

### 3) Déploiement de la base de données sur Azure (DataWarehouse)

- Déployer la base de données sur Azure en utilisant une méthode au choix (instance de conteneur ou Azure SQL Databases).
- Si Azure SQL Databases est choisi, valider la configuration avec le responsable pour éviter des coûts élevés.

### 4) Création d'un tableau de bord

- Concevoir un tableau de bord pour l'équipe de direction permettant de suivre les activités de l'entreprise.
- Utiliser les requêtes SQL précédemment créées comme base pour le tableau de bord.
- Choix des technologies pour le tableau de bord : Django, PowerBI, Streamlit, etc.

## Objectifs

- Terminer la mise en place des bases de données OLTP et DataWarehouse.
- Réaliser des requêtes SQL pour répondre aux besoins opérationnels (OLTP).
- Déployer la base de données sur Azure en respectant les contraintes budgétaires (DataWarehouse).
- Créer un tableau de bord fonctionnel pour le suivi d'activité de l'entreprise.

# Réalisation

| Partie | Livrable |
|---|---|
| 1) Récupération et configuration des données | [`Dockerfile`](Dockerfile) (restauration des deux bases) et [`docs/01-bases-de-donnees.md`](docs/01-bases-de-donnees.md) : connexion, rôle des bases, ERD, ETL, définitions |
| 2) Requêtes SQL pour l'OLTP | [`sql/Script.sql`](sql/Script.sql) : 100 requêtes (1 à 50 : bases du SQL ; 51 à 100 : analyses avancées avec CTE, fonctions de fenêtrage, PIVOT, hiérarchie, achats, stocks et RH) |
| 3) Déploiement sur Azure | [`docs/03-deploiement-azure.md`](docs/03-deploiement-azure.md) : image publiée sur Docker Hub et déployée dans Azure Container Instances |
| 4) Tableau de bord | [`dashboard/`](dashboard) : application Streamlit connectée à la base OLTP |

## Lancer le projet

Les images sont publiées sur Docker Hub : [`olaffsen/adventureworks-db`](https://hub.docker.com/r/olaffsen/adventureworks-db) (SQL Server 2022 + sauvegardes AdventureWorks) et [`olaffsen/adventureworks-dashboard`](https://hub.docker.com/r/olaffsen/adventureworks-dashboard). Elles ne contiennent aucun mot de passe : le mot de passe SA est choisi au lancement, et les bases sont restaurées au premier démarrage.

### Base de données et tableau de bord (Docker Compose)

```bash
cp .env.example .env      # puis choisir un mot de passe SA dans .env
docker compose up -d      # télécharge les images depuis Docker Hub
```

- Tableau de bord : http://localhost:8501
- SQL Server : `localhost,1433`, utilisateur `sa` (DBeaver, Azure Data Studio...)

Au premier lancement, la restauration des deux bases prend environ 1 minute 30 ; le tableau de bord démarre dès qu'elles sont prêtes (`docker compose ps` affiche alors `healthy`). Les bases sont conservées dans le volume `mssql-data` : les lancements suivants prennent quelques secondes.

| Commande | Effet |
|---|---|
| `docker compose up -d --build` | construit les images à partir du code au lieu de les télécharger |
| `docker compose pull` | récupère la dernière version des images publiées |
| `docker compose down` | arrête les conteneurs (les bases sont conservées) |
| `docker compose down -v` | arrête et supprime les bases ; à faire aussi après un changement de mot de passe dans `.env` |

### Base de données seule

```bash
docker run -d -e MSSQL_SA_PASSWORD=<mot_de_passe> -p 1433:1433 --name adventureworks-db olaffsen/adventureworks-db
```

Le mot de passe doit respecter la politique de complexité de SQL Server (au moins 8 caractères avec majuscules, minuscules, chiffres et symboles).

### Publication des images

Le workflow [`.github/workflows/docker-publish.yml`](.github/workflows/docker-publish.yml) construit et publie les deux images sur Docker Hub à chaque modification de `Dockerfile`, `docker/` ou `dashboard/` sur `main` (ou manuellement depuis l'onglet *Actions*). Il nécessite, dans *Settings > Secrets and variables > Actions* :

- la **variable** `DOCKERHUB_USERNAME` : le nom du compte Docker Hub ;
- le **secret** `DOCKERHUB_TOKEN` : un jeton d'accès Docker Hub (*Account settings > Personal access tokens*, droits *Read & Write*).

## Tableau de bord

Le tableau de bord suit l'activité commerciale à partir de la base OLTP, avec des requêtes dérivées de celles de [`sql/Script.sql`](sql/Script.sql) (voir [`dashboard/queries.py`](dashboard/queries.py)) :

- indicateurs clés : chiffre d'affaires, nombre de commandes, panier moyen, clients actifs, part des ventes en ligne ;
- évolution mensuelle du chiffre d'affaires ;
- répartition par catégorie de produits et par territoire ;
- top 10 des produits et des vendeurs ;
- filtres par année et par zone géographique, et données consultables sous forme de tableaux.

![Tableau de bord](docs/img/dashboard.png)

Pour le lancer sans Docker (base déjà démarrée) :

```bash
cd dashboard
pip install -r requirements.txt
DB_PASSWORD=<mot_de_passe> streamlit run app.py
```

Sous Windows (PowerShell) : `$env:DB_PASSWORD="<mot_de_passe>"; streamlit run app.py`.

Variables disponibles : `DB_HOST` (défaut `localhost`), `DB_PORT` (`1433`), `DB_USER` (`sa`), `DB_PASSWORD`, `DB_NAME` (`AdventureWorks2019`). Pour se connecter à l'instance Azure, indiquer son adresse dans `DB_HOST`.
