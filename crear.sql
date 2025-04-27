CREATE TABLE Aeropuerto (
    -- La clave primaria es el IATA, el resto de atributos son obligatorios.
    -- El país en nuestro caso siempre va a ser 'USA'.
    IATA VARCHAR(3) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Estado VARCHAR(5) NOT NULL, 
    Pais VARCHAR(15) NOT NULL,
    Ciudad VARCHAR(40) NOT NULL
);

CREATE TABLE Compagnia (
    -- La clave primaria de la compañía será su código.
    -- Restricción explicada en memoria.
    Codigo VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE Fabricante (
    -- El atributo único Fabricante es clave primaria.
    Fabricante VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Modelo (
    -- Se usa una clave artificial que será clave primaria.
    -- El nombre, motor y Fabricante son atributos obligatorios.
    ID VARCHAR (4) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL,  
    Motor VARCHAR(20) NOT NULL,     
    Fabricante VARCHAR(30) NOT NULL,        
    FOREIGN KEY (Fabricante) REFERENCES Fabricante(Fabricante)
);

CREATE TABLE Avion (
    Matricula VARCHAR(6) PRIMARY KEY,
    ID_Modelo VARCHAR(30),              -- PUEDE SER NULL
    Agno VARCHAR(4),                    -- PUEDE SER NULL
    FOREIGN KEY (ID_Modelo) REFERENCES Modelo(ID)
);

CREATE TABLE Vuelo (
    -- Como se puede observar, ID, que es la clave artificial es la clave primaria de la entidad.
    ID VARCHAR (5) PRIMARY KEY,
    -- El numero de vuelo no puede ser nulo.
    Numero VARCHAR(4) NOT NULL,
    -- La fecha del vuelo no puede ser nula.
    Fecha DATE NOT NULL,
    -- La hora de salida y llegada del vuelo no pueden ser nulos.
    -- Al igual que la matrícula, el aeropuerto de destino y llegada y la compañía que opera el vuelo.
    HoraSalida NUMBER NOT NULL,
    HoraSalidaEsperada NUMBER,
    HoraLlegada NUMBER NOT NULL,
    HoraLlegadaEstimada NUMBER,
    Matricula VARCHAR(10) NOT NULL,
    IATAdest VARCHAR(3) NOT NULL,
    IATAsali VARCHAR(3) NOT NULL,
    Company VARCHAR(10) NOT NULL,
    FOREIGN KEY (Matricula) REFERENCES Avion(Matricula),
    FOREIGN KEY (IATAdest) REFERENCES Aeropuerto(IATA),
    FOREIGN KEY (IATAsali) REFERENCES Aeropuerto(IATA),
    FOREIGN KEY (Company) REFERENCES Compagnia(Codigo)
);


CREATE TABLE Cancelacion (
    -- La clave primaria es la ID del vuelo, y Causa es un atributo obligatorio.
    ID_Vuelo VARCHAR(8),
    Causa VARCHAR(20) NOT NULL,
    PRIMARY KEY (ID_Vuelo),                 
    FOREIGN KEY (ID_Vuelo) REFERENCES Vuelo(ID)
);

CREATE TABLE Desvio (
    -- La clave primaria es la clave Artificial de desvio y la clave primaria de Vuelo.
    -- La clave del aeropuerto de desvío no puede ser nulo.
    ID VARCHAR (5),
    ID_Vuelo VARCHAR(8),
    IATA_desv VARCHAR(3) NOT NULL,
    PRIMARY KEY (ID,ID_Vuelo),
    FOREIGN KEY (ID_VUELO) REFERENCES Vuelo(ID),
    FOREIGN KEY (IATA_desv) REFERENCES Aeropuerto(IATA)
);

CREATE TABLE Retraso (
    -- La clave primaria es la ID del vuelo y el motivo del retraso.
    -- La duración no puede ser ni NULO ni > 0
    ID_Vuelo VARCHAR(8),
    Motivo VARCHAR(15),
    Duracion NUMBER NOT NULL,
    PRIMARY KEY (ID_Vuelo, Motivo),
    FOREIGN KEY (ID_Vuelo) REFERENCES Vuelo(ID)
    CHECK (Duracion > 0)
);