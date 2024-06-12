# language: es
Característica: Calificar contenido
    
Antecedentes:
    Dado un usuario "juan@gmail.com" 123456789
    Y que el usuario ya vio la pelicula "Nahir" 2024 "drama"

    Escenario: US15 - 01 Como cinefilo quiero poder calificar contenido ya visto
        Cuando califica la pelicula con un 4
        Entonces ve un mensaje de exito

    @wip
    Escenario: US15 - 02 Como cinefilo quiero poder re-calificar contenido ya visto
        Dado que el usuario la habia calificado con un 5
        Cuando califica la pelicula con un 3 se actualiza
        Y ve un mensaje "Calificacion registrada exitosamente"

    Escenario: US15 - 03 Ingreso el valor de la calificacion negativa
        Cuando califica la pelicula con un -1
        Entonces ve un mensaje de calificacion fuera de rango

    Escenario: US15 - 04 El contenido a calificar no existe
        Cuando el usuario quiere calificar con 4 un contenido que no existe en la base de datos
        Entonces ve un mensaje de que el contenido a calificar no existe

    Escenario: US15 - 05 La calificacion esta fuera de rango
        Cuando califica la pelicula con un 6
        Entonces ve un mensaje de calificacion fuera de rango

    @wip
    Escenario: US15 - 06 La pelicula no fue vista aun
        Cuando califica la pelicula con un 1
        Entonces ve un mensaje "Error al calificar: Solo puedes calificar peliculas ya vistas"
