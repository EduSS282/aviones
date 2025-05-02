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
    HoraSalida NUMBER,
    HoraSalidaEsperada NUMBER,
    HoraLlegada NUMBER,
    HoraLlegadaEstimada NUMBER,
    Matricula VARCHAR(10),
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
);

/*
 * TRIGGER: verificar_IATA
 * 
 * PROPÓSITO: Validar que los códigos IATA de aeropuertos en los vuelos 
 * cumplan con el formato estándar internacional (3 letras mayúsculas).
 * 
 * ACCIÓN: Se ejecuta antes de insertar o actualizar un registro en la tabla Vuelo
 */
CREATE OR REPLACE TRIGGER verificar_IATA
BEFORE INSERT OR UPDATE ON Vuelo
FOR EACH ROW
BEGIN
    -- Valida que el código IATA de salida tenga exactamente 3 letras mayúsculas
    IF NOT REGEXP_LIKE(:NEW.IATAsali, '^[A-Z]{3}$') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error: El IATA de salida debe tener exactamente 3 letras mayúsculas.');
    END IF;
    
    -- Valida que el código IATA de destino tenga exactamente 3 letras mayúsculas
    IF NOT REGEXP_LIKE(:NEW.IATAdest, '^[A-Z]{3}$') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error: El IATA de destino debe tener exactamente 3 letras mayúsculas.');
    END IF;
END;
/

/*
 * TRIGGER: validar_matricula_vuelo
 * 
 * PROPÓSITO: Garantizar que las matrículas de aviones sigan el formato estándar
 * utilizado en los registros de la FAA (Administración Federal de Aviación de EE.UU.)
 * 
 * ACCIÓN: Se ejecuta antes de insertar un registro en la tabla Vuelo
 */
CREATE OR REPLACE TRIGGER validar_matricula_vuelo
BEFORE INSERT ON Vuelo
FOR EACH ROW
BEGIN
  -- Valida que la matrícula cumpla con el formato estándar:
  -- Debe comenzar con N seguido de 1 a 6 caracteres alfanuméricos
  IF NOT REGEXP_LIKE(:NEW.Matricula, '^N[0-9A-Z]{1,6}$') THEN
      RAISE_APPLICATION_ERROR(-20004, 'Error: La matrícula debe seguir el formato N seguido de 1-6 caracteres alfanuméricos');
  END IF;
END;
/

/*
 * TRIGGER: validar_desvio
 * 
 * PROPÓSITO: Este trigger realiza múltiples validaciones para garantizar la 
 * integridad de los datos en la tabla Desvio, verificando que:
 * 1. El vuelo referenciado exista
 * 2. El aeropuerto de desvío no sea el mismo que el de origen
 * 3. El aeropuerto de desvío exista en la base de datos
 * 4. El código IATA del aeropuerto de desvío tenga el formato correcto
 *
 * ACCIÓN: Se ejecuta antes de insertar o actualizar un registro en la tabla Desvio
 */
CREATE OR REPLACE TRIGGER validar_desvio
BEFORE INSERT OR UPDATE ON Desvio
FOR EACH ROW
DECLARE
    v_iata_origen VARCHAR2(3);  -- Almacena IATA de origen del vuelo
    v_existe_aeropuerto NUMBER; -- Para verificar existencia del aeropuerto de desvío
    v_existe_vuelo NUMBER;      -- Para verificar existencia del vuelo
BEGIN
    -- 1. Verificar que el vuelo existe
    -- Es importante validar esto primero para evitar referencias huérfanas
    BEGIN
        SELECT COUNT(*) INTO v_existe_vuelo
        FROM Vuelo
        WHERE ID = :NEW.ID_Vuelo;
        
        IF v_existe_vuelo = 0 THEN
            RAISE_APPLICATION_ERROR(-20008, 'Error: El vuelo ' || :NEW.ID_Vuelo || ' no existe');
        END IF;
    END;   
    -- 2. Obtener aeropuerto de origen del vuelo
    -- Utilizamos un bloque separado para manejar específicamente la excepción NO_DATA_FOUND
    BEGIN
        SELECT IATAsali INTO v_iata_origen 
        FROM Vuelo 
        WHERE ID = :NEW.ID_Vuelo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20009, 'Error: No se pudo obtener el aeropuerto de origen del vuelo');
    END;   
    -- 3. Validar que el aeropuerto de desvío no sea el mismo que el de origen
    -- Un avión no debería desviarse al mismo aeropuerto del que despegó
    IF :NEW.IATA_desv = v_iata_origen THEN
        RAISE_APPLICATION_ERROR(-20007, 'Error: El aeropuerto de desvio no puede ser el mismo (' || 
                                       :NEW.IATA_desv || ') que el de origen');
    END IF;
    -- 4. Verificar que el aeropuerto de desvío exista
    -- El aeropuerto de desvío debe estar registrado en nuestra base de datos
    BEGIN
        SELECT COUNT(*) INTO v_existe_aeropuerto
        FROM Aeropuerto
        WHERE IATA = :NEW.IATA_desv;
        IF v_existe_aeropuerto = 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Error: El aeropuerto de desvio ' || :NEW.IATA_desv || ' no existe');
        END IF;
    END;
    -- 5. Validación adicional: formato IATA (3 letras mayúsculas)
    -- Aunque debería ser garantizado por las restricciones en la tabla Aeropuerto,
    -- realizamos esta validación como capa adicional de seguridad
    IF NOT REGEXP_LIKE(:NEW.IATA_desv, '^[A-Z]{3}$') THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: El código IATA de desvío debe tener 3 letras mayusculas');
    END IF;
EXCEPTION
    -- Captura de cualquier otra excepción no manejada específicamente
    WHEN OTHERS THEN
        -- Registrar error adicional si ocurre (para depuración)
        DBMS_OUTPUT.PUT_LINE('Error en validar_desvio: ' || SQLERRM);
        RAISE;  -- Relanzar el error original para mantener la trazabilidad
END;
/