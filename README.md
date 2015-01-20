# sensessions.vim

Maneja las sesiones de Vim de forma intuitiva y simple. En terminos practicos,
sensessions.vim permite manejar de forma sencilla distintas sesiones para
distintos proyectos (o distintas sesiones del mismo proyecto).

## Instalacion

Puede ser instalado utilizando Pathogen o Vundle. O simplememte copiando la
carpeta ```plugin``` en $VIM

## Uso

Para iniciar una nueva sesion, abrir una preexistente o cambiar de sesion:

    :Session <nombre-de-la-session>

Para cerrar la sesion actual (no cierra Vim)

    :SessionKill

Para eliminar una sesion y sus archivos (no cierra Vim)

    :SessionDelete <nombre-de-la-sesion>

Una sesion se guarda automaticamente al cerrar Vim. Asegurate de no cerrar todas
las ventanas, ya que solo se guardara la sesion con la ultima ventana abierta.
En vez de eso, utiliza ```:qa``` o ```:wqa```.

## Observaciones en la configuracion

EL plugin maneja automaticamente ```sessionoptions```. Se recomienda no modificar
esta opcion en las configuraciones personales

## Licencia

El presente plugin se distribuye bajo los mismos terminos de Vim
