create procedure [dbo].[ManageOwnerTypes]
as
begin
    set nocount on;

    declare @Domain table (
        [Key]   tinyint         not null,
        [Code]  nvarchar(2)     not null,
        [Name]  nvarchar(40)    not null
    );

    declare @Add table (
        [Key]   tinyint not null
        );

    declare @Update table (
        [Key]   tinyint not null
        );

    declare @Remove table (
        [Key]   tinyint not null
        );

    -- See https://developer.nrel.gov/docs/transportation/alt-fuel-stations-v1/all/ for values
    -- list. Key values arbitrarily added.
    insert @Domain ( [Key], [Code], [Name] )
    values  ( 1, N'P', N'Privately owned' ),
            ( 2, N'T', N'Utility owned' ),
            ( 3, N'FG', N'Federal government owned' ),
            ( 4, N'LG', N'Local government owned' ),
            ( 5, N'SG', N'State government owned' ),
            ( 6, N'J', N'Jointly owned (combination of owner types)' );
    
    insert @Add ( [Key] )
    select  [Key]
    from    [@Domain]
    where   not exists ( select * from [App].[DimOwnerTypes] where [DimOwnerTypes].[Key] = [@Domain].[Key] );
    
    insert @Update ( [Key] )
    select  [Key]
    from    [@Domain]
    where   exists (
                    select  *
                    from    [App].[DimOwnerTypes]
                    where   [DimOwnerTypes].[Key] = [@Domain].[Key]
                            and
                            (
                                [DimOwnerTypes].[Code] != [@Domain].[Code]
                                or
                                [DimOwnerTypes].[Name] != [@Domain].[Name]
                            )
                   );
    
    insert @Remove ( [Key] )
    select  [Key]
    from    [App].[DimOwnerTypes]
    where   not exists ( select * from [@Domain] where [DimOwnerTypes].[Key] = [@Domain].[Key] );
    
    begin try
        begin tran;

            if exists ( select * from @Add )
                insert [App].[DimOwnerTypes] ( [Key], [Code], [Name] )
                select  *
                from    [@Domain]
                where   exists ( select * from [@Add] where [@Add].[Key] = [@Domain].[Key] )

            if exists ( select * from @Update )
                update  [DimOwnerTypes]
                set     [Code]  = [@Domain].[Code],
                        [Name]  = [@Domain].[Name]
                from    [App].[DimOwnerTypes]
                        inner join
                        [@Domain] on [@Domain].[Key] = [DimOwnerTypes].[Key]

            if exists ( select * from @Remove )
                delete  [App].[DimOwnerTypes]
                where   exists ( select * from @Remove where [@Delete].[Key] = [DimOwnerTypes].[Key] );

        commit tran;
    end try

    begin catch
        rollback tran;
        throw;
    end catch;
end;