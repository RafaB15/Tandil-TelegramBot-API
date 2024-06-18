# language: es
Característica: Consultar los contenidos añadidos en la última semana
    
    Escenario: US21 - 01 Como cinefilo quiero poder visualizar las peliculas cargadas en la ultima semana
        Dado que se agrego dos nuevos peliculas esta semana "Titanic" "Juliet"
        Cuando solicito ver el ultimo contenido cargado
        Entonces visualizo un listado donde se encuentran las peliculas "Titanic" "Juliet"

    Escenario: US21 - 02 Como cinefilo no visualizo ninguna pelicula cargada la ultima semana porque no hay
        Dado que no se agrego contenido nuevo esta semana
        Cuando solicito ver el ultimo contenido cargado
        Entonces tengo un listado de vistos vacio

    Escenario: US21 - 03 Hay menos de 5 peliculas nuevos
        Dado que se agrego "Batman" hace 10 dias
        Y que se agrego "Superman" hace 2 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Superman"

    Escenario: US21 - 04 Hay peliculas pero no fueron agregados la última semana
        Dado que se agrego "pelicula1" hace 10 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces tengo un listado de vistos vacio
    
    Escenario: US21 - 05 Hay mas de 5 peliculas nuevos y me muestra los 5 mas recientes
        Dado que se agrego "Barbie" hace 6 dias
        Dado que se agrego "Cenicienta" hace 5 dias
        Dado que se agrego "Bella" hace 4 dias
        Dado que se agrego "La Sirenita" hace 3 dias
        Dado que se agrego "Jasmin" hace 2 dias
        Dado que se agrego "Aurora" hace 1 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Cenicienta" en la posicion 5
        Entonces me muestra "Bella" en la posicion 4
        Entonces me muestra "La Sirenita" en la posicion 3
        Entonces me muestra "Jasmin" en la posicion 2
        Entonces me muestra "Aurora" en la posicion 1
        Entonces me muestra 5 peliculas

    Escenario: US21 - 06 Hay 5 peliculas añadidos al mismo tiempo y me los muestra en orden alfabético
        Dado que se agrego "La Sirenita" hace 3 dias
        Dado que se agrego "Cenicienta" hace 3 dias
        Dado que se agrego "Bella" hace 3 dias
        Dado que se agrego "Aurora" hace 3 dias
        Dado que se agrego "Jasmin" hace 3 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Aurora" en la posicion 1
        Entonces me muestra "Bella" en la posicion 2
        Entonces me muestra "Cenicienta" en la posicion 3
        Entonces me muestra "Jasmin" en la posicion 4
        Entonces me muestra "La Sirenita" en la posicion 5

    Escenario: US31 - 01 Como cinefilo quiero poder visualizar el contenido cargado en la ultima semana
        Dado que se agrego la pelicula "Titanic" hace 2 dias
        Y que se agrego la serie "Juliet" hace 2 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Juliet" en la posicion 1
        Y me muestra "Titanic" en la posicion 2

    Escenario: US31 - 02 Como cinefilo no visualizo ningún contenido cargado la ultima semana porque no hay
        Dado que no se agrego contenido nuevo esta semana
        Cuando solicito ver el ultimo contenido cargado
        Entonces tengo un listado de vistos vacio

    Escenario: US31 - 03 Hay menos de 5 contenidos nuevos
        Dado que se agrego la serie "Batman" hace 10 dias
        Y que se agrego la pelicula "Iron Man" hace 8 dias
        Y que se agrego la serie "Superman" hace 2 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Superman" en la posicion 1

    Escenario: US31 - 04 Hay contenidos pero no fueron agregados la última semana
        Dado que se agrego la serie "Batman" hace 10 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces tengo un listado de vistos vacio

    Escenario: US31 - 05 Hay mas de 5 contenidos nuevos y me muestra los 5 mas recientes
        Dado que se agrego la pelicula "Barbie" hace 6 dias
        Y que se agrego la serie "Cenicienta" hace 5 dias
        Y que se agrego la serie "Bella" hace 4 dias
        Y que se agrego la pelicula "La Sirenita" hace 3 dias
        Y que se agrego la serie "Jasmin" hace 2 dias
        Y que se agrego la pelicula "Aurora" hace 1 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Aurora" en la posicion 1
        Y me muestra "Jasmin" en la posicion 2
        Y me muestra "La Sirenita" en la posicion 3
        Y me muestra "Bella" en la posicion 4
        Y me muestra "Cenicienta" en la posicion 5

    @current
    Escenario: US31 - 06 Hay 5 contenidos aniadidos al mismo tiempo y me los muestra en orden alfabético
        Dado que se agrego la pelicula "La Sirenita" hace 3 dias
        Y que se agrego la serie "Cenicienta" hace 3 dias
        Y que se agrego la serie "Bella" hace 3 dias
        Y que se agrego la pelicula "Aurora" hace 3 dias
        Y que se agrego la serie "Jasmin" hace 3 dias
        Cuando solicito ver el ultimo contenido cargado
        Entonces me muestra "Aurora" en la posicion 1
        Y me muestra "Bella" en la posicion 2
        Y me muestra "Cenicienta" en la posicion 3
        Y me muestra "Jasmin" en la posicion 4
        Y me muestra "La Sirenita" en la posicion 5