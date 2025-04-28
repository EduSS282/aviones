-- Primero creamos la vista materializada para la compañía con más aviones
CREATE MATERIALIZED VIEW MV_COMPAGNIA_MAX_AVIONES AS
SELECT C.Codigo AS CODE, C.Nombre
FROM Compagnia C
JOIN Vuelo V ON C.Codigo = V.Company
GROUP BY C.Codigo, C.Nombre
HAVING COUNT(DISTINCT V.Matricula) = (
    SELECT MAX(NumAviones)
    FROM (
        SELECT C2.Codigo, COUNT(DISTINCT V2.Matricula) AS NumAviones
        FROM Compagnia C2
        JOIN Vuelo V2 ON C2.Codigo = V2.Company
        GROUP BY C2.Codigo
    )
);

-- Luego creamos la vista materializada para los aeropuertos
CREATE MATERIALIZED VIEW MV_AEROPUERTOS_COMPAGNIAS AS
SELECT DISTINCT V.IATAdest AS dest, V.IATAsali AS sali
FROM Vuelo V
WHERE V.Company IN (SELECT CODE FROM MV_COMPAGNIA_MAX_AVIONES);

-- Ahora creamos índices en las vistas materializadas
CREATE INDEX idx_mv_dest ON MV_AEROPUERTOS_COMPAGNIAS(dest);
CREATE INDEX idx_mv_sali ON MV_AEROPUERTOS_COMPAGNIAS(sali);

-- Finalmente, usamos las vistas materializadas en la consulta principal
SELECT A.IATA, A.Nombre, A.Estado
FROM Aeropuerto A
WHERE A.IATA NOT IN (SELECT dest FROM MV_AEROPUERTOS_COMPAGNIAS)
  AND A.IATA NOT IN (SELECT sali FROM MV_AEROPUERTOS_COMPAGNIAS)
  AND A.Estado IN ('AK', 'CA');
