let g:SessionDir = expand('<sfile>:p:h').'/../sessions/'

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
autocmd VimLeave * call sensession#SaveSession()

" Mapea la funcion SetSession al comando :Session (autocompletado)
if !exists(":Session")
  command -complete=custom,ListSessions -nargs=1
    \ Session call sensession#SetSession(<f-args>)
endif

" Mapea la funcion KillSession al comando :SessionKill
if !exists(":SessionKill")
  command SessionKill call sensession#KillSession()
endif

" Mapea la funcion DeleteSession al comando :SessionDelete (autocompletado)
if !exists(":SessionDelete")
  command -complete=custom,ListSessions -nargs=1
    \ SessionDelete call sensession#DeleteSession(<f-args>)
endif
