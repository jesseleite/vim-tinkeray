" ------------------------------------------------------------------------------
" # Configurable Settings
" ------------------------------------------------------------------------------

if exists('g:tinkeray#tinker_command') == 0
  let g:tinkeray#tinker_command = 'php artisan tinker'
endif

if exists('g:tinkeray#disable_autocmds') == 0
  let g:tinkeray#disable_autocmds = 0
endif


" ------------------------------------------------------------------------------
" # Functions
" ------------------------------------------------------------------------------

let s:plugin_path = expand('<sfile>:p:h:h')
let s:app_path = getcwd()

function! tinkeray#run()
  if isdirectory(s:app_path.'/vendor/spatie/laravel-ray')
    silent exec '!export TINKERAY_APP_PATH="' . s:app_path . '" &&' g:tinkeray#tinker_command s:plugin_path . '/bin/tinkeray.php'
  else
    echo 'Cannot find [spatie/laravel-ray] package!'
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
  call writefile(readfile(s:plugin_path . '/bin/stub.php'), s:app_path . '/tinkeray.php')
endfunction

function! tinkeray#register_autocmds()
  if g:tinkeray#disable_autocmds
    return
  endif
  augroup tinkeray_autocmds
    autocmd!
    autocmd BufEnter tinkeray.php :call tinkeray#open()
    autocmd BufWritePost tinkeray.php :call tinkeray#run()
  augroup END
endfunction
