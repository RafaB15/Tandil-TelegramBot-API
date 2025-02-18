# language: es
Característica: Calificar contenido
    
Antecedentes:
    Dado un usuario "juan@gmail.com" 123456789
    Y que existe la temporada "Friends - Temporada 1" 1999 "comedia" 24 en la base de datos
    Y que el usuario ya vio la temporada de serie
    Y que el usuario ya vio la pelicula "Nahir" 2024 "drama" "pelicula"

    Escenario: US15 - 01 Como cinefilo quiero poder calificar contenido ya visto
        Cuando califica la pelicula con un 4
        Entonces ve un mensaje de exito

    Escenario: US15 - 02 Como cinefilo quiero poder re-calificar contenido ya visto
        Dado que el usuario la habia calificado con un 5
        Cuando califica la pelicula con un 3 se actualiza
        Entonces ve un mensaje que el la calificacion fue actualizada

    Escenario: US15 - 03 Ingreso el valor de la calificacion negativa
        Cuando califica la pelicula con un -1
        Entonces ve un mensaje de calificacion fuera de rango

    Escenario: US15 - 04 El contenido a calificar no existe
        Cuando el usuario quiere calificar con 4 un contenido que no existe en la base de datos
        Entonces ve un mensaje de que el contenido a calificar no existe

    Escenario: US15 - 05 La calificacion esta fuera de rango
        Cuando califica la pelicula con un 6
        Entonces ve un mensaje de calificacion fuera de rango

    Escenario: US15 - 06 La pelicula no fue vista aun
        Dado que existe el contenido "Titanic" 1997 "drama" "pelicula" y el usuario no lo vio
        Cuando califica una pelicula que no vio con un 1
        Entonces ve un mensaje de que la pelicula no fue vista
    
    Escenario: US15 - 07 Como cinefilo quiero no poder re-calificar contenido con una calificacion invalida
        Dado que el usuario la habia calificado con un 5
        Cuando califica la pelicula con un -1
        Entonces ve un mensaje de calificacion fuera de rango