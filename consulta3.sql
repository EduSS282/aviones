-- Este alias lo que hace es hacer un JOIN entre
-- aeropuerto, vuelos y avion, de manera que coge
-- los vuelos que pasan por un aeropuerto y 
-- calcula la media de edad de esos aviones.
WITH edadMediaAeropuertos AS (
    SELECT A.nombre, A.iata, AVG(2025 - AV.agno) as average
    FROM aeropuerto A, vuelo V, avion AV
    WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.agno IS NOT NULL
    GROUP BY A.Nombre, A.IATA
)
-- Por último, se coge de las medias calculadas
-- la menor de todas, mediante ese WHERE EMA.average
-- que tiene un SELECT dentro, de manera que si varios
-- tuviesen la misma media se cogiesen todos.
SELECT EMA.nombre, EMA.iata, EMA.average
FROM edadMediaAeropuertos EMA
WHERE EMA.average = (
    SELECT MIN(average) as minimo
    FROM edadMediaAeropuertos
);
