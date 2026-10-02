# Adventure Works Database on SQL Server 2022
# Image contenant les sauvegardes AdventureWorks2019 (OLTP) et AdventureWorksDW2019 (DataWarehouse).
# Les bases sont restaurées au premier démarrage du conteneur : l'image ne contient aucun mot de passe
# et peut être publiée publiquement sur Docker Hub.
#
#   docker build -t olaffsen/adventureworks-db .
#   docker run -d -e MSSQL_SA_PASSWORD=<mot_de_passe> -p 1433:1433 --name adventureworks-db olaffsen/adventureworks-db

FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y

ADD --chown=mssql https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak /opt/adventureworks/backup/
ADD --chown=mssql https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2019.bak /opt/adventureworks/backup/
COPY --chmod=755 docker/restore-databases.sh docker/entrypoint.sh /usr/local/bin/

# Les bases restaurées sont prêtes quand AdventureWorksDW2019 (restaurée en dernier) accepte les connexions
HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=30 \
    CMD /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d AdventureWorksDW2019 -Q "SELECT 1" -o /dev/null

CMD ["/usr/local/bin/entrypoint.sh"]
