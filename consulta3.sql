-- Este alias lo que hace es hacer un JOIN entre
-- aeropuerto, vuelos y avion, de manera que coge
-- los vuelos que pasan por un aeropuerto y 
-- calcula la media de edad de esos aviones.
-- Este alias lo que hace es hacer un JOIN entre
-- aeropuerto, vuelos y avion, de manera que coge
-- los vuelos que pasan por un aeropuerto y 
-- calcula la media de edad de esos aviones.
WITH AVIONES_AEROPUERTOS AS (
SELECT DISTINCT A.nombre AS NOMBRE, A.iata AS IATA, (2025 - AV.agno) as edad, AV.MATRICULA
FROM aeropuerto A, vuelo V, avion AV
WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.AGNO IS NOT NULL
),
PROMEDIO_EDAD AS (
    SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM AVIONES_AEROPUERTOS AA
    GROUP BY AA.NOMBRE,AA.IATA
)
-- Por último, se coge de las medias calculadas
-- la menor de todas, mediante ese WHERE EMA.average
-- que tiene un SELECT dentro, de manera que si varios
-- tuviesen la misma media se cogiesen todos.
SELECT *
FROM PROMEDIO_EDAD PE
WHERE PE.PROMEDIO = (
    SELECT MIN(PROMEDIO) as minimo
    FROM PROMEDIO_EDAD
);
