" Commands
command! TinkerayOpen call tinkeray#open()
command! TinkerayRun  call tinkeray#run()

" Mappings
nnoremap <Plug>TinkerayOpen :TinkerayOpen<CR>
nnoremap <Plug>TinkerayRun  :TinkerayRun<CR>

" Autocmds
augroup auto_run_tinkeray_on_write
  autocmd!
  autocmd BufEnter tinkeray.php :call tinkeray#open()
  autocmd BufWritePost tinkeray.php :call tinkeray#run()
augroup END
