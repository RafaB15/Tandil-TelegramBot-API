# language: es
Característica: Consultar los contenidos añadidos en la última semana

    Escenario: US21 - 01 Como cinefilo quiero poder visualizar las peliculas cargadas en la ultima semana
        Dado que se agrego dos nuevos contenidos esta semana
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces visualizo un listado donde se encuentran las peliculas

    Escenario: US21 - 02 Como cinefilo no visualizo ninguna pelicula cargada la ultima semana porque no hay
        Dado que no se agrego contenido nuevo esta semana
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces tengo un listado de vistos vacio

    Escenario: US21 - 03 Hay menos de 5 contenidos nuevos
        Dado que se agrego "Batman" hace 10 dias
        Y que se agrego "Superman" hace 2 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces me muestra "Superman"

    @wip
    Escenario: US21 - 04 Hay contenidos pero no fueron agregados la última semana
        Dado que se agrego "pelicula1" hace 10 dias
        Cuando solicito ver las ultimas peliculas cargadas
        Entonces me indica que no hay contenidos nuevos