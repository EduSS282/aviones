import csv

aviones=[]
modelo=[]
fabricante=[]
vuelo=[]
retraso=[]
cancelacion=[]
desvio=[]
aeropuerto=[]
company=[]

# Add a counter for model IDs

def BuscarIDModelo(nombre_modelo, tipo_motor):
    global modelo, modelo_id_counter
    
    # Search for the model in the list
    for m in modelo:
        # Check if it's the model we're looking for
        if m["NOMBRE"] == nombre_modelo and m["TIPO_MOTOR"] == tipo_motor:
            return m["ID"]
        
    return ""
with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DatosVuelo.csv", encoding='utf-8') as fichero:
    file = csv.reader(fichero, delimiter=';')
    next(file)
    claveArtificialVuelo = 0
    claveArtificialModelo = 0
    claveArtificialRetraso = 0
    claveArtificialCancelacion = 0
    claveArtificialDesvio = 0
    for f in file:
        carrierCode, carrierName, flightDate, tailNum, flightNum, crsDepTime, depTime, wheelsOff, wheelsOn, crsArrTime, arrTime, cancelled, diverted, crsElapsedTime, actualElapsedTime, airTime, distance, carrierDelay, weatherDelay, nasDelay, securityDelay, lateAircraftDelay, divAirportLandings, divReachedDest, divActualElapsedTime, divArrDelay, divDistance, div1airport, div1WheelsOn, div1WheelsOff, div1TailNum, div2airport, div2WheelsOn, div2WheelsOff, div2TailNum, cancellationName, planeManufacturer, planeModel, planeAircraft_type, plane_Engine_type, planeYear, div1planeManufacturer, div1planeModel, div1planeAircraft_type, div1plane_Engine_type, div1planeYear, div2planeManufacturer, div2planeModel, div2planeAircraft_type, div2plane_Engine_type, div2planeYear, originiata, originairport, origincity, originstate, origincountry, originlat, originlon, destiata, destairport, destcity, deststate, destcountry, destlat, destlon, div1airportname, div1city, div1state, div1country, div1lat, div1lon, div2airportname, div2city, div2state, div2country, div2lat, div2lon = f
        
        if (carrierDelay != "0" and carrierDelay != ""):
            retraso_info_company = {
                "ID_RETRASO" : claveArtificialRetraso,
                "ID_VUELO" : claveArtificialVuelo,
                "MOTIVO" : "Comp operadora",
                "DURACION" : carrierDelay
            }
            retraso.append(retraso_info_company)
            claveArtificialRetraso = claveArtificialRetraso + 1

        if (weatherDelay != "0" and weatherDelay != ""):
            retraso_info_tiempo = {
                "ID_RETRASO" : claveArtificialRetraso,
                "ID_VUELO" : claveArtificialVuelo,
                "MOTIVO":  "TIEMPO",
                "DURACION": weatherDelay
            }
            retraso.append(retraso_info_tiempo)
            claveArtificialRetraso = claveArtificialRetraso + 1

        if (nasDelay != "0" and nasDelay != ""):
            retraso_info_centro_control = {
                "ID_RETRASO" : claveArtificialRetraso,                
                "ID_VUELO" : claveArtificialVuelo,
                "MOTIVO":  "CENTRO CONTROL",
                "DURACION": nasDelay
            }
            retraso.append(retraso_info_centro_control)
            claveArtificialRetraso = claveArtificialRetraso + 1
        if (securityDelay != "0" and securityDelay != "" ):
            retraso_info_seguridad = {
                "ID_RETRASO" : claveArtificialRetraso,
                "ID_VUELO" : claveArtificialVuelo,
                "MOTIVO":  "SEGURIDAD",
                "DURACION": securityDelay
            }
            retraso.append(retraso_info_seguridad)
            claveArtificialRetraso = claveArtificialRetraso + 1
        if (lateAircraftDelay != "0" and lateAircraftDelay != ""):
            retraso_info_tarde_llegada = {
                #"ID_RETRASO" : claveArtificialRetraso,
                "ID_VUELO" : claveArtificialVuelo,
                "MOTIVO":  "TIEMPO",
                "DURACION": lateAircraftDelay
            }
            retraso.append(retraso_info_tarde_llegada)
            claveArtificialRetraso = claveArtificialRetraso + 1
        if (divAirportLandings != "0" and divAirportLandings != "" and div1airport != destiata):
            desvio_info = {
                "ID_DESVIO": claveArtificialDesvio,
                "ID_VUELO" : claveArtificialVuelo,
                "AEROPUERTO" : div1airport
            }
            desvio.append(desvio_info)
            claveArtificialDesvio = claveArtificialDesvio + 1

        if (cancelled != "0" and cancelled != ""):
            cancelacion_info = {
                #"ID_CANCELACION" : claveArtificialCancelacion,
                "ID_VUELO" : claveArtificialVuelo,
                "CAUSA" : cancellationName
            }
            cancelacion.append(cancelacion_info)
            claveArtificialCancelacion = claveArtificialCancelacion + 1
        
        if (flightNum != "") :
            vuelo_info = {
                "ID" : claveArtificialVuelo,
                "NUMERO_VUELO" : flightNum,
                "FECHA" : flightDate,
                "HORA_SALIDA" : depTime,
                "HORA_SALIDA_ESPERADA" : crsDepTime,
                #"HORA_DE_DESPEGUE" : wheelsOff
                "HORA_LLEGADA" : arrTime,
                "HORA_LLEGADA_ESTIMADA" : crsArrTime,
                #"HORA_DE_ATERRIZAJE" : wheelsOn
                "MATRICULA_AVION" : tailNum,
                "AEROPUERTO_LLEGADA" : destiata,
                "AEROPUERTO_SALIDA" : originiata,
                "COMPANY" : carrierCode
            }
            vuelo.append(vuelo_info)
            claveArtificialVuelo = claveArtificialVuelo + 1

        if (planeModel != ""):
            modelo_info = {
            "ID" : claveArtificialModelo,
            "NOMBRE": planeModel,
            "TIPO_MOTOR": plane_Engine_type,
            "FABRICANTE": planeManufacturer
            }
            if not any(m["NOMBRE"] == planeModel and m["TIPO_MOTOR"] == plane_Engine_type for m in modelo):
                modelo.append(modelo_info)
                claveArtificialModelo = claveArtificialModelo + 1
        
        if (tailNum != ""):
            avion_info = {
                "MATRICULA_AVION" : tailNum,
                "AGNO_FABRICACION" : planeYear,
                "ID_MODELO" : BuscarIDModelo(planeModel,plane_Engine_type)
            }
            if not any(avion['MATRICULA_AVION'] == tailNum for avion in aviones):
                aviones.append(avion_info)

        if (planeManufacturer != ""):
            fabricante_info = {
                "FABRICANTE" : planeManufacturer
            }
            if not any(M['FABRICANTE'] == planeManufacturer for M in fabricante):
                fabricante.append(fabricante_info)

        if (originiata != ""):
            aeropuerto_salida = {
                "IATA" : originiata,
                "NOMBRE" : originairport,
                "ESTADO" : originstate,
                "PAIS" : origincountry,
                "CIUDAD" : origincity
                #"LATITUD" : originlat
                #"LONGITUD" : originlon
            }
            if not any(airport['IATA'] == originiata for airport in aeropuerto):
                aeropuerto.append(aeropuerto_salida)

            aeropuerto_llegada = {
                "IATA" : destiata,
                "NOMBRE" : destairport,
                "ESTADO" : deststate,
                "PAIS" : destcountry,
                "CIUDAD" : destcity
            }
            if not any(airport['IATA'] == destiata for airport in aeropuerto):
                aeropuerto.append(aeropuerto_llegada)

        if (carrierCode != ""):
            company_info = {
                "CODIGO" : carrierCode,
                "NOMBRE" : carrierName
            }
            if not any(com['CODIGO'] == carrierCode for com in company):
                company.append(company_info)

        

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Modelos.csv", mode='w', encoding='utf-8', newline='') as aviones_file:
    aviones_writer = csv.writer(aviones_file, delimiter=';')
    for avion in modelo:
        aviones_writer.writerow([avion['ID'] ,avion['NOMBRE'], avion['TIPO_MOTOR'], avion['FABRICANTE']])

            
with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Aviones.csv", mode='w', encoding='utf-8', newline='') as aviones_file:
    aviones_writer = csv.writer(aviones_file, delimiter=';')
    for avion in aviones:
        aviones_writer.writerow([avion['MATRICULA_AVION'], avion['AGNO_FABRICACION'], avion['ID_MODELO']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Vuelos.csv", mode='w', encoding='utf-8', newline='') as vuelos_file:
    vuelos_writer = csv.writer(vuelos_file, delimiter=';')
    for flight in vuelo:
        vuelos_writer.writerow([flight['ID'], flight['NUMERO_VUELO'], flight['FECHA'], flight['HORA_SALIDA'],flight['HORA_SALIDA_ESPERADA'], flight['HORA_LLEGADA'], flight['HORA_LLEGADA_ESTIMADA'],flight['MATRICULA_AVION'], flight['AEROPUERTO_LLEGADA'], flight['AEROPUERTO_SALIDA'], flight['COMPANY']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Fabricantes.csv", mode='w', encoding='utf-8', newline='') as fabricante_file:
    fabricante_writer = csv.writer(fabricante_file, delimiter=';')
    for manufacturer in fabricante:
        fabricante_writer.writerow([manufacturer['FABRICANTE']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Aeropuertos.csv", mode='w', encoding='utf-8', newline='') as airport_file:
    airport_writer = csv.writer(airport_file, delimiter=';')
    for airport in aeropuerto:
        airport_writer.writerow([airport['IATA'], airport['NOMBRE'],airport['ESTADO'],airport['PAIS'],airport['CIUDAD']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Compagnias.csv", mode='w', encoding='utf-8', newline='') as companies_file:
    companies_writer = csv.writer(companies_file, delimiter=';')
    for compagnia in company:
        companies_writer.writerow([compagnia['CODIGO'], compagnia['NOMBRE']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Retrasos.csv", mode='w', encoding='utf-8', newline='') as retrasos_file:
    retrasos_writer = csv.writer(retrasos_file, delimiter=';')
    for delay in retraso:
        retrasos_writer.writerow([delay['ID_VUELO'], delay['MOTIVO'], delay['DURACION']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Desvios.csv", mode='w', encoding='utf-8', newline='') as desvios_file:
    desvios_writer = csv.writer(desvios_file, delimiter=';')
    for dev in desvio:
        desvios_writer.writerow([dev['ID_DESVIO'], dev['ID_VUELO'], dev['AEROPUERTO']])

with open("C:\\Users\\eduar\\Documents\\SegundoIngInf\\SegundoCuatri\\Bases\\aviones\\DATOS\\Cancelaciones.csv", mode='w', encoding='utf-8', newline='') as cancelaciones_file:
    cancelaciones_writer = csv.writer(cancelaciones_file, delimiter=';')
    for cancellation in cancelacion:
        cancelaciones_writer.writerow([cancellation['ID_VUELO'], cancellation['CAUSA']])
