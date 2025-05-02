-- Por último, se cogerán los datos de los promedios
-- de retraso antes calculados con un JOIN a las 
-- compañías que cumplen los requisitos
EXPLAIN PLAN FOR SELECT C.NOMBRE AS NOMBRE, MC.Media_Retraso AS Media_Retraso
FROM (SELECT Codigo_Compania AS Compagnia
	FROM (
        SELECT 
            V.Company AS Codigo_Compania,
            V.Fecha,
        COUNT(V.ID) AS Total_Vuelos
        FROM Vuelo V
        GROUP BY V.Company, V.Fecha
        HAVING COUNT(V.ID) >= 1000
    )
	GROUP BY Codigo_Compania
	HAVING COUNT(*) = 3) CRD, 
    (
        SELECT NVC.Compagnia AS Compagnia, RC.Total_Retraso / NVC.Vuelos_Totales AS Media_Retraso
	    FROM (SELECT v.Company AS Compagnia, COUNT(ID) AS Vuelos_Totales
            FROM Vuelo v
            GROUP BY v.Company) NVC
	    JOIN (
        SELECT V.Company AS Codigo_Compania,
            SUM(r.Duracion) AS Total_Retraso
	    FROM Vuelo V
	    JOIN Retraso r ON V.ID = r.ID_Vuelo
	    GROUP BY V.Company) RC ON RC.Codigo_Compania = NVC.Compagnia) MC, 
    Compagnia C
WHERE CRD.Compagnia = C.Codigo AND CRD.Compagnia = MC.Compagnia AND C.Codigo = MC.Compagnia
ORDER BY Media_Retraso ASC;