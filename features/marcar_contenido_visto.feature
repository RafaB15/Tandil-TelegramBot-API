# language: es
Característica: Marcar contenido como visto
    
Antecedentes:
    Dado un usuario "juan@gmail.com" 123456789
    Y que existe la pelicula "Iron Man" 2008 "accion" en la base de datos
    Y que existe la temporada "Game of Thrones - Temporada 3" 2011 "drama" 12 en la base de datos

    Escenario: US06 - 01 Como administrador quiero marcar el contenido visto de un usuario
        Cuando el usuario lo visualiza
        Entonces el administrador debería poder marcar el contenido como visto para ese usuario
        Y deberia ver un mensaje de la visualizacion cargada exitosamente

    @wip
    Escenario: US06 - 02 Como administrador quiero marcar un contenido inexistente visto de un usuario
        Dado que el contenido "Romance" no existe en la base de datos
        Cuando marco ese contenido como visto para este usuario
        Entonces debería devolver un mensaje "Error : Contenido inexistente"

    @wip
    Escenario: US06 - 03 Como administrador quiero marcar un contenido visto de un usuario inexistente
        Dado que no existe un usuario "rodrigo@gmail.com"
        Cuando marco un contenido como visto para un usuario inexistente
        Entonces debería devolver un mensaje "Error : Usuario inexistente"

    Escenario: US25 - 01 Como administrador quiero marcar un capitulo de una serie como visto por un usuario
        Cuando el administrador marca el capitulo 2 de la temporada como visto para el usuario
        Entonces se deberia ver un mensaje de la visualizacion cargada exitosamente

    Escenario: US25 - 02 Como administrador marco una temporada de una serie como visto por un usuario
        Cuando el administrador marca el capitulo 1 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 2 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 3 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 4 de la temporada como visto para el usuario
        Entonces la serie "Game of Thrones - Temporada 3" se contabiliza como vista


    Escenario: US25 - 03 Como administrador marco 3 capitulos de una serie como vistos por un usuario, no llega a los 4 capitulos
        Cuando el administrador marca el capitulo 1 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 2 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 3 de la temporada como visto para el usuario
        Entonces la serie "Game of Thrones - Temporada 3" NO se contabiliza como vista
    
    Escenario: US25 - 04 Como administrador repetidamente marco 2 capitulos de una serie como vistos por un usuario, no llega a los 4 capitulos
        Cuando el administrador marca el capitulo 1 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 2 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 2 de la temporada como visto para el usuario
        Y el administrador marca el capitulo 3 de la temporada como visto para el usuario
        Entonces la serie "Game of Thrones - Temporada 3" NO se contabiliza como vista