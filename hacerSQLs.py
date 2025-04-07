import csv

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Aviones.csv") as fichero_aviones:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\aviones.sql", mode='w', encoding='utf-8', newline='') as avion_sql:
        aviones_reader = csv.reader(fichero_aviones, delimiter=';')
        for aviones in aviones_reader:
            MATRICULA, AGNO, ID_MODELO = aviones
            sql = f"INSERTO INTO Avion (matricula, agno, id_modelo) VALUES ('{MATRICULA}', '{AGNO}', '{ID_MODELO}');\n"
            avion_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Aeropuertos.csv") as fichero_aero:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\aeropuertos.sql", mode='w', encoding='utf-8', newline='') as aero_sql:
        aero_reader = csv.reader(fichero_aero, delimiter=';')
        for aero in aero_reader:
            IATA, ESTADO, PAIS, CIUDAD = aero
            sql = f"INSERTO INTO Aeropuerto (IATA, estado, pais, ciudad) VALUES ('{IATA}', '{ESTADO}', '{PAIS}', {CIUDAD});\n"
            aero_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Cancelaciones.csv") as fichero_cancelaciones:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\cancelaciones.sql", mode='w', encoding='utf-8', newline='') as cance_sql:
        cance_reader = csv.reader(fichero_cancelaciones, delimiter=';')
        for cance in cance_reader:
            ID, ID_VUELO, CAUSA = cance
            sql = f"INSERTO INTO Cancelacion (ID, ID_VUELO, causa) VALUES ('{ID}', '{ID_VUELO}', '{CAUSA}');\n"
            cance_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Compagnias.csv") as fichero_compagnias:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\compagnias.sql", mode='w', encoding='utf-8', newline='') as compagnias_sql:
        comp_reader = csv.reader(fichero_compagnias, delimiter=';')
        for comp in comp_reader:
            Codigo, Nombre = comp
            sql = f"INSERTO INTO Compagnia (Codigo, Nombre) VALUES ('{Codigo}', '{Nombre}');\n"
            compagnias_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Desvios.csv") as fichero_desvios:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\Desvios.sql", mode='w', encoding='utf-8', newline='') as desvios_sql:
        desv_reader = csv.reader(fichero_desvios, delimiter=';')
        for desv in desv_reader:
            ID_Vuelo, ID_Desvio, IATA = desv
            sql = f"INSERTO INTO Desvio (ID_Vuelo, ID_Desvio, Aeropuerto) VALUES ('{ID_Vuelo}', '{ID_Desvio}', '{IATA}');\n"
            desvios_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Fabricantes.csv") as fichero_fabricantes:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\fabricantes.sql", mode='w', encoding='utf-8', newline='') as fabricantes_sql:
        fabric_reader = csv.reader(fichero_fabricantes, delimiter=';')
        for fabric in fabric_reader:
            fabricante = fabric[0]
            sql = f"INSERTO INTO Fabricante (Fabricante) VALUES ('{fabricante}');\n"
            fabricantes_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Modelos.csv") as fichero_modelos:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\modelos.sql", mode='w', encoding='utf-8', newline='') as modelos_sql:
        modelos_reader = csv.reader(fichero_modelos, delimiter=';')
        for modelo in modelos_reader:
            ID, Nombre, Motor, Fabricante = modelo
            sql = f"INSERTO INTO Modelo (ID, Nombre, Motor, Fabricante) VALUES ('{ID}', '{Nombre}', '{Motor}','{fabricante}');\n"
            modelos_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Retrasos.csv") as fichero_retrasos:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\Retrasos.sql", mode='w', encoding='utf-8', newline='') as retrasos_sql:
        retrasos_reader = csv.reader(fichero_retrasos, delimiter=';')
        for retraso in retrasos_reader:
            ID, ID_VUELO, Motivo, Duracion = retraso
            sql = f"INSERTO INTO Retraso (ID, ID_VUELO, Motivo, Duracion) VALUES ('{ID}', '{ID_VUELO}', '{Motivo}','{Duracion}');\n"
            retrasos_sql.write(sql)

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Vuelos.csv") as fichero_vuelos:
    with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\SQL\\Vuelos.sql", mode='w', encoding='utf-8', newline='') as vuelos_sql:
        vuelos_reader = csv.reader(fichero_vuelos, delimiter=';')
        for vuelo in vuelos_reader:
            ID, NUMERO, FECHA, HoraSalida, HoraSalidaEsperada, HoraLlegada, HoraLlegadaEstimada, Matricula, IATALlegada, IATASalida, AvionUsado, Company = vuelo
            sql = f"INSERTO INTO Vuelo (ID, Numero_Vuelo, Fecha, Hora_Salida, Hora_Salida_Esperada, Hola_Llegada, Hora_Llegada_Estimada, Matricula, Aeropuerto_Llegada, Aeropuerto_Salida, Avion_Usado, Compagnia) VALUES ('{ID}', '{NUMERO}', '{FECHA}','{HoraSalida}', '{HoraSalidaEsperada}', '{HoraLlegada}' , '{HoraLlegadaEstimada}', '{Matricula}', '{IATALlegada}', '{IATASalida}', '{AvionUsado}', '{Company}');\n"
            vuelos_sql.write(sql)

