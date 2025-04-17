WITH fechaMasReciente AS (
    SELECT MAX(v.Fecha) AS Fecha
    FROM Vuelo v
),
edadAviones AS (
    SELECT av.Matricula, EXTRACT(YEAR FROM (SELECT Fecha FROM fechaMasReciente)) - TO_NUMBER(av.Agno) AS Edad
    FROM Avion av
    WHERE av.Agno IS NOT NULL
),
MediaEdadPorAeropuerto AS (
    SELECT a.IATA, a.Ciudad AS NombreAeropuerto, AVG(e.Edad) AS MediaEdad
    FROM Aeropuerto a
    JOIN Vuelo v ON a.IATA = v.IATAsali OR a.IATA = v.IATAdest
    JOIN EdadAviones e ON v.Matricula = e.Matricula
    GROUP BY a.IATA, a.Ciudad
)
SELECT IATA AS CodigoAeropuerto, NombreAeropuerto, MediaEdad AS MediaEdadAviones
FROM MediaEdadPorAeropuerto
WHERE MediaEdad = (SELECT MIN(MediaEdad) FROM MediaEdadPorAeropuerto);