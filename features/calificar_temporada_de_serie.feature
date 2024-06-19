# language: es
Característica: Calificar temporadas series

Antecedentes:
    
    Dado un usuario "pepito@gmail.com" 123456789
    Y que existe la temporada "Friends - Temporada 1" 1999 "comedia" 24 en la base de datos
    Y que el usuario ya vio la temporada de serie

    Escenario: US28 - 01 Como cinefilo quiero poder calificar una temporada de serie ya vista

        Cuando califica la temporada de serie con un 4
        Entonces ve un mensaje de calificacion exitosa