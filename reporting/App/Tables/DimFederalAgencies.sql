-- Loaded via ETL process.
create table [App].[DimFederalAgencies]
(
    [Id]        int             IDENTITY(1, 1) not null,
    [Name]      nvarchar(500)   not null,

    constraint [PK_DimFederalAgencies] primary key clustered ( [Id] )
);
