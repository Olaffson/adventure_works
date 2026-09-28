# docker pull mcr.microsoft.com/mssql/server:2022-preview-ubuntu-22.04


# docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Olivier79%" -e "MSSQL_PID=Evaluation" -p 1433:1433  --name sqlpreview --hostname sqlpreview mcr.microsoft.com/mssql/server:2022-preview-ubuntu-22.04


# docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Olivier79%" -e "MSSQL_PID=Evaluation" -p 1433:1433  --name mssqlserver --hostname mssqlserver docker.io/olaffsen/mssqlserver:2022-preview-ubuntu-22.04


# docker cp /home/apprenant/Documents/Projets/adventure_works/data/AdventureWorks2019.bak sqlpreview:/var/opt/mssql/data/
# docker cp /home/apprenant/Documents/Projets/adventure_works/data/AdventureWorksDW2019.bak sqlpreview:/var/opt/mssql/data/


# RESTORE FILELISTONLY FROM DISK = N'/var/opt/mssql/data/AdventureWorks2019.bak'

# RESTORE DATABASE AdventureWorks2019
# FROM DISK = '/var/opt/mssql/data/AdventureWorks2019.bak'
# WITH MOVE 'AdventureWorks2019' TO '/var/opt/mssql/data/AdventureWorks2019.mdf',
#      MOVE 'AdventureWorks2019_Log' TO '/var/opt/mssql/data/AdventureWorks2019_Log.ldf',
#      REPLACE;


# RESTORE FILELISTONLY FROM DISK = N'/var/opt/mssql/data/AdventureWorksDW2019.bak'

# RESTORE DATABASE AdventureWorksDW2019
# FROM DISK = '/var/opt/mssql/data/AdventureWorksDW2019.bak'
# WITH MOVE 'AdventureWorksDW2019' TO '/var/opt/mssql/data/AdventureWorksDW2019.mdf',
#      MOVE 'AdventureWorksDW2019_Log' TO '/var/opt/mssql/data/AdventureWorksDW2019_Log.ldf',
#      REPLACE;