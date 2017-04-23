create procedure [dbo].[ManageStates]
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

    -- See http://www.fonz.net/blog/wp-content/uploads/2008/04/states.csv for values list. Key
    -- values arbitrarily added.
    insert @Domain ( [Key], [Name], [Code] )
    values  ( 1, N'Alabama', N'AL' ),
            ( 2, N'Alaska', N'AK' ),
            ( 3, N'Arizona', N'AZ' ),
            ( 4, N'Arkansas', N'AR' ),
            ( 5, N'California', N'CA' ),
            ( 6, N'Colorado', N'CO' ),
            ( 7, N'Connecticut', N'CT' ),
            ( 8, N'Delaware', N'DE' ),
            ( 9, N'District of Columbia', N'DC' ),
            ( 10, N'Florida', N'FL' ),
            ( 11, N'Georgia', N'GA' ),
            ( 12, N'Hawaii', N'HI' ),
            ( 13, N'Idaho', N'ID' ),
            ( 14, N'Illinois', N'IL' ),
            ( 15, N'Indiana', N'IN' ),
            ( 16, N'Iowa', N'IA' ),
            ( 17, N'Kansas', N'KS' ),
            ( 18, N'Kentucky', N'KY' ),
            ( 19, N'Louisiana', N'LA' ),
            ( 20, N'Maine', N'ME' ),
            ( 21, N'Montana', N'MT' ),
            ( 22, N'Nebraska', N'NE' ),
            ( 23, N'Nevada', N'NV' ),
            ( 24, N'New Hampshire', N'NH' ),
            ( 25, N'New Jersey', N'NJ' ),
            ( 26, N'New Mexico', N'NM' ),
            ( 27, N'New York', N'NY' ),
            ( 28, N'North Carolina', N'NC' ),
            ( 29, N'North Dakota', N'ND' ),
            ( 30, N'Ohio', N'OH' ),
            ( 31, N'Oklahoma', N'OK' ),
            ( 32, N'Oregon', N'OR' ),
            ( 33, N'Maryland', N'MD' ),
            ( 34, N'Massachusetts', N'MA' ),
            ( 35, N'Michigan', N'MI' ),
            ( 36, N'Minnesota', N'MN' ),
            ( 37, N'Mississippi', N'MS' ),
            ( 38, N'Missouri', N'MO' ),
            ( 39, N'Pennsylvania', N'PA' ),
            ( 40, N'Rhode Island', N'RI' ),
            ( 41, N'South Carolina', N'SC' ),
            ( 42, N'South Dakota', N'SD' ),
            ( 43, N'Tennessee', N'TN' ),
            ( 44, N'Texas', N'TX' ),
            ( 45, N'Utah', N'UT' ),
            ( 46, N'Vermont', N'VT' ),
            ( 47, N'Virginia', N'VA' ),
            ( 48, N'Washington', N'WA' ),
            ( 49, N'West Virginia', N'WV' ),
            ( 50, N'Wisconsin', N'WI' ),
            ( 51, N'Wyoming', N'WY' );
    
    insert @Add ( [Key] )
    select  [Key]
    from    [@Domain]
    where   not exists ( select * from [App].[DimStates] where [DimStates].[Key] = [@Domain].[Key] );
    
    insert @Update ( [Key] )
    select  [Key]
    from    [@Domain]
    where   exists (
                    select  *
                    from    [App].[DimStates]
                    where   [DimStates].[Key] = [@Domain].[Key]
                            and
                            (
                                [DimStates].[Code] != [@Domain].[Code]
                                or
                                [DimStates].[Name] != [@Domain].[Name]
                            )
                   );
    
    insert @Remove ( [Key] )
    select  [Key]
    from    [App].[DimStates]
    where   not exists ( select * from [@Domain] where [DimStates].[Key] = [@Domain].[Key] );
    
    begin try
        begin tran;

            if exists ( select * from @Add )
                insert [App].[DimStates] ( [Key], [Code], [Name] )
                select  *
                from    [@Domain]
                where   exists ( select * from [@Add] where [@Add].[Key] = [@Domain].[Key] )

            if exists ( select * from @Update )
                update  [DimStates]
                set     [Code]  = [@Domain].[Code],
                        [Name]  = [@Domain].[Name]
                from    [App].[DimStates]
                        inner join
                        [@Domain] on [@Domain].[Key] = [FuelTypes].[Key]

            if exists ( select * from @Remove )
                delete  [App].[DimStates]
                where   exists ( select * from @Remove where [@Delete].[Key] = [DimStates].[Key] );

        commit tran;
    end try

    begin catch
        rollback tran;
        throw;
    end catch;
end;

