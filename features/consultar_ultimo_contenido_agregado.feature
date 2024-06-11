# language: es
Caracteristica: Consultar los contenidos añadidos en la última semana

    @wip
    Escenario: US21 - 01 Como cinefilo quiero poder visualizar las peliculas cargadas en la ultima semana
        Dado que se agrego dos nuevos contenidos esta semana
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces visualizo un listado donde se encuentran las peliculas

    @wip
    Escenario: US21 - 02 Como cinefilo no visualizo ninguna pelicula cargada la ultima semana porque no hay
        Dado que no se agrego contenido nuevo esta semana
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces tengo un listado de vistos vacio