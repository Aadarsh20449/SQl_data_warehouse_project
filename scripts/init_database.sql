use master;
--drop and re create Datawarehouse
if exists (select 1 from sys.databases where name='DataWarehouse')
begin
     alter database DataWarehouse set single_user with rollback immediate;
	 drop database DataWarehouse;
end;
go

create database DataWarehouse;

use DataWarehouse;

go
create schema bronze;
go
create schema silver;
go
create schema gold;
go
