# language: es
Característica: Consultar los contenidos más vistos

Antecedentes: 
        Dado que existe un usuario con email "fer@gmail.com" y id_telegram 123456789
        Dado que existen 3 contenidos en la plataforma
    
    Escenario: US14 - 01 Como cinefilo quiero consultar lista de contenidos mas vistos
        Dado que hay 3 contenidos vistos en la plataforma
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de los 3 contenidos mas vistos 
    
    Escenario: US14 - 02 Mas de 3 contenidos tuvieron la misma cantidad de visualizaciones maximas se resuelve alfabeticamente
        Dado que hay 4 contenidos: "Alfa", "Beta", "Gamma", "Delta"
        Y que los 4 contenidos son los mas vistos en la plataforma con la misma cantidad de vistas
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de los 3 contenidos más vistos, seleccionados alfabéticamente: "Alfa", "Beta", "Delta"
    
    Escenario: US14 - 03 Hay menos de 3 contenidos visualizados
        Dado que solo hay 2 contenidos que obtuvieron visualizaciones
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces se ve una lista de 2 contenidos

    Escenario: US14 - 04 No hubo ninguna visualizacion
        Cuando se consulta por la lista de contenidos mas vistos
        Entonces tengo un listado de vistos vacio
        