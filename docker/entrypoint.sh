#!/bin/bash
# Démarre SQL Server et lance la restauration des bases en arrière-plan.
if [ -z "$MSSQL_SA_PASSWORD" ]; then
    echo "MSSQL_SA_PASSWORD manquant : lancer le conteneur avec -e MSSQL_SA_PASSWORD=<mot_de_passe>" >&2
    exit 1
fi

/usr/local/bin/restore-databases.sh &

# exec : SQL Server devient le processus principal et reçoit les signaux d'arrêt (docker stop)
exec /opt/mssql/bin/sqlservr
