augroup filetype_go
    autocmd!
    " DISABLED because it slows down write operations
    " au BufWritePre *.go :GoImports
augroup END

let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = []
autocmd FileType go nmap <leader>b :GoBuild<cr>
autocmd FileType go nmap <leader>t :GoTestCompile<cr>
autocmd FileType go nmap <leader>i :GoInfo<cr>
autocmd FileType go nmap <leader>v :GoVet<cr>
autocmd FileType go nmap <leader>d :GoDescribe<cr>

let g:go_play_browser_command = '/usr/bin/firefox'
let g:go_auto_type_info = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_updatetime = 800
let g:go_bin_path = '/usr/local/go/bin'
" Make sure that GOROOT is set for jumptodefinition to work for stdlib

nnoremap <leader>f yiwo<Esc>ifmt.Printf("DEBUG:<Esc>pa %+v\n",<Esc>pa)<Esc>
let g:go_highlight_function_calls = 1
