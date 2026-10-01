# Adventure Works Database on SQL Server 2022
# Dockerfile pour creer l image et restaurer les bdd AdventureWorks2019 (OLTP) et AdventureWorksDW2019 (DataWarehouse)
#
# Le mot de passe SA n est pas stocke dans le depot : il est passe au moment du build
#   docker build --build-arg MSSQL_SA_PASSWORD=<mot_de_passe> -t olaffsen/mssqlserver:adventureworks2019 .
#   docker run -p 1433:1433 --name mssqlserver --hostname mssqlserver olaffsen/mssqlserver:adventureworks2019

FROM mcr.microsoft.com/mssql/server:2022-latest

ARG MSSQL_SA_PASSWORD
ENV ACCEPT_EULA=Y

ADD --chown=mssql https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak /var/opt/mssql/backup/
ADD --chown=mssql https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2019.bak /var/opt/mssql/backup/

RUN test -n "$MSSQL_SA_PASSWORD" || (echo "MSSQL_SA_PASSWORD manquant : utiliser --build-arg MSSQL_SA_PASSWORD=..." && exit 1) \
    && ( /opt/mssql/bin/sqlservr & ) \
    && for i in $(seq 1 60); do /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" > /dev/null 2>&1 && break; sleep 2; done \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -b -Q "RESTORE DATABASE AdventureWorks2019 FROM DISK = '/var/opt/mssql/backup/AdventureWorks2019.bak' WITH MOVE 'AdventureWorks2019' TO '/var/opt/mssql/data/AdventureWorks2019.mdf', MOVE 'AdventureWorks2019_log' TO '/var/opt/mssql/data/AdventureWorks2019_log.ldf', STATS = 10" \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -b -Q "RESTORE DATABASE AdventureWorksDW2019 FROM DISK = '/var/opt/mssql/backup/AdventureWorksDW2019.bak' WITH MOVE 'AdventureWorksDW2019' TO '/var/opt/mssql/data/AdventureWorksDW2019.mdf', MOVE 'AdventureWorksDW2019_log' TO '/var/opt/mssql/data/AdventureWorksDW2019_log.ldf', STATS = 10" \
    && pkill sqlservr

CMD ["/opt/mssql/bin/sqlservr"]
