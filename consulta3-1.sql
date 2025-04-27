CREATE INDEX idx_vuelo_iatasali ON Vuelo(IATAsali);
CREATE INDEX idx_vuelo_iatadest ON Vuelo(IATAdest);
CREATE INDEX idx_vuelo_matricula ON Vuelo(Matricula);
WITH edadMediaAeropuertos AS (
SELECT AE.nombre, AE.iata, AVG(2025 - AV.agno) as media
FROM aeropuerto AE, vuelo V, avion AV
WHERE (AE.IATA = V.IATAsali or AE.iata = V.IATAdest) AND AV.matricula = V.matricula AND AV.agno IS NOT NULL
GROUP BY AE.nombre, AE.iata
)
SELECT S.nombre, S.iata, S.media
FROM edadMediaAeropuertos S
WHERE S.media = (
    SELECT MIN(media) as minimo
    FROM edadMediaAeropuertos A
);
