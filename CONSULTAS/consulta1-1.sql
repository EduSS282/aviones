-- Este alias lo que va a calcular son las compañías
-- que operan al menos 1000 vuelos los días de la base
-- de datos (que son 3 en este caso).
CREATE INDEX codigo_compagnia_idx ON vuelo(Company);
CREATE VIEW COMPANIAS_VUELOS_MINIMOS AS
    SELECT 
        V.Company AS Codigo_Compania,
        V.Fecha,
        COUNT(V.ID) AS Total_Vuelos
    FROM Vuelo V
    GROUP BY V.Company, V.Fecha
    HAVING COUNT(V.ID) >= 1000;
-- Para este primer alias lo que vamos a hacer
-- es calcular el retraso promedio de los 
-- vuelos de cada compañía, con el fin
-- de luego coger la compañía necesaria.
CREATE MATERIALIZED VIEW RETRASOS_COMPAGNIAS AS
    SELECT 
	    V.Company AS Codigo_Compania,
	    AVG(R.Duracion) AS Retraso_Promedio
	FROM Vuelo V
	JOIN Retraso R ON V.ID = R.ID_Vuelo
	WHERE R.Duracion IS NOT NULL
	GROUP BY V.Company;
-- Este alias lo que hará será coger las compañías
-- que cumplan los 1000 vuelos los 3 días de datos
WITH COMPANIAS_CUMPLEN_REQUISITO_DIAS AS (
	SELECT Codigo_Compania
	FROM COMPANIAS_VUELOS_MINIMOS
	GROUP BY Codigo_Compania
	HAVING COUNT(*) = 3
)
-- Por último, se cogerán los datos de los promedios
-- de retraso antes calculados con un JOIN a las 
-- compañías que cumplen los requisitos
SELECT C.NOMBRE AS NOMBRE, RC.RETRASO_PROMEDIO
FROM RETRASOS_COMPAGNIAS RC, COMPANIAS_CUMPLEN_REQUISITO_DIAS CR, COMPAGNIA C
WHERE RC.CODIGO_COMPANIA = CR.CODIGO_COMPANIA AND C.CODIGO = CR.CODIGO_COMPANIA AND C.CODIGO = RC.CODIGO_COMPANIA;
