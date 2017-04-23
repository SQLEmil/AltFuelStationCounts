-- Loaded via post-deployment script.
create table [App].[DimStates]
(
    [Key]   tinyint     not null,
    [Code]  nvarchar(2) not null,
    [Name]  nvarchar(50)    not null,

    constraint [PK_DimStates] primary key clustered ( [Key] )
);
