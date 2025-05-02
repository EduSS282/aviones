EXPLAIN PLAN FOR SELECT *
FROM (SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM (
        SELECT DISTINCT A.nombre AS NOMBRE, A.iata AS IATA, (2025 - AV.agno) as edad, AV.MATRICULA
        FROM aeropuerto A, vuelo V, avion AV
        WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.AGNO IS NOT NULL) AA
        GROUP BY AA.NOMBRE,AA.IATA) PE
WHERE PE.PROMEDIO = (
    SELECT MIN(PROMEDIO) as minimo
    FROM (SELECT AA.NOMBRE, AA.IATA, AVG(edad) AS PROMEDIO
    FROM (
        SELECT DISTINCT A.nombre AS NOMBRE, A.iata AS IATA, (2025 - AV.agno) as edad, AV.MATRICULA
        FROM aeropuerto A, vuelo V, avion AV
        WHERE (A.IATA = V.IATAsali or A.IATA = V.IATAdest) AND AV.Matricula = V.Matricula AND AV.AGNO IS NOT NULL) AA
        GROUP BY AA.NOMBRE,AA.IATA)
);
