" Guarda una sesion
function! sensession#SaveSession()
  if !exists('g:Session') | return 0 | endif
  if !isdirectory(g:SessionDir) | call mkdir(g:SessionDir, "p") | endif

  exe "mksession! ".g:SessionDir.g:Session.".session.vim"
  return 1
endfunc

" Crea una nueva sesion, y la carga si existe
function! sensession#SetSession(session)
  if exists('g:Session') | call SaveSession() | exe "bufdo! bdelete" | endif
  let g:Session = a:session
  let l:sname = g:SessionDir.g:Session.".session.vim"

  if !filereadable(l:sname)
    echo "Nueva sesion, creando archivos."
    call SaveSession()
    call UpdateSessionList()
    return 0
  endif

  try | exe "source ".l:sname | return 1
  catch | echo "Error cargando ".l:sname | call KillSession() | return 0
  endtry
endfunc

" Elimina las variables globales que indican que existe una sesion
function! sensession#KillSession()
  echo "La sesion ya no sera guardada al cerrar vim."
  unlet! g:Session g:SessionLoad
endfunc

" Elimina una sesion
function! sensession#DeleteSession(session)
  let l:sname = g:SessionDir.a:session.".session.vim"

  if !filereadable(l:sname)
    echo "No existe la sesion. Nada que borrar."
    return 0
  endif

  if (exists('g:Session') && g:Session == a:session)
    call KillSession()
  endif

  try | call delete(l:sname) | call UpdateSessionList()
    \ | echo "Eliminado ".l:sname | return 1
  catch | echo "Error eliminando ".l:sname | return 0
  endtry
endfunc
