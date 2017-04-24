-- Loaded via ETL process. Key is ID from source system
create table [App].[DimFederalAgencies]
(
    [Key]       int             not null,
    [Name]      nvarchar(500)   not null,

    constraint [PK_DimFederalAgencies] primary key clustered ( [Key] )
);
