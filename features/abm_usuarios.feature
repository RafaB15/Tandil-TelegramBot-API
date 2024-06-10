# language: es
Característica: ABM de usuarios

  @notlocal
  Escenario: Alta de usuario
    Cuando creo un usuario
    Entonces se le asigna un id
    
  @notlocal
  Escenario: Consulta de usuarios
    Dado que no existen usuario
    Cuando consulto los usuarios
    Entonces tengo un listado vacio
