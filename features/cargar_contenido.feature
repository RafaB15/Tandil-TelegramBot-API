# language: es
Característica: Cargar peliculas via API

    Escenario: US19 - 01 Como administrador quiero poder cargar una pelicula via API
        Cuando cargo "Suerte" 2022 "comedia"
        Entonces deberia devolver un resultado exitoso

    @wip
    Escenario: US19 - 02 Como administrador cargo una pelicula repetido via API
        Dado que ya esta cargada la pelicula "Atlas" 2024 "accion"
        Cuando cargo "Atlas" 2024 "accion"
        Entonces deberia devolver un mensaje "Error al cargar : Pelicula ya existente"

    @wip
    Escenario: US19 - 03 Como administrador cargo una pelicula incompleta
        Cuando cargo "Nahir" 2024 ""
        Entonces deberia devolver un mensaje "Error al cargar : informacion incompleta"
    
    @wip
    Escenario: US19 - 04 Como administrador cargo un dato invalido
        Cuando cargo "Oppenheimer" 2024 "suspenso"
        Entonces deberia devolver un mensaje "Error al cargar : dato invalido"