WITH COMPAGNIA_MAX_AVIONES AS (
    SELECT C.Codigo AS CODE, C.Nombre
    FROM Compagnia C
    JOIN Vuelo V ON C.Codigo = V.Company
    GROUP BY C.Codigo, C.Nombre
    HAVING COUNT(V.Matricula) = (
        SELECT MAX(NumAviones)
        FROM (
            SELECT C2.Codigo, COUNT(V2.Matricula) AS NumAviones
            FROM Compagnia C2
            JOIN Vuelo V2 ON C2.Codigo = V2.Company
            GROUP BY C2.Codigo
        )
    )
),
AEROPUERTOS_COMPAGNIAS AS (
    SELECT DISTINCT V.IATAdest AS dest, V.IATAsali AS sali
    FROM Vuelo V
    WHERE V.Company IN (SELECT CODE FROM COMPAGNIA_MAX_AVIONES)
)
SELECT A.IATA, A.Nombre, A.Estado
FROM Aeropuerto A
WHERE A.IATA NOT IN (SELECT dest FROM AEROPUERTOS_COMPAGNIAS) AND A.IATA NOT IN (SELECT sali FROM AEROPUERTOS_COMPAGNIAS) AND A.Estado IN ('AK', 'CA');