WITH edadMediaAeropuertos AS (
SELECT A.nombre, A.iata, AVG(2025 - AV.agno) as average
FROM aeropuerto A, vuelo V, avion AV
WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.agno IS NOT NULL
GROUP BY A.Nombre, A.IATA
)
SELECT EMA.nombre, EMA.iata, EMA.average
FROM edadMediaAeropuertos EMA
WHERE EMA.average = (
    SELECT MIN(average) as minimo
    FROM edadMediaAeropuertos
);
