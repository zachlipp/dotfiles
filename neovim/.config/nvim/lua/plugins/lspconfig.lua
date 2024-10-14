return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Python
		lspconfig.pyright.setup({ capabilities = capabilities })
		-- Golang
		lspconfig.gopls.setup({ capabilities = capabilities })
	end,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/vim-vsnip",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/nvim-cmp",
	},
}
