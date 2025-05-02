-- Para este primer alias lo que vamos a hacer
-- es calcular el retraso promedio de los 
-- vuelos de cada compañía, con el fin
-- de luego coger la compañía necesaria.
WITH Numero_Vuelos_Compagnia AS (
	SELECT v.Company AS Compagnia, COUNT(ID) AS Vuelos_Totales
	FROM Vuelo v
	GROUP BY v.Company
),
Retrasos_Compagnias AS (
	SELECT 
		V.Company AS Codigo_Compania,
		SUM(r.Duracion) AS Total_Retraso
	FROM Vuelo V
	JOIN Retraso r ON V.ID = r.ID_Vuelo
	GROUP BY V.Company
),
Media_Compagnias AS (
	SELECT NVC.Compagnia AS Compagnia, RC.Total_Retraso / NVC.Vuelos_Totales AS Media_Retraso
	FROM Numero_Vuelos_Compagnia NVC
	JOIN Retrasos_Compagnias RC ON RC.Codigo_Compania = NVC.Compagnia
),
-- Este alias lo que va a calcular son las compañías
-- que operan al menos 1000 vuelos los días de la base
-- de datos (que son 3 en este caso).
COMPANIAS_VUELOS_MINIMOS AS (
    SELECT 
        V.Company AS Codigo_Compania,
        V.Fecha,
        COUNT(V.ID) AS Total_Vuelos
    FROM Vuelo V
    GROUP BY V.Company, V.Fecha
    HAVING COUNT(V.ID) >= 1000
),
-- Este alias lo que hará será coger las compañías
-- que cumplan los 1000 vuelos los 3 días de datos
COMPANIAS_CUMPLEN_REQUISITO_DIAS AS (
	SELECT Codigo_Compania AS Compagnia
	FROM COMPANIAS_VUELOS_MINIMOS
	GROUP BY Codigo_Compania
	HAVING COUNT(*) = 3
)
-- Por último, se cogerán los datos de los promedios
-- de retraso antes calculados con un JOIN a las 
-- compañías que cumplen los requisitos
SELECT C.NOMBRE AS NOMBRE, MC.Media_Retraso AS Media_Retraso
FROM COMPANIAS_CUMPLEN_REQUISITO_DIAS CRD, Media_Compagnias MC, Compagnia C
WHERE CRD.Compagnia = C.Codigo AND CRD.Compagnia = MC.Compagnia AND C.Codigo = MC.Compagnia
ORDER BY Media_Retraso ASC;