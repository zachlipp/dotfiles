set nocompatible

call plug#begin()
Plug 'Chiel92/vim-autoformat'
Plug 'Raimondi/delimitMate'
Plug 'kaicataldo/material.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'sbdchd/neoformat'
Plug 'mrk21/yaml-vim'
call plug#end()

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set background=dark
colorscheme material

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

let g:material_theme_style = 'dark'

let g:neoformat_python_black = { 
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-l 79', '--quiet', '-' ]}

let g:neoformat_enabled_python = ['black']

let g:neoformat_enabled_yaml = ['prettier']

let g:neoformat_basic_format_trim = 1

autocmd BufWritePre *.py Neoformat
autocmd BufWritePre *.yaml Neoformat
