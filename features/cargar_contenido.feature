# language: es
Característica: Cargar contenido via API

    @current
    Escenario: US19 - 01 Como administrador quiero poder cargar una pelicula via API
        Cuando cargo "Suerte" 2022 "comedia" "pelicula"
        Entonces deberia devolver un resultado exitoso

    Escenario: US19 - 02 Como administrador cargo una pelicula repetido via API
        Dado que ya esta cargada la pelicula "Atlas" 2024 "accion" "pelicula"
        Cuando cargo "Atlas" 2024 "drama" "pelicula" ya es un contenido existente
        Entonces deberia devolver conflicto (409) y un mensaje de error "Ya existe una pelicula con el mismo titulo y año."

    Escenario: US19 - 03 Como administrador cargo una pelicula sin año
        Cuando cargo "Nahir" "comedia" "pelicula"
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido anio debe ser un año positivo"

    Escenario: US19 - 04 Como administrador cargo una pelicula sin titulo
        Cuando cargo 2024 "drama" "pelicula"
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido titulo debe ser un nombre"

    Escenario: US19 - 05 Como administrador cargo una pelicula con titulo vacio
        Cuando cargo "" 2024 "drama" "pelicula"
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido titulo debe ser un nombre"

    Escenario: US19 - 06 Como administrador cargo un dato invalido
        Cuando cargo "Oppenheimer" 2024 "suspenso" "pelicula"
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido genero debe ser drama, accion o comedia"
        Y en los detalles se debe especificar los generos permitidos

    Escenario: US24 - 01 Como administrador quiero poder cargar una serie via API
        Cuando cargo "Game of thrones - Temporada 1" 2011 "accion" 10 "serie"
        Entonces deberia devolver un resultado exitoso