# language: es
Característica: Aniadir contenido a favoritos
    
Antecedentes:
    Dado un usuario "pepito@gmail.com" 123456789
    
    Escenario: US08 - 01 Como cinefilo quiero aniadir un contenido a favoritos
        Dado que el contenido "Siempre Risas" 2010 "comedia" existe en la base de datos
        Cuando el usuario aniade un contenido "Siempre Risas" a favoritos
        Entonces ve un mensaje de exito al aniadir la pelicula a favoritos

    @wip
    Escenario: US08 - 02 Contenido inexistente
        Dado que el contenido "Amor de Primavera" no existe en la base de datos
        Cuando el usuario aniade un contenido "Amor de Primavera" a favoritos
        Entonces ve un mensaje "Error: Contenido inexistente"

    @wip
    Escenario: US08 - 03 Dato faltante
        Cuando el usuario aniade un contenido "" a favoritos
        Entonces ve un mensaje "Error: Contenido faltante"
    
    