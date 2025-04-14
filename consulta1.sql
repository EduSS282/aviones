WITH VUELOS_RETRASOS AS (
    SELECT 
        V.Company AS Codigo_Compania,
        R.Duracion AS Retraso
    FROM Vuelo V
    JOIN Retraso R ON V.ID = R.ID_Vuelo
    WHERE R.Duracion IS NOT NULL
),
COMPANIAS_VUELOS_MINIMOS AS (
    SELECT 
        V.Company AS Codigo_Compania,
        V.Fecha,
        COUNT(V.ID) AS Total_Vuelos
    FROM Vuelo V
    GROUP BY V.Company, V.Fecha
    HAVING COUNT(V.ID) >= 1000
),
MEDIA_RETRASOS_COMPANIA AS (
    SELECT 
        VR.Codigo_Compania AS Company,
        AVG(VR.Retraso) AS Media_Retrasos
    FROM VUELOS_RETRASOS VR
    WHERE VR.Codigo_Compania IN (
        SELECT DISTINCT Codigo_Compania 
        FROM COMPANIAS_VUELOS_MINIMOS
    )
    GROUP BY VR.Codigo_Compania
)
SELECT 
    C.Nombre AS Compania,
    ROUND(R.Media_Retrasos, 2) AS Media_Retrasos_Minutos
FROM MEDIA_RETRASOS_COMPANIA R
JOIN Compagnia C ON R.Company = C.Codigo
ORDER BY R.Media_Retrasos ASC;