CREATE TABLE Aeropuerto (
    IATA VARCHAR(3) PRIMARY KEY,
    Nombre VARCHAR(50),
    Estado VARCHAR(5),              -- Contemplamos que puedan ser NULL
    Pais VARCHAR(15),
    Ciudad VARCHAR(40)
);

CREATE TABLE Compagnia (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Fabricante (
    Fabricante VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Modelo (
    ID VARCHAR (4) PRIMARY KEY,
    Nombre VARCHAR(20) not NULL,    -- Tiene las restricciones del modelo E-R simplemente se usa una clave artificial para simplificar.
    Motor VARCHAR(20) not NULL,     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    Fabricante VARCHAR(30),         -- Puede ser null.
    FOREIGN KEY (Fabricante) REFERENCES Fabricante(Fabricante)
);

CREATE TABLE Avion (
    Matricula VARCHAR(6) PRIMARY KEY,
    ID_Modelo VARCHAR(30),              -- PUEDE SER NULL
    Agno VARCHAR(4),                    -- PUEDE SER NULL
    FOREIGN KEY (ID_Modelo) REFERENCES Modelo(ID)
);

CREATE TABLE Vuelo (
    -- Aquí nos vuelve a pasar lo mismo y es que usamos una clave artificial para el vuelo
    -- No se si realmente la necesitamos, hay que valorarlo.
    ID VARCHAR (5) PRIMARY KEY,
    Numero VARCHAR(4),
    Fecha DATE,
    HoraSalida NUMBER,
    HoraSalidaEsperada NUMBER,
    HoraLlegada NUMBER,
    HoraLlegadaEstimada NUMBER,
    Matricula VARCHAR(10),
    IATAdest VARCHAR(3),
    IATAsali VARCHAR(3),
    Company VARCHAR(10),
    FOREIGN KEY (Matricula) REFERENCES Avion(Matricula),
    FOREIGN KEY (IATAdest) REFERENCES Aeropuerto(IATA),
    FOREIGN KEY (IATAsali) REFERENCES Aeropuerto(IATA),
    FOREIGN KEY (Company) REFERENCES Compagnia(Codigo)
);


CREATE TABLE Cancelacion (
    ID VARCHAR(5),                              -- Va a haber que cambiarlo para que tienda de INCIDENCIA
    ID_Vuelo VARCHAR(8),
    Causa VARCHAR(20),
    PRIMARY KEY (ID,ID_Vuelo),                  -- Hay que darle 2 vueltas a esto
    FOREIGN KEY (ID_Vuelo) REFERENCES Vuelo(ID)
    -- FOREIGN KEY (ID) REFERENCES Incidencia(ID)
);

CREATE TABLE Desvio (
    ID VARCHAR (5),
    ID_Vuelo VARCHAR(8),
    IATA_desv VARCHAR(3),
    PRIMARY KEY (ID,ID_Vuelo),
    FOREIGN KEY (ID_VUELO) REFERENCES Vuelo(ID),
    FOREIGN KEY (IATA_desv) REFERENCES Aeropuerto(IATA)
    -- FOREIGN KEY (ID) REFERENCES Incidencia(ID)
);

CREATE TABLE Retraso (
    ID VARCHAR (5),
    ID_Vuelo VARCHAR(8),
    Motivo VARCHAR(15),
    Duracion NUMBER,
    PRIMARY KEY (ID,ID_Vuelo),
    FOREIGN KEY (ID_Vuelo) REFERENCES Vuelo(ID)
    -- FOREIGN KEY ID REFERENCES Incidencia(ID)
);