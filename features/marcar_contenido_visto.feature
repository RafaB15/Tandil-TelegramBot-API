# language: es
Característica: Marcar contenido como visto
Background:
    Dado un usuario existente "juan@gmail.com"

    
    @wip
    Escenario: US06 - 01 Como administrador quiero marcar el contenido visto de un usuario
        Cuando visualiza un contenido "AironMan"
        Entonces debería poder marcar el contenido como visto para este usuario
        Entonces deberia devolver un mensaje exitoso "Contenido marcado como visto exitosamente"

    @wip
    Escenario: US06 - 02 Como administrador quiero marcar un contenido inexistente visto de un usuario
        Dado que el contenido "Romance" no existe en la base de datos
        Cuando marco ese contenido como visto para este usuario
        Entonces debería devolver un mensaje "Error : Contenido inexistente"

    @wip
    Escenario: US06 - 03 Como administrador quiero marcar un contenido visto de un usuario inexistente
        Dado que no existe un usuario "rodrigo@gmail.com"
        Cuando marco un contenido como visto para un usuario inexistente
        Entonces debería devolver un mensaje "Error : Usuario inexistente"