# 3) Déploiement de la base de données sur Azure

La méthode retenue est **Azure Container Instances (ACI)** : l'image Docker contenant SQL Server et les bases restaurées est publiée sur Docker Hub, puis lancée comme conteneur sur Azure. C'est la solution la moins coûteuse : on ne paie que pendant que le conteneur tourne, et on peut l'arrêter à tout moment (contrairement à Azure SQL Database, qui demande une validation préalable du responsable à cause du coût).

## Prérequis

- Un compte Azure et [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (`az login`)
- Docker et un compte Docker Hub

## 1. Construire et publier l'image

```bash
docker build --build-arg MSSQL_SA_PASSWORD=<mot_de_passe_fort> -t olaffsen/mssqlserver:adventureworks2019 .
docker login
docker push olaffsen/mssqlserver:adventureworks2019
```

> ⚠️ Le mot de passe passé au build est stocké dans l'image (visible avec `docker history`). Utiliser un mot de passe dédié à ce déploiement, et une image **privée** sur Docker Hub si possible (ajouter alors `--registry-username` et `--registry-password` à la commande `az container create`).

## 2. Créer le conteneur sur Azure

```bash
az group create --name rg-adventureworks --location francecentral

az container create \
  --resource-group rg-adventureworks \
  --name aci-adventureworks \
  --image olaffsen/mssqlserver:adventureworks2019 \
  --os-type Linux \
  --cpu 2 --memory 4 \
  --ports 1433 \
  --ip-address Public \
  --dns-name-label adventureworks-<suffixe-unique>
```

SQL Server demande au moins 2 Go de mémoire ; 4 Go laissent de la marge pour les deux bases.

## 3. Se connecter

```bash
az container show --resource-group rg-adventureworks --name aci-adventureworks \
  --query "{fqdn: ipAddress.fqdn, etat: instanceView.state}" --output table
```

Dans DBeaver : hôte = le FQDN affiché (`adventureworks-<suffixe>.francecentral.azurecontainer.io`), port `1433`, utilisateur `sa`.

## 4. Maîtriser les coûts

```bash
az container stop  --resource-group rg-adventureworks --name aci-adventureworks   # arrête la facturation du calcul
az container start --resource-group rg-adventureworks --name aci-adventureworks
az group delete --name rg-adventureworks                                          # supprime tout
```

## Sécurité

- L'instance est exposée publiquement sur le port 1433 : le compte `sa` doit avoir un mot de passe fort et unique, qui ne doit jamais apparaître dans le dépôt.
- Arrêter le conteneur quand il n'est pas utilisé.
- Pour un usage réel, préférer un réseau virtuel (`--vnet`) ou Azure SQL Database avec règles de pare-feu.
