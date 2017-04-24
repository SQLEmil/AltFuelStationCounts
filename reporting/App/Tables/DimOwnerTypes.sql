﻿-- See https://developer.nrel.gov/docs/transportation/alt-fuel-stations-v1/all/ Loaded via post-
-- deployment script.
CREATE TABLE [App].[DimOwnerTypes]
(
	[Key]   tinyint         not null,
	[Code]  nvarchar(2)     not null,
	[Name]  nvarchar(50)    not null,
	
	constraint [PK_DimOwnerTypes] PRIMARY KEY CLUSTERED ( [Key] )
);
