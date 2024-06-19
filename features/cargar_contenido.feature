# language: es
Característica: Cargar contenido via API

    Escenario: US19 - 01 Como administrador quiero poder cargar una pelicula via API
        Cuando cargo "Suerte" 2022 "comedia" "pelicula"
        Entonces deberia devolver un resultado exitoso

    Escenario: US19 - 02 Como administrador cargo una pelicula repetido via API
        Dado que ya esta cargada la pelicula "Atlas" 2024 "accion" "pelicula"
        Cuando cargo "Atlas" 2024 "drama" "pelicula" ya es un contenido existente
        Entonces deberia devolver conflicto (409) y un mensaje de error "Ya existe un contenido con el mismo titulo y año."

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

    Escenario: US24.1 - 01 Como administrador quiero poder cargar una serie via API
        Cuando cargo "Game of thrones - Temporada 1" 2011 "accion" "serie" 10
        Entonces deberia devolver un resultado exitoso

    @current
    Escenario: US24.3 - 02 Como administrador cargo una serie repetido via API
        Dado que ya esta cargada la pelicula "Atlas" 2024 "accion" "serie" 12
        Cuando cargo "Atlas" 2024 "drama" "serie" 12 ya es un contenido existente
        Entonces deberia devolver conflicto (409) y un mensaje de error "Ya existe un contenido con el mismo titulo y año."

    Escenario: US24.3 - 03 Como administrador cargo una serie sin año
        Cuando cargo "Nahir" "comedia" "serie" 12
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido anio debe ser un año positivo"

    Escenario: US24.3 - 04 Como administrador cargo una serie sin titulo
        Cuando cargo 2024 "drama" "serie" 12
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido titulo debe ser un nombre"

    Escenario: US24.3 - 05 Como administrador cargo una serie con titulo vacio
        Cuando cargo "" 2024 "drama" "serie" 12
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido titulo debe ser un nombre"

    Escenario: US24.3 - 06 Como administrador cargo un dato invalido
        Cuando cargo "Oppenheimer" 2024 "suspenso" "serie" 12
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido genero debe ser drama, accion o comedia"
        Y en los detalles se debe especificar los generos permitidos

    Escenario: US24.2 - 07 Como administrador cargo una serie sin cantidad de capitulos
        Cuando cargo "Suits - Temporada 3" 2012 "drama" "serie" -1
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido cantidad de capitulos debe ser positivo."

    @wip
    Escenario: US24.2 - 08 Como administrador cargo el dato tipo invalido
        Cuando cargo "Suits - Temporada 3" 2012 "drama" "documental" 24
        Entonces deberia devolver solicitud incorrecta (400) y un mensaje de error "El parametro requerido tipo debe ser un valor permitido."
        Y en los detalles se debe especificar los tipos permitidos