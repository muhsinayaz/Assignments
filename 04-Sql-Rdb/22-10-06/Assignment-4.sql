create or alter function faktoriel(@sayi int)
returns int
as
begin
if @sayi < 0
	set @sayi *= -1
if @sayi = 0 or @sayi = 1
	return 1
else
	declare @carpim int = 1
	while @sayi > 1
	begin
	set @carpim *= @sayi
	set @sayi -= 1
	end
return @carpim
end


select [dbo].[faktoriel](6) as sonuc