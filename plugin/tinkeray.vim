" Commands
command! TinkerayOpen call tinkeray#open()
command! TinkerayRun  call tinkeray#run()

" Mappings
nnoremap <Plug>TinkerayOpen :TinkerayOpen<CR>
nnoremap <Plug>TinkerayRun  :TinkerayRun<CR>

" Autocmds
call tinkeray#register_autocmds()
