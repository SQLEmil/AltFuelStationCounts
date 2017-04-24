create procedure [App].[LoadDataMart]
as
begin
    set nocount on;

    if exists ( select * from [App].[FactStation] )
        throw 50000, N'Data mart is already loaded!', 0;

    begin try
        begin tran;

        --=========================================================================================
        -- Load dimension data
        --=========================================================================================
        insert [App].[DimFederalAgencies] ( [Key], [Name] )
        select  distinct
                [FederalAgencyId],
                [FederalAgencyName]
        from    [App].[StationDump]
        where   [FederalAgencyId] is not null;
        
        -- See http://www.fonz.net/blog/wp-content/uploads/2008/04/states.csv for values list. Key
        -- values arbitrarily added.
        insert [App].[DimStates] ( [Key], [Name], [Code] )
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

        insert [App].[DimCities] ( [StateKey], [Name] )
        select  distinct
                [DimStates].[Key],
                [StationDump].[City]
        from    [App].[StationDump]
                inner join
                [App].[DimStates] on [DimStates].[Code] = [StationDump].[State]
        where   [State] is not null;

        -- See https://developer.nrel.gov/docs/transportation/alt-fuel-stations-v1/all/ for values
        -- list. Key values arbitrarily added.
        insert [App].[DimFuelTypes] ( [Key], [Code], [Name] )
        values  ( 1, N'BD', N'Biodiesel (B20 and above)' ),
                ( 2, N'CNG', N'Compressed Natural Gas' ),
                ( 3, N'E85', N'Ethanol (E85)' ), 
                ( 4, N'ELEC', N'Electric' ),
                ( 5, N'HY', N'Hydrogen' ),
                ( 6, N'LNG', N'Liquefied Natural Gas' ),
                ( 7, N'LPG', N'Liquefied Petroleum Gas (Propane)' );
    
        -- See https://developer.nrel.gov/docs/transportation/alt-fuel-stations-v1/all/ for values
        -- list. Key values arbitrarily added.
        insert [App].[DimOwnerTypes] ( [Key], [Code], [Name] )
        values  ( 1, N'P', N'Privately owned' ),
                ( 2, N'T', N'Utility owned' ),
                ( 3, N'FG', N'Federal government owned' ),
                ( 4, N'LG', N'Local government owned' ),
                ( 5, N'SG', N'State government owned' ),
                ( 6, N'J', N'Jointly owned (combination of owner types)' );
        
        --=========================================================================================
        -- Load fact data
        --=========================================================================================
        insert [App].[FactStation] (
            [DimStatesKey],
            [DimCitiesId],
            [DimFuelTypesKey],
            [DimOwnerTypesKey],
            [DimFederalAgenciesKey],
            [Name]
            )
        select  [DimStatesKey]          = [DimStates].[Key],
                [DimCitiesId]           = [DimCities].[Id],
                [DimFuelTypesKey]       = [DimFuelTypes].[Key],
                [DimOwnerTypesKey]      = [DimOwnerTypes].[Key],
                [DimFederalAgenciesKey] = [StationDump].[FederalAgencyId],
                [Name]                  = [StationDump].[StationName]
        from    [App].[StationDump]
                inner join
                [App].[DimStates] on [DimStates].[Code] = [StationDump].[State]
                inner join
                [App].[DimCities] on [DimCities].[Name] = [StationDump].[City]
                inner join
                [App].[DimFuelTypes] on [DimFuelTypes].[Code] = [StationDump].[FuelTypeCode]
                inner join
                [App].[DimOwnerTypes] on [DimOwnerTypes].[Code] = [StationDump].[OwnerTypeCode];

        commit tran;
    end try

    begin catch
        rollback tran;
        throw;
    end catch;

end;