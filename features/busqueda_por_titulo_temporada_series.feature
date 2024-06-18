# language: es
Característica: Buscar contenido por titulo de serie

Antecedentes:
    Dado un usuario "pepito@gmail.com" 123456789
    Y que existe la temporada "Pretty Little Liars - Temporada 2" 2010 "drama" 24 existe en la base de datos
    Y que existe la temporada "Pretty Little Liars - Temporada 3" 2011 "drama" 24 existe en la base de datos

    Escenario: US26 - 01 Como cinefilo quiero buscar una temporada por su nombre

        Cuando el usuario busca la temporada "Pretty Little Liars - Temporada 2"
        Entonces la cantidad de resultados es 1
        Y deberia ver la temporada "Pretty Little Liars - Temporada 2" listada entre las existentes

    Escenario: US26 - 02 Como cinefilo quiero buscar una temporada sin especificar temporada

        Cuando el usuario busca la temporada "Pretty Little Liars"
        Entonces la cantidad de resultados es 2
        Y deberia ver la temporada "Pretty Little Liars - Temporada 2" listada entre las existentes
        Y deberia ver la temporada "Pretty Little Liars - Temporada 3" listada entre las existentes

    @current
    Escenario: US26 - 03 Como cinefilo quiero buscar una temporada de una serie que no está disponible

        Cuando el usuario busca la temporada "Pretty Little Liars - Temporada 1"
        Entonces la cantidad de resultados es 0