EXPLAIN PLAN FOR SELECT A.IATA, A.Nombre, A.Estado
FROM Aeropuerto A
WHERE A.IATA NOT IN (SELECT dest FROM (
    SELECT DISTINCT V.IATAdest AS dest, V.IATAsali AS sali
    FROM Vuelo V
    WHERE V.Company IN (SELECT CODE FROM (
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
    ))))) 
AND A.IATA NOT IN (SELECT sali FROM (
    SELECT DISTINCT V.IATAdest AS dest, V.IATAsali AS sali
    FROM Vuelo V
    WHERE V.Company IN (SELECT CODE FROM (
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
    ))))) 
AND A.Estado IN ('AK', 'CA');