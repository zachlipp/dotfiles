"For sharing"
set nocompatible

call plug#begin()
  Plug 'scrooloose/nerdtree'
  Plug 'Raimondi/delimitMate'
  Plug 'rakr/vim-one'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'deoplete-plugins/deoplete-jedi'
  Plug 'davidhalter/jedi-vim'
  Plug 'sbdchd/neoformat'
  Plug 'mrk21/yaml-vim'
  Plug 'heavenshell/vim-pydocstring' 
  Plug 'editorconfig/editorconfig-vim'
  Plug 'stsewd/isort.nvim'
call plug#end()

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard^=unnamed

colorscheme one
set background=dark

let g:airline_theme='one'

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

let g:neoformat_enabled_yaml = ['prettier']

let g:neoformat_basic_format_trim = 1

let g:deoplete#enable_at_startup = 1
let g:jedi#goto_command = "<leader>d"
let g:jedi#completions_enabled = 0

"autocmd BufWritePre *.py Neoformat
autocmd BufWritePre *.yaml Neoformat

nmap <silent> <C-d> <Plug>(pydocstring)
nmap <silent> <C-n> :NERDTreeToggle<CR>
