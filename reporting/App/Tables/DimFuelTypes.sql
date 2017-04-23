-- See https://developer.nrel.gov/docs/transportation/alt-fuel-stations-v1/all/. Loaded via post-
-- deployment script.
CREATE TABLE [App].[DimFuelTypes]
(
	[Key]   tinyint         not null,
	[Code]  nvarchar(4)     not null,
	[Name]  nvarchar(40)    not null,
	
	constraint [PK_DimFuelTypes] PRIMARY KEY CLUSTERED ( [Key] )
);
