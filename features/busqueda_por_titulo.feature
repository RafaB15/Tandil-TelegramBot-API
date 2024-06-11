# language: es
Característica: Buscar contenido por título

Antecedentes:
    Dado un usuario "pepito@gmail.com" 123456789
    Y que el contenido "Titanic" 1997 "drama" existe en la base de datos

    Escenario: US08 - 01 Como cinefilo quiero buscar una pelicula por su nombre completo
        Cuando el usuario busca la pelicula "Titanic"
        Entonces debería ver la película "Titanic" listada entre las existentes

    Escenario: US08 - 02 Como cinefilo quiero buscar una pelicula por su nombre parcial
        Dado que el contenido "Catch me if you can" 2002 "comedia" existe en la base de datos
        Cuando el usuario busca la pelicula "Catch"
        Entonces debería ver la película "Catch me if you can" listada entre las existentes

    Escenario: US08 - 03 Como cinefilo quiero buscar una pelicula por su nombre en minuscula
        Cuando el usuario busca la pelicula "titanic"
        Entonces debería ver la película "Titanic" listada entre las existentes

    Escenario: US08 - 04 Como cinefilo quiero ver multiples peliculas que coincidan con mi criterio de busqueda
        Dado que el contenido "Titan" 2001 "accion" existe en la base de datos
        Cuando el usuario busca la pelicula "tita"
        Entonces debería ver las peliculas "Titanic" y "Titan" listadas entre las existentes.