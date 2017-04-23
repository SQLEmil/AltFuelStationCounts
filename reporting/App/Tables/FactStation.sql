create table [App].[FactStation]
(
    [Id]                    int             not null,
    [DimStatesKey]          tinyint         not null,
    [DimCitiesKey]          int             not null,
    [DimFuelTypesKey]       tinyint         not null,
    [DimOwnerTypesKey]      tinyint         not null,
    [DimFederalAgenciesKey] int             null,
    [Name]                  nvarchar(500)   null,

    constraint [PK_FactStation] primary key clustered ( [Id] )
)
