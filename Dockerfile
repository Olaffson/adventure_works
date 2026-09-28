# Adventure Works Database on SQL Server 2022
# Dockerfile pour creer l image et restaurer la bdd

FROM mcr.microsoft.com/mssql/server:2022-preview-ubuntu-22.04

ENV SA_PASSWORD=Olivier79
ENV ACCEPT_EULA=Y

USER root

# RUN wget -progress=bar:force -q -O AdventureWorks2019.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak \
#    && chmod 777 AdventureWorks2019.bak \
#    && mkdir /var/opt/mssql/backup \
#    && cp AdventureWorks2019.bak /var/opt/mssql/backup/

RUN wget -progress=bar:force -q -O AdventureWorksDW2019.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2019.bak \
   && chmod 777 AdventureWorksDW2019.bak \
   && mkdir /var/opt/mssql/backup \
   && cp AdventureWorksDW2019.bak /var/opt/mssql/backup/

USER mssql

# RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
#     && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P ${SA_PASSWORD} -Q 'RESTORE DATABASE AdventureWorks2019 FROM DISK = "/var/opt/mssql/backup/AdventureWorks2019.bak" WITH MOVE "AdventureWorks2019" to "/var/opt/mssql/data/AdventureWorks2019.mdf", MOVE "AdventureWorks2019_Log" to "/var/opt/mssql/data/AdventureWorks2019_log.ldf", NOUNLOAD, STATS = 5' \
#     && pkill sqlservr

RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P ${SA_PASSWORD} -Q 'RESTORE DATABASE AdventureWorksDW2019 FROM DISK = "/var/opt/mssql/backup/AdventureWorksDW2019.bak" WITH MOVE "AdventureWorksDW2019" to "/var/opt/mssql/data/AdventureWorksDW2019.mdf", MOVE "AdventureWorksDW2019_Log" to "/var/opt/mssql/data/AdventureWorksDW2019_log.ldf", NOUNLOAD, STATS = 5' \
    && pkill sqlservr

CMD ["/opt/mssql/bin/sqlservr"]

# docker build -t olaffsen/mssqlserver:adventureworksDW2019 .
# docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Olivier79" -e "MSSQL_PID=Evaluation" -p 1433:1433  --name mssqlserver --hostname mssqlserver olaffsen/mssqlserver:adventureworks2019