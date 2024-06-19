# language: es
Característica: Calificar temporadas series

Antecedentes:
    Dado un usuario "pepito@gmail.com" 123456789
    Y que existe la temporada "Friends - Temporada 1" 1999 "comedia" 24 en la base de datos
    Y que el usuario ya vio la temporada de serie

    Escenario: US28 - 01 Como cinefilo quiero poder calificar una temporada de serie ya vista
        Cuando califica la temporada de serie con un 4
        Entonces ve un mensaje de calificacion exitosa

    Escenario: US28 - 02 la temporada no fue vista aun
        Dado que existe la temporada "The Big Bang Theory" 2007 "comedia" 17 en la base de datos 
        Y que el usuario no la vio
        Cuando califica la temporada de serie con un 4
        Entonces ve un mensaje de que la temporada no fue vista

    Escenario: US28 - 03 Como cinefilo quiero poder re-calificar serie ya vista
        Dado que el usuario la habia calificado con un 5
        Cuando re-califica la temporada de serie con un 3
        Entonces ve un mensaje de re-calificacion exitosa

    Escenario: US28 - 04 La serie a calificar no existe
        Dado que no existe la temporada "The Big Bang Theory" en la base de datos 
        Cuando califica la temporada de serie con un 4
        Entonces ve un mensaje de error la temporada no existe.

    Escenario: US28 - 05 La calificacion esta fuera de rango
        Cuando califica la temporada de serie con un 6
        Entonces ve un mensaje de calificacion fuera de rango