-- Este alias lo que hace es asociar los aviones que pasan por
-- cada aeropuerto y asociar Aeropuerto - Edad del avión
WITH AVIONES_AEROPUERTOS AS (
SELECT DISTINCT A.nombre AS NOMBRE, A.iata AS IATA, (2025 - AV.agno) as edad, AV.MATRICULA
FROM aeropuerto A, vuelo V, avion AV
WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.AGNO IS NOT NULL
),
-- Este alias lo que hace es calcular el promedio de la edad
-- de cada aeropuerto agrupando.
PROMEDIO_EDAD AS (
    SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM AVIONES_AEROPUERTOS AA
    GROUP BY AA.NOMBRE,AA.IATA
)
-- Por último, se coge de las medias calculadas
-- la menor de todas, mediante ese WHERE PE.promedio
-- que tiene un SELECT dentro, de manera que si varios
-- tuviesen la misma media se cogiesen todos.
SELECT *
FROM PROMEDIO_EDAD PE
WHERE PE.PROMEDIO = (
    SELECT MIN(PROMEDIO) as minimo
    FROM PROMEDIO_EDAD
);
