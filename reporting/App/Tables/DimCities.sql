-- Loaded via ETL process.
create table [App].[DimCities]
(
    [Id]        int             IDENTITY(1, 1) not null,
    [StateKey]  tinyint         not null,
    [Name]      nvarchar(500)   not null,

    constraint [PK_DimCities] primary key clustered ( [Id] )
);
