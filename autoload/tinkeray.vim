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
  if exists("*jobstart")
    let job = jobstart(g:tinkeray#tinker_command . ' ' . s:plugin_path . '/bin/tinkeray.php', {
      \ 'env': {'TINKERAY_APP_PATH': s:app_path},
      \ 'on_stderr': function('s:handle_stderr'),
      \ 'on_stdout': function('s:handle_stderr'),
      \ })
    if job == 1
      call s:handle_stderr(0, ['Could not open input file: artisan'], 0)
    endif
  else
    redir @r
      silent exec '!export TINKERAY_APP_PATH="' . s:app_path . '" &&' g:tinkeray#tinker_command s:plugin_path . '/bin/tinkeray.php'
    redir END
    call s:handle_stderr(0, [@r], 0)
  endif
endfunction

function! tinkeray#open()
  if filereadable(s:app_path . '/tinkeray.php') == 0
    call tinkeray#create_stub()
  endif
  exec 'edit tinkeray.php'
endfunction

function! tinkeray#opened()
  call search("'tinkeray ready'")
  if exists("*jobstart")
    call tinkeray#run()
  endif
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
    exec 'autocmd BufEnter' getcwd() . '/tinkeray.php :call tinkeray#opened()'
    exec 'autocmd BufWritePost' getcwd() . '/tinkeray.php :call tinkeray#run()'
  augroup END
endfunction

function! s:handle_stderr(channel, data, name)
  let output = join(a:data)
  if match(output, 'Could not open input file: artisan') > -1
    echo 'Could not find [artisan] executable! Please run in context of a Laravel application.'
  elseif match(output, 'Call to undefined function ray\(\)') > -1
    echo 'Ray is not installed! Please install spatie/ray, spatie/laravel-ray, or spatie/global-ray.'
  endif
endfunction
