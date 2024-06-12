# language: es
Característica: Detallar contenido via informacion de API externa

Antecedentes: 
   
    
    Escenario: US22.1 - 01 Como cinefilo quiero detalles acerca de una pelicula
        Dado que existe el contenido "Titanic" 1997 "drama"
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver la informacion esperada

    @current
    Escenario: US22.1 - 02 La pelicula no está en nuestra BD

        Dado que no hay contenidos en la BD
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver un mensaje de error de que no está lo que busca
    
    @wip
    Escenario: US22.1 - 03 La película está en nuestra BD pero OMDB no la tiene

        Dado que existe el contenido "Titanic" 1997 "drama"
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver un mensaje que no se pueden mostrar detalles adicionales

    @wip
    Escenario: US22.1 - 04 La pelicula está en OMDB pero no tiene todos los campos que queremos

        Dado que existe el contenido "Titanic" 1997 "drama"
        Dado que OMDB no da información del campo "director"
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver el campo "director" como no disponible