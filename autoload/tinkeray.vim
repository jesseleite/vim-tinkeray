" ------------------------------------------------------------------------------
" # Configurable Settings
" ------------------------------------------------------------------------------

let g:tinkeray#tinker_command = 'php artisan tinker'


" ------------------------------------------------------------------------------
" # Functions
" ------------------------------------------------------------------------------

let s:plugin_path = expand('<sfile>:p:h:h')
let s:app_path = expand('%:p')

function! tinkeray#run()
  if isdirectory(expand('%:p:h').'/vendor/spatie/laravel-ray')
    silent exec '!export TINKERAY_APP_PATH="' . s:app_path . '" &&' g:tinkeray#tinker_command s:plugin_path . '/bin/tinkeray.php'
  else
    echo 'Cannot find [spatie/laravel-ray] package!'
  endif
endfunction

function! tinkeray#open()
  exec 'edit tinkeray.php'
  call search("'tinkeray ready'")
endfunction
