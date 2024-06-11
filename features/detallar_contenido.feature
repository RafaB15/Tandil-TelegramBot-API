# language: es
Característica: Detallar contenido via informacion de API externa

Antecedentes: 
    Dado que el contenido "Titanic" 1997 "drama" existe en la base de datos
    
    Escenario: US22.1 - 01 Como cinefilo quiero detalles acerca de una pelicula
        Cuando el cinefilo pide detalles acerca de la pelicula "Titanic" con su ID
        Entonces debería ver la informacion esperada