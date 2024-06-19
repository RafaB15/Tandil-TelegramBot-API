# language: es
Característica: Aniadir contenido a favoritos
    
Antecedentes:
    Dado un usuario "pepito@gmail.com" 123456789
 
    Escenario: US08 - 01 Como cinefilo quiero aniadir un contenido a favoritos
        Dado que el contenido "Siempre Risas" 2010 "comedia" "pelicula" existe en la base de datos
        Y que el usuario ya vio el contenido
        Cuando el usuario aniade el contenido a favoritos
        Entonces ve un mensaje de exito al aniadir la pelicula a favoritos

    @wip
    Escenario: US08 - 02 Contenido inexistente
        Dado que el contenido "Amor de Primavera" no existe en la base de datos
        Cuando el usuario aniade el contenido a favoritos
        Entonces ve un mensaje "Error: Contenido inexistente"

    @wip
    Escenario: US08 - 03 Dato faltante
        Cuando el usuario aniade un contenido "" a favoritos
        Entonces ve un mensaje "Error: Contenido faltante"
    
    Escenario: US29.1 - 01 Como cinefilo quiero aniadir una temporada a favoritos
        Dado que existe la temporada "Game of Thrones - Temporada 3" 2011 "drama" 12 en la base de datos
        Y que el usuario ya vio la temporada de serie
        Cuando el usuario aniade el contenido a favoritos
        Entonces el contenido se aniade a favoritos exitosamente

    Escenario: US29.2 - 01 Agregar a favoritos sin haber visto el contenido no se puede
        Dado que existe la temporada "Game of Thrones - Temporada 3" 2011 "drama" 12 en la base de datos
        Y que el usuario no la vio
        Cuando el usuario aniade el contenido a favoritos
        Entonces ve un mensaje de error de que la temporada no fue vista
