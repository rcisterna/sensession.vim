let g:SessionDir = expand('<sfile>:p:h').'/../sessions/'

" Opciones necesarias para el correcto funcionamiento
set sessionoptions=blank,buffers,curdir,globals,tabpages,winsize

" ----- FUNCIONES

" Guarda una sesion
function! SaveSession()
  if !exists('g:Session') | return 0 | endif
  if !isdirectory(g:SessionDir) | call mkdir(g:SessionDir, "p") | endif

  exe "mksession! ".g:SessionDir.g:Session.".session.vim"
  return 1
endfunc

" Crea una nueva sesion, y la carga si existe
function! SetSession(session)
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
function! KillSession()
  echo "La sesion ya no sera guardada al cerrar vim."
  unlet! g:Session g:SessionLoad
endfunc

" Elimina una sesion
function! DeleteSession(session)
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

" Mantiene una lista de las sesiones
function! UpdateSessionList()
  let g:SessionList = ""
  let l:sessionfiles = split(globpath(g:SessionDir, '*'), '\n')
  for file in l:sessionfiles
    let l:tail = split(split(file, '/')[-1], '\.')[0]
    let g:SessionList = g:SessionList.l:tail."\n"
  endfor
endfunc

" VimList de sesiones para autocompletar
function! ListSessions(arg, line, cur)
  return g:SessionList
endfunc


" ----- USABILIDAD

" Crea la lista de sesiones existentes al iniciar vim
autocmd VimEnter * call UpdateSessionList()

" Guarda automaticamente una sesion al cerrar vim
autocmd VimLeave * call SaveSession()

" Mapea la funcion SetSession al comando :Session (autocompletado)
if !exists(":Session")
  command -complete=custom,ListSessions -nargs=1
    \ Session call SetSession(<f-args>)
endif

" Mapea la funcion KillSession al comando :SessionKill
if !exists(":SessionKill")
  command SessionKill call KillSession()
endif

" Mapea la funcion DeleteSession al comando :SessionDelete (autocompletado)
if !exists(":SessionDelete")
  command -complete=custom,ListSessions -nargs=1
    \ SessionDelete call DeleteSession(<f-args>)
endif
