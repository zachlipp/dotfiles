"For sharing"
set nocompatible

call plug#begin()
  Plug 'scrooloose/nerdtree'
  Plug 'Raimondi/delimitMate'
  Plug 'rakr/vim-one'
  Plug 'sbdchd/neoformat'
  Plug 'mrk21/yaml-vim'
  Plug 'heavenshell/vim-pydocstring'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'stsewd/isort.nvim'
  Plug 'jpalardy/vim-slime'
  Plug 'fatih/vim-go'
  Plug 'APZelos/blamer.nvim'
  Plug 'arcticicestudio/nord-vim'
call plug#end()

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard^=unnamed

colorscheme nord
set background=dark

"let g:airline_theme='one'

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" let g:neoformat_verbose = 1
let g:neoformat_run_all_formatters = 1
let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-l 79', '--quiet', '-' ],
    \ }

let g:neoformat_python_isort = {
    \ 'exe': 'isort',
    \ 'args': ['-'],
    \ 'stdin': 1,
    \ }

let g:neoformat_enabled_python = ['isort', 'black']
let g:neoformat_sql_sqlformat = {
    \ 'exe': 'sqlformat',
    \ 'args': ['-k upper', '--comma_first 1', '-i lower', '--indent_after_first', '-r', '-'],
    \ 'stdin': 1,
    \ }

let g:neoformat_tf_fmt = {
    \ 'exe': 'terraform',
    \ 'args': ['fmt', '-write', '-'],
    \ 'stdin': 1,
    \}
let g:neoformat_enabled_tf = ['fmt']
autocmd BufWritePre *.tf Neoformat

" Defaults to jq
autocmd BufWritePre *.json Neoformat

let g:neoformat_enabled_yaml = ['prettier']
let g:neoformat_enabled_sql = ['sqlformat']
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_go = ['goimports']
let g:slime_python_ipython = 1


" autocmd BufWritePre *.py Neoformat

let g:blamer_enabled = 1
let g:blamer_delay = 1000
let g:blamer_template = '<committer> <commit-short> <summary>'
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.go Neoformat

nmap <silent> <C-d> <Plug>(pydocstring)
nmap <silent> <C-n> :NERDTreeToggle<CR>

" See https://octetz.com/docs/2019/2019-04-24-vim-as-a-go-ide/
"
" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
