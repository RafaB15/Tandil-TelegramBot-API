# language: es
Característica: Registrar usuario
    
    Escenario: US01 - 01 Un usuario sin registrar se puede registrar correctamente
        Dado que no estoy registrado
        Cuando creo un usuario de nombre "Emilio" con el email "emilio@gmail.com" y telegram ID 5030671568
        Entonces debería ver un mensaje de bienvenida
        Y quedo registrado

    @wip
    Escenario: US01 - 02 Registrarse con un email inválido da error
        Cuando creo un usuario de nombre "Emilio" con el email "gmail.com" y telegram ID 5030671568
        Entonces debería ver un mensaje de email inválido
    
    @wip
    Escenario: US01 - 03 Registrarse con un telegram ID ya registrado da error
        Dado que creo un usuario de nombre "Emilio" con email válido y telegram ID 5030671568
        Cuando creo un usuario de nombre "Pablo" con el email "pablo@gmail.com" y mismo telegram ID que el usuario anterior
        Entonces debería ver un mensaje de usuario de telegram ya registrado

    @wip
    Escenario: US01 - 04 Un registro a un mail ya registrado da error
        Dado que creo un usuario de nombre "Emilio" con email "emilio@gmail.com" y telegram ID válido
        Cuando creo un usuario de nombre "Pablo" con el mismo email que el usuario anterior y telegram ID 5030671568
        Entonces debería ver un mensaje de email ya registrado