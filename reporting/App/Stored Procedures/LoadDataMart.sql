create procedure [App].[LoadDataMart]
as
begin
    set nocount on;

    if exists ( select * from [App].[FactStation] )
        throw 50000, N'Data mart is already loaded!', 0;

    begin try

    end try

    begin catch
        rollback tran;
        throw;
    end catch;

end;