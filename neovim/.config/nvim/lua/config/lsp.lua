-- Python
vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "strict", -- 'off' | 'basic' | 'strict'
				autoImportCompletions = true,
			},
		},
	},
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
	settings = {
		typescript = {
			inlayHints = { includeInlayParameterNameHints = "literals" },
		},
	},
})

-- Go
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			analyses = { unusedparams = true },
		},
	},
})

-- GDScript
-- No binary to install: Neovim connects over TCP to the LSP server that the
-- Godot editor runs. Godot must be open for this to attach.
-- Default port is 6005 (Godot 4) — check Editor Settings > Network > Language Server.
vim.lsp.config("gdscript", {
	cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
})

-- Enable
vim.lsp.enable({ "pyright", "ts_ls", "gopls", "gdscript" })

-- Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf
		local map = function(mode, lhs, rhs)
			vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true })
		end

		map("n", "gd", vim.lsp.buf.definition)
		map("n", "gD", vim.lsp.buf.declaration)
		map("n", "gr", vim.lsp.buf.references)
		map("n", "gi", vim.lsp.buf.implementation)
		map("n", "K", vim.lsp.buf.hover)
		map("n", "<leader>rn", vim.lsp.buf.rename)
		map("n", "<leader>ca", vim.lsp.buf.code_action)
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end)
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end)
		map("n", "<leader>e", vim.diagnostic.open_float)
	end,
})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	float = { border = "rounded" },
})
