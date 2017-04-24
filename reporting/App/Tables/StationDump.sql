-- Holds limited information set from https://developer.nrel.gov/api/alt-fuel-stations/v1.json.
-- Loaded via ETL.
create table [App].[StationDump]
(
	[Id]                int             IDENTITY(1, 1) not null,
	[StationName]       nvarchar(500)   null,
	[City]              nvarchar(500)   null,
	[State]             nchar(2)        null, -- state code is returned
	[OwnerTypeCode]     nvarchar(2)     null,
	[FuelTypeCode]      nvarchar(4)     null,
	[FederalAgencyId]   int             null,
    [FederalAgencyName] nvarchar(500)   null,

	CONSTRAINT [PK_StationDump] PRIMARY KEY CLUSTERED ( [Id] )
);
