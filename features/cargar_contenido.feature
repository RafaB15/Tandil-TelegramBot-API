# language: es
Característica: Cargar peliculas via API

    Escenario: US19 - 01 Como administrador quiero poder cargar una pelicula via API
        Cuando cargo "Suerte" 2022 "comedia"
        Entonces deberia devolver un resultado exitoso

    @wip
    Escenario: US19 - 02 Como administrador cargo una pelicula repetido via API
        Dado que ya esta cargada la pelicula "Atlas" 2024 "accion"
        Cuando cargo "Atlas" 2024 "accion" ya es un contenido existente
        Entonces deberia devolver un mensaje "Error al cargar: Contenido ya existente"

    @wip
    Escenario: US19 - 03 Como administrador cargo una pelicula sin año
        Cuando cargo "Nahir" "comedia"
        Entonces deberia devolver solicitud incorrecta y un mensaje de error "Falta el parámetro requerido: anio"
    
    @wip
    Escenario: US19 - 04 Como administrador cargo una pelicula sin titulo
        Cuando cargo 2024 "drama"
        Entonces deberia devolver un mensaje "Error al cargar: informacion incompleta"

    @wip
    Escenario: US19 - 05 Como administrador cargo un dato invalido
        Cuando cargo "Oppenheimer" 2024 "suspenso"
        Entonces deberia devolver un mensaje "Error al cargar: dato invalido"