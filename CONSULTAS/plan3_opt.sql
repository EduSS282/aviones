-- Por último, se coge de las medias calculadas
-- la menor de todas, mediante ese WHERE EMA.average
-- que tiene un SELECT dentro, de manera que si varios
-- tuviesen la misma media se cogiesen todos.
EXPLAIN PLAN FOR SELECT *
FROM (SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM AVIONES_AEROPUERTOS AA
    GROUP BY AA.NOMBRE,AA.IATA) PE
WHERE PE.PROMEDIO = (
    SELECT MIN(PROMEDIO) as minimo
    FROM (SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM AVIONES_AEROPUERTOS AA
    GROUP BY AA.NOMBRE,AA.IATA)
);