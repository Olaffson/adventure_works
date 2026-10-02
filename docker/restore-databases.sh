#!/bin/bash
# Restaure AdventureWorks2019 et AdventureWorksDW2019 au premier démarrage du conteneur.
# Le mot de passe SA est fourni à l'exécution (variable MSSQL_SA_PASSWORD) : il n'est jamais stocké dans l'image.

SQLCMD=(/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -b)
BACKUP_DIR=/opt/adventureworks/backup

# Attend que SQL Server accepte les connexions (2 minutes maximum)
for i in $(seq 1 60); do
    "${SQLCMD[@]}" -Q "SELECT 1" > /dev/null 2>&1 && break
    sleep 2
done

for db in AdventureWorks2019 AdventureWorksDW2019; do
    if [ "$("${SQLCMD[@]}" -h -1 -W -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = '$db'")" = "1" ]; then
        echo "[restore] $db existe déjà, restauration ignorée"
        continue
    fi
    echo "[restore] Restauration de $db..."
    "${SQLCMD[@]}" -Q "RESTORE DATABASE [$db] FROM DISK = '$BACKUP_DIR/$db.bak'
        WITH MOVE '$db' TO '/var/opt/mssql/data/$db.mdf',
             MOVE '${db}_log' TO '/var/opt/mssql/data/${db}_log.ldf',
             STATS = 25" \
        && echo "[restore] $db restaurée" \
        || echo "[restore] ERREUR : échec de la restauration de $db"
done
