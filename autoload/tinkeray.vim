" ------------------------------------------------------------------------------
" # Configurable Settings
" ------------------------------------------------------------------------------

" Disable autocmds if you wish to manually run tinkeray
if exists('g:tinkeray#disable_autocmds') == 0
  let g:tinkeray#disable_autocmds = 0
endif

" Some environments might require a custom tinker command or path
if exists('g:tinkeray#tinker_command') == 0
  let g:tinkeray#tinker_command = 'php artisan tinker'
endif

" Some environments might require that the tinkeray.php wrapper be copied and run from storage/app
if exists('g:tinkeray#run_from_storage') == 0
  let g:tinkeray#run_from_storage = 0
endif

" Sugar to easily set sail ⛵
function! tinkeray#set_sail(...)
  let service = a:0 ? a:1 : 'laravel.test'
  let g:tinkeray#run_from_storage = 1
  let g:tinkeray#tinker_command = './vendor/bin/sail exec -T -u sail ' . service . ' php artisan tinker storage/app/tinkeray.php'
endfunction


" ------------------------------------------------------------------------------
" # Functions
" ------------------------------------------------------------------------------

let s:plugin_path = expand('<sfile>:p:h:h')
let s:app_path = getcwd()

function! tinkeray#run()
  if g:tinkeray#run_from_storage
    silent exec '!cp -r' s:plugin_path . '/bin/tinkeray.php' s:app_path . '/storage/app/tinkeray.php'
  endif
  redir @r
    if exists("*jobstart")
      " TODO: on stdout/stderr, capture output for error handling below
      call jobstart(g:tinkeray#tinker_command . ' ' . s:plugin_path . '/bin/tinkeray.php', {'env': {'TINKERAY_APP_PATH': s:app_path}})
    else
      silent exec '!export TINKERAY_APP_PATH="' . s:app_path . '" &&' g:tinkeray#tinker_command s:plugin_path . '/bin/tinkeray.php'
    endif
  redir END
  if match(@r, 'Could not open input file: artisan') > -1
    echo 'Could not find [artisan] executable! Please run in context of a Laravel application.'
  elseif match(@r, 'Call to undefined function ray\(\)') > -1
    echo 'Ray is not installed! Please install spatie/ray, spatie/laravel-ray, or spatie/global-ray.'
  endif
endfunction

function! tinkeray#open()
  if filereadable(s:app_path . '/tinkeray.php') == 0
    call tinkeray#create_stub()
  endif
  exec 'edit tinkeray.php'
  call search("'tinkeray ready'")
  " call tinkeray#run() " TODO: Only auto run on open when running async
endfunction

function! tinkeray#create_stub()
  let stub = isdirectory(s:app_path . '/lang') ? 'stub.php' : 'stub-legacy.php'
  call writefile(readfile(s:plugin_path . '/bin/' . stub), s:app_path . '/tinkeray.php')
endfunction

function! tinkeray#register_autocmds()
  if g:tinkeray#disable_autocmds
    return
  endif
  augroup tinkeray_autocmds
    autocmd!
    exec 'autocmd BufEnter' getcwd() . '/tinkeray.php :call tinkeray#open()'
    exec 'autocmd BufWritePost' getcwd() . '/tinkeray.php :call tinkeray#run()'
  augroup END
endfunction
