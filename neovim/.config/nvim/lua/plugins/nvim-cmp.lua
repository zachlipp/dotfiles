return {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					--vim.fn["vsnip#anonymous"](args.body),
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
			}),
		})
	end,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/vim-vsnip",
	},
}
