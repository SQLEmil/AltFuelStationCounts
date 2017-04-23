create procedure [dbo].[ManageFuelTypes]
as
begin
    set nocount on;

    declare @Domain table (
        [Key]   tinyint         not null,
        [Code]  nvarchar(4)     not null,
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
    values  ( 1, N'BD', N'Biodiesel (B20 and above)' ),
            ( 2, N'CNG', N'Compressed Natural Gas' ),
            ( 3, N'E85', N'Ethanol (E85)' ), 
            ( 4, N'ELEC', N'Electric' ),
            ( 5, N'HY', N'Hydrogen' ),
            ( 6, N'LNG', N'Liquefied Natural Gas' ),
            ( 7, N'LPG', N'Liquefied Petroleum Gas (Propane)' );
    
    insert @Add ( [Key] )
    select  [Key]
    from    [@Domain]
    where   not exists ( select * from [App].[DimFuelTypes] where [FuelTypes].[Key] = [@Domain].[Key] );
    
    insert @Update ( [Key] )
    select  [Key]
    from    [@Domain]
    where   exists (
                    select  *
                    from    [App].[DimFuelTypes]
                    where   [FuelTypes].[Key] = [@Domain].[Key]
                            and
                            (
                                [FuelTypes].[Code] != [@Domain].[Code]
                                or
                                [FuelTypes].[Name] != [@Domain].[Name]
                            )
                   );
    
    insert @Remove ( [Key] )
    select  [Key]
    from    [App].[DimFuelTypes]
    where   not exists ( select * from [@Domain] where [FuelTypes].[Key] = [@Domain].[Key] );
    
    begin try
        begin tran;

            if exists ( select * from @Add )
                insert [App].[DimFuelTypes] ( [Key], [Code], [Name] )
                select  *
                from    [@Domain]
                where   exists ( select * from [@Add] where [@Add].[Key] = [@Domain].[Key] )

            if exists ( select * from @Update )
                update  [DimFuelTypes]
                set     [Code]  = [@Domain].[Code],
                        [Name]  = [@Domain].[Name]
                from    [App].[DimFuelTypes]
                        inner join
                        [@Domain] on [@Domain].[Key] = [FuelTypes].[Key]

            if exists ( select * from @Remove )
                delete  [App].[DimFuelTypes]
                where   exists ( select * from @Remove where [@Delete].[Key] = [FuelTypes].[Key] );

        commit tran;
    end try

    begin catch
        rollback tran;
        throw;
    end catch;
end;