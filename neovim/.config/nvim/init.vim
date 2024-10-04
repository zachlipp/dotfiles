"For sharing"
set nocompatible

call plug#begin()
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'sbdchd/neoformat'
  Plug 'mrk21/yaml-vim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'benlubas/molten-nvim'
  Plug '3rd/image.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'ray-x/go.nvim'
call plug#end()

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard^=unnamed
set relativenumber

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
let g:neoformat_python_ruff = {
    \ 'exe': 'ruff',
    \ 'stdin': 1,
    \ 'args': ['format', '--quiet', '-' ],
    \ }

let g:neoformat_enabled_python = ['ruff']
let g:neoformat_sql_sqlformat = {
    \ 'exe': 'sqlformat',
    \ 'args': ['-k upper', '--comma_first 1', '-i lower', '--indent_after_first', '-r', '-'],
    \ 'stdin': 1,
    \ }

let g:neoformat_tf_fmt = {
    \ 'exe': 'terraform',
    \ 'args': ['fmt', '-write', '-'],
    \ 'stdin': 1,
    \ }
let g:neoformat_enabled_tf = ['fmt']
autocmd BufWritePre *.tf Neoformat

let g:neoformat_html_beautify = {
    \ 'exe': 'html-beautify',
    \ 'args': ['-'],
    \ 'stdin': 1,
    \ }
let g:neoformat_enabled_html = ['beautify']
autocmd BufWritePre *.html Neoformat

let g:neoformat_javascript_prettier = {
    \ 'exe': 'prettier',
    \ 'args': ['--stdin-filepath', '"%:p"'],
    \ 'stdin': 1,
    \ 'try_node_exe': 1,
    \ }
let g:neoformat_enabled_javascript = ['prettier']
autocmd BufWritePre *.js Neoformat

let g:neoformat_go_gofmt = {
      \ 'exe': 'gofmt',
      \ 'stdin': 1,
      \ }

" autocmd BufWritePre <buffer> lua vim.lsp.buf.format()let g:neoformat_enabled_go = ['gofmt']
autocmd BufWritePre *.go Neoformat
" autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500)
" autocmd BufWritePre <buffer> lua vim.lsp.buf.format()

" Defaults to jq
autocmd BufWritePre *.json Neoformat


let g:neoformat_enabled_yaml = ['prettier']
let g:neoformat_enabled_sql = ['sqlformat']
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_go = ['goimports', 'gofmt']



autocmd BufWritePre *.py Neoformat

autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.go Neoformat

nmap <silent> <C-d> <Plug>(pydocstring)
nmap <silent> <C-n> :NERDTreeToggle<CR>



" Molten
" noremap <leader>mi :MoltenInit<CR>
noremap <leader>e :MoltenEvaluateOperator<CR>
noremap <leader>rl :MoltenEvaluateLine<CR>
noremap <leader>rr :MoltenReevaluateCell<CR>
lua <<EOF
vim.keymap.set("n", "<localleader>mi", function()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv ~= nil then
    -- format /some/path/to/kernel-name/.venv
    kernel = string.match(venv, ".+/(.+)/.+")
    vim.cmd(("MoltenInit %s"):format(kernel))
  else
    vim.cmd("MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })
EOF


" noremap <leader>rc :<C-u>MoltenEvaluateVisual<CR>

" vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
"     { silent = true, desc = "evaluate visual selection" })



" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]

map <space>e :lua vim.diagnostic.open_float(0, {scope="line"})<CR>


lua <<EOF
  local lspconfig = require("lspconfig")
  lspconfig.gopls.setup({})
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]--

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }

  -- MOLTEN STUFF
  -- TODO: Just write an init.lua already
  vim.g.mapleader = ','
  local function create_molten_extmark_cell_range()
    local bufnr = 0
    local ns_id = vim.api.nvim_create_namespace("molten")

    local start_row_raw = vim.fn.search("# ---", "Wb")
    if past_row == 0 then
      print("No previous occurrence of '# ---' found")
      return
    end
    local end_row_raw = vim.fn.search("# ---", "W")
    if end_row_raw == 0 then
      print("No next occurrence of '# ---' found")
      return
    end
    local start_row = start_row_raw + 1
    local end_row = end_row_raw - 1
    vim.fn.MoltenEvaluateRange(start_row, end_row)
    vim.api.nvim_win_set_cursor(0, {start_row, 0})
  end
  _G.create_molten_extmark_cell_range = create_molten_extmark_cell_range

  vim.api.nvim_set_keymap('n', '<leader>m', ":<C-u>lua create_molten_extmark_cell_range()<CR>", { noremap = true, silent = false })
EOF
