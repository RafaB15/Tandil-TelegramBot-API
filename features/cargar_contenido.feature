# language: es
Característica: Cargar contenido via API
    
    Background:
        Dado que ya esta cargada la pelicula "Atlas" "2024" "accion"
    
    @wip
    Escenario: US19 - 01 Como administrador quiero poder cargar contenido via API
        Dado que tengo el contenido "Suerte" para cargar
        Cuando cargo "Suerte" "2022" "comedia"
        Entonces deberia devolver un mensaje exitoso "Contenido cargado exitosamente"

    @wip
    Escenario: US19 - 02 Como administrador cargo un contenido repetido via API
        Dado que tengo el contenido "Atlas" para cargar
        Cuando cargo "Atlas" "2024" "accion" pero es un contenido ya existente
        Entonces deberia devolver un mensaje "Error al cargar : Contenido ya existente"

    @wip
    Escenario: US19 - 03 Como administrador cargo un contenido incompleto
        Dado que tengo el contenido "Nahir" para cargar
        Cuando cargo "Nahir" "" "drama"
        Entonces deberia devolver un mensaje "Error al cargar : informacion incompleta"
    
    @wip
    Escenario: US19 - 04 Como administrador cargo un dato invalido
        Dado que tengo el contenido "Oppenheimer" para cargar
        Cuando cargo "Oppenheimer" "2024" "suspenso"
        Entonces deberia devolver un mensaje "Error al cargar : dato invalido"