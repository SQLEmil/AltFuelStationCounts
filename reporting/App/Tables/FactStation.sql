create table [App].[FactStation]
(
    [Id]                    int             IDENTITY(1, 1) not null,
    [DimStatesKey]          tinyint         not null,
    [DimCitiesId]           int             not null,
    [DimFuelTypesKey]       tinyint         not null,
    [DimOwnerTypesKey]      tinyint         not null,
    [DimFederalAgenciesKey] int             null,
    [Name]                  nvarchar(500)   null,

    constraint [PK_FactStation] primary key clustered ( [Id] ),
    constraint [FK_FactStation_DimStates_Key] foreign key ( [DimStatesKey] ) references [App].[DimStates] ( [Key] ),
    constraint [FK_FactStation_DimCities_Id] foreign key ( [DimCitiesId] ) references [App].[DimCities] ( [Id] ),
    constraint [FK_FactStation_DimFuelTypes_Key] foreign key ( [DimFuelTypesKey] ) references [App].[DimFuelTypes] ( [Key] ),
    constraint [FK_FactStation_DimOwnerTypes_Key] foreign key ( [DimOwnerTypesKey] ) references [App].[DimOwnerTypes] ( [Key] ),
    constraint [FK_FactStation_DimFederalAgencies_Key] foreign key ( [DimFederalAgenciesKey] ) references [App].[DimFederalAgencies] ( [Key] )
);
