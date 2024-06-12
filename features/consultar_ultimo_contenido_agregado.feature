# language: es
Característica: Consultar los contenidos añadidos en la última semana

    Escenario: US21 - 01 Como cinefilo quiero poder visualizar las peliculas cargadas en la ultima semana
        Dado que se agrego dos nuevos contenidos esta semana "Titanic" "Juliet"
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces visualizo un listado donde se encuentran las peliculas "Titanic" "Juliet"

    Escenario: US21 - 02 Como cinefilo no visualizo ninguna pelicula cargada la ultima semana porque no hay
        Dado que no se agrego contenido nuevo esta semana
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces tengo un listado de vistos vacio

    Escenario: US21 - 03 Hay menos de 5 contenidos nuevos
        Dado que se agrego "Batman" hace 10 dias
        Y que se agrego "Superman" hace 2 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces me muestra "Superman"

    Escenario: US21 - 04 Hay contenidos pero no fueron agregados la última semana
        Dado que se agrego "pelicula1" hace 10 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces tengo un listado de vistos vacio
    
    Escenario: US21 - 05 Hay mas de 5 contenidos nuevos y me muestra los 5 mas recientes
        Dado que se agrego "Barbie" hace 6 dias
        Dado que se agrego "Cenicienta" hace 5 dias
        Dado que se agrego "Bella" hace 4 dias
        Dado que se agrego "La Sirenita" hace 3 dias
        Dado que se agrego "Jasmin" hace 2 dias
        Dado que se agrego "Aurora" hace 1 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces me muestra "Cenicienta" en la posicion 5
        Entonces me muestra "Bella" en la posicion 4
        Entonces me muestra "La Sirenita" en la posicion 3
        Entonces me muestra "Jasmin" en la posicion 2
        Entonces me muestra "Aurora" en la posicion 1
        Entonces me muestra 5 contenidos

    Escenario: US21 - 06 Hay 5 contenidos añadidos al mismo tiempo y me los muestra en orden alfabético
        Dado que se agrego "La Sirenita" hace 3 dias
        Dado que se agrego "Cenicienta" hace 3 dias
        Dado que se agrego "Bella" hace 3 dias
        Dado que se agrego "Aurora" hace 3 dias
        Dado que se agrego "Jasmin" hace 3 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces me muestra "Aurora" en la posicion 1
        Entonces me muestra "Bella" en la posicion 2
        Entonces me muestra "Cenicienta" en la posicion 3
        Entonces me muestra "Jasmin" en la posicion 4
        Entonces me muestra "La Sirenita" en la posicion 5