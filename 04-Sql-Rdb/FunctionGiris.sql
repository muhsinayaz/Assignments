

DECLARE @miktar DECIMAL(18, 2)
SET @miktar = 2542.37

DECLARE @para_tablosu TABLE (
    para DECIMAL(18, 2),
    adet INT
)

INSERT INTO @para_tablosu (para, adet)
VALUES (200, 0), (100, 0), (50, 0), (20, 0), (10, 0), (5, 0), (1, 0), (0.5, 0), (0.25, 0), (0.1, 0), (0.05, 0), (0.01, 0)

DECLARE @para DECIMAL(18, 2)
DECLARE @adet INT

DECLARE para_cursor CURSOR FOR
SELECT para
FROM @para_tablosu
ORDER BY para DESC

OPEN para_cursor

FETCH NEXT FROM para_cursor INTO @para

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @adet = @miktar / @para
    UPDATE @para_tablosu
    SET adet = @adet
    WHERE para = @para

    SET @miktar = @miktar - (@adet * @para)

    FETCH NEXT FROM para_cursor INTO @para
END

CLOSE para_cursor
DEALLOCATE para_cursor

SELECT para, adet
FROM @para_tablosu
WHERE adet > 0
ORDER BY para DESC



--Soru 2

--Fonksiyon

CREATE FUNCTION dbo.ValidateTCKimlik (
    @tckimlik NVARCHAR(11)
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0;
    
    IF LEN(@tckimlik) = 11
    BEGIN
        DECLARE @digit1 INT, @digit2 INT, @digit3 INT, @digit4 INT, @digit5 INT,
                @digit6 INT, @digit7 INT, @digit8 INT, @digit9 INT, @digit10 INT, @digit11 INT;

        SET @digit1 = CAST(SUBSTRING(@tckimlik, 1, 1) AS INT);
        SET @digit2 = CAST(SUBSTRING(@tckimlik, 2, 1) AS INT);
        SET @digit3 = CAST(SUBSTRING(@tckimlik, 3, 1) AS INT);
        SET @digit4 = CAST(SUBSTRING(@tckimlik, 4, 1) AS INT);
        SET @digit5 = CAST(SUBSTRING(@tckimlik, 5, 1) AS INT);
        SET @digit6 = CAST(SUBSTRING(@tckimlik, 6, 1) AS INT);
        SET @digit7 = CAST(SUBSTRING(@tckimlik, 7, 1) AS INT);
        SET @digit8 = CAST(SUBSTRING(@tckimlik, 8, 1) AS INT);
        SET @digit9 = CAST(SUBSTRING(@tckimlik, 9, 1) AS INT);
        SET @digit10 = CAST(SUBSTRING(@tckimlik, 10, 1) AS INT);
        SET @digit11 = CAST(SUBSTRING(@tckimlik, 11, 1) AS INT);

        IF (@digit1 + @digit2 + @digit3 + @digit4 + @digit5 + @digit6 + @digit7 + @digit8 + @digit9 + @digit10) % 10 = @digit11
            AND ((@digit1 + @digit3 + @digit5 + @digit7 + @digit9) * 7 + (@digit2 + @digit4 + @digit6 + @digit8) * 9) % 10 = @digit10
            AND ((@digit1 + @digit3 + @digit5 + @digit7 + @digit9) * 8) % 10 = @digit11
        BEGIN
            SET @isValid = 1;
        END
    END

    RETURN @isValid;
END;


--Sorgu--

DECLARE @tckimlik NVARCHAR(11) = '48538377454';

IF dbo.ValidateTCKimlik(@tckimlik) = 1
BEGIN
    PRINT 'TC kimlik numarasý geçerlidir.';
END
ELSE
BEGIN
    PRINT 'TC kimlik numarasý geçerli deðildir.';
END


--Soru-3

CREATE FUNCTION  dbo.KdvIskontoHesapla(
	@urun_fiyati decimal(10,0),
	@kdv_orani decimal(5,0),
	@iskonto_orani decimal(5,0)
	)

RETURNS  TABLE 
AS
RETURN

(
SELECT CAST((@urun_fiyati * @iskonto_orani /100) AS ÝNT) AS ÝskontoMiktarý,
		CAST((@urun_fiyati - (@urun_fiyati * @iskonto_orani /100)) * @kdv_orani/100 AS INT) as KdvMiktarý,
		CAST(@urun_fiyati - (@urun_fiyati * @iskonto_orani /100) +(@urun_fiyati - (@urun_fiyati * @iskonto_orani /100)) * @kdv_orani/100 AS INT) AS ToplamMiktar
)


SELECT * FROM dbo.KdvIskontoHesapla(100,18,10)

