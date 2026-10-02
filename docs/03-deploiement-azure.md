# 3) Déploiement de la base de données sur Azure

La méthode retenue est **Azure Container Instances (ACI)** : l'image Docker contenant SQL Server et les bases restaurées est publiée sur Docker Hub, puis lancée comme conteneur sur Azure. C'est la solution la moins coûteuse : on ne paie que pendant que le conteneur tourne, et on peut l'arrêter à tout moment (contrairement à Azure SQL Database, qui demande une validation préalable du responsable à cause du coût).

> Le compte Azure utilisé pour le projet n'est plus actif : cette page décrit la procédure pour redéployer la base.

## Prérequis

- Un compte Azure et [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (`az login`)
- L'image `olaffsen/adventureworks-db` publiée sur Docker Hub (automatiquement par le workflow GitHub Actions, voir le [README](../README.md#publication-des-images))

L'image ne contient aucun mot de passe : il est transmis au conteneur au lancement, et les bases sont restaurées au premier démarrage.

## 1. Créer le conteneur sur Azure

```bash
az group create --name rg-adventureworks --location francecentral

az container create \
  --resource-group rg-adventureworks \
  --name aci-adventureworks \
  --image olaffsen/adventureworks-db:latest \
  --os-type Linux \
  --cpu 2 --memory 4 \
  --ports 1433 \
  --ip-address Public \
  --dns-name-label adventureworks-<suffixe-unique> \
  --secure-environment-variables MSSQL_SA_PASSWORD=<mot_de_passe_fort>
```

`--secure-environment-variables` masque le mot de passe dans le portail et dans les réponses de l'API Azure.

SQL Server demande au moins 2 Go de mémoire ; 4 Go laissent de la marge pour les deux bases.

## 2. Se connecter

```bash
az container show --resource-group rg-adventureworks --name aci-adventureworks \
  --query "{fqdn: ipAddress.fqdn, etat: instanceView.state}" --output table
```

La restauration des bases prend 1 à 2 minutes après le démarrage (`az container logs --resource-group rg-adventureworks --name aci-adventureworks`). Dans DBeaver : hôte = le FQDN affiché (`adventureworks-<suffixe>.francecentral.azurecontainer.io`), port `1433`, utilisateur `sa`.

## 3. Maîtriser les coûts

```bash
az container stop  --resource-group rg-adventureworks --name aci-adventureworks   # arrête la facturation du calcul
az container start --resource-group rg-adventureworks --name aci-adventureworks
az group delete --name rg-adventureworks                                          # supprime tout
```

## Sécurité

- L'instance est exposée publiquement sur le port 1433 : le compte `sa` doit avoir un mot de passe fort et unique, qui ne doit jamais apparaître dans le dépôt.
- Arrêter le conteneur quand il n'est pas utilisé.
- Pour un usage réel, préférer un réseau virtuel (`--vnet`) ou Azure SQL Database avec règles de pare-feu.
